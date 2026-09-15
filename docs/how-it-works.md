# How it works

[← Back to README](../README.md)

For developers and anyone curious. File references are relative to `addons/`.

- [Layout and build](#layout-and-build)
- [Keys carry their cut](#keys-carry-their-cut)
- [Vehicle state](#vehicle-state)
- [Deciding access](#deciding-access)
- [Locality](#locality)
- [ACE menus](#ace-menus)
- [Replacing ACE's vehicle lock](#replacing-aces-vehicle-lock)
- [Lockpicking with TLB Interactions](#lockpicking-with-tlb-interactions)
- [Modules and attributes](#modules-and-attributes)
- [Assets](#assets)

---

## Layout and build

| Addon | PBO | Holds |
| --- | --- | --- |
| `main` | `tlb_keys_main.pbo` | version, logo, CBA versioning |
| `items` | `tlb_keys_items.pbo` | the key classes and their pictures |
| `core` | `tlb_keys_core.pbo` | settings, access rules, ACE actions, event handlers, the naming dialog |
| `modules` | `tlb_keys_modules.pbo` | Eden and Zeus modules, vehicle attributes |

Functions are registered through `CfgFunctions` (`tlb_keys_core_fnc_*`,
`tlb_keys_modules_fnc_*`), with `preInit` and `postInit` functions instead of
XEH, and no P: drive.

`tools\build.ps1` packs each addon with its own PBO writer. It binarises configs
with CfgConvert when Arma 3 Tools is installed, and can sign and deploy.

## Keys carry their cut

Arma items cannot carry per-item data. ACE's custom key uses magazine IDs, but
those change whenever a loadout is re-created (respawn, saved loadouts) and
cannot be read in a crate.

TLB Keys uses a magazine's **round count** instead (`items\config.cpp`). Every
key class has `count = 9999`:

- **9999** (full) is a blank key. The Arsenal, Zeus and crates hand out full
  magazines, so a new key is always blank.
- **1-9998** is the code of the lock it was cut to.

Round counts survive dropping, crates (`addMagazineAmmoCargo`), handing over,
`getUnitLoadout` / `setUnitLoadout`, ACE Arsenal loadouts and respawn loadouts.

- **Repacking:** keys set `ace_disableRepacking = 1`, so ACE never merges them.
- **Arsenal:** `ACE_isUnique = 1` files them under the Arsenal's misc items.
- **Cutting:** there is no command to change one magazine's count, so
  `fn_cutKey` and `fn_takeKey` take out every magazine of the class and put
  them back with one count changed.

Codes are handed out by `fn_newCode`. Each code in use has a public
`tlb_keys_code_N` variable holding its label, so codes do not repeat and JIP
players see the labels. `fn_setCode` maps a key set name to one code
(`tlb_keys_set_<name>`).

## Vehicle state

All on the vehicle, public (`setVariable [..., true]`), written by
`fn_assign` and the manage functions:

| Variable | Holds |
| --- | --- |
| `tlb_keys_mode` | -1 none, 0 side, 1 squad, 2 paired |
| `tlb_keys_side` | side number, 0-3 |
| `tlb_keys_group` | the squad |
| `tlb_keys_owner` | UID, `""` or `"#master"` |
| `tlb_keys_ownerName` | owner's name |
| `tlb_keys_codes` | accepted codes |
| `tlb_keys_label` | name |
| `tlb_keys_hotwired`, `tlb_keys_pickable`, `tlb_keys_keepLock` | lockpicking and start state |

Lock state itself is the vanilla `locked` value, set with `lock` where the
vehicle is local.

## Deciding access

`fn_getAccess` returns 0 (nothing), 1 (open, lock, drive) or 2 (manage), from
the keys `fn_keys` finds on the unit:

1. A **master key** of the vehicle's side, or ACE's master key: manage.
2. A vehicle **without keys** gives nothing else.
3. A **cut key or fob** whose code is in `tlb_keys_codes`: open, in any mode.
4. A **blank side key** of the vehicle's side, in side mode, or in squad mode
   while the unit is in the vehicle's squad (`fn_inSquad`): open. With *Cut
   keys still open side vehicles* on, cut keys count here too.
5. Managing also needs the owner rule: no owner means anyone who can open it
   may manage it, `#master` means nobody (master keys were handled in step 1),
   and a UID means that player. Depending on the setting, the squad leader or
   anyone with access may manage as well.

`fn_keys` caches its result on the unit for the current frame, because ACE
evaluates menu conditions several times per frame.

## Locality

| Job | Where it runs | How it gets there |
| --- | --- | --- |
| `lock` | where the vehicle is local | `fn_setLock` sends `tlb_keys_core_setLock` with `CBA_fnc_targetEvent` |
| Adding and removing keys | where the unit is local | `fn_giveKey` / `fn_cutKey` send `tlb_keys_core_giveKey` / `tlb_keys_core_cutKey` |
| Messages | the receiving player's machine | `tlb_keys_core_notify` |
| Fob chirp | every machine | `tlb_keys_core_chirp`, played with `say3D` |
| Ignition lock | where the vehicle is local | `Engine` class event handler, `fn_onEngine` |
| Inventory lock | the opening player's machine | `InventoryOpened`, `fn_onInventory`: closes the vehicle's inventory and opens the player's own, as ACE does |
| Start state | server | `initPost` handler registered at `CBA_settingsInitialized`, 2 s after the vehicle is created |
| Owner timeout | server | `PlayerDisconnected` |

## ACE menus

`fn_postInit` adds four actions:

- **"Vehicle Keys" on vehicles:** `ACE_MainActions` on `LandVehicle`, `Air`
  and `Ship` (static weapons excluded), plus the vehicles' self-actions for
  crew.
- **"Vehicle Keys" on yourself:** `ACE_SelfActions` on `CAManBase`.
- **"Hand over key":** `ACE_MainActions` on `CAManBase`.

Each action builds its children with an insert-children function when the menu
opens (`fn_menuVehicle`, `fn_menuManage`, `fn_menuPick`, `fn_menuKeys`,
`fn_menuKey`, `fn_menuGive`). The menu therefore only lists what is possible at
that moment, and statements re-check access before acting.

## Replacing ACE's vehicle lock

- **Actions:** `core\config.cpp` rewrites the condition of ACE's
  `ACE_unlockVehicle`, `ACE_lockVehicle` and `ACE_lockpickVehicle` on `Car`,
  `Tank`, `Motorcycle`, `Helicopter`, `Plane` and `Ship_F` (self and main
  actions). Each condition first checks `tlb_keys_core_replaceAce`, so turning
  the setting off brings ACE's actions back without a restart.
- **Start locking and inventory lock:** `fn_preInit` registers a
  `CBA_settingsInitialized` handler before ACE's post-init. While ACE is
  replaced, it sets `ace_vehiclelock_vehicleStartingLockState` to -1 and
  `ace_vehiclelock_lockVehicleInventory` to false. ACE then never locks vehicles
  at start or guards inventories with its own keys.
- **ACE's keys:** `fn_keys` reads ACE's side keys and master key from the unit's
  items (`tlb_keys_core_aceKeys`).

## Lockpicking with TLB Interactions

`fn_menuPick` checks for `tlbi_lockpick_fnc_start` and asks
`tlbi_lockpick_fnc_hasTool` for a kit or a paperclip. `fn_pick` calls
`tlbi_lockpick_fnc_start` with `fn_picked` as the unlock callback.

The board treats its target as a building and closes when the player strays
4 m from the door. A vehicle's centre can be further away than that. So the
board gets a local invisible helipad at the player's feet as its "building",
which is deleted when the board closes. That object's class is not in any of
TLB Interactions' door lists, so picks use its civilian difficulty.

Without TLB Interactions, `fn_pick` runs an ACE progress bar for ACE's lockpick.

## Modules and attributes

- **Key Set** and **Master Key** run on the server (`isGlobal = 0`). They set
  up vehicles and crates, and store on the module what each synced unit gets
  (`tlb_keys_give`), then mark it `tlb_keys_ready`.
- `modules\functions\fn_postInit.sqf` runs on **every** machine: once a module
  is ready, it gives the keys to the synced units local to that machine (the
  server's AI, a headless client's AI, a player including JIP). A per-module
  flag on the unit stops keys being given twice. This avoids sending keys to a
  client that is still loading.
- **Respawn:** units remember module keys in `tlb_keys_respawnKeys`.
  `fn_onRespawn` tops up whatever the respawn loadout did not restore.
- **Vehicle attributes** (`Cfg3DEN`, condition `objectVehicle`) only store
  their values. `fn_attributes` schedules `fn_applyAttributes` once per vehicle
  on the server, the frame after all of them have been read.
- **Zeus modules** follow ACE's pattern: `curatorCanAttach`, read
  `bis_fnc_curatorObjectPlaced_mouseOver` on the Zeus's machine, delete the
  logic.

## Assets

`tools\gen_assets.py` draws every inventory picture, menu icon, module icon and
the logo with Pillow, converts them with ImageToPAA, and writes the fob chirps
as WAV. Intermediate PNGs go to `tools\.png` (ignored by git).
