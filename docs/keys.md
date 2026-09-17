# Player guide

[← Back to README](../README.md)

Everything here happens in the ACE interaction menu. The **Vehicle Keys** entry
on a vehicle only shows what you can do right now. What that is depends on your
keys and on your server's [settings](settings.md), so some entries below may be
switched off where you play.

- [The keys](#the-keys)
- [Locking a vehicle for the first time](#locking-a-vehicle-for-the-first-time)
- [Locking and unlocking](#locking-and-unlocking)
- [Managing a vehicle](#managing-a-vehicle)
- [Your keys](#your-keys)
- [Key fobs](#key-fobs)
- [Key bindings](#key-bindings)
- [Handing over a key](#handing-over-a-key)
- [Master keys](#master-keys)
- [Lockpicking](#lockpicking)
- [Common questions](#common-questions)

---

## The keys

<img src="images/items.png" alt="The key items" width="820">

| Item | What it opens |
| --- | --- |
| **Vehicle Key (side)**, blank | Vehicles of that side locked *for the side*, and *for your squad* when you are in the vehicle's squad. This is the key you get from the Arsenal. |
| **Vehicle Key (side)**, cut | Only the vehicles it was cut to, whatever their mode. Cutting a key ties it to those vehicles. |
| **Master Key (side)** | Every vehicle of that side, however it is locked. It can also manage all of them. |
| **Key Fob**, blank | Nothing, until it is programmed at a vehicle. |
| **Key Fob**, programmed | The vehicles it was programmed to. It also locks and unlocks them from a distance. |

Keys belong to a side, not to a player. Take an enemy's key and it opens their
vehicles.

A key keeps its cut when you drop it, store it in a crate, hand it over, save
it in a loadout or respawn with it.

## Locking a vehicle for the first time

A vehicle nobody has locked has no keys and is open. At the vehicle, *Vehicle
Keys* offers:

| Action | Result |
| --- | --- |
| **Lock for BLUFOR** (your side) | Every blank key of your side opens it. |
| **Lock for my squad** | Blank keys of your side carried by your squad open it. |
| **Lock to my key** | One of your blank keys is cut to the vehicle. Only that key, and spares cut from it later, open it. |

You become the owner, and the vehicle takes your side and your squad. The
server decides which of the three you are offered, who may lock a vehicle
first, and whether you need a blank key to do it.

## Locking and unlocking

At a vehicle your keys fit, use *Vehicle Keys → Lock* or *Unlock*. From a seat,
ACE self-interaction has the same entry, and there anyone can lock and unlock
without a key, like a door handle.

While a vehicle has keys:

- **Its inventory is shut** from outside to anyone whose keys do not fit.
- **The engine will not start** for a driver whose keys do not fit, even in the
  driver's seat.

*Check lock* shows whether it is locked and who it opens for. If your keys fit,
it also shows who manages it and which code it takes.

## Managing a vehicle

The owner and master keys get *Vehicle Keys → Manage keys*. Depending on the
server, the owner's squad leader, or anyone whose keys fit, may get it too.

| Action | What it does |
| --- | --- |
| **Opens for: …** | Switch between every key of the side, the squad, and paired keys only. Switching to paired keys cuts one of your blank keys first, so you do not lock yourself out. |
| **Cut keys** | Lists the keys in your inventory that do not fit yet. *Cut a spare from* a blank key makes a spare, *Re-cut* moves a key from another vehicle to this one, and *Program* pairs a key fob. A spare always costs a blank key. |
| **Change locks** | The vehicle gets a new code. Your own keys for it are re-cut, and every other key cut for it stops fitting, including spares you handed out. Blank side and squad keys are not affected. |
| **Name vehicle** | The name shows in menus, and on every key cut for it. |
| **Give ownership to** | Hands the vehicle, and its squad, to a player standing nearby. Hand the keys over separately. |
| **Release vehicle** | No keys, no owner, unlocked, as if nobody had ever locked it. |

## Your keys

ACE self-interaction → *Vehicle Keys* lists every key you carry, one entry per
key.

| Action | What it does |
| --- | --- |
| **Inspect** | What the key is and which vehicles it opens right now, with map grid and lock state. Use it on a key from the Arsenal or a crate to see whether it is linked to anything yet. |
| **Label key** | Name a cut key, e.g. *Alpha Hunter*. Every copy of that key shows the label. |
| **Wipe blank** | Turns a cut key back into a blank side key. |

## Key fobs

A fob is its own item. Program it at a vehicle under *Manage keys → Cut keys*.
Afterwards it opens that vehicle like a key.

With a programmed fob in your pocket, ACE self-interaction → *Vehicle Keys* lists
every vehicle it is paired to within 15 m (the server can change the range).
The same buttons are under the fob's own entry in that menu. *Lock* and
*Unlock* work instantly, and the vehicle chirps: twice to lock, once to unlock.

## Key bindings

Lock and unlock without opening the ACE menu. Bind the keys under *Options →
Controls → Configure Addons → TLB Keys*. They start unbound.

| Binding | What it does |
| --- | --- |
| **Lock/unlock nearest vehicle** | In a seat: the vehicle you are in. Outside: the nearest vehicle any of your keys open, within 5 m of its side. With a key fob programmed to it, from as far as the fob reaches, with a chirp. |
| **Lock/unlock with key slot 1 / 2 / 3** | The same, but only with the key in that slot. |

To put a key in a slot, open ACE self-interaction → *Vehicle Keys*, pick the
key, then *Key slot* and the slot. A key is in one slot at a time, and the key
list shows which slot it is in. Slots are remembered for the mission, even after
respawning or reconnecting.

Carrying keys to two vehicles? The nearest-vehicle binding picks whichever of
them is closest, so walking up to either and pressing it is enough. Slots are
for choosing, say, your own car's fob on one binding and the squad truck's key
on another.

The server decides which kinds of vehicle use keys at all, so on some servers
boats or aircraft have no keys.

## Handing over a key

Look at another player, open ACE interaction and choose *Hand over key*, then
the key. It goes straight into their inventory, or onto the ground at their
feet if they have no room.

## Master keys

A master key opens and manages every vehicle of its side, however it is
locked:

- it can reset another player's vehicle
- it can manage vehicles the mission set up
- it can unlock vehicles the mission locked without keys

It is meant for Zeus, commanders and the motor pool. Mission makers hand them
out with the Master Key module, and servers can hide them from the Arsenal.

## Lockpicking

At a locked vehicle none of your keys fit, *Vehicle Keys → Pick lock* appears
when you carry a tool:

- **With [TLB Interactions](https://github.com/TLB-MilSim/TLB-Interactions)
  loaded:** *With lock pick kit* or *With paperclip* opens its lockpicking
  board. Stay close to the vehicle while you pick.
- **Without it:** *With lockpick* uses ACE's lockpick and a progress bar.

A picked vehicle is **hotwired**: it starts without a key until someone with a
key locks it again. Some vehicles cannot be picked at all.

## Common questions

**My Arsenal key does not open my squad's car.** The car may be locked to
paired keys only. Ask the owner to cut you a spare, or to switch it to *the
owner's squad*.

**I cut my key and now it does not open the side's other cars.** A cut key is
tied to the vehicles it was cut for. Wipe it blank to make it a side key again,
unless your server keeps cut keys working as side keys.

**Someone ran off with a spare.** *Change locks*.

**The owner left the server.** After the time the server sets, the vehicle
loses its owner, and anyone whose keys fit can manage it. A master key can
always manage it.
