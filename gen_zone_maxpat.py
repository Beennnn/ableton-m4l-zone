#!/usr/bin/env python3
# gen_zone_maxpat.py — builds zone.maxpat (the "Zone" Max for Live MIDI Effect).
# Notes -> [js zone.js] (filter [Lo,Hi) then octave/semitone shift, mute, bypass) -> midiout.
# Everything else (CC, pitch bend, aftertouch, program, poly) passes through midiparse -> midiformat.
# No on-screen keyboard: each bound is set by typing the MIDI value in its numbox, OR by clicking its
# "learn" button (arms it) then playing the note you want as the limit. All live.* controls are
# parameter_enable'd -> mappable to Ableton macros.
import json, os

boxes, lines = [], []

def box(id, maxclass, text, rect, ins, outs, outtype=None, extra=None):
    b = {"id": id, "maxclass": maxclass, "numinlets": ins, "numoutlets": outs, "patching_rect": rect}
    if text is not None: b["text"] = text
    if outtype is not None: b["outlettype"] = outtype
    if extra: b.update(extra)
    boxes.append({"box": b})

def line(s, so, d, di):
    lines.append({"patchline": {"source": [s, so], "destination": [d, di]}})

def lnum(id, var, short, rect, init, mn, mx, pres):
    box(id, "live.numbox", None, rect, 1, 2, ["", "float"], {
        "varname": var, "parameter_enable": 1, "presentation": 1, "presentation_rect": pres,
        "saved_attribute_attributes": {"valueof": {
            "parameter_longname": var, "parameter_shortname": short, "parameter_type": 1,
            "parameter_mmin": mn, "parameter_mmax": mx, "parameter_initial_enable": 1, "parameter_initial": [init]}}})

def ltog(id, var, short, rect, pres, color=None):
    extra = {"varname": var, "parameter_enable": 1, "presentation": 1, "presentation_rect": pres,
             "saved_attribute_attributes": {"valueof": {
                 "parameter_longname": var, "parameter_shortname": short, "parameter_type": 2,
                 "parameter_enum": ["off", "on"], "parameter_mmin": 0, "parameter_mmax": 1}}}
    if color: extra["activecolor"] = color   # "on" colour (teal for Low, violet for High)
    box(id, "live.toggle", None, rect, 1, 1, ["", ""], extra)

def learnbtn(id, var, short, pres):   # live.button — the reliable momentary button in M4L.
    # (Plain textbutton does NOT fire clicks through in this device — that was the dead ">"/learn
    # bug; every live.* control works, so use live.button.) It's a mappable parameter (bonus: you
    # can map a footswitch to Learn). Pair it with a small "learn" comment label for clarity.
    box(id, "live.button", None, [640, 100, 20, 20], 1, 1, ["bang"],
        {"varname": var, "parameter_enable": 1, "presentation": 1, "presentation_rect": pres,
         "saved_attribute_attributes": {"valueof": {"parameter_longname": var, "parameter_shortname": short}}})

def note(id, text, pres, color):   # read-only note-name label (comment) driven by zone.js
    box(id, "comment", text, [520, 100, 44, 18], 1, 0, None,
        {"presentation": 1, "presentation_rect": pres, "fontsize": 11.0, "textjustification": 0, "textcolor": color})

def lbl(id, text, pres, dim=False, w=None):
    if w is None: w = max(18, len(text) * 6 + 2)
    box(id, "comment", text, [pres[0], 300 + pres[1], 120, 18], 1, 0, None,
        {"fontsize": 10.0, "textcolor": [0.55 if dim else 0.83]*3 + [1.0], "presentation": 1, "presentation_rect": [pres[0], pres[1], w, 15]})

# --- MIDI flow (patching view) ---
box("obj-1", "newobj", "midiin",     [ 30,  30,  45, 22], 1, 1, ["int"])
box("obj-2", "newobj", "midiparse",  [ 30,  80,  62, 22], 1, 7, ["", "", "", "int", "int", "int", "int"])
box("obj-3", "newobj", "js zone.js", [ 30, 360,  90, 22], 1, 7, ["", "", "", "", "", "", ""])  # 0 MIDI, 1/2 Low/High fb, 3/4 note names, 5/6 Low/High learn-state
box("obj-4", "newobj", "midiformat", [200, 300,  66, 22], 7, 1, ["int"])
box("obj-5", "newobj", "midiout",    [ 30, 440,  50, 22], 1, 0)

# --- UI controls (mappable) + presentation rects ---
TEAL   = [0.0, 0.69, 0.53, 1.0]    # Low  accent (toggle "on" colour)
VIOLET = [0.55, 0.50, 0.91, 1.0]   # High accent
TEAL_T   = [0.0, 0.44, 0.30, 1.0]  # readable dark text on the grey device
VIOLET_T = [0.36, 0.14, 0.58, 1.0]
# Global row (y~10) : Bypass = let everything through raw ; Mute = block all output
ltog("obj-13", "bypass", "Bypass", [400, 40, 24, 24], [ 60, 10, 15, 15])
ltog("obj-12", "mute",   "Mute",   [400, 70, 24, 24], [206, 10, 15, 15])
# Limits — Low on its own row (y~50), High below (y~72). Each: [on][learn][state][value][note].
ltog("obj-6", "loOn", "Lo on", [400, 100, 24, 24], [40, 50, 15, 15], color=TEAL)
learnbtn("obj-17", "learnLo", "Learn Lo", [62, 50, 15, 15])
lnum("obj-7", "loNote", "Low", [440, 100, 60, 18], 48, 0.0, 127.0, [118, 50, 34, 16])
note("obj-60", "C2", [156, 50, 30, 16], TEAL_T)
ltog("obj-8", "hiOn", "Hi on", [400, 130, 24, 24], [40, 72, 15, 15], color=VIOLET)
learnbtn("obj-18", "learnHi", "Learn Hi", [62, 72, 15, 15])
lnum("obj-9", "hiNote", "High", [440, 130, 60, 18], 72, 0.0, 127.0, [118, 72, 34, 16])
note("obj-61", "C4", [156, 72, 30, 16], VIOLET_T)
# Transpose row (y~96) : octave (coarse) + tone (fine), applied AFTER the filter
lnum("obj-10", "octave",  "Octave", [400, 160, 60, 18],  0, -4.0,  4.0, [116, 96, 40, 16])
lnum("obj-11", "semitone", "Tone",  [440, 160, 60, 18],  0, -12.0, 12.0, [196, 96, 40, 16])

