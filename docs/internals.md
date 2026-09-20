# Under the hood

| File | Purpose |
|---|---|
| [`../zone.amxd`](../zone.amxd) | the device, ready to use — **source of truth** (hand-arranged layout + logic) |
| [`../zone.js`](../zone.js) | the brain — zone filter, octave/tone transpose, Tone-via-CC, note tracking |
| [`../zone.maxpat`](../zone.maxpat) | the patcher inside the device (UI + wiring), kept in sync with `zone.amxd` |
| [`../gen_zone_maxpat.py`](../gen_zone_maxpat.py) | the original scaffold that generated the first patch (reference only — see hacking notes) |
| [`../rack/`](../rack/) | Zone Keyboard rack preset + demo set + docs |

## Signal path

```
midiin → midiparse ┬ notes ──────────────→ [js zone.js] ┬ outlet 0 → midiout            (filtered + shifted notes → instrument)
                   ├ control-change ──────→ [js zone.js] └ outlet 9 → midiout OpenLamp   (zone boundaries → wled-midi `zone`)
                   │                                       (Tone/Octave-via-CC: consumed, or re-emitted untouched)
                   └ everything else → midiformat → midiout                              (untouched passthrough)
```

## The 16 outlets of `zone.js`

| outlet | carries |
|---|---|
| `0` | MIDI out — the filtered, shifted notes going to the instrument |
| `1`–`4` | note 1…4 value feedback (Learn → numbox) |
| `5` | note 5 value feedback |
| `6` | note 5 name display |
| `7` | Tone value, when CC-driven |
| `8` | Octave value, when CC-driven |
| `9` | **WLED lights** — the zone's two boundary note-ons → `midiout OpenLamp` |
| `10`–`13` | note 1…4 name display |
| `14` | toggle-clear bus — what makes Min and Max behave as radio buttons |
| `15` | inclusion bus (`indK bgcolor r g b a`) → the per-row dot: green = note in zone, grey = out |

The lights path is independent of outlet 0, so it never disturbs the notes reaching your
instrument.

## The filter itself

Each of the five notes can be a low bound (`minK`) and/or a high bound (`maxK`),
independently. `lower` is the highest note whose Min is ticked (default 0), `upper` the
lowest note whose Max is ticked (default 128). One rule covers band, single-sided cut and
notch:

```js
return (lo <= hi) ? (p >= lo && p < hi)     // BAND  — keep [lower, upper)
                  : (p >= lo || p < hi);    // NOTCH — bounds crossed: keep the two ends
```

Note names use **scientific pitch** (60 = C4 = middle C, so 0 = C-1 and 127 = G9), chosen
so the on-screen names match what you type. Note that the ClyphX `zn` note parser stays on
Ableton's C3 = 60, which leaves a one-octave label gap between the device and ClyphX —
prefer MIDI numbers in ClyphX to avoid the confusion.

## Hacking notes

- `zone.js` is **referenced, not frozen** in the device, and runs with `autowatch = 1`:
  edit the file next to the device and Max hot-reloads it. (Adding or removing a `js`
  **outlet** needs a *full* device reload, not a hot-reload — which is why the outlet
  writes are wrapped in `try`/`catch`, as load-order armour.)
- **The presentation layout is hand-arranged in Max and lives in `zone.amxd`** — it is
  the source of truth. `zone.maxpat` is that device's patcher JSON, kept in sync. The
  `.amxd` is a 32-byte `ampf` header + the patcher JSON, so structural changes can be
  applied to it directly.
- `gen_zone_maxpat.py` **scaffolded the original** structure. It does **not** reproduce
  the hand-tuned layout or the later additions — re-running it would reset the
  presentation. Keep it as a reference for how the wiring was first built; don't overwrite
  the shipped files with it.
