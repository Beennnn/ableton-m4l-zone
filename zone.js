// zone.js — brain of the "Zone" Max for Live MIDI device.
// Keyboard-zone / split filter, THEN octave + tone (semitone) shift, plus mute and bypass.
//
// MODEL (min/max PER NOTE — Benoit, 2026-07-31): FIVE notes (note1..note5), and EACH note has its own
// two checkboxes on its row:
//   minK = this note is a LOW bound  (keep p >= noteK)     maxK = this note is a HIGH bound (keep p < noteK)
// So every note can filter low and/or high, independently. Passing rule (see passes()):
//   lower = max of the noteK whose minK is on (default 0)  ·  upper = min of the noteK whose maxK is on (default 128)
//   lower <= upper -> BAND : keep [lower, upper)           (the classic split)
//   lower >  upper -> NOTCH: keep p>=lower OR p<upper       (the two ends, middle muted)
// No box ticked on a side = that side open. Both min+max on the SAME note = lower==upper -> empty (assumed).
//
// No on-screen keyboard: each note is set by typing the MIDI value in its numbox, or by clicking its
// Learn button (arms it) then playing the note. Signal path: mute -> dropped ; bypass -> ignore the
// LIMITS only (every note passes) but STILL transposed ; else passes(p) -> pass, shifted by octave*12 + tone.
//
// MIT — free to use, modify and share.

autowatch = 1;
outlets = 16;  // 0 = MIDI out ; 1-4 = note1..note4 value feedback (learn -> numbox) ; 5 = note5 feedback ; 6 = note5 name ; 7 = Tone value (CC-driven) ; 8 = Octave value (CC-driven) ; 9 = WLED lights out (zone boundaries -> OpenLamp / wled-midi `zone` posfn) ; 10-13 = note1..note4 name display ; 14 = toggle-clear bus (radio) ; 15 = inclusion bus ("indK bgcolor r g b a" -> route -> the per-row dot, green=note in zone / grey=out)

// Note-filter state. `notes` holds the 4 candidate boundary values ; min/max pick which one bounds each
// side. Handler functions (note1(), minsel(), …) are named distinctly from any var so they never clash.
var notes = [21, 48, 60, 84, 109];   // note1..note5 (MIDI) — A0/C3/C4/C6/C#8 ; note5=C#8(109) so Max<C#8 INCLUDES C8 (borne exclusive => carrelage propre entre zones)
var minK = [1, 0, 0, 0, 0];          // per note : this note is a LOW bound (keep >= noteK) — default: A0 (note1)
var maxK = [0, 0, 0, 0, 1];          // per note : this note is a HIGH bound (keep < noteK) — default: C8 (note5)
var narm = [0, 0, 0, 0, 0];          // learn-arm per note ; the next played note sets that note
var oct = 0, semi = 0, muted = 0, bypassed = 0;
var held = {};                       // inPitch -> outPitch

// --- WLED lights (outlet 9) -----------------------------------------------------------------------
// Optionally *show* this instrument's keyboard zone on a WLED strip. We hold two notes — the zone's
// low and high boundary — on `lightChan`, sent to the OpenLamp MIDI port; wled-midi's `zone` position
// function lights the LED band between the lowest and highest held note, in that channel's colour. So
// each Zone instance paints its own coloured band on the strip, and moving a split moves the band live.
// The channel picks the colour (wled-midi hand/zone map: ch1 = hand 1, ch2 = hand 2, …).
var lightsOn = 0, lightChan = 1;
var litLo = -1, litHi = -1;          // boundary notes currently held on the lights port (-1 = none)
// Tone-via-CC : a control CC drives the Tone (semitone) value. The CC number is set from the UI
// (default 102 — 102-119 is the MIDI "Undefined" range, collision-free). Channel is NOT filtered here.
// The CC *value* uses a dead-zone window: 58..69 -> -6..+5 (value = 64 + semitones), saturating outside.
// A matching CC is CONSUMED (not passed downstream) ; every other CC passes through untouched.
var ctlNum = 102, octCtlNum = 103, curChan = 1;
var center64 = 1, rangeStep = 1, ccOn = 1, octCcOn = 1;

function clamp(v, a, b) { v = Math.round(v); return v < a ? a : (v > b ? b : v); }
function shift(p)       { return clamp(p + oct * 12 + semi, 0, 127); }

// The kept region as [lower, upper). Each side either bounds at its selected note or stays open.
function bounds() {
    var lo = 0, hi = 128;
    for (var k = 0; k < 5; k++) {
        if (minK[k]) lo = Math.max(lo, notes[k]);
        if (maxK[k]) hi = Math.min(hi, notes[k]);
    }
    return [lo, hi];
}
// lower <= upper -> band (keep the middle) ; lower > upper -> bounds crossed outward, so the intent is a
// NOTCH: keep the two ends and mute the gap. One line covers band, single-sided cut, and notch.
function passes(p) {
    var b = bounds(), lo = b[0], hi = b[1];
    return (lo <= hi) ? (p >= lo && p < hi) : (p >= lo || p < hi);
}

