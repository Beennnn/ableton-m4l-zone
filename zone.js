// zone.js — brain of the "Zone" Max for Live MIDI device.
// Keyboard-zone / split filter, THEN octave + tone (semitone) shift, plus mute and bypass.
// No on-screen keyboard: the bounds are set either by typing the MIDI value in the numbox, or by
// clicking a "learn" button (arms that bound) then playing the note you want as the limit.
//
// Signal path: bypass -> untouched (no transpose) ; mute -> dropped ;
//   else inside [Low, High) (a side with its limit off is open) -> pass, shifted by octave*12 + tone.
//
// MIT — free to use, modify and share.

autowatch = 1;
outlets = 10;  // 0 = MIDI out ; 1 = Low fb ; 2 = High fb ; 3 = Low note-name ; 4 = High note-name ; 5 = Low learn-state ; 6 = High learn-state ; 7 = Tone value (CC-driven) ; 8 = Octave value (CC-driven) ; 9 = WLED lights out (zone boundaries -> OpenLamp / wled-midi `zone` posfn)

var loOn = 0, loNote = 0, hiOn = 0, hiNote = 128;
var oct = 0, semi = 0, muted = 0, bypassed = 0;
var loLearn = 0, hiLearn = 0;        // armed by the Learn buttons ; the next played note sets that bound
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
function passes(p)      { return (!loOn || p >= loNote) && (!hiOn || p < hiNote); }

// Read-only note-name display (outlets 3/4 -> two comment boxes). Ableton Live convention: 60 = C3
// (octave = floor(n/12) - 2), so 0 = C-2 and 127 = G8. Display only — the editable value stays the
// raw MIDI number in the live.numbox. try/catch = load-order armour (Max only adds js outlets on a
// FULL device reload, not an autowatch hot-reload) so a missing outlet can never break note output.
var NOTE_NAMES = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"];
function noteName(n) { n = clamp(n, 0, 127); return NOTE_NAMES[n % 12] + (Math.floor(n / 12) - 2); }
function names()     { try { outlet(3, "set", noteName(loNote)); outlet(4, "set", noteName(hiNote)); } catch (e) {} }

// Learn buttons: click to arm, then play a note to set that bound (= MIDI learn for the limit).
// arm() drives the label under each button: "play" while armed (prompt + armed indicator), "learn"
// idle. It flips back to "learn" the instant the note is captured, so you always see the state.
function arm()     { try { outlet(5, "set", loLearn ? "play" : "learn"); outlet(6, "set", hiLearn ? "play" : "learn"); } catch (e) {} }
function learnlo() { loLearn = 1; arm(); }
function learnhi() { hiLearn = 1; arm(); }

function list(pitch, velocity) {
    if (velocity > 0) {
        if (loLearn) { loNote = clamp(pitch, 0, 127); loLearn = 0; outlet(1, loNote); names(); arm(); emitLights(); }
        if (hiLearn) { hiNote = clamp(pitch, 0, 127); hiLearn = 0; outlet(2, hiNote); names(); arm(); emitLights(); }
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

// The zone's effective span in MIDI notes. A side with its limit off is open (0 / 127). High is
// exclusive in the filter (a note passes if p < hiNote), so the top *playing* key is hiNote-1 — that's
// the boundary we light, keeping the lit band flush with what actually sounds.
function zoneLo() { return loOn ? loNote : 0; }
function zoneHi() { var h = hiOn ? hiNote - 1 : 127; var lo = zoneLo(); return clamp(h < lo ? lo : h, 0, 127); }

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
function loon(v)     { loOn = v ? 1 : 0; emitLights(); }
function lo(v)       { loNote = clamp(v, 0, 127); names(); emitLights(); }
function hion(v)     { hiOn = v ? 1 : 0; emitLights(); }
function hi(v)       { hiNote = clamp(v, 0, 127); names(); emitLights(); }
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
