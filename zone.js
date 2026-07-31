// zone.js — brain of the "Zone" Max for Live MIDI device.
// Keyboard-zone / split filter, THEN octave + tone (semitone) shift, plus mute and bypass.
// No on-screen keyboard: the notes are set either by typing the MIDI value in the numbox, or by
// clicking a "learn" button (arms that note) then playing the note you want as the limit.
//
// FOUR NUMBERED NOTES, each with two role checkboxes (added on Benoit's request):
//   noteK : loK = "keep notes >= noteK" (acts as a LOW bound)  · hiK = "keep notes < noteK" (HIGH bound)
// So each note can filter in either direction, independently. Passing rule (see passes()):
//   lower = max of the active ">=" notes (default 0) ; upper = min of the active "<" notes (default 128).
//   lower <= upper -> BAND : keep [lower, upper)   (the classic split — default lo1+hi2)
//   lower >  upper -> NOTCH: keep p>=lower OR p<upper  (the two ends, middle muted — e.g. hi1+lo2)
// The default (lo1 on, hi2 on, hi1/lo2 off) reproduces the old [note1, note2) band exactly. A note
// with NO active role is fully open. Both roles on the SAME note (e.g. lo1+hi1) => lower==upper==note1
// => empty, left as-is (an assumed "mute this note and up-or-down" corner, not special-cased).
//
// Signal path: bypass -> untouched (no transpose) ; mute -> dropped ;
//   else passes(p) -> pass, shifted by octave*12 + tone.
//
// MIT — free to use, modify and share.

autowatch = 1;
outlets = 14;  // 0 = MIDI out ; 1/2 = note1/note2 fb ; 3/4 = note1/note2 name ; 5/6 = note1/note2 learn-state ; 7 = Tone value (CC-driven) ; 8 = Octave value (CC-driven) ; 9 = WLED lights out (zone boundaries -> OpenLamp / wled-midi `zone` posfn) ; 10/11 = note3/note4 fb ; 12/13 = note3/note4 name (note3/note4 have no learn-state label — matches note2)

// Note-filter state. Vars are named *On / nK so they never clash with the same-named message
// handlers Max calls (function lo1() sets lo1On, etc. — a var and a function can't share a name).
var lo1On = 0, hi1On = 0, n1 = 48;   // note1 (MIDI value nK) + its two role flags
var lo2On = 0, hi2On = 0, n2 = 72;   // note2
var lo3On = 0, hi3On = 0, n3 = 0;    // note3
var lo4On = 0, hi4On = 0, n4 = 0;    // note4
var oct = 0, semi = 0, muted = 0, bypassed = 0;
var l1arm = 0, l2arm = 0, l3arm = 0, l4arm = 0;   // armed by the Learn buttons ; the next played note sets that note
var held = {};                       // inPitch -> outPitch

// --- WLED lights (outlet 9) -----------------------------------------------------------------------
// Optionally *show* this instrument's keyboard zone on a WLED strip. We hold two notes — the zone's
// low and high boundary — on `lightChan`, sent to the OpenLamp MIDI port; wled-midi's `zone` position
// function lights the LED band between the lowest and highest held note, in that channel's colour. So
// each Zone instance paints its own coloured band on the strip, and moving a split moves the band live.
// The channel picks the colour (wled-midi hand/zone map: ch1 = hand 1, ch2 = hand 2, …).
var lightsOn = 0, lightChan = 1;
var litLo = -1, litHi = -1;          // boundary notes currently held on the lights port (-1 = none) — so a move clears the old band
// Tone-via-CC : a control CC drives the Tone (semitone) value. The CC number is set from the UI
// (default 102 — 102-119 is the MIDI "Undefined" range, collision-free). Channel is NOT filtered here:
// Ableton's track input is the natural channel gate, so we act on the CC on whatever channel reaches us.
// The CC *value* uses a dead-zone window: 58..69 -> -6..+5 (value = 64 + semitones), saturating outside,
// so "value 64 + n = Tone n" with no math and no rounding. A matching CC is CONSUMED (not passed
// downstream) ; every other CC passes through untouched.
var ctlNum = 102, octCtlNum = 103, curChan = 1;   // Tone CC + Octave CC ; curChan latched only to re-emit passthrough CCs
var center64 = 1, rangeStep = 1, ccOn = 1, octCcOn = 1;   // Mode (shared by Tone+Octave): center64 (1=CC64->0 / 0=CC0->0) ; rangeStep (1=1CC<->1step / 0=interpolate) ; ccOn/octCcOn = per-target master enable

function clamp(v, a, b) { v = Math.round(v); return v < a ? a : (v > b ? b : v); }
function shift(p)       { return clamp(p + oct * 12 + semi, 0, 127); }

