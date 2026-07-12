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
outlets = 8;   // 0 = MIDI out ; 1 = Low fb ; 2 = High fb ; 3 = Low note-name ; 4 = High note-name ; 5 = Low learn-state ; 6 = High learn-state ; 7 = Tone value (CC-driven)

var loOn = 0, loNote = 0, hiOn = 0, hiNote = 128;
var oct = 0, semi = 0, muted = 0, bypassed = 0;
var loLearn = 0, hiLearn = 0;        // armed by the Learn buttons ; the next played note sets that bound
var held = {};                       // inPitch -> outPitch
// Tone-via-CC : a control CC drives the Tone (semitone) value. The CC number is set from the UI
// (default 102 — 102-119 is the MIDI "Undefined" range, collision-free). Channel is NOT filtered here:
// Ableton's track input is the natural channel gate, so we act on the CC on whatever channel reaches us.
// The CC *value* uses a dead-zone window: 58..69 -> -6..+5 (value = 64 + semitones), saturating outside,
// so "value 64 + n = Tone n" with no math and no rounding. A matching CC is CONSUMED (not passed
// downstream) ; every other CC passes through untouched.
var ctlNum = 102, curChan = 1;   // curChan is latched only to re-emit passthrough CCs on their own channel
var center64 = 1, rangeStep = 1, ccOn = 1;   // Mode: center64 (1=CC64->0 / 0=CC0->0) ; rangeStep (1=1CC<->1semi / 0=interpolate) ; ccOn = master enable

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
        if (loLearn) { loNote = clamp(pitch, 0, 127); loLearn = 0; outlet(1, loNote); names(); arm(); }
        if (hiLearn) { hiNote = clamp(pitch, 0, 127); hiLearn = 0; outlet(2, hiNote); names(); arm(); }
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

function loadbang() { names(); arm(); }               // restore note-name labels + learn labels when the device loads
function loon(v)     { loOn = v ? 1 : 0; }
function lo(v)       { loNote = clamp(v, 0, 127); names(); }
function hion(v)     { hiOn = v ? 1 : 0; }
function hi(v)       { hiNote = clamp(v, 0, 127); names(); }
function octaven(v)  { oct = clamp(v, -4, 4); }
function semin(v)    { semi = clamp(v, -6, 5); }      // "Tone" control (semitones) — -6/+5 tiles exactly with the ±4 Octave knob (Roland/Korg convention)
function muteon(v)   { muted = v ? 1 : 0; if (muted) allOff(); }
function bypasson(v) { allOff(); bypassed = v ? 1 : 0; }
function panic()     { allOff(); }

// --- Tone via CC (parameterizable CC number + channel + mode, no hardcoding) ---
function ctlnum(v)    { ctlNum  = clamp(v, 0, 127); }   // which CC number drives Tone
function ctlcenter(v) { center64 = v ? 1 : 0; }         // 1 = center on CC 64 (window) ; 0 = center on CC 0 (wrap)
function ctlrange(v)  { rangeStep = v ? 1 : 0; }        // 1 = Step (1 CC = 1 semitone) ; 0 = All range (interpolate)
function ccon(v)      { ccOn = v ? 1 : 0; }             // master enable : off = the control CC just passes through, untouched
function chan(v)      { curChan = v; }                  // latched from midiparse (channel outlet fires before the CC)

// CC value (0-127) -> Tone (-6..+5), across the 4 modes (Center 0/64 x Step/All-range). An index i in
// 0..11 picks one of the 12 semitone slots : Center sets the slot ORDER, Range sets the CC SPACING.
function toneFromCC(v) {
    var i;
    if (!rangeStep)    i = Math.round(v * 11 / 127);   // All range : 12 slots spread over the whole 0..127
    else if (center64) i = clamp(v, 58, 69) - 58;      // Step + Center 64 : window 58..69, saturate outside
    else               i = v % 12;                     // Step + Center 0  : 1 CC = 1 semitone, wrap every 12
    return center64 ? (i - 6)                          // Center 64 : -6,-5,..,+5  (0 in the middle)
                    : (((i + 6) % 12) - 6);            // Center 0  : 0,+1,..,+5,-6,..,-1  (0 first, reaches -1)
}
function ctl(controller, value) {
    if (ccOn && controller == ctlNum) {
        try { outlet(7, toneFromCC(value)); } catch (e) {}  // drives the Tone numbox (-> semin, moves the param)
        return;                                             // consume : the control CC does not pass on
    }
    outlet(0, [0xB0 + (curChan - 1), controller, value]);   // any other CC -> untouched passthrough
}
