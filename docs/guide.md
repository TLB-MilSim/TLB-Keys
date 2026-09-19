# Full guide

[← Back to README](../README.md)

Everything TLB Keys does, in the order you will meet it. Almost all of it
happens in the ACE interaction menu: **Vehicle Keys** on a vehicle, and
**Vehicle Keys** on yourself.

The menu only ever shows what you can do at that moment, so if an entry below is
missing, either your keys do not fit or your server has that part switched off.
Everything here is a [setting](settings.md).

- [How it works in one minute](#how-it-works-in-one-minute)
- [The keys](#the-keys)
- [Locking a vehicle for the first time](#locking-a-vehicle-for-the-first-time)
- [Opening, driving and cargo](#opening-driving-and-cargo)
- [Managing a vehicle](#managing-a-vehicle)
- [Your own keys](#your-own-keys)
- [Key fobs](#key-fobs)
- [Key bindings and key slots](#key-bindings-and-key-slots)
- [Handing keys to other players](#handing-keys-to-other-players)
- [Master keys](#master-keys)
- [Lockpicking and hotwiring](#lockpicking-and-hotwiring)
- [Which vehicles have keys](#which-vehicles-have-keys)
- [Worked examples](#worked-examples)
- [Troubleshooting](#troubleshooting)

---

## How it works in one minute

Three ideas carry the whole mod:

1. **A vehicle nobody has locked has no keys and is open.** Anyone can drive it.
2. **Locking a vehicle gives it keys.** Whoever locks it first becomes its
   **owner** and picks who else it opens for: everyone on their side, their
   squad, or only keys cut to that vehicle.
3. **A key is an item with a cut.** A blank key is a side key. Cut it to a
   vehicle and it becomes that vehicle's key. The cut travels with the item, so
   it survives being dropped, stored in a crate, handed over, saved in a loadout
   and respawning.

Everything else — spares, fobs, master keys, key bindings — is a way of moving
those keys around or using them faster.

## The keys

<img src="images/items.png" alt="The key items" width="820">

| Item | What it opens |
| --- | --- |
| **Vehicle Key (side)**, blank | Vehicles of that side locked *for the side*, and *for the squad* when you are in the vehicle's squad. This is the key you take from the Arsenal. |
| **Vehicle Key (side)**, cut | Only the vehicles it was cut to, whatever mode they are in. |
| **Master Key (side)** | Every vehicle of that side, however it is locked, and it manages them too. |
| **Key Fob**, blank | Nothing, until it is programmed at a vehicle. |
| **Key Fob**, programmed | The vehicles it was programmed to, up close or from a distance. |

A few things worth knowing:

- **Keys belong to a side, not to a player.** Take an enemy's key off a body and
  it opens their vehicles.
- **Cutting a key ties it down.** A cut key stops working as a side key, unless
  your server turns that back on. *Wipe blank* undoes it.
- **Keys stack.** Ten blank BLUFOR keys are one line in your inventory; the same
  key cut to two different vehicles is two lines.
- **Where keys come from:** the Arsenal, crates a mission maker filled, another
  player, Zeus, or a body.

## Locking a vehicle for the first time

Walk up to a vehicle nobody has locked and open *Vehicle Keys*:

| Action | What it does |
| --- | --- |
| **Lock for BLUFOR** (your side) | Every blank key of your side opens it. Good for a shared motor pool. |
| **Lock for my squad** | Only your squad, carrying a blank key of the side. Good for a squad's own truck. |
| **Lock to my key** | One of your blank keys is cut to the vehicle. Only that key and spares cut later open it. Good for a command car or anything you do not want borrowed. |

Whichever you pick, you become the **owner**, and the vehicle takes your side and
your squad. By default you need a blank key of your side to do it, and *Lock to
my key* always needs one, because it cuts it.

Your server may offer only one of the three, and may allow only group leaders or
master key holders to lock a vehicle first.

## Opening, driving and cargo

Once a vehicle has keys:

| | |
| --- | --- |
| **Doors** | *Vehicle Keys → Lock* / *Unlock* at the vehicle, if your keys fit. |
| **From a seat** | ACE self-interaction has the same entry, and anyone sitting inside may lock and unlock without a key, like a door handle. |
| **Engine** | A driver whose keys do not fit cannot start it, even sitting in the driver's seat. |
| **Cargo** | A locked vehicle's inventory will not open from outside for anyone whose keys do not fit. |
| **Check lock** | Anyone can read the lock: locked or not, and who it opens for. If your keys fit, it also names who manages it and which code it takes. |

Locking and unlocking by hand can be instant or take a couple of seconds, as the
server sets it. From a seat, and with a fob, it is always instant.

## Managing a vehicle

The owner gets *Vehicle Keys → Manage keys*, and so does anyone with a master
key. Your server may extend it to the owner's squad leader, or to anyone whose
keys fit.

| Action | What it does | Watch out for |
| --- | --- | --- |
| **Opens for: …** | Switches between side, squad and paired keys. | Switching to paired keys cuts one of your blank keys first, so you are not locked out. With no blank key to cut, it refuses. |
| **Cut keys** | Lists the keys you carry that do not fit yet: *Cut a spare from* a blank key, *Re-cut* a key from another vehicle, *Program* a fob. | A spare always costs a blank key, and re-cutting a key takes it off the vehicle it used to open. |
| **Change locks** | The vehicle gets a new code. Keys you carry for it are re-cut. | Every other key cut for it stops fitting, including spares you handed out and fobs. Blank side keys are unaffected. |
| **Name vehicle** | Names it in menus, and on every key cut for it. | A key set's name is a better place to start if the mission maker set one. |
| **Give ownership to** | Hands the vehicle and its squad to a player standing nearby. | Keys are not handed over with it: pass those separately. |
| **Release vehicle** | No keys, no owner, unlocked, as if nobody had locked it. | Keys cut for it keep the old code and fit nothing. |

## Your own keys

ACE self-interaction → *Vehicle Keys* lists every key you carry.

| Action | What it does |
| --- | --- |
| **Inspect** | What the key is and which vehicles it opens right now, with map grid and lock state. Use it on a key from the Arsenal or a crate to see whether it is linked to anything yet. |
| **Key slot** | Puts the key in key slot 1, 2 or 3 for the key bindings, or takes it out. |
| **Label key** | Names a cut key, e.g. *Alpha Hunter*. Every copy shows the label. |
| **Wipe blank** | Turns a cut key back into a blank side key. |

A key fob that is programmed also gets **lock and unlock buttons** for each of
its vehicles in range, right under its own entry.

## Key fobs

A fob is its own item, blank until you program it.

1. Stand at a vehicle you manage.
2. *Vehicle Keys → Manage keys → Cut keys → Program Key Fob*.

From then on the fob opens that vehicle like a key, and:

- ACE self-interaction → *Vehicle Keys* lists every vehicle it is programmed to
  within range (15 m by default), with *Lock* and *Unlock*.
- The same buttons sit under the fob's own entry in that menu.
- The vehicle **chirps**: twice to lock, once to unlock.
- A key binding does the same without any menu.

One fob can be programmed to several vehicles: program it at each of them.

## Key bindings and key slots

Bind these under *Options → Controls → Configure Addons → TLB Keys*. They start
**unbound**, so they never steal a key you already use.

| Binding | What it does |
| --- | --- |
| **Lock/unlock nearest vehicle** | In a seat: the vehicle you are in. Outside: the nearest vehicle any of your keys open, within 5 m of its side — or as far as a fob reaches, if a fob is programmed to it. |
| **Lock/unlock with key slot 1 / 2 / 3** | The same, but only with the key in that slot. |

**Putting a key in a slot:** ACE self-interaction → *Vehicle Keys* → the key →
*Key slot* → the slot. A key sits in one slot at a time, and the key list shows
`[slot 1]` next to it. Slots are remembered for the mission, through respawns
and reconnects.

**Which binding to use:**

- Carrying keys to several vehicles and just want the one in front of you?
  *Lock/unlock nearest vehicle*. It always picks the closest vehicle your keys
  open, so walking up to any of them is enough.
- Want one button for your own car's fob and another for the squad truck? Put
  each key in its own slot.

If a slot's key is not in your pockets, the binding says so instead of opening
the wrong vehicle.

## Handing keys to other players

Look at the other player, open ACE interaction, choose **Hand over key**, then
the key. It goes straight into their inventory, or on the ground at their feet
if they have no room.

Keys also travel the ordinary ways: drop them, put them in a crate or a vehicle,
or take them off a body.

## Master keys

A master key opens **and manages every vehicle of its side**, however it is
locked. With one you can:

- unlock a vehicle whose owner is offline, or whose keys are lost
- manage vehicles the mission set up
- open a vehicle the mission locked without giving anyone a key
- reset a vehicle entirely: *Manage keys → Release vehicle*

They are meant for Zeus, commanders and the motor pool. Mission makers hand them
out with the Master Key module, and a server can hide them from the Arsenal so
they only come from modules, Zeus or a crate.

## Lockpicking and hotwiring

No key? Locks can be picked, if the server allows it and the vehicle is
pickable. You need a picking tool:

Which kit that is depends on the mods your server runs. There is only ever one
in the Arsenal, because the other is hidden:

| Mods loaded | The tool you carry | Who decides |
| --- | --- | --- |
| **TLB Interactions** (with or without TSP Breach) | Its lock pick kit or paperclip, or TSP Breach's | TLB Interactions, in its own settings |
| **TSP Breach** only | TSP Breach's kit and paperclip, or TLB Keys' **Lock Pick Kit** | your server's *Lock pick kit* setting |
| **Neither** | TLB Keys' **Lock Pick Kit** | - |

ACE's **Lockpick** works in all of them, if your mission hands them out.

At a locked vehicle, *Vehicle Keys → Pick lock* lists the tools you carry:

- **With [TLB Interactions](https://github.com/TLB-MilSim/TLB-Interactions)
  loaded:** its lockpicking board opens, where picking a lock is something you
  actually do. Stay by the vehicle while you work.
- **Without it:** a progress bar, the way ACE's own lockpicking works.

A picked vehicle is **hotwired**: the ignition lock lets it start without a key,
until someone with a key locks it again. The cargo is open while it is unlocked,
like any unlocked vehicle.

### Hotwiring from the driver's seat

An unlocked vehicle whose keys you do not have is a different problem: there is
no lock left to pick, and the engine still will not start. Sit in the driver's
seat and use *Vehicle Keys → Hotwire* (ACE self-interaction). After about
25 seconds it starts without a key, until someone with a key locks it again.

That is how you drive off in a vehicle you found open, or one a team mate
unlocked for you and then left.

## Which vehicles have keys

Your server chooses which kinds of vehicle use keys at all: cars, trucks and
MRAPs; wheeled APCs; tanks and tracked vehicles; helicopters; planes; boats.

A type that is switched off behaves as if the mod were not there: no *Vehicle
Keys* menu, no ignition or inventory lock, and ACE's own lock actions on it
instead. Static weapons and UAVs never use keys.

## Worked examples

**A squad truck.** Get a blank key from the Arsenal, walk to the truck, *Lock
for my squad*. Everyone in your squad with a key of your side can now use it,
and nobody else. If someone joins the squad later, their key works right away.

**A command car nobody else drives.** *Lock to my key* cuts your key to the car.
Then *Manage keys → Cut keys → Cut a spare from Vehicle Key* and hand the spare
to your driver with *Hand over key*. Anyone else's key is useless, even from
your own side.

**Your own car with a fob.** Lock the car to your key, then *Manage keys → Cut
keys → Program Key Fob*. Put the fob in key slot 1 and bind slot 1 to a key. Now
you lock and unlock it from across the parking area with one button and a chirp.

**A key went missing.** *Manage keys → Change locks*. Your own keys are re-cut
on the spot; every other key for the vehicle, including the lost one and any
fobs, stops fitting. Cut fresh spares for the people who should still have one.

**You captured an enemy truck.** It still has its old owner's keys, so take
their key off a body or pick the lock. Once it is unlocked and you manage it (a
master key, or the owner released it), lock it again to your own side.

## Troubleshooting

**My Arsenal key does not open my squad's car.** It is probably locked to paired
keys only. Ask the owner for a spare, or to switch it to *the owner's squad*.

**I cut my key and now the side's other cars are shut.** A cut key is tied to
what it was cut for. *Wipe blank* makes it a side key again, unless your server
keeps cut keys working as side keys too.

**"You need a blank key to cut first."** Switching a vehicle to paired keys, or
cutting a spare, needs a blank key in your pocket. Take one from the Arsenal or
a crate.

**The engine will not start.** Your keys do not fit that vehicle. Check *Vehicle
Keys → Check lock* to see who it opens for.

**My key binding does nothing.** Bind it first under *Controls → Configure
Addons → TLB Keys*, stand within about 5 m of the vehicle, and make sure the key
is actually in the slot you pressed.

**The owner left the server.** After a while the vehicle loses its owner, and
anyone whose keys fit can manage it. A master key can always manage it.

**A vehicle has no Vehicle Keys menu at all.** Its type is switched off in the
server's settings, or it is a static weapon or UAV.