// The kept region as [lower, upper). Each active role tightens one side (>= tightens lower, < tightens
// upper). Neutral defaults (0 / 128) mean "no bound on that side" for MIDI 0..127.
function bounds() {
    var lo = 0, hi = 128;
    if (lo1On) lo = Math.max(lo, n1);
    if (lo2On) lo = Math.max(lo, n2);
    if (lo3On) lo = Math.max(lo, n3);
    if (lo4On) lo = Math.max(lo, n4);
    if (hi1On) hi = Math.min(hi, n1);
    if (hi2On) hi = Math.min(hi, n2);
    if (hi3On) hi = Math.min(hi, n3);
    if (hi4On) hi = Math.min(hi, n4);
    return [lo, hi];
}
// lower <= upper -> band (keep the middle) ; lower > upper -> the bounds crossed outward, so the intent
// is a NOTCH: keep the two ends and mute the gap. One line covers band, single-sided cut, and notch.
function passes(p) {
    var b = bounds(), lo = b[0], hi = b[1];
    return (lo <= hi) ? (p >= lo && p < hi) : (p >= lo || p < hi);
}

// Read-only note-name display (outlets 3/4 -> two comment boxes). Ableton Live convention: 60 = C3
// (octave = floor(n/12) - 2), so 0 = C-2 and 127 = G8. Display only — the editable value stays the
// raw MIDI number in the live.numbox. try/catch = load-order armour (Max only adds js outlets on a
// FULL device reload, not an autowatch hot-reload) so a missing outlet can never break note output.
var NOTE_NAMES = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"];
function noteName(n) { n = clamp(n, 0, 127); return NOTE_NAMES[n % 12] + (Math.floor(n / 12) - 2); }
function names()     { try { outlet(3, "set", noteName(n1)); outlet(4, "set", noteName(n2)); outlet(12, "set", noteName(n3)); outlet(13, "set", noteName(n4)); } catch (e) {} }

// Learn buttons: click to arm, then play a note to set that note (= MIDI learn for the limit).
// arm() drives the label under each button: "play" while armed (prompt + armed indicator), "learn"
// idle. It flips back to "learn" the instant the note is captured, so you always see the state.
function arm()     { try { outlet(5, "set", l1arm ? "play" : "learn"); outlet(6, "set", l2arm ? "play" : "learn"); } catch (e) {} }
function learn1()  { l1arm = 1; arm(); }
function learn2()  { l2arm = 1; arm(); }

function list(pitch, velocity) {
    if (velocity > 0) {
        if (l1arm) { n1 = clamp(pitch, 0, 127); l1arm = 0; outlet(1, n1); names(); arm(); emitLights(); }
        if (l2arm) { n2 = clamp(pitch, 0, 127); l2arm = 0; outlet(2, n2); names(); arm(); emitLights(); }
        if (l3arm) { n3 = clamp(pitch, 0, 127); l3arm = 0; outlet(10, n3); names(); emitLights(); }
        if (l4arm) { n4 = clamp(pitch, 0, 127); l4arm = 0; outlet(11, n4); names(); emitLights(); }
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
// passes if p < upper), so the top *playing* key is upper-1 — that's the boundary we light, keeping the
// lit band flush with what actually sounds. In the NOTCH case (bounds crossed) the lit band collapses to
// the lower boundary — a two-band notch isn't representable with a single lit span, so we don't try.
function zoneLo() { return bounds()[0]; }
function zoneHi() { var b = bounds(); var h = b[1] - 1; var lo = b[0]; return clamp(h < lo ? lo : h, 0, 127); }

// Send the zone to the WLED lights: hold the two boundary notes on lightChan (outlet 9 -> midiout ->
// OpenLamp). wled-midi's `zone` posfn then lights the LED band between them. Cleared when lights are off
// or the device is muted/bypassed (the zone isn't meaningfully filtering then). Idempotent: re-emits
// only on an actual boundary change, so dragging a split doesn't spam the port. try/catch is the same
// load-order armour used elsewhere — on an autowatch hot-reload Max hasn't added outlet 9 yet (that needs
// a full device reload), so a missing outlet must never throw and break note output.
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
        outlet(9, [st, lo, 100]);                 // low boundary (velocity is a placeholder — `zone` maps span, not level)
        if (hi !== lo) outlet(9, [st, hi, 100]);  // high boundary (a single note if the zone collapses to one key)
    } catch (e) {}
    litLo = lo; litHi = (hi !== lo) ? hi : -1;
}
function lightson(v)  { lightsOn = v ? 1 : 0; emitLights(); }   // master enable for the WLED band
function lightchan(v) { clearLights(); lightChan = clamp(v, 1, 16); emitLights(); }  // colour = wled-midi channel/hand

