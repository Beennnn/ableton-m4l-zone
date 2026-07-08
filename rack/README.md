# Zone Keyboard — rack template

A ready-to-load **Instrument Rack** that turns Zone into a stage-keyboard
program: several sounds, each **solo / split / layer / split + layer**, with the
split points **synced by a macro**.

## Idea

One chain per sound. A **Zone** MIDI device sits at the head of each chain and
filters which keys reach that chain's instrument. Because Zone's **Low** / **High**
bounds are automatable, a single **rack macro** can drive the split point across
two chains at once (High of A = Low of B) — move one knob, the split moves
everywhere. Native Live key-zones can't be macro-mapped; Zone's can. That's the
whole point of doing it with the device instead of the built-in chain zones.

| Physical keyboard | In this rack |
|---|---|
| **Solo** (1 sound, whole keyboard) | one chain, Zone Low/High off |
| **Split** (A low / B high) | Zone A `High` = point, Zone B `Low` = point, **1 macro → both** |
| **Layer** (A+B same keys) | both chains full range (Low/High off) |
| **Split + Layer** | mix — e.g. bass `[..B1]`, two layered sounds `[C2..]` |

## Macros

- **Split 1·2** → chain 1 `High` + chain 2 `Low`  (one knob = the 1|2 split point)
- **Split 2·3** → chain 2 `High` + chain 3 `Low`
- **Layer 3**   → chain 3 `Low on` / `High on`  (fold sound 3 in/out as a layer)

## Build / customise (in Live)

A rack embedding a Max device must be saved **by Live** to be a valid `.adg`, so
build it once and re-save:

1. New MIDI track → drop **zone.amxd** on it (MIDI-effect slot, before the instrument).
2. Drop your instrument after it (Keyscape, Omnisphere, …).
3. Select both devices → **⌘G** → Instrument Rack.
4. Open the chain list → **duplicate the chain ×2** (3 sounds).
5. Macro view → **Configure** → click a macro, then click chain 1 Zone **High**
   *and* chain 2 Zone **Low** → rename "Split 1·2". Repeat for "Split 2·3".
6. Rack title bar **floppy → Save** as `Zone Keyboard`.

## Use live

- Load `Zone Keyboard`, drop an instrument in each chain.
- Turn **Split 1·2** to move the low split; **Split 2·3** for the high one.
- Bypass a chain's Zone (or Low/High off) to make that sound a full-range layer.
- Octave / Tone per chain to transpose a sound after the split.

---

*The `.adg` file lives next to this README once exported from Live — it references
`zone.amxd` by path, so keep the device installed.*
