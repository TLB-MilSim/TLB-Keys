<p align="center">
  <img src="https://raw.githubusercontent.com/wiki/TLB-MilSim/TLB-Keys/images/logo.png" alt="TLB Keys" width="200">
</p>

<h1 align="center">TLB Keys</h1>

<p align="center">
  Vehicle keys for Arma 3 with ACE3, set up the way your unit plays.<br>
  <strong>Lock it for your side, your squad, or one key.</strong>
</p>

---

ACE's vehicle keys open every vehicle of a side, and there is no good way to
hand one out in the middle of a mission. TLB Keys replaces them with keys your
players manage in the field, from the ACE interaction menu or a key binding.

<p align="center">
  <img src="https://raw.githubusercontent.com/wiki/TLB-MilSim/TLB-Keys/images/key-items.png" alt="Vehicle keys for each side, master keys for each side and the key fob" width="820">
</p>

## Where to start

| Page | For |
| --- | --- |
| **[Quick Start](Quick-Start)** | Your first key, your first locked vehicle, in five steps. |
| **[Player Guide](Player-Guide)** | Every feature, step by step, with screenshots and examples. |
| **[Key Fobs and Key Bindings](Key-Fobs-and-Key-Bindings)** | Programming fobs, the three key slots, locking without a menu. |
| **[Mission Making](Mission-Making)** | Key Set and Master Key modules, Eden attributes, Zeus modules, scripting. |
| **[Settings](Settings)** | Every CBA setting, its default and what it changes. |
| **[Troubleshooting](Troubleshooting)** | "My key does not fit", and the rest of the usual questions. |
| **[How It Works](How-It-Works)** | For developers: how keys carry their cut, how access is decided. |
| **[Changelog](Changelog)** | What changed in each version. |

## The three ways to lock a vehicle

A vehicle nobody has locked is open. The first player to lock one becomes its
**owner** and chooses who else it opens for:

| Mode | Who gets in |
| --- | --- |
| **Every key of the side** | Anyone carrying a blank key of the vehicle's side. |
| **The owner's squad** | The owner's squad, carrying a blank key of the side. |
| **Paired keys only** | Only keys cut to that vehicle. The owner's key is cut as it is locked. |

<p align="center">
  <img src="https://raw.githubusercontent.com/wiki/TLB-MilSim/TLB-Keys/images/lock-a-vehicle.jpg" alt="The Vehicle Keys menu on an unlocked vehicle, offering Lock for BLUFOR, Lock for my squad and Lock to my key" width="820">
</p>

Your server decides which of the three are allowed, so a unit can run one way of
using keys or all of them.

## What else it does

| Feature | What it gives you |
| --- | --- |
| **Spare keys** | Cut a blank key to the vehicle and hand it to someone. |
| **Change locks** | Every key cut for the vehicle stops fitting, spares included. |
| **Master keys** | One per side, for Zeus, command and the motor pool. Opens and manages every vehicle of that side, however it is locked. |
| **Key fobs** | Program one to a vehicle: it opens the vehicle and locks it from a distance, with a chirp. |
| **Key bindings** | Lock or unlock the nearest vehicle your keys open without a menu, plus three key slots. |
| **Ignition lock** | No key, no engine, even in the driver's seat. |
| **Locked cargo** | A locked vehicle's inventory stays shut to anyone whose keys do not fit. |
| **Inside handle** | Anyone in a seat can lock and unlock, like a real car door. |
| **Hand over key** | An ACE action on another player: no swapping inventories. |
| **Inspect and label** | See what a key opens, and name it, so a crate of motor pool keys stays readable. |
| **Lockpicking** | A lock pick kit opens vehicles your keys do not fit: on [TLB Interactions](https://github.com/TLB-MilSim/TLB-Interactions)' board when that mod is loaded, otherwise with a progress bar. |
| **Hotwiring** | In the driver's seat of a vehicle you have no key for, hotwire it. Picked and hotwired vehicles start without a key until someone locks them again. |
| **Vehicle types** | Choose which kinds of vehicle use keys at all: cars, APCs, tanks, helicopters, planes, boats. |

## Requirements

| | |
| --- | --- |
| Arma 3 | v2.14 or newer |
| [CBA_A3](https://steamcommunity.com/workshop/filedetails/?id=450814997) | required |
| [ACE3](https://steamcommunity.com/workshop/filedetails/?id=463939057) | required |
| [TLB Interactions](https://github.com/TLB-MilSim/TLB-Interactions) | optional: vehicle locks are picked on its lockpicking board |

Load it on the server **and** on every client. All settings are server-forced.
Servers that verify signatures need `keys\TLBKeys01.bikey` from the mod folder.