function loadbang() { names(); arm(); emitLights(); } // restore note-name + learn labels, and (re)paint the band when the device loads
function lo1(v)      { lo1On = v ? 1 : 0; emitLights(); }   // noteK acts as a LOW bound  (keep >= noteK)
function hi1(v)      { hi1On = v ? 1 : 0; emitLights(); }   // noteK acts as a HIGH bound (keep < noteK)
function lo2(v)      { lo2On = v ? 1 : 0; emitLights(); }
function hi2(v)      { hi2On = v ? 1 : 0; emitLights(); }
function lo3(v)      { lo3On = v ? 1 : 0; emitLights(); }
function hi3(v)      { hi3On = v ? 1 : 0; emitLights(); }
function lo4(v)      { lo4On = v ? 1 : 0; emitLights(); }
function hi4(v)      { hi4On = v ? 1 : 0; emitLights(); }
function note1(v)    { n1 = clamp(v, 0, 127); names(); emitLights(); }
function note2(v)    { n2 = clamp(v, 0, 127); names(); emitLights(); }
function note3(v)    { n3 = clamp(v, 0, 127); names(); emitLights(); }
function note4(v)    { n4 = clamp(v, 0, 127); names(); emitLights(); }
function learn3()    { l3arm = 1; }   // note3/note4 arm silently (no learn-state label, like note2)
function learn4()    { l4arm = 1; }
function octaven(v)  { oct = clamp(v, -4, 4); }
function semin(v)    { semi = clamp(v, -6, 5); }      // "Tone" control (semitones) — -6/+5 tiles exactly with the ±4 Octave knob (Roland/Korg convention)
function muteon(v)   { muted = v ? 1 : 0; if (muted) allOff(); emitLights(); }
function bypasson(v) { allOff(); bypassed = v ? 1 : 0; emitLights(); }
function panic()     { allOff(); clearLights(); }

// --- Tone via CC (parameterizable CC number + channel + mode, no hardcoding) ---
function ctlnum(v)    { ctlNum  = clamp(v, 0, 127); }    // which CC number drives Tone
function octctlnum(v){ octCtlNum = clamp(v, 0, 127); }   // which CC number drives Octave
function ctlcenter(v) { center64 = v ? 1 : 0; }         // 1 = center on CC 64 (window) ; 0 = center on CC 0 (wrap)  [shared]
function ctlrange(v)  { rangeStep = v ? 1 : 0; }        // 1 = Step (1 CC = 1 step) ; 0 = All range (interpolate)     [shared]
function ccon(v)      { ccOn = v ? 1 : 0; }             // Tone master enable : off = the Tone CC just passes through
function octccon(v)   { octCcOn = v ? 1 : 0; }          // Octave master enable : off = the Octave CC just passes through
function chan(v)      { curChan = v; }                  // latched from midiparse (channel outlet fires before the CC)

// CC value (0-127) -> a shift in [lo..hi], across the 4 modes (Center 0/64 x Step/All-range). Shared by
// Tone (lo=-6, hi=+5 -> 12 slots) and Octave (lo=-4, hi=+4 -> 9 slots) ; Center + Range are common to both.
// An index i in 0..N-1 picks a slot : Center sets the slot ORDER, Range sets the CC SPACING.
function ccToShift(v, lo, hi) {
    var N = hi - lo + 1, i;
    if (!rangeStep)    i = Math.round(v * (N - 1) / 127);            // All range : N slots over the whole 0..127
    else if (center64) i = clamp(v, 64 + lo, 64 + hi) - (64 + lo);  // Step + Center 64 : window around 64 (value 64 -> 0)
    else               i = v % N;                                   // Step + Center 0  : 1 CC = 1 step, wrap every N
    return center64 ? (i + lo)                                      // Center 64 : lo..hi  (0 in the middle)
                    : (((i - lo) % N) + lo);                        // Center 0  : 0,+1,..,hi,lo,..,-1  (0 first)
}
function ctl(controller, value) {
    if (ccOn && controller == ctlNum) {                    // Tone CC
        try { outlet(7, ccToShift(value, -6, 5)); } catch (e) {}   // -> Tone numbox (semin)
        return;                                                    // consume
    }
    if (octCcOn && controller == octCtlNum) {              // Octave CC
        try { outlet(8, ccToShift(value, -4, 4)); } catch (e) {}   // -> Octave numbox (octaven)
        return;                                                    // consume
    }
    outlet(0, [0xB0 + (curChan - 1), controller, value]);  // any other CC -> untouched passthrough
}