# --- labels (presentation) ---
lbl("obj-70", "Global",         [10, 11], dim=True)
lbl("obj-40", "Bypass",         [79, 11])
lbl("obj-71", "no limits",      [127, 11], dim=True)
lbl("obj-41", "Mute",           [225, 11])
lbl("obj-72", "mute track",     [263, 11], dim=True)
lbl("obj-73", "Limits",         [10, 36], dim=True)
# Per-limit row labels (coloured) — one row for Low (y50), one for High (y72).
box("obj-48", "comment", "Low",  [520, 100, 40, 18], 1, 0, None, {"presentation": 1, "presentation_rect": [10, 51, 26, 13], "fontsize": 9.0, "textcolor": [0.00, 0.44, 0.30, 1.0]})
box("obj-49", "comment", "High", [520, 130, 40, 18], 1, 0, None, {"presentation": 1, "presentation_rect": [10, 73, 26, 13], "fontsize": 9.0, "textcolor": [0.36, 0.14, 0.58, 1.0]})
# Learn-state labels right of each learn button — driven by zone.js outlets 5/6: "learn" idle,
# "play" while armed (prompt + armed indicator).
box("obj-46", "comment", "learn", [520, 160, 44, 18], 1, 0, None, {"presentation": 1, "presentation_rect": [82, 51, 32, 13], "fontsize": 9.0, "textjustification": 1, "textcolor": [0.00, 0.44, 0.30, 1.0]})
box("obj-47", "comment", "learn", [520, 190, 44, 18], 1, 0, None, {"presentation": 1, "presentation_rect": [82, 73, 32, 13], "fontsize": 9.0, "textjustification": 1, "textcolor": [0.36, 0.14, 0.58, 1.0]})
lbl("obj-74", "Post transpose", [10, 97], dim=True)
lbl("obj-44", "Oct",            [96, 98])
lbl("obj-45", "Tone",           [172, 98])

# --- prepends (UI -> js) : source object id -> js message ---
pre = {"loon": "obj-6", "lo": "obj-7", "hion": "obj-8", "hi": "obj-9", "octaven": "obj-10",
       "semin": "obj-11", "muteon": "obj-12", "bypasson": "obj-13",
       "learnlo": "obj-17", "learnhi": "obj-18"}
pid = {}
y = 170
for i, (msg, src) in enumerate(pre.items()):
    oid = "obj-%d" % (20 + i)      # obj-20..obj-29 (10 entries) — clear of the feedback prepends below
    pid[msg] = oid
    box(oid, "newobj", "prepend %s" % msg, [400, y + i * 26, 110, 22], 1, 1)
box("obj-50", "newobj", "prepend set", [640, 300, 75, 22], 1, 1)   # Lo feedback (js -> numbox, no re-output)
box("obj-51", "newobj", "prepend set", [640, 340, 75, 22], 1, 1)   # Hi feedback

# --- wiring : MIDI ---
line("obj-1", 0, "obj-2", 0)
line("obj-2", 0, "obj-3", 0)                        # notes -> js
for k in range(1, 7): line("obj-2", k, "obj-4", k)  # everything else -> passthrough
line("obj-3", 0, "obj-5", 0)                        # filtered/shifted notes -> midiout
line("obj-4", 0, "obj-5", 0)                        # passthrough -> midiout

# --- wiring : UI -> prepend -> js ---
for msg, src in pre.items():
    line(src, 0, pid[msg], 0)
    line(pid[msg], 0, "obj-3", 0)
# --- feedback : js -> numbox (set = no re-output) ---
line("obj-3", 1, "obj-50", 0); line("obj-50", 0, "obj-7", 0)
line("obj-3", 2, "obj-51", 0); line("obj-51", 0, "obj-9", 0)
# --- note-name displays ---
line("obj-3", 3, "obj-60", 0)   # Low note-name  -> comment ("set <name>")
line("obj-3", 4, "obj-61", 0)   # High note-name -> comment
# --- learn-state labels (learn / play) ---
line("obj-3", 5, "obj-46", 0)   # Low learn-state  -> label
line("obj-3", 6, "obj-47", 0)   # High learn-state -> label

patch = {"patcher": {
    "fileversion": 1,
    "appversion": {"major": 8, "minor": 6, "revision": 0, "architecture": "x64", "modernui": 1},
    "classnamespace": "box",
    "rect": [80, 80, 820, 560],
    "openinpresentation": 1,
    "default_fontsize": 12.0, "default_fontface": 0, "default_fontname": "Arial",
    "gridonopen": 1, "gridsize": [15.0, 15.0],
    "boxes": boxes, "lines": lines,
}}

out = os.path.expanduser("~/dev/music/m4l/zone.maxpat")
json.dump(patch, open(out, "w"), indent=2)
json.load(open(out))
print(f"OK wrote: {out}")
print(f"  {len(boxes)} boxes · {len(lines)} lines · valid JSON · no keyboard (learn buttons)")
