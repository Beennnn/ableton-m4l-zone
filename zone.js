// zone.js — brain of the "Zone" Max for Live MIDI device (v3).
// Keyboard zone / split filter, THEN octave + semitone shift, plus mute and bypass.
// One on-screen keyboard, driven by a MODE selector:
//   0 Edit Lo   — click a key to set the low bound
//   1 Edit Hi   — click a key to set the high bound
//   2 Watch In  — the keyboard highlights the INCOMING note you play
//   3 Watch Out — the keyboard highlights the OUTGOING (filtered + shifted) note
// So you see the incoming vs outgoing note by switching mode (no custom-drawn keyboard needed).
//
// Signal path per note: bypass -> untouched ; mute -> dropped ; else if inside [Lo,Hi) -> pass, shifted by octave*12+semitone.
// Note tracking: each held note remembers its OUTPUT pitch, so the note-off always matches — no stuck notes.
//
// MIT — free to use, modify and share.

autowatch = 1;
outlets = 4;   // 0 = MIDI -> midiout ; 1 = Lo feedback ; 2 = Hi feedback ; 3 = keyboard display (pitch velocity) for Watch modes

var loOn = 0, loNote = 0, hiOn = 0, hiNote = 128;
var oct = 0, semi = 0, muted = 0, bypassed = 0;
var mode = 0, learning = 0;          // mode 0=Edit Lo, 1=Edit Hi, 2=Watch In, 3=Watch Out
var held = {};                       // inPitch -> outPitch

function clamp(v, a, b) { v = Math.round(v); return v < a ? a : (v > b ? b : v); }
function shift(p)       { return clamp(p + oct * 12 + semi, 0, 127); }
function passes(p)      { return (!loOn || p >= loNote) && (!hiOn || p < hiNote); }
function setBound(n)    { if (mode == 1) { hiNote = clamp(n, 0, 127); outlet(2, hiNote); } else if (mode == 0) { loNote = clamp(n, 0, 127); outlet(1, loNote); } }
function viz(inP, outP, vel) { if (mode == 2) outlet(3, [inP, vel]); else if (mode == 3) outlet(3, [outP, vel]); }  // -> kslider display

function list(pitch, velocity) {
    if (learning && mode < 2 && velocity > 0) { setBound(pitch); learning = 0; return; }
    if (velocity > 0) noteOn(pitch, velocity);
    else              noteOff(pitch);
}
function noteOn(p, v) {
    noteOff(p);
    if (bypassed) { outlet(0, [0x90, p, v]); held[p] = p; viz(p, p, v); return; }
    if (muted) return;
    if (passes(p)) { var o = shift(p); outlet(0, [0x90, o, v]); held[p] = o; viz(p, o, v); }
}
function noteOff(p) {
    if (held[p] !== undefined) { outlet(0, [0x90, held[p], 0]); viz(p, held[p], 0); delete held[p]; }
}
function allOff() { for (var p in held) noteOff(Number(p)); }

function kbd(n)      { if (mode < 2) setBound(n); }   // keyboard click sets the armed bound (edit modes only)
function moded(v)    { mode = clamp(v, 0, 3); }
function learnon(v)  { learning = v ? 1 : 0; }
function loon(v)     { loOn = v ? 1 : 0; }
function lo(v)       { loNote = clamp(v, 0, 127); }
function hion(v)     { hiOn = v ? 1 : 0; }
function hi(v)       { hiNote = clamp(v, 0, 127); }
function octaven(v)  { oct = clamp(v, -4, 4); }
function semin(v)    { semi = clamp(v, -12, 12); }
function muteon(v)   { muted = v ? 1 : 0; if (muted) allOff(); }
function bypasson(v) { allOff(); bypassed = v ? 1 : 0; }
function panic()     { allOff(); }
