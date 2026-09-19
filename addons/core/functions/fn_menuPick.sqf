#include "..\script_component.hpp"
/*
 * Author: TLB
 * The ways the player can pick a locked vehicle's lock.
 *
 * Whichever picking tools the loaded mods provide are used, so there is never
 * a second kit doing the same job:
 *
 *   TLB Interactions loaded   its lockpicking board, with the tools it knows -
 *                             TSP Breach's kit and paperclip when that is
 *                             loaded too, otherwise its own - and ours as a
 *                             kit for anyone still carrying one
 *   TSP Breach only           its kit or paperclip, on a progress bar
 *   neither                   our own Lock Pick Kit, on a progress bar
 *
 * ACE's lockpick counts everywhere. The items addon hides our kit from the
 * Arsenal whenever TLB Interactions or TSP Breach is loaded.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Player <OBJECT>
 *
 * Return Value:
 * ACE child actions, empty when the player cannot pick it <ARRAY>
 */

params ["_veh", "_unit"];

if (!tlb_keys_core_lockpickEnabled || {!(_veh getVariable ["tlb_keys_pickable", true])}) exitWith { [] };
if ((_veh getVariable ["ace_vehiclelock_lockpickStrength", tlb_keys_core_lockpickTime]) < 0) exitWith { [] };

private _actions = [];

private _statement = {
    params ["_veh", "_unit", "_params"];
    _params params ["_method", "_item"];
    [_unit, _veh, _method, _item] call tlb_keys_core_fnc_pick;
};

private _fnc_add = {
    params ["_name", "_method", "_item"];
    _actions pushBack [
        [
            _name,
            format [localize "STR_tlb_keys_core_action_pickWith", getText (configFile >> "CfgWeapons" >> _item >> "displayName")],
            ICON_PICK, _statement, {true}, {}, [_method, _item]
        ] call ace_interact_menu_fnc_createAction,
        [],
        _veh
    ];
};

private _items = _unit call ace_common_fnc_uniqueItems;

private _board = tlb_keys_core_useTlbi
    && {!isNil "tlbi_lockpick_fnc_start"}
    && {missionNamespace getVariable ["tlbi_lockpick_enabled", true]};

if (_board) then {
    // TLB Interactions picks the tool: TSP Breach's first when it is loaded.
    {
        private _tool = _x;
        private _item = [_unit, _tool] call tlbi_lockpick_fnc_hasTool;
        if (_item == "" && {_tool == 0} && {"tlb_keys_lockpick" in _items}) then {
            _item = "tlb_keys_lockpick";
        };
        if (_item != "") then {
            [format ["pick%1", _tool], _tool, _item] call _fnc_add;
        };
    } forEach [0, 1];
} else {
    // No board: a progress bar with the best tool the player carries.
    {
        if (_x in _items) then {
            [format ["pick%1", _forEachIndex], 2, _x] call _fnc_add;
        };
    } forEach ["tsp_lockpick", "tsp_paperclip", "tlbi_lockpickKit", "tlbi_paperclip", "tlb_keys_lockpick", "ACE_key_lockpick"];
};

_actions
