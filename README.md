# Zone — keyboard split / zone filter for Ableton Live

![Zone — Max for Live MIDI device](zone-device.png)

One tiny **Max for Live MIDI effect** per instrument: it plays only the keys you give it.
Set a low and a high bound, shift the result by octaves or semitones, drive that shift from
a MIDI CC if you like, and build hardware-style **splits and layers** — one rack macro can
move a split point across several instruments at once.

## Get it

1. Download **[`zone.amxd`](https://github.com/Beennnn/zone-m4l/raw/main/zone.amxd)**
   (also listed on [maxforlive.com](https://www.maxforlive.com/library/device.php?id=15717)).
2. Drop it on a **MIDI track, before the instrument** (or into a rack chain).
3. Requires Live with Max for Live (Suite, or Standard + M4L). Built on Live 12 / Max 8.6.

## Manual — every field and what it does

The device is a few rows of controls (no on-screen keyboard). Every control is a Live
parameter, so it's **automatable, MIDI-mappable and rack-macro-mappable**.

### Global

| Field | Default | Impact |
|---|---|---|
| **Bypass** | off | On = hard bypass: every note passes through **raw** — no zone filter, no transpose. Off = normal. |
| **Mute** | off | On = blocks **all** note output (empty zone, nothing plays). Non-note MIDI still passes; held notes get their note-off so nothing hangs. |

### Limits — the zone

A note plays only if it falls **inside** the zone. Each side has an on/off toggle, a value,
and a Learn button.

| Field | Default | Impact |
|---|---|---|
| **Low** | 0 | The low bound. With `Lo on`, only notes **≥ Low** pass. Its note name is shown beside it (C-2 at 0). |
| **High** | 127 | The high bound. With `Hi on`, only notes **< High** pass — the High note itself belongs to the *upper* zone, so adjacent split zones meet with **no overlap**. Note name shown (G8 at 127). |
| **Lo on / Hi on** | off | Enable each bound. A side that's off is **open** (no limit). Both off = full range, everything passes. |
| **Learn Lo / Learn Hi** | — | Click to arm, then **play a note**: that note becomes the bound. Editing *is* the learn. |

Defaults **0 / 127 with limits off** = a fully-open zone (everything through); the 0/127
values are just neutral starting points for when you switch a limit on.

### Post transpose — applied *after* the filter

| Field | Default | Impact |
|---|---|---|
| **Oct** (Octave) | 0 | Coarse shift, **±4 octaves**. |
| **Tone** | 0 | Fine shift, **−6…+5 semitones**. Tiles exactly with Octave (no gap, no duplicate) — the Roland/Korg half-octave convention. Final pitch = `note + Oct×12 + Tone`, clamped 0–127. |

### Tone via CC — drive `Tone` from an incoming MIDI controller

Lets an external CC (a fader, a clip envelope, a script) move the Tone value. Handy when you
**author** the CC by value (e.g. a clip sending CC to this track).

| Field | Default | Impact |
|---|---|---|
| **CC on** | on | Master enable. On = the watched CC drives Tone and is **consumed** (never reaches the instrument downstream). Off = that CC passes through untouched, Tone unaffected (feature disabled). |
| **CC#** | 102 | Which CC number is watched, on **any channel** that reaches the track. **102–119** is the MIDI "Undefined" range → no collision with mod-wheel (1), expression (11), sustain (64), cutoff (74)… (Channel is filtered by Ableton's track input, so there's no channel field here.) |
| **Center** | 64 | Where Tone 0 sits in the CC **value**. `64` = value 64 → Tone 0 (a window around 64). `0` = value 0 → Tone 0 (wraps, so you can reach the negatives even though a CC value never goes below 0). |
| **Range** | Step | `Step` = 1 CC value = 1 semitone (a 12-value window; the rest saturates or wraps). `All` = the whole 0–127 sweep is interpolated across the 12 semitones. |

**The four modes** (Center × Range), output folded to the 12 values −6…+5:

| | **Step** (1 value = 1 semitone) | **All** (interpolate 0–127) |
|---|---|---|
| **Center 64** | window **58–69 → −6…+5**, saturates outside — `value 64 + n`, no math | ramp: value 0→−6, 64→0, 127→+5 |
| **Center 0** | wrap /12: 0→0, 1→+1, …, 5→+5, 6→−6, … | value 0→0 … 127→−1 (12 steps, no return to 0) |

Default **64 + Step** = the window: value **68 → +4**, 64 → 0, 58 → −6, 69 → +5, outside saturates.

> **Drive it from a Stream Deck.** The [Trevliga Spel Stream Deck MIDI plugin](https://trevligaspel.se/streamdeck/midi/index.php)
> fires MIDI (CC, **Program Change**, Note…) straight from physical Stream Deck keys — assign a key to send
> `CC 102` at a fixed value and you get one-press Tone recalls, or drive any of Zone's parameters hands-on.

### Passthrough

Everything that isn't a note passes through **untouched** — sustain, expression, pitch bend,
aftertouch, program change, and **any CC except the one watched by Tone-via-CC** (consumed
when `CC on`). Held notes always get their note-off, even if you move a bound, transpose, mute
or bypass while they ring: **no stuck notes**.

## Splits & layers — the point of it all

Put one Zone at the head of each Instrument Rack chain and map the bounds to macros —
the instances stay independent, the *sync* lives in the rack:

| Stage-keyboard mode | With Zones |
|---|---|
| **Solo** (one sound everywhere) | one chain, limits off |
| **Split** (bass left / keys right) | chain A `High` + chain B `Low` on **one macro** = movable split point |
| **Layer** (two sounds together) | both chains full range (or both bypassed) |
| **Split + layer** | any mix — stack as many Zones as you like |

## Try it in the browser

**[Interactive demo](https://claude.ai/code/artifact/1a33057b-34ec-4ba8-b8df-364b2746d822)**
(or open [`zone-demo.html`](zone-demo.html) locally) — move a macro, watch one split
point drive several zones.

---

## Under the hood

| File | Purpose |
|---|---|
| [`zone.amxd`](zone.amxd) | the device, ready to use — **source of truth** (hand-arranged layout + logic) |
| [`zone.js`](zone.js) | the brain — zone filter, octave/tone transpose, Tone-via-CC, note tracking |
| [`zone.maxpat`](zone.maxpat) | the patcher inside the device (UI + wiring), kept in sync with `zone.amxd` |
| [`gen_zone_maxpat.py`](gen_zone_maxpat.py) | the original scaffold that generated the first patch (reference only — see hacking notes) |
| [`rack/`](rack/) | Zone Keyboard rack preset + demo set + docs |

```
midiin → midiparse ┬ notes ──────────────→ [js zone.js] → midiout   (filtered + shifted notes)
                   ├ control-change ──────→ [js zone.js]             (Tone-via-CC: drives Tone & consumed,
                   │                                                   or re-emitted untouched)
                   └ everything else → midiformat → midiout          (untouched passthrough)
```

Hacking notes:

- `zone.js` is **referenced, not frozen** in the device, and runs with `autowatch = 1`:
  edit the file next to the device and Max hot-reloads it. (Adding/removing a `js` **outlet**
  needs a *full* device reload, not a hot-reload.)
- **The presentation layout is hand-arranged in Max and lives in `zone.amxd`** — it is the
  source of truth. `zone.maxpat` is that device's patcher JSON, kept in sync. The `.amxd` is a
  32-byte `ampf` header + the patcher JSON, so structural changes can be applied to it directly.
- `gen_zone_maxpat.py` **scaffolded the original** structure. It does **not** reproduce the
  hand-tuned layout or the later additions — re-running it would reset the presentation. Keep it
  as a reference for how the wiring was first built; don't overwrite the shipped files with it.

Latest version, changelog and issues live here on GitHub — the maxforlive page is a
pointer to this repo.

## License

MIT — see [LICENSE](LICENSE).
