#!/usr/bin/env python3
# gen_zone_maxpat.py — builds zone.maxpat (the "Zone" Max for Live MIDI Effect).
# Notes are filtered by [js zone.js]; ALL other MIDI (CC, pitch bend, aftertouch,
# program, poly) passes through unchanged via midiparse -> midiformat.
# live.* params are parameter_enable'd -> mappable to Ableton macros for inter-instance sync.
import json, os

boxes, lines = [], []

def box(id, maxclass, text, rect, ins, outs, outtype=None, extra=None):
    b = {"id": id, "maxclass": maxclass, "numinlets": ins, "numoutlets": outs,
         "patching_rect": rect}
    if text is not None: b["text"] = text
    if outtype is not None: b["outlettype"] = outtype
    if extra: b.update(extra)
    boxes.append({"box": b})

def line(s, so, d, di):
    lines.append({"patchline": {"source": [s, so], "destination": [d, di]}})

def lnum(id, var, short, rect, init):
    box(id, "live.numbox", None, rect, 1, 2, ["", "float"], {
        "varname": var, "parameter_enable": 1,
        "saved_attribute_attributes": {"valueof": {
            "parameter_longname": var, "parameter_shortname": short,
            "parameter_type": 1, "parameter_mmin": 0.0, "parameter_mmax": 127.0,
            "parameter_initial_enable": 1, "parameter_initial": [init]}}})

def ltog(id, var, short, rect):
    box(id, "live.toggle", None, rect, 1, 1, ["", ""], {
        "varname": var, "parameter_enable": 1,
        "saved_attribute_attributes": {"valueof": {
            "parameter_longname": var, "parameter_shortname": short,
            "parameter_type": 2, "parameter_enum": ["off", "on"],
            "parameter_mmin": 0, "parameter_mmax": 1}}})

def lbtn(id, var, short, rect):
    box(id, "live.button", None, rect, 1, 1, ["bang"], {
        "varname": var, "parameter_enable": 1,
        "saved_attribute_attributes": {"valueof": {
            "parameter_longname": var, "parameter_shortname": short}}})

# --- MIDI flow ---
box("obj-1", "newobj", "midiin",         [ 30,  30,  45, 22], 1, 1, ["int"])
box("obj-2", "newobj", "midiparse",      [ 30,  80,  62, 22], 1, 7, ["", "", "", "int", "int", "int", "int"])
box("obj-3", "newobj", "js zone.js",     [ 30, 340,  90, 22], 1, 3, ["", "", ""])
box("obj-4", "newobj", "midiformat",     [200, 290,  66, 22], 7, 1, ["int"])
box("obj-5", "newobj", "midiout",        [ 30, 430,  50, 22], 1, 0)

# --- UI (mappable params) ---
ltog("obj-6",  "loOn",    "Lo on",    [400,  40, 24, 24])
lnum("obj-7",  "loNote",  "Lo note",  [440,  40, 60, 22], 48)
lbtn("obj-8",  "learnLo", "Learn Lo", [520,  40, 24, 24])
ltog("obj-9",  "hiOn",    "Hi on",    [400, 100, 24, 24])
lnum("obj-10", "hiNote",  "Hi note",  [440, 100, 60, 22], 72)
lbtn("obj-11", "learnHi", "Learn Hi", [520, 100, 24, 24])

# --- prepend UI -> js ---
box("obj-12", "newobj", "prepend loon",    [400, 170,  90, 22], 1, 1)
box("obj-13", "newobj", "prepend lo",      [440, 200,  70, 22], 1, 1)
box("obj-14", "newobj", "prepend learnlo", [520, 170, 100, 22], 1, 1)
box("obj-15", "newobj", "prepend hion",    [400, 230,  90, 22], 1, 1)
box("obj-16", "newobj", "prepend hi",      [440, 260,  70, 22], 1, 1)
box("obj-17", "newobj", "prepend learnhi", [520, 230, 100, 22], 1, 1)
box("obj-18", "newobj", "prepend set",     [640, 200,  75, 22], 1, 1)
box("obj-19", "newobj", "prepend set",     [640, 260,  75, 22], 1, 1)
# pianos cliquables : clic sur une touche -> pose la borne (alimente le numbox)
box("obj-20", "kslider", None, [360, 300, 340, 56], 1, 2, ["int", "int"])
box("obj-21", "kslider", None, [360, 370, 340, 56], 1, 2, ["int", "int"])

# --- MIDI flow wiring ---
line("obj-1", 0, "obj-2", 0)
line("obj-2", 0, "obj-3", 0)     # notes -> js (filter)
line("obj-2", 1, "obj-4", 1)     # poly  -> passthrough
line("obj-2", 2, "obj-4", 2)     # CC (expression/sustain/breath) -> passthrough
line("obj-2", 3, "obj-4", 3)     # program
line("obj-2", 4, "obj-4", 4)     # aftertouch
line("obj-2", 5, "obj-4", 5)     # pitch bend
line("obj-2", 6, "obj-4", 6)     # channel
line("obj-3", 0, "obj-5", 0)     # filtered notes -> midiout
line("obj-4", 0, "obj-5", 0)     # passthrough    -> midiout
# --- UI -> js ---
for tog, pre in [("obj-6","obj-12"),("obj-7","obj-13"),("obj-8","obj-14"),
                 ("obj-9","obj-15"),("obj-10","obj-16"),("obj-11","obj-17")]:
    line(tog, 0, pre, 0); line(pre, 0, "obj-3", 0)
# --- learn feedback -> numbox (set = no re-output) ---
line("obj-3", 1, "obj-18", 0); line("obj-18", 0, "obj-7", 0)
line("obj-3", 2, "obj-19", 0); line("obj-19", 0, "obj-10", 0)
# --- pianos -> numbox (clic pose la borne) ---
line("obj-20", 0, "obj-7", 0)    # piano Lo -> loNote
line("obj-21", 0, "obj-10", 0)   # piano Hi -> hiNote

patch = {"patcher": {
    "fileversion": 1,
    "appversion": {"major": 8, "minor": 6, "revision": 0, "architecture": "x64", "modernui": 1},
    "classnamespace": "box",
    "rect": [80, 80, 780, 540],
    "openinpresentation": 0,
    "default_fontsize": 12.0, "default_fontface": 0, "default_fontname": "Arial",
    "gridonopen": 1, "gridsize": [15.0, 15.0],
    "boxes": boxes, "lines": lines,
}}

out = os.path.expanduser("~/dev/music/m4l/zone.maxpat")
json.dump(patch, open(out, "w"), indent=2)
json.load(open(out))  # JSON valid?
print(f"OK wrote: {out}")
print(f"  {len(boxes)} boxes · {len(lines)} lines · valid JSON")
