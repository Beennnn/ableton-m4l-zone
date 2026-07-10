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

def lnum(id, var, short, rect, init, mn, mx, pres, unitstyle=None):
    # unitstyle=8 = "MIDI Note" -> the numbox displays note names (C3, F6…) instead of raw 0-127.
    # A note is an integer, so switch parameter_type to Int (0) when a note unitstyle is set.
    valueof = {
        "parameter_longname": var, "parameter_shortname": short,
        "parameter_type": 0 if unitstyle is not None else 1,
        "parameter_mmin": mn, "parameter_mmax": mx, "parameter_initial_enable": 1, "parameter_initial": [init]}
    if unitstyle is not None:
        valueof["parameter_unitstyle"] = unitstyle
    box(id, "live.numbox", None, rect, 1, 2, ["", "float"], {
        "varname": var, "parameter_enable": 1, "presentation": 1, "presentation_rect": pres,
        "saved_attribute_attributes": {"valueof": valueof}})

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

def lbl(id, text, pres, dim=False, w=None):
    if w is None: w = max(18, len(text) * 6 + 2)          # text-fit width -> a label never covers/blocks a nearby control
    box(id, "comment", text, [pres[0], 300 + pres[1], 120, 18], 1, 0, None,
        {"fontsize": 10.0, "textcolor": [0.55 if dim else 0.83]*3 + [1.0], "presentation": 1, "presentation_rect": [pres[0], pres[1], w, 15]})

# --- MIDI flow (patching view) ---
box("obj-1", "newobj", "midiin",       [ 30,  30,  45, 22], 1, 1, ["int"])
box("obj-2", "newobj", "midiparse",    [ 30,  80,  62, 22], 1, 7, ["", "", "", "int", "int", "int", "int"])
box("obj-3", "newobj", "js zone.js",   [ 30, 360,  90, 22], 1, 6, ["", "", "", "", "", ""])  # +2 outlets: 4=Low note-name, 5=High note-name
box("obj-4", "newobj", "midiformat",   [200, 300,  66, 22], 7, 1, ["int"])
box("obj-5", "newobj", "midiout",      [ 30, 440,  50, 22], 1, 0)

# --- UI controls (mappable) + presentation rects ---
# Global row (y~9) : Bypass = let everything through (no limits) ; Mute = block everything (empty zone)
ltog("obj-13", "bypass", "Bypass", [400, 40, 24, 24], [ 60,  9, 15, 15])
ltog("obj-12", "mute",   "Mute",   [400, 70, 24, 24], [206,  9, 15, 15])
# Limits row (y~34) : Lo + Hi bounds, kept close together
# Limits row grouped as [toggle][value][note-name] per side, so the raw MIDI number and its note
# name sit together. loOn/Low#/Low-name, then hiOn/High#/High-name.
ltog("obj-6",  "loOn",   "Lo on",  [400,100, 24, 24], [ 40, 34, 15, 15])
lnum("obj-7",  "loNote", "Low",    [440,100, 60, 18], 48, 0.0,127.0, [ 58, 34, 34, 16])  # raw MIDI value (editable) ; note name in obj-60 right after it
ltog("obj-8",  "hiOn",   "Hi on",  [400,130, 24, 24], [190, 34, 15, 15])
lnum("obj-9",  "hiNote", "High",   [440,130, 60, 18], 72, 0.0,127.0, [208, 34, 34, 16])  # raw MIDI value (editable) ; note name in obj-61 right after it
# Read-only note-name displays (comment, NOT a Live parameter — driven by zone.js outlets 4/5 via a
# "set <name>" message). Sit immediately right of each value; light tint + fontsize 11 for legibility
# on the grey device. Touching the numbox's own unit style broke device instantiation, so this stays
# a separate, parameter-free label. Nudge in Max presentation mode to taste.
box("obj-60", "comment", "C2", [520, 100, 44, 18], 1, 0, None, {"presentation": 1, "presentation_rect": [ 94, 34, 32, 16], "fontsize": 11.0, "textjustification": 0, "textcolor": [0.00, 0.44, 0.30, 1.0]})
box("obj-61", "comment", "C4", [520, 130, 44, 18], 1, 0, None, {"presentation": 1, "presentation_rect": [244, 34, 32, 16], "fontsize": 11.0, "textjustification": 0, "textcolor": [0.36, 0.14, 0.58, 1.0]})
# Post-transpose row (y~60) : octave (coarse) + tone (fine), applied AFTER the filter
lnum("obj-10", "octave", "Octave", [400,160, 60, 18],  0, -4.0, 4.0, [130, 60, 40, 16])
lnum("obj-11", "semitone","Tone",  [440,160, 60, 18],  0, -12.0,12.0,[214, 60, 40, 16])
box("obj-14", "live.tab", None, [400, 190, 210, 20], 1, 3, ["", "", ""], {"varname": "mode", "parameter_enable": 1, "presentation": 1, "presentation_rect": [10, 88, 300, 18], "saved_attribute_attributes": {"valueof": {"parameter_longname": "mode", "parameter_shortname": "Mode", "parameter_type": 2, "parameter_enum": ["Edit Low", "Edit High", "Watch In", "Watch Out"], "parameter_mmin": 0, "parameter_mmax": 3}}})
# Learn button removed — Edit Lo/Hi mode captures played notes directly
box("obj-16", "kslider", None, [400, 230, 340, 56], 1, 2, ["int", "int"], {"presentation": 1, "presentation_rect": [26, 112, 408, 38], "offset": 36, "range": 61})
# octave-scroll arrows for the keyboard view (textbutton = plain UI, not a Live parameter)
box("obj-17", "textbutton", None, [640, 230, 20, 20], 1, 3, ["", "", ""], {"text": "<", "presentation": 1, "presentation_rect": [10, 112, 14, 38], "fontsize": 9.0})
box("obj-18", "textbutton", None, [670, 230, 20, 20], 1, 3, ["", "", ""], {"text": ">", "presentation": 1, "presentation_rect": [436, 112, 14, 38], "fontsize": 9.0})

