# Zone — keyboard split / zone filter for Ableton Live

![Zone — Max for Live MIDI device](zone-device.png)

One tiny **Max for Live MIDI effect** per instrument: it plays only the keys you give it,
then transposes the result. Two things make it worth it:

- **Transpose *after* the split — the split point never moves with it.** The zone is filtered
  on the notes you actually play; the octave/semitone shift hits only the survivors,
  **downstream**. So you can transpose the sound as much as you like and the split boundary
  stays exactly where you set it — it never transposes itself. Define the split once, shift the
  sound freely on top.
- **Mappable min/max bounds — which Ableton can't do natively.** `Low` and `High` are real Live
  parameters, so the split point is **MIDI-mappable and automatable** (Ableton's built-in key
  zones are not). Map several Zones' bounds to one CC and move a split across instruments, live.

Stack instances to build **splits and layers**.

**Bonus — light your splits on a WLED strip.** Turn on **Lights** and each Zone paints its keyboard
range as a coloured band on an LED strip, live, via the open [wled-midi](https://github.com/openlamp/wled-midi)
convention — [see below](#light-your-zones-on-a-wled-strip-openlamp).

## Get it

1. Download **[`zone.amxd`](https://github.com/Beennnn/zone-m4l/raw/main/zone.amxd)**
   (also listed on [maxforlive.com](https://www.maxforlive.com/library/device.php?id=15717)).
2. Drop it on a **MIDI track, before the instrument** (or into a rack chain).
3. Requires Live with Max for Live (Suite, or Standard + M4L). Built on Live 12 / Max 8.6.

## Manual — every field and what it does

The device is a few rows of controls (no on-screen keyboard). Every control is a Live
parameter, so it's **automatable and MIDI-mappable** — including the `Low`/`High` split bounds,
which Ableton's native key zones don't let you map.

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

### Transpose via CC — drive `Tone` and `Octave` from MIDI CCs

Lets external CCs (a fader, a clip envelope, a script) move the Tone and/or Octave value. Handy
when you **author** the CC by value (e.g. a clip sending CC to this track). Each has its own CC
number and enable; the mapping **mode is shared**.

| Field | Default | Impact |
|---|---|---|
| **Tone on** / **Oct on** | on | Per-target master enable. On = the watched CC drives Tone / Octave and is **consumed** (never reaches the instrument). Off = that CC passes through untouched. |
| **Tone CC#** | 102 | Which CC number drives Tone, on **any channel** that reaches the track. **102–119** is the MIDI "Undefined" range → no collision with mod-wheel (1), expression (11), sustain (64), cutoff (74)… (Channel is Ableton's track-input job — no channel field here.) |
| **Oct CC#** | 103 | Which CC number drives Octave (same rules). |
| **Center** | 64 | *(shared)* Where 0 sits in the CC **value**. `64` = value 64 → 0 (a window around 64). `0` = value 0 → 0 (wraps, so you reach the negatives even though a CC value never goes below 0). |
| **Range** | Step | *(shared)* `Step` = 1 CC value = 1 step (a window; the rest saturates or wraps). `All` = the whole 0–127 sweep is interpolated across the steps. |

**The four modes** (Center × Range) — shown for Tone (folded to −6…+5); **Octave works identically** with its own ±4 range (9 steps, `value 64 + n`):

| | **Step** (1 value = 1 semitone) | **All** (interpolate 0–127) |
|---|---|---|
| **Center 64** | window **58–69 → −6…+5**, saturates outside — `value 64 + n`, no math | ramp: value 0→−6, 64→0, 127→+5 |
| **Center 0** | wrap /12: 0→0, 1→+1, …, 5→+5, 6→−6, … | value 0→0 … 127→−1 (12 steps, no return to 0) |

Default **64 + Step** = the window: value **68 → +4**, 64 → 0, 58 → −6, 69 → +5, outside saturates.

**Why a CC per target, with modes?** Octave (9 values) and Tone (12 values) are far coarser than a
CC's 127 steps — a straight linear sweep wastes most of the range and lands *between* values. So each
shift gets its **own CC**, plus a shared choice of **how** the value maps onto its few slots — in
particular the window **around 64**, where `value 64 = 0` and every step is one increment
(`64 + n = n`): trivial to author by hand and precise, instead of hunting for the right point on a
127-step fader.

> **Drive it from a Stream Deck.** The [Trevliga Spel Stream Deck MIDI plugin](https://trevligaspel.se/streamdeck/midi/index.php)
> is an absolute gem — it fires MIDI (CC, **Program Change**, Note…) straight from physical Stream Deck keys.
> Assign a key to send `CC 102` at a fixed value and you get one-press Tone recalls, or drive any of Zone's
> parameters hands-on. Honestly a killer companion for this device.

### Passthrough

Everything that isn't a note passes through **untouched** — sustain, expression, pitch bend,
aftertouch, program change, and **any CC except the ones assigned to Tone / Octave** (each
consumed while its enable is on). Held notes always get their note-off, even if you move a bound, transpose, mute
or bypass while they ring: **no stuck notes**.

## Splits & layers

Put one Zone at the head of each instrument and **MIDI-map the bounds directly** (Ableton's MIDI
map, Cmd-M) — no rack, no internal linking. Map several Zones' `Low`/`High` to the **same CC** and
one control moves the split across all of them at once:

| Stage-keyboard mode | With Zones |
|---|---|
| **Solo** (one sound everywhere) | limits off |
| **Split** (bass left / keys right) | Zone A `High` + Zone B `Low` on **one CC** = movable split point |
| **Layer** (two sounds together) | both full range (or both bypassed) |
| **Split + layer** | any mix — stack as many Zones as you like |

## Light your zones on a WLED strip (OpenLamp)

Zone can **show each split on an LED strip** — every instrument's keyboard range lit as a coloured
band, moving live as you move the split. It drives [**wled-midi**](https://github.com/openlamp/wled-midi),
the open MIDI↔WLED convention, in its **`zone`** position mode.

**How it works.** Turn **Lights** on and Zone holds two notes — the zone's **low** and **high**
boundary — on the **Lights Ch** channel, sent to a MIDI port named **`OpenLamp`**. A wled-midi
implementation (the [engine](https://github.com/openlamp/engine), the
[browser tool](https://github.com/openlamp/wled-midi-web), the [Bome pack](https://github.com/openlamp/bome)…)
listening on that port lights the LED band between the lowest and highest held note, in the channel's
colour. Move a bound → the band moves. Stack Zones on different channels → each instrument's range shows
in its own colour, a live map of your split.

| Control | Default | Impact |
|---|---|---|
| **Lights** | off | On = emit this zone's boundaries to the `OpenLamp` port (the WLED band). Off = nothing sent. Muted/bypassed zones clear their band. |
| **Lights Ch** | 1 | The MIDI channel the band is sent on = **which colour** in wled-midi's hand/zone map (ch 1 = hand 1, ch 2 = hand 2…). Give each Zone its own channel. |

A side with its limit **off** is open, so the band runs to the strip end (note 0 / 127) on that side —
exactly the range that actually plays. `High` is exclusive (the filter passes `note < High`), so the band
tops out at `High − 1`, flush with the last sounding key.

**Setup (once).** Create a virtual MIDI port named **`OpenLamp`** (macOS: Audio MIDI Setup → IAC Driver;
Windows: [loopMIDI](https://www.tobias-erichsen.de/software/loopmidi.html)) — the same port the wled-midi
implementations listen on. Zone's internal `[midiout OpenLamp]` sends straight to it, **independent of
Ableton's track routing** (your instrument still gets the normal filtered notes). Point your wled-midi
implementation at your WLED device, set it to **`strip` / `zone`** mode, and turn **Lights** on.

> The Lights output is **additive and non-intrusive** — it never touches the note stream going to your
> instrument. If the `OpenLamp` port doesn't exist, the `midiout` is simply silent; nothing else changes.

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
midiin → midiparse ┬ notes ──────────────→ [js zone.js] ┬ outlet 0 → midiout            (filtered + shifted notes → instrument)
                   ├ control-change ──────→ [js zone.js] └ outlet 9 → midiout OpenLamp   (zone boundaries → wled-midi `zone`)
                   │                                       (Tone/Octave-via-CC: consumed, or re-emitted untouched)
                   └ everything else → midiformat → midiout                              (untouched passthrough)
```

`zone.js` has 10 outlets: 0 = MIDI out (to the instrument), 1–2 = Low/High value feedback, 3–4 = note-name
labels, 5–6 = learn-state labels, 7–8 = Tone/Octave value (CC-driven), **9 = WLED lights** (the zone's two
boundary note-ons → `midiout OpenLamp`). The lights path is independent of outlet 0, so it never disturbs
the notes reaching your instrument.

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

---

**Splits for Live — and an optional bridge to light.** Zone is a standalone Max for Live device; its
optional WLED output speaks the open [**wled-midi**](https://github.com/openlamp/wled-midi) convention —
the agreed dictionary between [**MIDI**](https://midi.org) (the MIDI Association) and
[**WLED**](https://kno.wled.ge). Part of the [OpenLamp](https://github.com/openlamp) ecosystem; free for
anyone to build on.
