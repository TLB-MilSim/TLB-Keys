# Changelog

[← Back to README](README.md)

## Unreleased

### Changed

- **TLB Interactions owns vehicles when it says so.** With that mod loaded and its
  *Pick vehicle locks* setting on, it now runs vehicle picking, hotwiring and the
  ignition lock completely, and TLB Keys stops offering its own picking and
  hotwiring so there is only ever one of each in the menu. Turn that setting off
  and TLB Keys keeps its own system and settings. Keys are never handed over: who
  holds one is still decided here.

## 1.0.1 (2026-09-19)

### Added

- **Lock pick kit.** TLB Keys ships its own kit, so vehicle locks can be picked
  on any server. Which kit is used follows the mods you run:

  | Loaded | Picking uses | Who chooses the tool |
  | --- | --- | --- |
  | **TLB Interactions** (with or without TSP Breach) | Its lockpicking board | TLB Interactions, in its own settings |
  | **TSP Breach** only | A progress bar | The *Lock pick kit* setting: TSP Breach's kit or TLB Keys' own |
  | Neither | A progress bar | TLB Keys' own kit |

  The kit that is not in use is hidden from the ACE Arsenal, so players never
  see two kits for the same job. ACE's lockpick works throughout.

- **Hotwiring.** Sitting in the driver's seat of a vehicle your keys do not fit,
  *Vehicle Keys → Hotwire* starts it without a key until someone with a key
  locks it again — the same state a picked vehicle is left in. New settings:
  *Allow hotwiring* and *Hotwire time*.
- **Key bindings** (*Controls → Configure Addons → TLB Keys*, unbound by
  default). *Lock/unlock nearest vehicle* works on the vehicle you are sitting
  in, or the nearest one your keys open — key reach at the vehicle, key fob
  range with a programmed fob.
- **Key slots.** Bind a chosen key to one of three slots from its entry in your
  Vehicle Keys menu, each with its own key binding. Slots are remembered per
  mission, through respawns and reconnects.
- **Key fob buttons** under the fob's own entry in the keys menu, next to the
  list of vehicles it opens.
- **Vehicle types.** Six settings choose which kinds of vehicle use keys at all:
  cars and trucks, wheeled APCs, tanks, helicopters, planes and boats. A type
  that is switched off is left entirely to vanilla and ACE, with ACE's own lock
  actions back on it.

### Fixed

- **Keys dropped on the ground.** Cutting a key, pairing it to a vehicle,
  programming a fob, changing the locks, wiping a key or handing one over could
  throw keys out of the inventory. They now go back into the uniform, vest or
  backpack they came from.
- **Startup error** on the items config (`Preprocessor failed ... error 7`),
  caused by a preprocessor directive Arma does not support.

### Changed

- *ACE lockpick time* is now **Lockpick time**: it times picking with any kit,
  and TLB Interactions' board ignores it, because there the lock decides.
- *Picked vehicles can be driven* is now **Picked and hotwired vehicles can be
  driven**, and covers both. Off, picking only opens the doors and hotwiring is
  not offered at all.
- Whether TLB Interactions' board handles vehicle locks is now **its** setting
  (*Pick vehicle locks*), not one of ours: the mod that owns the board owns the
  switch. Needs TLB Interactions 1.1.1 or newer; without it, its board is used
  as before.
- Documentation moved to the [wiki](https://github.com/TLB-MilSim/TLB-Keys/wiki),
  with a quick start, a troubleshooting page and screenshots.

## 1.0.0

- First release: vehicle keys locked for a side, a squad or one key; spare keys,
  changing locks and master keys; key fobs; the ignition lock, locked cargo and
  the inside handle; handing keys over, inspecting and labelling them; Key Set
  and Master Key modules, Eden attributes and Zeus modules; and around 35
  server-forced CBA settings.
