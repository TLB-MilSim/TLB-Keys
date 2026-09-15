# Mission making

[← Back to README](../README.md)

Players can set up keys themselves during a mission. These tools set them up
before it starts: which vehicles open for whom, which crates hold keys, and who
spawns with one.

- [Key Set module](#key-set-module)
- [Master Key module](#master-key-module)
- [Vehicle attributes](#vehicle-attributes)
- [Zeus modules](#zeus-modules)
- [Scripting](#scripting)
- [Recipes](#recipes)

All of it is under **Systems → Modules → TLB Keys** (F5) in Eden. The vehicle
attributes are in each vehicle's attribute window.

---

## Key Set module

One set of keys for everything synced to it (F5 → sync):

| Synced to | Gets |
| --- | --- |
| **Vehicles** | The set's mode, side and code, and its start lock. They are managed by master keys only, unless *Who may manage them* says otherwise. |
| **Crates** (any object with an inventory) | *Keys per crate* keys cut to the set, of the chosen key type. |
| **Units** | One key of the chosen type each, given again after respawn when *Give again on respawn* is on. With *Whole group*, every member of their group gets one. JIP players get theirs when they join. |

| Attribute | Default | Effect |
| --- | --- | --- |
| Key set name | empty | Shown on the keys, e.g. *Motor Pool*. **Key Set modules and vehicle attributes with the same name share one code**, so their keys open all of those vehicles. Empty: the keys are named after the first vehicle. |
| Opens for | Paired keys only | The set's keys always open the vehicles. *Every key of the side* or *The owner's squad* (the first synced unit's squad) also let blank keys in. |
| Side | Auto | Whose side the vehicles and keys belong to. Auto: the first synced unit's side, else the first vehicle's faction. |
| Who may manage them | Master keys only | Or *Anyone whose keys fit*: then key holders can change the mode, cut spares and change the locks in the mission. |
| Start locked | on | The vehicles start locked. |
| Key type | Vehicle key | *Vehicle key*, *Key fob* or *Key and key fob*, for units and crates. |
| Keys per crate | 4 | Of each key type. 0 for none. |
| Whole group | off | Synced units' whole groups get keys. |
| Give again on respawn | on | Units get the keys back after respawn, unless their respawn loadout already carries them. |

A vehicle synced to two Key Set modules opens for both sets' keys. The last
module decides its mode and side.

## Master Key module

Every unit synced to it starts with a master key.

| Attribute | Default | Effect |
| --- | --- | --- |
| Side | Each unit's own side | Or a fixed side for every synced unit. |
| Whole group | off | Synced units' whole groups get one. |
| Give again on respawn | on | As above. |

A master key opens and manages every vehicle of its side, however it is
locked. Give them to Zeus, commanders and the motor pool. To keep them out of
players' hands otherwise, turn off *Master keys in the ACE Arsenal*, or
blacklist `tlb_keys_master_west` / `_east` / `_indep` / `_civ` in your arsenal.

## Vehicle attributes

Every vehicle has a **TLB Keys** section in its attributes. Use it for vehicles
that do not need a module:

| Attribute | Default | Effect |
| --- | --- | --- |
| Opens for | None | None: no keys until a player locks it. Otherwise the vehicle starts with keys in that mode, managed by master keys only. |
| Side | Vehicle's faction | Whose keys fit. |
| Key set | empty | Vehicles and Key Set modules with the same name share their keys. With *Opens for* on None, a key set makes the vehicle open for paired keys only. |
| Start locked | off | Starts locked. A vehicle with no keys stays locked, and only a master key or a lockpick opens it. |
| Lock can be picked | on | Off: nobody can pick this vehicle's lock. |

A crewed vehicle set to *The owner's squad* opens for its crew's squad. For an
empty one, use a Key Set module synced to a member of the squad.

Use either a Key Set module or the attributes on a vehicle, not both.

## Zeus modules

Under **TLB Keys** in the Zeus module list. Place them on a vehicle or a unit:

| Module | Placed on | Effect |
| --- | --- | --- |
| Lock / Unlock Vehicle | vehicle | Toggles the lock. Its keys do not change. |
| Remove Vehicle Keys | vehicle | Unlocked, no keys, no owner. |
| Key for Vehicle | vehicle | Drops a key cut for it on the ground beside it. A vehicle without keys is paired first, managed by master keys only. |
| Give Master Key | unit | A master key for the unit's side. |

## Scripting

All functions are global. Vehicle state lives in public variables, so set it
up on the server.

```sqf
// A vehicle that opens only for the "HQ" key set, locked, managed by master keys.
if (isServer) then {
    private _code = ["HQ"] call tlb_keys_core_fnc_setCode;
    [hq_truck, 2, 1, grpNull, "#master", "", [_code], "HQ Truck", true] call tlb_keys_core_fnc_assign;
};

// Give a unit a key (or "fob") cut for a vehicle. Pairs the vehicle first if it has no keys.
[player, hq_truck, "fob"] call tlb_keys_core_fnc_addKeyForVehicle;

// Put a key with a known code in a crate: the round count is the cut.
supply_crate addMagazineAmmoCargo ["tlb_keys_key_west", 2, ["HQ"] call tlb_keys_core_fnc_setCode];

// What a unit may do with a vehicle: 0 nothing, 1 open and drive, 2 manage.
[player, hq_truck] call tlb_keys_core_fnc_getAccess;
```

| Function | Arguments | Returns |
| --- | --- | --- |
| `tlb_keys_core_fnc_assign` | vehicle, mode (-1 none, 0 side, 1 squad, 2 paired), side (0 OPFOR, 1 BLUFOR, 2 Independent, 3 Civilian), squad group, owner UID / `""` / `"#master"`, owner name, codes, label, locked | nothing |
| `tlb_keys_core_fnc_setCode` | key set name | the set's code, created on first use |
| `tlb_keys_core_fnc_newCode` | label | a new unused code |
| `tlb_keys_core_fnc_addKeyForVehicle` | unit, vehicle, `"key"` or `"fob"` | code |
| `tlb_keys_core_fnc_giveKey` | unit, key class, code (9999 blank), silent, from name | nothing; drops the key at the unit's feet when full |
| `tlb_keys_core_fnc_getAccess` | unit, vehicle | 0, 1 or 2 |
| `tlb_keys_core_fnc_keys` | unit | `[[class, type, side, code], ...]` |
| `tlb_keys_core_fnc_setLock` | vehicle, locked | nothing; runs where the vehicle is local |

**Key classes:**

- `tlb_keys_key_west`, `tlb_keys_key_east`, `tlb_keys_key_indep`, `tlb_keys_key_civ`
- `tlb_keys_master_west`, `tlb_keys_master_east`, `tlb_keys_master_indep`, `tlb_keys_master_civ`
- `tlb_keys_fob`

A key's round count is its cut: 9999 is blank, 1-9998 is a code.

**Vehicle variables (public):**

| Variable | Holds |
| --- | --- |
| `tlb_keys_mode` | -1 none, 0 side, 1 squad, 2 paired |
| `tlb_keys_side` | the side number |
| `tlb_keys_group` | the squad |
| `tlb_keys_owner` | the owner's UID, `""` for no owner, or `"#master"` for master keys only |
| `tlb_keys_ownerName` | the owner's name |
| `tlb_keys_codes` | the codes it accepts |
| `tlb_keys_label` | its name |
| `tlb_keys_hotwired` | picked, and starts without a key |
| `tlb_keys_pickable` | false for vehicles that cannot be picked |
| `tlb_keys_keepLock` | a vehicle without keys that stays locked |

**Event:** `tlb_keys_vehiclePicked` with `[vehicle, unit]`, raised on every
machine when a lock is picked.

ACE's `ace_vehiclelock_lockpickStrength` on a vehicle still sets how long ACE's
lockpick takes; -1 makes it unpickable.

## Recipes

**Motor pool.** A Key Set module named *Motor Pool*, set to *Every key of the
side* and *Start locked*, synced to the pool's vehicles and the motor pool
officer. The officer also gets a Master Key module.

**Each squad its own truck.** One Key Set module per squad, set to *The owner's
squad*, synced to the truck and one member of the squad. Key type *Vehicle
key*, *Whole group* on.

**A car only the informant can drive.** A Key Set module set to *Paired keys
only* and key type *Key fob*, synced to the car and the informant.

**Keys to find.** A Key Set module synced to the vehicles and to a crate or
two, with no units. Players have to find the crate first.
