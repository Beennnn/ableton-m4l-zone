# Light your zones on a WLED strip (OpenLamp)

Zone can **show each split on an LED strip** — every instrument's keyboard range lit as a
coloured band, moving live as you move the split. It drives
[**wled-midi**](https://github.com/openlamp/openlamp-spec-midi), the open MIDI↔WLED convention, in
its **`zone`** position mode.

## How it works

Turn **Lights** on and Zone holds two notes — the zone's **low** and **high** boundary —
on the **Lights Ch** channel, sent to a MIDI port named **`OpenLamp`**. A wled-midi
implementation (the [engine](https://github.com/openlamp/openlamp-engine-python), the
[browser tool](https://github.com/openlamp/openlamp-demo-web), the
[Bome pack](https://github.com/openlamp/openlamp-pack-bome)…) listening on that port lights the LED band
between the lowest and highest held note, in the channel's colour. Move a bound → the band
moves. Stack Zones on different channels → each instrument's range shows in its own
colour, a live map of your split.

| Control | Default | Impact |
|---|---|---|
| **Lights** | off | On = emit this zone's boundaries to the `OpenLamp` port (the WLED band). Off = nothing sent. Muted/bypassed zones clear their band. |
| **Lights Ch** | 1 | The MIDI channel the band is sent on = **which colour** in wled-midi's hand/zone map (ch 1 = hand 1, ch 2 = hand 2…). Give each Zone its own channel. |

A side with its limit **off** is open, so the band runs to the strip end (note 0 / 127) on
that side — exactly the range that actually plays. `High` is exclusive (the filter passes
`note < High`), so the band tops out at `High − 1`, flush with the last sounding key.

## Setup (once)

Create a virtual MIDI port named **`OpenLamp`** (macOS: Audio MIDI Setup → IAC Driver;
Windows: [loopMIDI](https://www.tobias-erichsen.de/software/loopmidi.html)) — the same port
the wled-midi implementations listen on. Zone's internal `[midiout OpenLamp]` sends
straight to it, **independent of Ableton's track routing** (your instrument still gets the
normal filtered notes). Point your wled-midi implementation at your WLED device, set it to
**`strip` / `zone`** mode, and turn **Lights** on.

> The Lights output is **additive and non-intrusive** — it never touches the note stream
> going to your instrument. If the `OpenLamp` port doesn't exist, the `midiout` is simply
> silent; nothing else changes.