// Note-name display + EDIT (outlets 10-13 + 6 -> five textedit boxes ; those boxes also SEND a typed
// name back into nn1..nn5). SCIENTIFIC pitch convention: 60 = C4 (middle C), octave = floor(n/12) - 1,
// so 0 = C-1 and 127 = G9. Chosen so the on-screen names match what you type (A0, C4, ...). NB the
// ClyphX `zn` note parser stays on Ableton's C3=60 (to keep existing clips valid) -> a 1-octave label
// gap between the device and ClyphX; prefer MIDI numbers in ClyphX to avoid confusion.
// try/catch = load-order armour (Max only adds js outlets on a FULL device reload) so a missing outlet
// can never break note output.
var NOTE_NAMES = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"];
var PITCH = { c: 0, d: 2, e: 4, f: 5, g: 7, a: 9, b: 11 };
function noteName(n) { n = clamp(n, 0, 127); return NOTE_NAMES[n % 12] + (Math.floor(n / 12) - 1); }
function names()     { try { for (var k = 0; k < 4; k++) outlet(10 + k, "set", noteName(notes[k])); outlet(6, "set", noteName(notes[4])); } catch (e) {} }

// Parse a typed value into a MIDI note : accepts a plain number (0-127) OR a note name (C4, a#3, fb2,
// Bb-1 ; scientific C4=60). Returns -1 if unparseable (caller then just restores the current display).
function nameToMidi(s) {
    s = ("" + s).trim();
    if (/^-?\d+$/.test(s)) return clamp(parseInt(s, 10), 0, 127);
    var m = s.toLowerCase().match(/^([a-g])([#b]*)(-?\d+)$/);
    if (!m) return -1;
    var sharps = (m[2].match(/#/g) || []).length, flats = (m[2].match(/b/g) || []).length;
    return clamp((parseInt(m[3], 10) + 1) * 12 + PITCH[m[1]] + sharps - flats, 0, 127);
}
// A textedit typed a name for note K -> set it (or revert the display if garbage). Fb outlet = numbox.
function setNote(k, s) { var n = nameToMidi(s); if (n >= 0) { notes[k] = n; outlet(k < 4 ? 1 + k : 5, n); emitLights(); } names(); }
function nn1(s) { setNote(0, s); }
function nn2(s) { setNote(1, s); }
function nn3(s) { setNote(2, s); }
function nn4(s) { setNote(3, s); }
function nn5(s) { setNote(4, s); }

// Learn buttons: click to arm noteK, then play a note to set it (= MIDI learn for that boundary).
function learn1() { narm[0] = 1; }
function learn2() { narm[1] = 1; }
function learn3() { narm[2] = 1; }
function learn4() { narm[3] = 1; }
function learn5() { narm[4] = 1; }

function list(pitch, velocity) {
    if (velocity > 0) {
        for (var k = 0; k < 5; k++) {
            if (narm[k]) { notes[k] = clamp(pitch, 0, 127); narm[k] = 0; outlet(k < 4 ? 1 + k : 5, notes[k]); names(); emitLights(); }
        }
    }
    if (velocity > 0) noteOn(pitch, velocity);
    else              noteOff(pitch);
}
function noteOn(p, v) {
    noteOff(p);
    if (muted) return;                                                 // mute = block everything
    // bypass = ignore the LIMITS only (every note passes) — the octave/tone transpose STILL applies.
    if (bypassed || passes(p)) { var o = shift(p); outlet(0, [0x90, o, v]); held[p] = o; }
}
function noteOff(p) {
    if (held[p] !== undefined) { outlet(0, [0x90, held[p], 0]); delete held[p]; }
}
function allOff() { for (var p in held) noteOff(Number(p)); }

// The zone's effective span in MIDI notes, for the WLED band. High is exclusive in the filter (a note
// passes if p < upper), so the top *playing* key is upper-1 — that's the boundary we light. In the NOTCH
// case (bounds crossed) the lit band collapses to the lower boundary — a two-band notch isn't
// representable with a single lit span, so we don't try.
function zoneLo() { return bounds()[0]; }
function zoneHi() { var b = bounds(); var h = b[1] - 1; var lo = b[0]; return clamp(h < lo ? lo : h, 0, 127); }

function clearLights() {
    if (litLo >= 0) { try { outlet(9, [0x90 + (lightChan - 1), litLo, 0]); } catch (e) {} }
    if (litHi >= 0) { try { outlet(9, [0x90 + (lightChan - 1), litHi, 0]); } catch (e) {} }
    litLo = -1; litHi = -1;
}
// Per-row inclusion dot (outlet 15 -> route ind1..ind5 -> each panel's bgcolor). Green = the note sounds
// (passes the filter), grey = muted. Strict reading: a Max boundary note is < exclusive, so it shows grey.
function updateIncl() {
    for (var k = 0; k < 5; k++) {
        var on = muted ? 0 : (bypassed ? 1 : passes(notes[k]));   // mute -> all grey ; bypass -> all green (limits off)
        try { outlet(15, "ind" + (k + 1), "bgcolor", on ? 0.18 : 0.28, on ? 0.76 : 0.28, on ? 0.45 : 0.28, 1.0); } catch (e) {}
    }
}
function emitLights() {
    updateIncl();                                  // refresh the inclusion dots on every change (bounds/notes/mute/bypass)
    if (!lightsOn || muted || bypassed) { clearLights(); return; }
    var lo = zoneLo(), hi = zoneHi();
    if (lo === litLo && (hi === litHi || (hi === lo && litHi === -1))) return;   // unchanged
    clearLights();
    var st = 0x90 + (lightChan - 1);
    try {
        outlet(9, [st, lo, 100]);
        if (hi !== lo) outlet(9, [st, hi, 100]);
    } catch (e) {}
    litLo = lo; litHi = (hi !== lo) ? hi : -1;
}
function lightson(v)  { lightsOn = v ? 1 : 0; emitLights(); }
function lightchan(v) { clearLights(); lightChan = clamp(v, 1, 16); emitLights(); }

function loadbang() { names(); emitLights(); }   // restore note-name labels + (re)paint the band on load
function note1(v)    { notes[0] = clamp(v, 0, 127); names(); emitLights(); }
function note2(v)    { notes[1] = clamp(v, 0, 127); names(); emitLights(); }
function note3(v)    { notes[2] = clamp(v, 0, 127); names(); emitLights(); }
function note4(v)    { notes[3] = clamp(v, 0, 127); names(); emitLights(); }
function note5(v)    { notes[4] = clamp(v, 0, 127); names(); emitLights(); }
// RADIO behaviour per group: at most ONE Min and ONE Max ticked. Turning a toggle ON clears the four
// others in its group — both the state array AND the on-screen toggle (outlet 14 -> `route` -> the
// toggle receives "set 0", i.e. silent, no re-output). Turning one OFF just clears its own flag.
function setTog(arr, side, i, v) {
    if (v) { for (var j = 0; j < 5; j++) { if (j !== i && arr[j]) { arr[j] = 0; try { outlet(14, side + (j + 1), "set", 0); } catch (e) {} } } arr[i] = 1; }
    else arr[i] = 0;
    emitLights();
}
function min1(v)     { setTog(minK, "min", 0, v ? 1 : 0); }   // Min group: exactly 0 or 1 note is the low bound
function min2(v)     { setTog(minK, "min", 1, v ? 1 : 0); }
function min3(v)     { setTog(minK, "min", 2, v ? 1 : 0); }
function min4(v)     { setTog(minK, "min", 3, v ? 1 : 0); }
function min5(v)     { setTog(minK, "min", 4, v ? 1 : 0); }
function max1(v)     { setTog(maxK, "max", 0, v ? 1 : 0); }   // Max group: exactly 0 or 1 note is the high bound
function max2(v)     { setTog(maxK, "max", 1, v ? 1 : 0); }
function max3(v)     { setTog(maxK, "max", 2, v ? 1 : 0); }
function max4(v)     { setTog(maxK, "max", 3, v ? 1 : 0); }
function max5(v)     { setTog(maxK, "max", 4, v ? 1 : 0); }
function octaven(v)  { oct = clamp(v, -4, 4); }
function semin(v)    { semi = clamp(v, -6, 5); }      // "Tone" (semitones) — -6/+5 tiles with the ±4 Octave knob
function muteon(v)   { muted = v ? 1 : 0; if (muted) allOff(); emitLights(); }
function bypasson(v) { allOff(); bypassed = v ? 1 : 0; emitLights(); }
function panic()     { allOff(); clearLights(); }

// --- Tone via CC (parameterizable CC number + channel + mode, no hardcoding) ---
function ctlnum(v)    { ctlNum  = clamp(v, 0, 127); }
function octctlnum(v){ octCtlNum = clamp(v, 0, 127); }
function ctlcenter(v) { center64 = v ? 1 : 0; }
function ctlrange(v)  { rangeStep = v ? 1 : 0; }
function ccon(v)      { ccOn = v ? 1 : 0; }
function octccon(v)   { octCcOn = v ? 1 : 0; }
function chan(v)      { curChan = v; }

// CC value (0-127) -> a shift in [lo..hi], across the 4 modes (Center 0/64 x Step/All-range). Shared by
// Tone (lo=-6, hi=+5) and Octave (lo=-4, hi=+4) ; Center + Range are common to both.
function ccToShift(v, lo, hi) {
    var N = hi - lo + 1, i;
    if (!rangeStep)    i = Math.round(v * (N - 1) / 127);
    else if (center64) i = clamp(v, 64 + lo, 64 + hi) - (64 + lo);
    else               i = v % N;
    return center64 ? (i + lo) : (((i - lo) % N) + lo);
}
function ctl(controller, value) {
    if (ccOn && controller == ctlNum) {
        try { outlet(7, ccToShift(value, -6, 5)); } catch (e) {}
        return;
    }
    if (octCcOn && controller == octCtlNum) {
        try { outlet(8, ccToShift(value, -4, 4)); } catch (e) {}
        return;
    }
    outlet(0, [0xB0 + (curChan - 1), controller, value]);
}