# --- labels (presentation) ---
lbl("obj-70", "Global",         [10, 11], dim=True)
lbl("obj-40", "Bypass",         [79, 11])
lbl("obj-71", "no limits",      [127,11], dim=True)
lbl("obj-41", "Mute",           [225,11])
lbl("obj-72", "empty zone",     [263,11], dim=True)
lbl("obj-73", "Limits",         [10, 36], dim=True)
# "Low"/"High" word labels dropped — the color-coded note names (teal=low, violet=high, matching
# the keyboard edit colours) + left-to-right order carry it, and the row is titled "Limits".
lbl("obj-74", "Post transpose", [10, 62], dim=True)
lbl("obj-44", "Oct",            [104,62])
lbl("obj-45", "Tone",           [182,62])
# (no Learn label — Edit auto-learns)

# --- prepends (UI -> js) ---
pre = {"loon":"obj-6","lo":"obj-7","hion":"obj-8","hi":"obj-9","octaven":"obj-10",
       "semin":"obj-11","muteon":"obj-12","bypasson":"obj-13","moded":"obj-14",
       "kbd":"obj-16","kleft":"obj-17","kright":"obj-18"}
pid = {}
y = 170
for i,(msg,src) in enumerate(pre.items()):
    oid = "obj-%d" % (20+i)
    pid[msg] = oid
    box(oid, "newobj", "prepend %s" % msg, [400, y+i*26, 110, 22], 1, 1)
# Feedback prepends live at obj-50/51 — clear of BOTH the prepend loop (obj-20..obj-31, so obj-31
# == "prepend kright") AND the labels (obj-40..45). The original obj-31/32 collided with the loop,
# leaving the ">" button wired to "prepend set" instead of "prepend kright" (dead scroll).
box("obj-50", "newobj", "prepend set", [640, 100, 75, 22], 1, 1)   # Lo feedback
box("obj-51", "newobj", "prepend set", [640, 140, 75, 22], 1, 1)   # Hi feedback

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
line("obj-3", 1, "obj-50", 0); line("obj-50", 0, "obj-7", 0)
line("obj-3", 2, "obj-51", 0); line("obj-51", 0, "obj-9", 0)
line("obj-3", 3, "obj-16", 0)   # viz + colour + note display -> kslider
line("obj-3", 4, "obj-60", 0)   # Low note-name  -> comment  (js sends "set <name>")
line("obj-3", 5, "obj-61", 0)   # High note-name -> comment

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
