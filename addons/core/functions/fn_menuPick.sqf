#include "..\script_component.hpp"
/*
 * Author: TLB
 * The ways the player can pick a locked vehicle's lock.
 *
 * With TLB Interactions loaded (and "Use TLB Interactions" on) its lockpicking
 * board is used, with its lock pick kit or paperclip - and with our own kit
 * too, for anyone still carrying one. Without it, a progress bar and any pick
 * the player has: ours or ACE's.
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

private _actions = [];

private _statement = {
    params ["_veh", "_unit", "_params"];
    _params params ["_method", "_item"];
    [_unit, _veh, _method, _item] call tlb_keys_core_fnc_pick;
};

private _fnc_add = {
    params ["_name", "_text", "_method", "_item"];
    _actions pushBack [
        [_name, _text, ICON_PICK, _statement, {true}, {}, [_method, _item]] call ace_interact_menu_fnc_createAction,
        [],
        _veh
    ];
};

private _fnc_itemName = {
    params ["_item"];
    getText (configFile >> "CfgWeapons" >> _item >> "displayName")
};

private _items = _unit call ace_common_fnc_uniqueItems;

if (tlb_keys_core_useTlbi && {!isNil "tlbi_lockpick_fnc_start"} && {missionNamespace getVariable ["tlbi_lockpick_enabled", true]}) then {
    // TLB Interactions' board. It knows its own tools; ours stands in as a kit.
    {
        _x params ["_tool", "_text"];
        private _item = [_unit, _tool] call tlbi_lockpick_fnc_hasTool;
        if (_item == "" && {_tool == 0} && {"tlb_keys_lockpick" in _items}) then {
            _item = "tlb_keys_lockpick";
        };
        if (_item != "") then {
            [format ["pick%1", _tool], format [localize "STR_tlb_keys_core_action_pickWith", [_item] call _fnc_itemName], _tool, _item] call _fnc_add;
        };
    } forEach [[0, "kit"], [1, "clip"]];
} else {
    // No board: ACE's progress bar with whichever pick the player carries.
    {
        if (_x in _items) then {
            [format ["pick%1", _forEachIndex], format [localize "STR_tlb_keys_core_action_pickWith", [_x] call _fnc_itemName], 2, _x] call _fnc_add;
        };
    } forEach ["tlb_keys_lockpick", "ACE_key_lockpick"];
};

if (_actions isNotEqualTo [] && {(_veh getVariable ["ace_vehiclelock_lockpickStrength", tlb_keys_core_lockpickTime]) < 0}) exitWith { [] };

_actions
