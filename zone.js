// zone.js — brain of the "Zone" Max for Live MIDI device (v3.4).
// Keyboard zone / split filter, THEN octave + tone (semitone) shift, plus mute and bypass.
// One on-screen keyboard, driven by a MODE selector :
//   0 Edit Low  — play a note or click the keyboard to set the low bound  (Edit IS the learn)
//   1 Edit High — set the high bound
//   2 Watch In  — the keyboard lights the INCOMING note you play
//   3 Watch Out — the keyboard lights the OUTGOING (filtered + shifted) note
// The keyboard-highlight colour follows the mode (Low=teal, High=violet, In=blue, Out=amber).
//
// Signal path: bypass -> untouched ; mute -> dropped ; else inside [Low,High) -> pass, shifted by octave*12 + tone.
//
// IMPORTANT — a kslider ECHOES back on its outlet any note we send it for display. Every
// programmatic send therefore goes through kout()/knote() which raise an `echo` flag, and kbd()
// ignores notes that arrive while `echo` is set. Without this, showKey -> kslider -> echo ->
// kbd -> setBound -> showKey ... recurses synchronously = "js stack overflow, outlets disabled".
// (The mode-tab was also recolored from here in v3.2 ; that fed live.tab back into moded() and was
// a second stack-overflow source, so tab recolouring is dropped — the keyboard carries the colour.)
//
// MIT — free to use, modify and share.

autowatch = 1;
outlets = 4;   // 0 = MIDI ; 1 = Low feedback ; 2 = High feedback ; 3 = keyboard (kslider) colour + note display

var loOn = 0, loNote = 0, hiOn = 0, hiNote = 128;
var oct = 0, semi = 0, muted = 0, bypassed = 0;
var mode = 0;
var held = {};                       // inPitch -> outPitch
var shown = -1;                      // key currently lit for the Edit-mode bound
var echo = 0;                        // 1 while we drive the kslider -> its echo must be ignored by kbd()
var koff = 36;                       // kslider view offset (lowest displayed note) — 61 keys shown, scroll by octave

var COL = { lo: [0.18, 0.69, 0.53, 1], hi: [0.55, 0.50, 0.91, 1], "in": [0.23, 0.62, 0.88, 1], out: [0.88, 0.64, 0.18, 1] };

function clamp(v, a, b) { v = Math.round(v); return v < a ? a : (v > b ? b : v); }
function shift(p)       { return clamp(p + oct * 12 + semi, 0, 127); }
function passes(p)      { return (!loOn || p >= loNote) && (!hiOn || p < hiNote); }

// every programmatic send to the kslider raises `echo` so its outlet bounce-back is ignored in kbd()
function kcol(c)     { echo = 1; outlet(3, "hkeycolor", c[0], c[1], c[2], c[3]); echo = 0; }
function knote(n, v) { echo = 1; outlet(3, [n, v]); echo = 0; }
function clearShown(){ if (shown >= 0) { knote(shown, 0); shown = -1; } }
function showKey(n)  { clearShown(); knote(n, 100); shown = n; }

function setBound(n) {
    if (mode == 1) { hiNote = clamp(n, 0, 127); outlet(2, hiNote); showKey(hiNote); }
    else if (mode == 0) { loNote = clamp(n, 0, 127); outlet(1, loNote); showKey(loNote); }
}
function viz(inP, outP, vel) { if (mode == 2) knote(inP, vel); else if (mode == 3) knote(outP, vel); }

function list(pitch, velocity) {
    if (mode < 2 && velocity > 0) setBound(pitch);   // Edit Low/High : a played note sets the armed bound (= learn)
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

function kbd(n) { if (echo) return; if (mode < 2) setBound(n); }   // real click sets the bound ; kslider echo is ignored

// ---- keyboard view scroll (61 visible keys out of 128 ; arrows move one octave) ----
function kview()  { echo = 1; outlet(3, "offset", koff); echo = 0; }
function kleft()  { koff = Math.max(0, koff - 12); kview(); }
function kright() { koff = Math.min(60, koff + 12); kview(); }      // 60 + 61 keys = top of MIDI range
function loadbang() { kview(); moded(mode); }                       // restore view + mode colour when the device loads
function moded(v) {
    mode = clamp(v, 0, 3);
    kcol(mode == 0 ? COL.lo : mode == 1 ? COL.hi : mode == 2 ? COL["in"] : COL.out);   // keyboard highlight -> mode colour
    clearShown();
    if (mode == 0) showKey(loNote);
    else if (mode == 1) showKey(hiNote);              // Watch modes : cleared, live notes fill in
}
function loon(v)     { loOn = v ? 1 : 0; }
function lo(v)       { loNote = clamp(v, 0, 127); if (mode == 0) showKey(loNote); }
function hion(v)     { hiOn = v ? 1 : 0; }
function hi(v)       { hiNote = clamp(v, 0, 127); if (mode == 1) showKey(hiNote); }
function octaven(v)  { oct = clamp(v, -4, 4); }
function semin(v)    { semi = clamp(v, -12, 12); }    // "Tone" control (semitones)
function muteon(v)   { muted = v ? 1 : 0; if (muted) allOff(); }
function bypasson(v) { allOff(); bypassed = v ? 1 : 0; }
function panic()     { allOff(); }
