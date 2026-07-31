// zone.js — brain of the "Zone" Max for Live MIDI device.
// Keyboard-zone / split filter, THEN octave + tone (semitone) shift, plus mute and bypass.
//
// MODEL (min/max PER NOTE — Benoit, 2026-07-31): FOUR notes (note1..note4), and EACH note has its own
// two checkboxes on its row:
//   minK = this note is a LOW bound  (keep p >= noteK)     maxK = this note is a HIGH bound (keep p < noteK)
// So every note can filter low and/or high, independently. Passing rule (see passes()):
//   lower = max of the noteK whose minK is on (default 0)  ·  upper = min of the noteK whose maxK is on (default 128)
//   lower <= upper -> BAND : keep [lower, upper)           (the classic split)
//   lower >  upper -> NOTCH: keep p>=lower OR p<upper       (the two ends, middle muted)
// No box ticked on a side = that side open. Both min+max on the SAME note = lower==upper -> empty (assumed).
//
// No on-screen keyboard: each note is set by typing the MIDI value in its numbox, or by clicking its
// Learn button (arms it) then playing the note. Signal path: bypass -> untouched (no transpose) ;
// mute -> dropped ; else passes(p) -> pass, shifted by octave*12 + tone.
//
// MIT — free to use, modify and share.

autowatch = 1;
outlets = 14;  // 0 = MIDI out ; 1-4 = note1..note4 value feedback (learn -> numbox) ; 5-6 = unused ; 7 = Tone value (CC-driven) ; 8 = Octave value (CC-driven) ; 9 = WLED lights out (zone boundaries -> OpenLamp / wled-midi `zone` posfn) ; 10-13 = note1..note4 name display

// Note-filter state. `notes` holds the 4 candidate boundary values ; min/max pick which one bounds each
// side. Handler functions (note1(), minsel(), …) are named distinctly from any var so they never clash.
var notes = [48, 72, 84, 96];        // note1..note4 (MIDI values)
var minK = [0, 0, 0, 0];             // per note : this note is a LOW bound (keep >= noteK)
var maxK = [0, 0, 0, 0];             // per note : this note is a HIGH bound (keep < noteK)
var narm = [0, 0, 0, 0];             // learn-arm per note ; the next played note sets that note
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
    for (var k = 0; k < 4; k++) {
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

// Read-only note-name display (outlets 10-13 -> four comment boxes). Ableton Live convention: 60 = C3
// (octave = floor(n/12) - 2), so 0 = C-2 and 127 = G8. Display only. try/catch = load-order armour
// (Max only adds js outlets on a FULL device reload) so a missing outlet can never break note output.
var NOTE_NAMES = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"];
function noteName(n) { n = clamp(n, 0, 127); return NOTE_NAMES[n % 12] + (Math.floor(n / 12) - 2); }
function names()     { try { for (var k = 0; k < 4; k++) outlet(10 + k, "set", noteName(notes[k])); } catch (e) {} }

// Learn buttons: click to arm noteK, then play a note to set it (= MIDI learn for that boundary).
function learn1() { narm[0] = 1; }
function learn2() { narm[1] = 1; }
function learn3() { narm[2] = 1; }
function learn4() { narm[3] = 1; }

function list(pitch, velocity) {
    if (velocity > 0) {
        for (var k = 0; k < 4; k++) {
            if (narm[k]) { notes[k] = clamp(pitch, 0, 127); narm[k] = 0; outlet(1 + k, notes[k]); names(); emitLights(); }
        }
    }
    if (velocity > 0) noteOn(pitch, velocity);
    else              noteOff(pitch);
}
function noteOn(p, v) {
    noteOff(p);
    if (bypassed) { outlet(0, [0x90, p, v]); held[p] = p; return; }   // bypass = raw, no transpose
    if (muted) return;                                                 // mute = block everything
    if (passes(p)) { var o = shift(p); outlet(0, [0x90, o, v]); held[p] = o; }
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
function emitLights() {
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
function min1(v)     { minK[0] = v ? 1 : 0; emitLights(); }   // note1 is a LOW bound (keep >= note1)
function min2(v)     { minK[1] = v ? 1 : 0; emitLights(); }
function min3(v)     { minK[2] = v ? 1 : 0; emitLights(); }
function min4(v)     { minK[3] = v ? 1 : 0; emitLights(); }
function max1(v)     { maxK[0] = v ? 1 : 0; emitLights(); }   // note1 is a HIGH bound (keep < note1)
function max2(v)     { maxK[1] = v ? 1 : 0; emitLights(); }
function max3(v)     { maxK[2] = v ? 1 : 0; emitLights(); }
function max4(v)     { maxK[3] = v ? 1 : 0; emitLights(); }
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
