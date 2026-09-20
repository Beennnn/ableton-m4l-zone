# Zone — every field and what it does

The device is a few rows of controls (no on-screen keyboard). Every control is a Live
parameter, so it's **automatable and MIDI-mappable** — including the note bounds, which
Ableton's native key zones don't let you map.

## Global

| Field | Default | Impact |
|---|---|---|
| **Bypass** | off | On = hard bypass: every note passes through **raw** — no zone filter, no transpose. Off = normal. |
| **Mute** | off | On = blocks **all** note output (empty zone, nothing plays). Non-note MIDI still passes; held notes get their note-off so nothing hangs. |

## Limits — the zone

Five **named notes** define the zone. Each row is one note with an editable **name** *and*
MIDI **number** (type either — `A0`, `C4`, `F#3`… or `60` — they sync), a **Learn**
button, and two checkboxes: **Min** and **Max**.

| Field | Default | Impact |
|---|---|---|
| **note 1–5** | A0 / C3 / C4 / C6 / C#8 | Five candidate boundary notes. Set each by typing its name or MIDI number, or by **Learn** (arm, then play the note). |
| **Min** | on note1 (A0) | Tick = this note is the **low bound** — only notes **≥ it** pass (inclusive). **Radio**: at most one Min across the five; ticking one clears the others. |
| **Max** | on note5 (C#8) | Tick = this note is the **high bound** — only notes **< it** pass (**exclusive**). **Radio**: at most one Max. |
| **in** | — | Read-only dot per row: **green** = that note currently sounds (inside the zone), **grey** = muted. Updates live. |
| **Learn** | — | Click to arm, then **play a note**: it becomes that row's note. Editing *is* the learn. |

| Config | Result |
|---|---|
| one Min + one Max, Min note **<** Max note | **band** — play the middle `[Min, Max)` |
| one Min + one Max, **crossed** (Min note > Max note) | **notch** — play the two ends, mute the middle |
| only a Min, or only a Max | single-sided cut |
| neither ticked | fully open — everything plays |

**Why Max is exclusive.** The Max note itself doesn't sound (`note < Max`), so two
adjacent zones that share a boundary note meet with **no overlap** and never double it —
set Zone A's Max and Zone B's Min to the same note and they tile cleanly.

Default **Min A0 / Max C#8** = the whole 88-key piano plays (A0…C8; C#8 is the exclusive
top, so C8 still sounds). Names use **scientific pitch** (C4 = middle C = 60).

## Post transpose — applied *after* the filter

| Field | Default | Impact |
|---|---|---|
| **Oct** (Octave) | 0 | Coarse shift, **±4 octaves**. |
| **Tone** | 0 | Fine shift, **−6…+5 semitones**. Tiles exactly with Octave (no gap, no duplicate) — the Roland/Korg half-octave convention. Final pitch = `note + Oct×12 + Tone`, clamped 0–127. |

## Transpose via CC — drive `Tone` and `Octave` from MIDI CCs

Lets external CCs (a fader, a clip envelope, a script) move the Tone and/or Octave value.
Handy when you **author** the CC by value (e.g. a clip sending CC to this track). Each has
its own CC number and enable; the mapping **mode is shared**.

| Field | Default | Impact |
|---|---|---|
| **Tone on** / **Oct on** | on | Per-target master enable. On = the watched CC drives Tone / Octave and is **consumed** (never reaches the instrument). Off = that CC passes through untouched. |
| **Tone CC#** | 102 | Which CC number drives Tone, on **any channel** that reaches the track. **102–119** is the MIDI "Undefined" range → no collision with mod-wheel (1), expression (11), sustain (64), cutoff (74)… (Channel is Ableton's track-input job — no channel field here.) |
| **Oct CC#** | 103 | Which CC number drives Octave (same rules). |
| **Center** | 64 | *(shared)* Where 0 sits in the CC **value**. `64` = value 64 → 0 (a window around 64). `0` = value 0 → 0 (wraps, so you reach the negatives even though a CC value never goes below 0). |
| **Range** | Step | *(shared)* `Step` = 1 CC value = 1 step (a window; the rest saturates or wraps). `All` = the whole 0–127 sweep is interpolated across the steps. |

**The four modes** (Center × Range) — shown for Tone (folded to −6…+5); **Octave works
identically** with its own ±4 range (9 steps, `value 64 + n`):

| | **Step** (1 value = 1 semitone) | **All** (interpolate 0–127) |
|---|---|---|
| **Center 64** | window **58–69 → −6…+5**, saturates outside — `value 64 + n`, no math | ramp: value 0→−6, 64→0, 127→+5 |
| **Center 0** | wrap /12: 0→0, 1→+1, …, 5→+5, 6→−6, … | value 0→0 … 127→−1 (12 steps, no return to 0) |

Default **64 + Step** = the window: value **68 → +4**, 64 → 0, 58 → −6, 69 → +5, outside
saturates.

**Why a CC per target, with modes?** Octave (9 values) and Tone (12 values) are far
coarser than a CC's 127 steps — a straight linear sweep wastes most of the range and lands
*between* values. So each shift gets its **own CC**, plus a shared choice of **how** the
value maps onto its few slots — in particular the window **around 64**, where
`value 64 = 0` and every step is one increment (`64 + n = n`): trivial to author by hand
and precise, instead of hunting for the right point on a 127-step fader.

> **Drive it from a Stream Deck.** The
> [Trevliga Spel Stream Deck MIDI plugin](https://trevligaspel.se/streamdeck/midi/index.php)
> is an absolute gem — it fires MIDI (CC, **Program Change**, Note…) straight from physical
> Stream Deck keys. Assign a key to send `CC 102` at a fixed value and you get one-press
> Tone recalls, or drive any of Zone's parameters hands-on. Honestly a killer companion
> for this device.

## Passthrough

Everything that isn't a note passes through **untouched** — sustain, expression, pitch
bend, aftertouch, program change, and **any CC except the ones assigned to Tone / Octave**
(each consumed while its enable is on). Held notes always get their note-off, even if you
move a bound, transpose, mute or bypass while they ring: **no stuck notes**.

## Splits & layers

Put one Zone at the head of each instrument and **MIDI-map the note bounds directly**
(Ableton's MIDI map, Cmd-M) — no rack, no internal linking. Map several Zones' boundary
notes to the **same CC** and one control moves the split across all of them at once:

| Stage-keyboard mode | With Zones |
|---|---|
| **Solo** (one sound everywhere) | no Min/Max ticked |
| **Split** (bass left / keys right) | Zone A's **Max** note + Zone B's **Min** note on the **same note/CC** = one movable split point (Max exclusive → no doubled note) |
| **Layer** (two sounds together) | both open (or both bypassed) |
| **Split + layer** | any mix — stack as many Zones as you like |

A ready-made rack that wires this up with four macros is in [`../rack/`](../rack/).
