# Zone Keyboard — rack template

A ready-to-load **Instrument Rack** that turns Zone into a stage-keyboard
program: a **Basse** chain (left/low) + a **Piano** chain (right/high), one
shared split point, and mode macros — like the split/layer section of a
hardware stage keyboard.

![Zone Keyboard rack in the demo set — Split Point / Full Bass / Full Piano / Split macros, Basse + Piano chains](zone-keyboard-set.png)

The demo set has two MIDI tracks: **Zone Keyboard** (the macro rack) and
**Zone solo** (the bare device + an instrument, the simple one-track usage).

## Files

- **`Zone Keyboard.adg`** — the rack preset. Drop it into
  `User Library/Presets/Instruments/Instrument Rack/` (or drag it straight
  onto a MIDI track). Requires `zone.amxd` installed (see repo root).
- **`Zone Keyboard Template Project/Zone Keyboard Template.als`** — a whole
  Live set with the rack already on track 1, ready to play.

Both ship with **Drift** as placeholder instruments — swap in your own sounds
(Keyscape, Omnisphere, …) inside each chain, the Zone devices and macros stay.

## The 4 macros

| Macro | Default | What it does |
|---|---|---|
| **Split Point** | 60 (C3) | moves Basse **High** *and* Piano **Low** together — one knob slides the split across both chains |
| **Full Bass** | 0 | turn up → Basse's high limit turns **off** (bass everywhere) and Piano is **muted** |
| **Full Piano** | 0 | turn up → Piano's low limit turns **off** and Basse is **muted** |
| **Split** | 127 | at 127 both Zone filters are active (**split** mode) ; at 0 both Zones are **bypassed** → both sounds across the whole keyboard = **layer** mode |

Modes, in stage terms:

- **Split** (default): Full Bass 0 · Full Piano 0 · Split 127
- **Full bass**: Full Bass 127
- **Full piano**: Full Piano 127
- **Layer**: Split 0 (bonus — the same knob morphs split ↔ layer)

Each macro is a plain rack macro: MIDI-map it, automate it, or drive it from
a Stream Deck CC (the FNK_Browse `< Lower` / `> Upper` dials pattern).

## How it was built (for the curious / to rebuild)

1. MIDI track → `zone.amxd` + instrument → select both → ⌘G (Instrument Rack).
2. Duplicate the chain, name them `Basse` / `Piano`.
3. Basse: **Hi on** + High=60 · Piano: **Lo on** + Low=60.
4. Macro mappings are Live's `<KeyMidi>` blocks with `Channel=16` and
   `NoteOrController=<macro index>` on each M4L parameter — patched directly
   in the gzipped XML (see repo history), since that's scriptable and exact.
   Inverted ranges (`Min=1 Max=0`) implement the "turn up to disable" targets.
