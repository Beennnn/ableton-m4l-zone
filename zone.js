// zone.js — brain of the "Zone" Max for Live MIDI device.
// A keyboard zone / split filter: passes only notes inside [Lo, Hi) and lets ALL other
// MIDI (control change, pitch bend, aftertouch, program, poly pressure) through untouched.
//
// Two independent, toggleable bounds:
//   Lo active -> pass notes  >= loNote
//   Hi active -> pass notes  <  hiNote     (exclusive: the pivot note belongs to the UPPER zone)
// Both bounds are Live parameters, so you can drive them from Rack macros and keep several
// instances in sync WITHOUT any internal linking — the sync lives in Ableton, not the device.
//
// Note tracking: every note we let through is remembered, so its note-off is ALWAYS sent
// later — even if you move or disable a bound while the note is held. No stuck notes.
//
// Stack one instance per Instrument Rack chain to build as many zones as you like.
//
// MIT — free to use, modify and share.

autowatch = 1;
outlets = 3;                 // 0 = MIDI [status,d1,d2] -> midiout ; 1 = loNote feedback ; 2 = hiNote feedback

var loOn = 0, loNote = 0;    // low bound
var hiOn = 0, hiNote = 128;  // high bound (128 = "everything" while active but unset)
var learnLo = 0, learnHi = 0;
var passed = {};             // pitch -> 1 : notes currently let through

function clamp(v)  { v = Math.round(v); return v < 0 ? 0 : (v > 127 ? 127 : v); }
function passes(p) { return (!loOn || p >= loNote) && (!hiOn || p < hiNote); }

// notes from [midiparse] : list = pitch velocity
function list(pitch, velocity) {
    if (learnLo && velocity > 0) { loNote = pitch; learnLo = 0; outlet(1, pitch); return; }
    if (learnHi && velocity > 0) { hiNote = pitch; learnHi = 0; outlet(2, pitch); return; }
    if (velocity > 0) noteOn(pitch, velocity);
    else              noteOff(pitch);
}
function noteOn(p, v) {
    noteOff(p);                                   // retrigger: release the old one first
    if (passes(p)) { outlet(0, [0x90, p, v]); passed[p] = 1; }
}
function noteOff(p) {
    if (passed[p]) { outlet(0, [0x90, p, 0]); delete passed[p]; }
}

// UI messages
function loon(v)    { loOn = v ? 1 : 0; }
function lo(v)      { loNote = clamp(v); }
function hion(v)    { hiOn = v ? 1 : 0; }
function hi(v)      { hiNote = clamp(v); }
function learnlo(v) { learnLo = v ? 1 : 0; }
function learnhi(v) { learnHi = v ? 1 : 0; }
function panic()    { for (var p in passed) noteOff(Number(p)); }   // release all held notes
