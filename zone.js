// zone.js — brain of the "Zone" Max for Live MIDI device (v2).
// Keyboard zone / split filter, THEN octave + semitone shift, plus mute and bypass.
//
// Signal path per note:
//   bypass ON   -> note passes untouched (no filter, no shift)
//   mute ON     -> note dropped
//   otherwise   -> if inside [Lo, Hi) : pass, shifted by (octave*12 + semitone)
//
//   Lo active -> pass notes >= loNote ; Hi active -> pass notes < hiNote (pivot belongs to the upper zone).
//   The shift is applied AFTER the filter (the filter tests the ORIGINAL pitch, the output is transposed).
//
// One on-screen keyboard sets both bounds: the "Edit" toggle arms Lo (off) or Hi (on); a keyboard click
// or a Learn-captured played note sets the armed bound.
//
// Note tracking: each held note remembers its OUTPUT pitch, so the note-off always matches — even if you
// move a bound, change the shift, mute or bypass while the note rings. No stuck notes.
//
// Outlet 3 streams (inPitch, outPitch, onoff) so a UI can show the incoming vs outgoing note in two colors.
//
// MIT — free to use, modify and share.

autowatch = 1;
outlets = 4;   // 0 = MIDI [status,d1,d2] -> midiout ; 1 = Lo feedback ; 2 = Hi feedback ; 3 = viz (in,out,onoff)

var loOn = 0, loNote = 0, hiOn = 0, hiNote = 128;
var oct = 0, semi = 0;            // octave (coarse) + semitone (fine), applied AFTER the filter
var muted = 0, bypassed = 0;
var edit = 0, learning = 0;       // edit: 0 = keyboard sets Lo, 1 = sets Hi ; learning: next played note -> armed bound
var held = {};                    // inPitch -> outPitch

function clamp(v, a, b) { v = Math.round(v); return v < a ? a : (v > b ? b : v); }
function shift(p)       { return clamp(p + oct * 12 + semi, 0, 127); }
function passes(p)      { return (!loOn || p >= loNote) && (!hiOn || p < hiNote); }
function setBound(n)    { if (edit) { hiNote = clamp(n, 0, 127); outlet(2, hiNote); } else { loNote = clamp(n, 0, 127); outlet(1, loNote); } }

// --- notes from [midiparse] : list = pitch velocity ---
function list(pitch, velocity) {
    if (learning && velocity > 0) { setBound(pitch); learning = 0; return; }
    if (velocity > 0) noteOn(pitch, velocity);
    else              noteOff(pitch);
}
function noteOn(p, v) {
    noteOff(p);                                        // retrigger : release the old one first
    if (bypassed) { outlet(0, [0x90, p, v]); held[p] = p; outlet(3, p, p, 1); return; }
    if (muted) return;
    if (passes(p)) { var o = shift(p); outlet(0, [0x90, o, v]); held[p] = o; outlet(3, p, o, 1); }
}
function noteOff(p) {
    if (held[p] !== undefined) { outlet(0, [0x90, held[p], 0]); outlet(3, p, held[p], 0); delete held[p]; }
}
function allOff() { for (var p in held) noteOff(Number(p)); }

// --- UI messages ---
function kbd(n)      { setBound(n); }                  // click on the on-screen keyboard -> armed bound
function edited(v)   { edit = v ? 1 : 0; }             // Edit toggle : 0=Lo, 1=Hi
function learnon(v)  { learning = v ? 1 : 0; }
function loon(v)     { loOn = v ? 1 : 0; }
function lo(v)       { loNote = clamp(v, 0, 127); }
function hion(v)     { hiOn = v ? 1 : 0; }
function hi(v)       { hiNote = clamp(v, 0, 127); }
function octaven(v)  { oct = clamp(v, -4, 4); }        // coarse
function semin(v)    { semi = clamp(v, -12, 12); }     // fine
function muteon(v)   { muted = v ? 1 : 0; if (muted) allOff(); }
function bypasson(v) { allOff(); bypassed = v ? 1 : 0; }
function panic()     { allOff(); }
