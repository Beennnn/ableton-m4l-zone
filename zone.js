// zone.js — brain of the "Zone" Max for Live MIDI device (v3.2).
// Keyboard zone / split filter, THEN octave + tone (semitone) shift, plus mute and bypass.
// One on-screen keyboard, driven by a MODE selector — with a consistent COLOR CODE:
//   0 Edit Lo   (teal)   — play a note or click the keyboard to set the low bound  (Edit IS the learn)
//   1 Edit Hi   (violet) — play a note or click the keyboard to set the high bound
//   2 Watch In  (blue)   — the keyboard lights the INCOMING note you play
//   3 Watch Out (amber)  — the keyboard lights the OUTGOING (filtered + shifted) note
// The keyboard's highlight colour and the active mode-tab colour follow the mode, so the same code
// (Lo=teal, Hi=violet, In=blue, Out=amber) is reused for the edits and the split-point / note colours.
//
// Signal path: bypass -> untouched ; mute -> dropped ; else if inside [Lo,Hi) -> pass, shifted by octave*12 + tone.
// Note tracking: each held note remembers its OUTPUT pitch -> the note-off always matches, no stuck notes.
//
// MIT — free to use, modify and share.

autowatch = 1;
outlets = 5;   // 0 = MIDI ; 1 = Lo fb ; 2 = Hi fb ; 3 = keyboard (kslider) hkeycolor + notes ; 4 = mode tab colour

var loOn = 0, loNote = 0, hiOn = 0, hiNote = 128;
var oct = 0, semi = 0, muted = 0, bypassed = 0;
var mode = 0, busy = 0;              // busy : guard against the live.tab colour-echo re-entering moded()
var held = {};                       // inPitch -> outPitch
var shown = -1;                      // key currently lit for the Edit-mode bound

// consistent colour code (RGBA 0..1) — Lo teal, Hi violet, In blue, Out amber
var COL = { lo: [0.18, 0.69, 0.53, 1], hi: [0.55, 0.50, 0.91, 1], "in": [0.23, 0.62, 0.88, 1], out: [0.88, 0.64, 0.18, 1] };

function clamp(v, a, b) { v = Math.round(v); return v < a ? a : (v > b ? b : v); }
function shift(p)       { return clamp(p + oct * 12 + semi, 0, 127); }
function passes(p)      { return (!loOn || p >= loNote) && (!hiOn || p < hiNote); }

function setColor(c) { outlet(3, "hkeycolor", c[0], c[1], c[2], c[3]); }
function clearShown() { if (shown >= 0) { outlet(3, [shown, 0]); shown = -1; } }
function showKey(n)   { clearShown(); outlet(3, [n, 100]); shown = n; }

function setBound(n) {
    if (mode == 1) { hiNote = clamp(n, 0, 127); outlet(2, hiNote); showKey(hiNote); }
    else if (mode == 0) { loNote = clamp(n, 0, 127); outlet(1, loNote); showKey(loNote); }
}
function viz(inP, outP, vel) { if (mode == 2) outlet(3, [inP, vel]); else if (mode == 3) outlet(3, [outP, vel]); }

function list(pitch, velocity) {
    if (mode < 2 && velocity > 0) setBound(pitch);   // Edit Lo/Hi : a played note sets the armed bound (= learn)
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

function kbd(n) { if (mode < 2) setBound(n); }        // click on the on-screen keyboard sets the armed bound
function moded(v) {
    mode = clamp(v, 0, 3);
    var c = mode == 0 ? COL.lo : mode == 1 ? COL.hi : mode == 2 ? COL["in"] : COL.out;
    setColor(c);                                          // kslider highlight -> mode colour
    if (!busy) {                                          // live.tab echoes the colour msg straight back into moded() -> guard the synchronous re-entry (was: js stack overflow, outlets disabled)
        busy = 1;
        outlet(4, "activebgcolor", c[0], c[1], c[2], c[3]);   // mode tab active colour
        busy = 0;
    }
    clearShown();
    if (mode == 0) showKey(loNote);
    else if (mode == 1) showKey(hiNote);                  // Watch modes : cleared, live notes fill in
}
function loon(v)     { loOn = v ? 1 : 0; }
function lo(v)       { loNote = clamp(v, 0, 127); if (mode == 0) showKey(loNote); }
function hion(v)     { hiOn = v ? 1 : 0; }
function hi(v)       { hiNote = clamp(v, 0, 127); if (mode == 1) showKey(hiNote); }
function octaven(v)  { oct = clamp(v, -4, 4); }
function semin(v)    { semi = clamp(v, -12, 12); }        // "Tone" control (semitones)
function muteon(v)   { muted = v ? 1 : 0; if (muted) allOff(); }
function bypasson(v) { allOff(); bypassed = v ? 1 : 0; }
function panic()     { allOff(); }
