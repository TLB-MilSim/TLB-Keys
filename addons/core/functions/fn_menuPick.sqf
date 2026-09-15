#include "..\script_component.hpp"
/*
 * Author: TLB
 * The ways the player can pick a locked vehicle's lock.
 *
 * With TLB Interactions loaded (and "Use TLB Interactions" on) its lockpicking
 * board is used with a lock pick kit or a paperclip. Without it, ACE's
 * lockpick opens the lock after a progress bar.
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

if (tlb_keys_core_useTlbi && {!isNil "tlbi_lockpick_fnc_start"} && {missionNamespace getVariable ["tlbi_lockpick_enabled", true]}) then {
    {
        _x params ["_tool", "_text"];
        private _item = [_unit, _tool] call tlbi_lockpick_fnc_hasTool;
        if (_item != "") then {
            _actions pushBack [
                [format ["pick%1", _tool], localize _text, ICON_PICK, _statement, {true}, {}, [_tool, _item]] call ace_interact_menu_fnc_createAction,
                [],
                _veh
            ];
        };
    } forEach [[0, "STR_tlb_keys_core_action_pickKit"], [1, "STR_tlb_keys_core_action_pickClip"]];
};

if (_actions isEqualTo []
    && {"ACE_key_lockpick" in (items _unit)}
    && {(_veh getVariable ["ace_vehiclelock_lockpickStrength", tlb_keys_core_lockpickTime]) >= 0}
) then {
    _actions pushBack [
        ["pickAce", localize "STR_tlb_keys_core_action_pickAce", ICON_PICK, _statement, {true}, {}, [2, "ACE_key_lockpick"]] call ace_interact_menu_fnc_createAction,
        [],
        _veh
    ];
};

_actions
