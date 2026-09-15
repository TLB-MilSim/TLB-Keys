# All settings

[← Back to README](../README.md)

Every setting is a CBA setting under **Options → Addon Options → TLB Keys**, and
every one is **server-forced**: the server (or the mission) decides, not
individual players. That lets each unit tailor keys in its own settings file,
from one way of locking vehicles to all of them. Saved CBA settings override new
defaults, so check them after updating the mod.

The *Variable* column is the CBA setting name, for `cba_settings.sqf` and mission
settings files.

- [General](#general)
- [Locking a vehicle](#locking-a-vehicle)
- [Keys and management](#keys-and-management)
- [Master keys](#master-keys)
- [Key fobs](#key-fobs)
- [Lockpicking](#lockpicking)
- [Example settings file](#example-settings-file)

---

## General

| Setting | Variable | Default | Range | Effect |
| --- | --- | --- | --- | --- |
| Enable TLB Keys | `tlb_keys_core_enabled` | on | on / off | Vehicle keys, locks and their ACE menus. Off hides every TLB Keys action and lets every vehicle start, without unloading the mod. |
| Replace ACE vehicle locking | `tlb_keys_core_replaceAce` | on | on / off | Hides ACE's lock, unlock and lockpick actions. Also switches off ACE's start-of-mission locking and inventory lock, which this mod does itself. Off shows ACE's actions next to these. |
| Accept ACE keys | `tlb_keys_core_acceptAceKeys` | on | on / off | ACE's side keys work as blank side keys, and ACE's master key as a master key for every side. |
| Vehicles without keys | `tlb_keys_core_startState` | Start unlocked | Start unlocked / Keep the mission's lock | A vehicle the mission locked without keys starts unlocked, so no vehicle is locked with no key in the mission. *Keep*: it stays locked, and only a master key or a lockpick opens it. Vehicles with the *Start locked* attribute are always kept locked. |
| Lock the inventory | `tlb_keys_core_lockInventory` | on | on / off | A locked vehicle's cargo cannot be opened from outside by anyone whose keys do not fit. |
| Ignition lock | `tlb_keys_core_ignitionLock` | on | on / off | A player whose keys do not fit cannot start the engine of a vehicle with keys, even from the driver's seat. Vehicles without keys, hotwired vehicles and AI drivers are not affected. |
| Lock and unlock from inside | `tlb_keys_core_insideUnlock` | on | on / off | Anyone in a seat can lock and unlock the vehicle without a key. |
| Lock and unlock time (s) | `tlb_keys_core_lockTime` | 0 | 0 to 10 | ACE progress bar for locking and unlocking by hand at the vehicle. 0 is instant. From a seat and with a fob it is always instant. |

## Locking a vehicle

The three *Allow* settings are how a unit picks its way of using keys. Leave one
on to force it. Leave several on and the first player to lock a vehicle chooses.

| Setting | Variable | Default | Range | Effect |
| --- | --- | --- | --- | --- |
| Allow: every key of the side | `tlb_keys_core_allowSide` | on | on / off | Vehicles can be locked so every blank key of the owner's side opens them. |
| Allow: the owner's squad | `tlb_keys_core_allowSquad` | on | on / off | Vehicles can be locked for members of the owner's squad carrying a blank key of the side. |
| Allow: paired keys only | `tlb_keys_core_allowPaired` | on | on / off | Vehicles can be locked so only keys cut to them open them. |
| Locking a vehicle first needs | `tlb_keys_core_claimKey` | A blank key of their side | Nothing / A blank key of their side | What a player must carry to lock a vehicle nobody has locked yet. Locking to paired keys always needs a blank key to cut. A master key always can. |
| Who may lock a vehicle first | `tlb_keys_core_claimWho` | Anyone | Anyone / Group leaders / Master key holders | Who can lock an unassigned vehicle and so become its owner. A master key always can. |
| Squad vehicles open for | `tlb_keys_core_squadFollowsOwner` | The squad it was locked for | The squad it was locked for / The owner's current squad | Whether a squad vehicle follows its owner into another squad. |

## Keys and management

| Setting | Variable | Default | Range | Effect |
| --- | --- | --- | --- | --- |
| Who may manage a vehicle | `tlb_keys_core_managePerms` | The owner | The owner / The owner and the squad leader / Anyone whose keys fit | Who, besides master keys, gets *Manage keys*: the mode, cutting keys, changing locks, naming, giving away and releasing. It always takes keys that fit. A vehicle without an owner is managed by anyone whose keys fit; one set up by a module or attribute, by master keys only. |
| Allow spare keys | `tlb_keys_core_allowSpare` | on | on / off | Blank keys can be cut to a vehicle as spares, and keys re-cut from another vehicle. |
| Allow wiping keys | `tlb_keys_core_allowWipe` | on | on / off | A cut key can be wiped blank again. |
| Cut keys still open side vehicles | `tlb_keys_core_pairedAsSide` | off | on / off | On: a cut key also keeps opening its side's vehicles locked for the side or the squad. Off: cutting ties a key to the vehicles it was cut for. |
| Allow handing over keys | `tlb_keys_core_allowHandOver` | on | on / off | The *Hand over key* action on other units. |
| Owner leaves: release after (min) | `tlb_keys_core_ownerTimeout` | 0 | 0 to 60 | When an owner has been off the server this long, their vehicles lose their owner. The locks stay. 0 keeps owners for the whole mission. |

## Master keys

| Setting | Variable | Default | Range | Effect |
| --- | --- | --- | --- | --- |
| Master keys | `tlb_keys_core_masterEnabled` | on | on / off | Master keys open and manage every vehicle of their side. Off: they open nothing. |
| Master keys in the ACE Arsenal | `tlb_keys_core_masterInArsenal` | on | on / off | Off hides master keys in the ACE Arsenal from everyone but Zeus, and from anyone already carrying one. They then only come from modules, Zeus and crates. Leaving it on and blacklisting them in a unit's arsenal works too. |

## Key fobs

| Setting | Variable | Default | Range | Effect |
| --- | --- | --- | --- | --- |
| Allow key fobs | `tlb_keys_core_allowFobs` | on | on / off | Fobs can be programmed, open their vehicles, and lock and unlock from a distance. |
| Key fob range (m) | `tlb_keys_core_fobRange` | 15 | 5 to 50 | How far a fob reaches. |
| Key fob chirp | `tlb_keys_core_fobSound` | on | on / off | Twice to lock, once to unlock. |

## Lockpicking

| Setting | Variable | Default | Range | Effect |
| --- | --- | --- | --- | --- |
| Vehicle lockpicking | `tlb_keys_core_lockpickEnabled` | on | on / off | Locked vehicles can be picked. Never for vehicles marked as not pickable, or with `ace_vehiclelock_lockpickStrength` -1. |
| Use TLB Interactions | `tlb_keys_core_useTlbi` | on | on / off | With TLB Interactions loaded, picking uses its board with a lock pick kit or a paperclip. Off, or without it, ACE's lockpick is used. The board's difficulty comes from TLB Interactions' settings for civilian doors. |
| ACE lockpick time (s) | `tlb_keys_core_lockpickTime` | 20 | 1 to 120 | How long ACE's lockpick takes, unless the vehicle sets `ace_vehiclelock_lockpickStrength`. |
| Picked vehicles can be driven | `tlb_keys_core_hotwire` | on | on / off | A picked vehicle is hotwired: the ignition lock lets it start until someone with a key locks it again. |

## Example settings file

A unit that only uses paired keys, keeps master keys for Zeus, and wants
locking to take a moment:

```sqf
force tlb_keys_core_allowSide = false;
force tlb_keys_core_allowSquad = false;
force tlb_keys_core_allowPaired = true;
force tlb_keys_core_claimWho = 1;
force tlb_keys_core_masterInArsenal = false;
force tlb_keys_core_lockTime = 2;
force tlb_keys_core_ownerTimeout = 15;
```
