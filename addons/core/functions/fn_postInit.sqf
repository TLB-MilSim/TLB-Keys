#include "..\script_component.hpp"
// TLB Keys - Core: events, class event handlers and ACE actions. Runs via
// CfgFunctions postInit.

diag_log text "[TLB Keys] core postInit";

// --- Events every machine answers ---------------------------------------------
// Inventory and lock commands have to run where the unit or vehicle is local;
// these carry them there.
["tlb_keys_core_setLock", { _this call tlb_keys_core_fnc_setLock }] call CBA_fnc_addEventHandler;
["tlb_keys_core_cutKey", { _this call tlb_keys_core_fnc_cutKey }] call CBA_fnc_addEventHandler;
["tlb_keys_core_giveKey", { _this call tlb_keys_core_fnc_giveKey }] call CBA_fnc_addEventHandler;
["tlb_keys_core_notify", { _this call tlb_keys_core_fnc_notify }] call CBA_fnc_addEventHandler;
["tlb_keys_core_chirp", { _this call tlb_keys_core_fnc_chirp }] call CBA_fnc_addEventHandler;

// --- Ignition lock and respawn keys, wherever the object is local ---------------
{
    [_x, "Engine", { _this call tlb_keys_core_fnc_onEngine }, true, ["StaticWeapon"]] call CBA_fnc_addClassEventHandler;
} forEach ["LandVehicle", "Air", "Ship"];

["CAManBase", "Respawn", { _this call tlb_keys_core_fnc_onRespawn }] call CBA_fnc_addClassEventHandler;

// --- Server: vehicles without keys, owners who leave ----------------------------
if (isServer) then {
    // CBA raises this the frame after post-init, with every setting in place.
    ["CBA_settingsInitialized", {
        {
            [_x, "initPost", { _this call tlb_keys_core_fnc_onVehicleInit }, true, ["StaticWeapon"], true] call CBA_fnc_addClassEventHandler;
        } forEach ["LandVehicle", "Air", "Ship"];
    }] call CBA_fnc_addEventHandler;

    addMissionEventHandler ["PlayerDisconnected", { _this call tlb_keys_core_fnc_onDisconnect }];
};

if (!hasInterface) exitWith {};

["CAManBase", "InventoryOpened", { _this call tlb_keys_core_fnc_onInventory }] call CBA_fnc_addClassEventHandler;
["ace_arsenal_displayOpened", { call tlb_keys_core_fnc_stripArsenal }] call CBA_fnc_addEventHandler;

// --- ACE actions ---------------------------------------------------------------
// One "Vehicle Keys" entry on every vehicle, outside and in a seat. Its children
// are built when the menu opens (fn_menuVehicle).
// ACE calls conditions and child builders with [target, player, action params].
private _outside = [
    "tlb_keys_vehicle", localize "STR_tlb_keys_core_action_vehicle", ICON_KEY, {},
    {
        params ["_target"];
        tlb_keys_core_enabled && {alive _target} && {!unitIsUAV _target}
    },
    {
        params ["_target", "_player"];
        [_target, _player, [false]] call tlb_keys_core_fnc_menuVehicle
    },
    [], [0, 0, 0], 4
] call ace_interact_menu_fnc_createAction;

private _inside = [
    "tlb_keys_vehicle", localize "STR_tlb_keys_core_action_vehicle", ICON_KEY, {},
    {
        params ["_target", "_player"];
        tlb_keys_core_enabled && {alive _target} && {_player in crew _target}
    },
    {
        params ["_target", "_player"];
        [_target, _player, [true]] call tlb_keys_core_fnc_menuVehicle
    }
] call ace_interact_menu_fnc_createAction;

{
    [_x, 0, ["ACE_MainActions"], _outside, true, ["StaticWeapon"]] call ace_interact_menu_fnc_addActionToClass;
    [_x, 1, ["ACE_SelfActions"], _inside, true, ["StaticWeapon"]] call ace_interact_menu_fnc_addActionToClass;
} forEach ["LandVehicle", "Air", "Ship"];

// "Vehicle Keys" on yourself: fob buttons, then every key carried.
private _myKeys = [
    "tlb_keys_keys", localize "STR_tlb_keys_core_action_myKeys", ICON_KEY, {},
    {
        params ["", "_player"];
        tlb_keys_core_enabled && {([_player] call tlb_keys_core_fnc_keys) isNotEqualTo []}
    },
    {
        params ["", "_player"];
        [_player] call tlb_keys_core_fnc_menuKeys
    }
] call ace_interact_menu_fnc_createAction;

["CAManBase", 1, ["ACE_SelfActions"], _myKeys, true] call ace_interact_menu_fnc_addActionToClass;

// "Hand over key" on anyone else.
private _give = [
    "tlb_keys_give", localize "STR_tlb_keys_core_action_give", ICON_GIVE, {},
    {
        params ["_target", "_player"];
        tlb_keys_core_enabled
        && {tlb_keys_core_allowHandOver}
        && {alive _target}
        && {_target != _player}
        && {(([_player] call tlb_keys_core_fnc_keys) findIf {isClass (configFile >> "CfgMagazines" >> (_x select 0))}) != -1}
    },
    {
        params ["_target", "_player"];
        [_target, _player] call tlb_keys_core_fnc_menuGive
    }
] call ace_interact_menu_fnc_createAction;

["CAManBase", 0, ["ACE_MainActions"], _give, true] call ace_interact_menu_fnc_addActionToClass;
