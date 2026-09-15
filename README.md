<p align="center">
  <img src="docs/images/logo.png" alt="TLB Keys" width="240">
</p>

<h1 align="center">TLB Keys</h1>

<p align="center">
  Vehicle keys for Arma 3 with ACE3, set up the way your unit plays.<br>
  <strong>Lock it for your side, your squad, or one key.</strong>
</p>

<p align="center">
  <a href="docs/keys.md">Player guide</a> ·
  <a href="docs/mission-making.md">Mission making</a> ·
  <a href="docs/settings.md">All settings</a> ·
  <a href="docs/how-it-works.md">How it works</a>
</p>

<p align="center">
  <img src="docs/images/items.png" alt="Vehicle keys for each side, master keys for each side and the key fob" width="820">
</p>

---

## What it is

ACE's vehicle keys work on every vehicle of a side, and they are hard to hand
out during a live mission. TLB Keys replaces them with keys you manage in the
field, all from the ACE interaction menu.

**A vehicle without keys is open.** The first player to lock it chooses who
else it opens for:

| Mode | Who gets in |
| --- | --- |
| **Every key of the side** | Anyone carrying a blank key of the vehicle's side. |
| **The owner's squad** | Members of the owner's squad carrying a blank key of the side. |
| **Paired keys only** | Only keys cut to that vehicle. The owner's key is cut as it is locked. |

On top of those:

- **Spare keys.** Cut a blank key to the vehicle and hand it to someone.
- **Change locks.** Every old copy stops fitting.
- **Master keys.** One per side, for Zeus and leaders. Opens and manages every vehicle of that side, however it is locked.
- **Key fobs.** Program one to a vehicle. It opens the vehicle like a key, and locks or unlocks it from 15 m with a chirp.
- **Ignition lock.** You cannot start a vehicle your keys do not fit, even from the driver's seat.
- **Inside handle.** Anyone in a seat can lock and unlock the vehicle.
- **Hand over key.** An ACE action on another player, so nobody digs through inventories.
- **Inspect a key** to see whether it is linked to anything yet and which vehicles it opens. **Label** keys so a crate of motor pool keys stays readable.
- **Lockpicking.** Uses the lockpicking board from [TLB Interactions](https://github.com/TLB-MilSim/TLB-Interactions) when that mod is loaded, otherwise ACE's lockpick. A picked vehicle is hotwired until someone locks it again.

**Mission makers** sync vehicles, crates and units to a **Key Set** module:

- The vehicles are locked to the set.
- The crates hold keys for them.
- The synced units spawn carrying one.

A **Master Key** module hands out master keys. There are Eden attributes on
every vehicle and four Zeus modules. Every rule is a CBA setting, so each unit
can allow one way of using keys or all of them.

## Requirements

| | |
| --- | --- |
| Arma 3 | v2.14 or newer |
| [CBA_A3](https://steamcommunity.com/workshop/filedetails/?id=450814997) | required |
| [ACE3](https://steamcommunity.com/workshop/filedetails/?id=463939057) | required |
| [TLB Interactions](https://github.com/TLB-MilSim/TLB-Interactions) | optional. Vehicle locks are picked on its lockpicking board |

## Installation

1. Load `@TLB Keys` together with CBA_A3 and ACE3.
2. On a server, load it on the server **and** every client. All settings are
   server-forced.

To build from source, run `.\tools\build.ps1`. The mod is written to
`release\@TLB Keys`. Add `-Sign` to sign it, or `-Deploy <folder>` to copy it
somewhere.

## Quick start

**Getting a key:** take a *Vehicle Key* for your side from the Arsenal, or from
a crate the mission maker filled.

**Locking a vehicle:** open ACE interaction on the vehicle and go to *Vehicle
Keys*. Pick *Lock for BLUFOR*, *Lock for my squad* or *Lock to my key*. Once it
is yours, *Manage keys* lets you:

- change who it opens for
- cut spare keys or program a fob
- change the locks
- name it, give it away or release it

**Your keys:** ACE self-interaction → *Vehicle Keys*. Inspect, label or wipe
each key, and use your fob. Full walkthrough: [Player guide](docs/keys.md).

**Configuring:** *Options → Addon Options → TLB Keys*. Every setting, its
default and its range: [All settings](docs/settings.md).

## Documentation

| Page | For |
| --- | --- |
| [Player guide](docs/keys.md) | Players: key types, locking, managing a vehicle, fobs, handing over, lockpicking. |
| [Mission making](docs/mission-making.md) | Mission makers: the Key Set and Master Key modules, vehicle attributes, Zeus modules, scripting. |
| [All settings](docs/settings.md) | Server admins: every CBA setting with its default and effect, and an example settings file. |
| [How it works](docs/how-it-works.md) | Developers: how keys store their cut, how access is decided, what is synced where, how ACE is replaced. |

## Compatibility

- **ACE vehicle lock:** its lock, unlock and lockpick actions are hidden, and
  its start-of-mission locking and inventory lock are switched off, while
  *Replace ACE vehicle locking* is on. ACE's side keys and master key keep
  working as TLB keys. ACE's lockpick picks locks.
- **Vanilla locking:** lock state is the vanilla `locked` value, so mission
  scripts that call `lock` still work. A vehicle the mission locks without
  giving it keys starts unlocked unless the settings say otherwise.
- **[TLB Interactions](https://github.com/TLB-MilSim/TLB-Interactions):**
  detected automatically; its lock pick kit and paperclip open vehicles on
  its board.

## Licence

TLB Keys is licensed under the
**[Arma Public License No Derivatives (APL-ND)](https://www.bohemia.net/community/licenses/arma-public-license-nd)**.
You may share it unmodified, for non-commercial use, with attribution. You may not
modify it or publish derivative works. See [`LICENSE`](LICENSE).

## Credits

Made by **TLB MilSim**. All code, textures, icons and sounds are original work;
textures and sounds are generated by `tools/gen_assets.py`. ACE3 and CBA_A3 are
used through their public APIs only, and no code or assets from other mods are
included.
