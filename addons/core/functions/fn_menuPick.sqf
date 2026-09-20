#include "..\script_component.hpp"
/*
 * Author: TLB
 * The ways the player can pick a locked vehicle's lock.
 *
 * Who owns the choice of tool depends on what is loaded:
 *
 *   TLB Interactions   its board owns picking, and its own settings choose the
 *                      tool - its kit and paperclip, or TSP Breach's. Our kit
 *                      still works for anyone carrying one from before.
 *   otherwise          the "Lock pick kit" setting: TSP Breach's kit, ours, or
 *                      Automatic, which is TSP Breach's when that mod is loaded
 *                      and ours when it is not.
 *
 * ACE's lockpick works in all of them.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Player <OBJECT>
 *
 * Return Value:
 * ACE child actions, empty when the player cannot pick it <ARRAY>
 */

params ["_veh", "_unit"];

// TLB Interactions puts its own entries on the vehicle when it owns picking.
if (call tlb_keys_core_fnc_deferred) exitWith { [] };

if (!tlb_keys_core_lockpickEnabled || {!(_veh getVariable ["tlb_keys_pickable", true])}) exitWith { [] };
if ((_veh getVariable ["ace_vehiclelock_lockpickStrength", tlb_keys_core_lockpickTime]) < 0) exitWith { [] };

private _board = !isNil "tlbi_lockpick_fnc_start"
    && {missionNamespace getVariable ["tlbi_lockpick_enabled", true]}
    && {missionNamespace getVariable ["tlbi_lockpick_vehicles", true]};

private _items = _unit call ace_common_fnc_uniqueItems;
private _actions = [];

private _statement = {
    params ["_veh", "_unit", "_params"];
    _params params ["_method", "_item"];
    [_unit, _veh, _method, _item] call tlb_keys_core_fnc_pick;
};

private _fnc_add = {
    params ["_method", "_item"];
    _actions pushBack [
        [
            format ["pick%1", count _actions],
            format [localize "STR_tlb_keys_core_action_pickWith", getText (configFile >> "CfgWeapons" >> _item >> "displayName")],
            ICON_PICK, _statement, {true}, {}, [_method, _item]
        ] call ace_interact_menu_fnc_createAction,
        [],
        _veh
    ];
};

if (_board) then {
    // TLB Interactions knows its tools, and which of them TSP Breach provides.
    {
        private _tool = _x;
        private _item = [_unit, _tool] call tlbi_lockpick_fnc_hasTool;
        if (_item == "" && {_tool == 0} && {"tlb_keys_lockpick" in _items}) then {
            _item = "tlb_keys_lockpick";
        };
        if (_item != "") then {
            [_tool, _item] call _fnc_add;
        };
    } forEach [0, 1];
} else {
    private _kits = switch (tlb_keys_core_pickKit) do {
        case 1: { ["tsp_lockpick", "tsp_paperclip"] };
        case 2: { ["tlb_keys_lockpick"] };
        // Automatic: whichever mod's kit is actually there.
        default {
            if (isClass (configFile >> "CfgWeapons" >> "tsp_lockpick")) then {
                ["tsp_lockpick", "tsp_paperclip"]
            } else {
                ["tlb_keys_lockpick"]
            }
        };
    };

    {
        if (_x in _items) then { [2, _x] call _fnc_add };
    } forEach (_kits + ["ACE_key_lockpick"]);
};

_actions
