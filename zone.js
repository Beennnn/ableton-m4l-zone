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
outlets = 5;   // 0 = MIDI out ; 1 = Low feedback (numbox) ; 2 = High feedback (numbox) ; 3 = Low note-name ; 4 = High note-name

var loOn = 0, loNote = 0, hiOn = 0, hiNote = 128;
var oct = 0, semi = 0, muted = 0, bypassed = 0;
var loLearn = 0, hiLearn = 0;        // armed by the Learn buttons ; the next played note sets that bound
var held = {};                       // inPitch -> outPitch

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
function learnlo() { loLearn = 1; }
function learnhi() { hiLearn = 1; }

function list(pitch, velocity) {
    if (velocity > 0) {
        if (loLearn) { loNote = clamp(pitch, 0, 127); loLearn = 0; outlet(1, loNote); names(); }
        if (hiLearn) { hiNote = clamp(pitch, 0, 127); hiLearn = 0; outlet(2, hiNote); names(); }
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

function loadbang() { names(); }                      // restore note-name labels when the device loads
function loon(v)     { loOn = v ? 1 : 0; }
function lo(v)       { loNote = clamp(v, 0, 127); names(); }
function hion(v)     { hiOn = v ? 1 : 0; }
function hi(v)       { hiNote = clamp(v, 0, 127); names(); }
function octaven(v)  { oct = clamp(v, -4, 4); }
function semin(v)    { semi = clamp(v, -12, 12); }    // "Tone" control (semitones)
function muteon(v)   { muted = v ? 1 : 0; if (muted) allOff(); }
function bypasson(v) { allOff(); bypassed = v ? 1 : 0; }
function panic()     { allOff(); }
