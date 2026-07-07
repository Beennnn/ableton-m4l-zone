#!/usr/bin/env python3
# gen_zone_maxpat.py — builds zone.maxpat (the "Zone" Max for Live MIDI Effect, v2).
# Compact single-keyboard layout (fits the Ableton device view height).
# Notes -> [js zone.js] (filter [Lo,Hi) then octave/semitone shift, mute, bypass) -> midiout.
# Everything else (CC, pitch bend, aftertouch, program, poly) passes through via midiparse -> midiformat.
# All live.* controls are parameter_enable'd -> mappable to Ableton macros.
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

def ltog(id, var, short, rect, pres):
    box(id, "live.toggle", None, rect, 1, 1, ["", ""], {
        "varname": var, "parameter_enable": 1, "presentation": 1, "presentation_rect": pres,
        "saved_attribute_attributes": {"valueof": {
            "parameter_longname": var, "parameter_shortname": short, "parameter_type": 2,
            "parameter_enum": ["off", "on"], "parameter_mmin": 0, "parameter_mmax": 1}}})

def lbtn(id, var, short, rect, pres):
    box(id, "live.button", None, rect, 1, 1, ["bang"], {
        "varname": var, "parameter_enable": 1, "presentation": 1, "presentation_rect": pres,
        "saved_attribute_attributes": {"valueof": {"parameter_longname": var, "parameter_shortname": short}}})

def lbl(id, text, pres, dim=False):
    box(id, "comment", text, [pres[0], 300 + pres[1], 120, 18], 1, 0, None,
        {"fontsize": 10.0, "textcolor": [0.55 if dim else 0.83]*3 + [1.0], "presentation": 1, "presentation_rect": pres})

# --- MIDI flow (patching view) ---
box("obj-1", "newobj", "midiin",       [ 30,  30,  45, 22], 1, 1, ["int"])
box("obj-2", "newobj", "midiparse",    [ 30,  80,  62, 22], 1, 7, ["", "", "", "int", "int", "int", "int"])
box("obj-3", "newobj", "js zone.js",   [ 30, 360,  90, 22], 1, 5, ["", "", "", "", ""])
box("obj-4", "newobj", "midiformat",   [200, 300,  66, 22], 7, 1, ["int"])
box("obj-5", "newobj", "midiout",      [ 30, 440,  50, 22], 1, 0)

# --- UI controls (mappable) + presentation rects ---
ltog("obj-13", "bypass", "Bypass", [400, 40, 24, 24], [10,  8, 16, 16])
ltog("obj-12", "mute",   "Mute",   [400, 70, 24, 24], [100, 8, 16, 16])
ltog("obj-6",  "loOn",   "Lo on",  [400,100, 24, 24], [10, 32, 16, 16])
lnum("obj-7",  "loNote", "Lo",     [440,100, 60, 18], 48, 0.0,127.0, [48, 32, 42, 17])
ltog("obj-8",  "hiOn",   "Hi on",  [400,130, 24, 24], [108,32, 16, 16])
lnum("obj-9",  "hiNote", "Hi",     [440,130, 60, 18], 72, 0.0,127.0, [146,32, 42, 17])
lnum("obj-10", "octave", "Octave", [400,160, 60, 18],  0, -4.0, 4.0, [44, 57, 42, 17])
lnum("obj-11", "semitone","Semi",  [440,160, 60, 18],  0, -12.0,12.0,[152,57, 42, 17])
box("obj-14", "live.tab", None, [400, 190, 210, 20], 1, 3, ["", "", ""], {"varname": "mode", "parameter_enable": 1, "presentation": 1, "presentation_rect": [10, 82, 210, 18], "saved_attribute_attributes": {"valueof": {"parameter_longname": "mode", "parameter_shortname": "Mode", "parameter_type": 2, "parameter_enum": ["Edit Lo", "Edit Hi", "Watch In", "Watch Out"], "parameter_mmin": 0, "parameter_mmax": 3}}})
lbtn("obj-15", "learn",  "Learn",  [440,190, 24, 24], [228,82, 44, 16])
box("obj-16", "kslider", None, [400, 230, 340, 56], 1, 2, ["int", "int"], {"presentation": 1, "presentation_rect": [10, 106, 440, 40]})

# --- labels (presentation) ---
lbl("obj-40", "Bypass", [30,  9])
lbl("obj-41", "Mute",   [120, 9])
lbl("obj-42", "Lo",     [30, 33])
lbl("obj-43", "Hi",     [128,33])
lbl("obj-44", "Oct",    [10, 58])
lbl("obj-45", "Semi",   [110,58])
lbl("obj-46", "Learn", [230, 68], dim=True)

# --- prepends (UI -> js) ---
pre = {"loon":"obj-6","lo":"obj-7","hion":"obj-8","hi":"obj-9","octaven":"obj-10",
       "semin":"obj-11","muteon":"obj-12","bypasson":"obj-13","moded":"obj-14",
       "learnon":"obj-15","kbd":"obj-16"}
pid = {}
y = 170
for i,(msg,src) in enumerate(pre.items()):
    oid = "obj-%d" % (20+i)
    pid[msg] = oid
    box(oid, "newobj", "prepend %s" % msg, [400, y+i*26, 110, 22], 1, 1)
box("obj-31", "newobj", "prepend set", [640, 100, 75, 22], 1, 1)   # Lo feedback
box("obj-32", "newobj", "prepend set", [640, 140, 75, 22], 1, 1)   # Hi feedback

# --- wiring : MIDI ---
line("obj-1", 0, "obj-2", 0)
line("obj-2", 0, "obj-3", 0)                 # notes -> js
for k in range(1, 7): line("obj-2", k, "obj-4", k)   # everything else -> passthrough
line("obj-3", 0, "obj-5", 0)                 # filtered/shifted notes -> midiout
line("obj-4", 0, "obj-5", 0)                 # passthrough -> midiout

# --- wiring : UI -> prepend -> js ---
for msg, src in pre.items():
    line(src, 0, pid[msg], 0)
    line(pid[msg], 0, "obj-3", 0)
# --- feedback : js -> numbox (set = no re-output) ---
line("obj-3", 1, "obj-31", 0); line("obj-31", 0, "obj-7", 0)
line("obj-3", 2, "obj-32", 0); line("obj-32", 0, "obj-9", 0)
line("obj-3", 3, "obj-16", 0)   # viz (Watch In/Out) -> kslider display
line("obj-3", 4, "obj-14", 0)   # mode colour -> mode tab (active colour)

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
print(f"  {len(boxes)} boxes · {len(lines)} lines · valid JSON · presentation ~460x150")
