#include "..\script_component.hpp"
/*
 * Author: TLB
 * The "Vehicle Keys" menu on a vehicle, from outside (ACE interaction) or from
 * a seat (ACE self-interaction). Built each time the menu opens, so it only
 * ever lists what the player can do right now.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Player <OBJECT>
 * 2: [From inside <BOOL>] <ARRAY>
 *
 * Return Value:
 * ACE child actions <ARRAY>
 */

params ["_veh", "_unit", ["_args", []]];
_args params [["_inside", false]];

private _actions = [];

private _fnc_action = {
    params ["_name", "_text", "_icon", "_statement", ["_params", []], ["_children", {}]];
    _actions pushBack [
        [_name, _text, _icon, _statement, {true}, _children, _params] call ace_interact_menu_fnc_createAction,
        [],
        _veh
    ];
};

private _mode = _veh getVariable ["tlb_keys_mode", MODE_NONE];
private _locked = (locked _veh) in [2, 3];
private _access = [_unit, _veh] call tlb_keys_core_fnc_getAccess;
private _occupant = _inside && {tlb_keys_core_insideUnlock};

private _lockStatement = {
    params ["_veh", "_unit", "_params"];
    _params params ["_lock"];
    [_unit, _veh, _lock] call tlb_keys_core_fnc_toggleLock;
};

if (_mode == MODE_NONE) then {
    if (_locked) then {
        if (_access > ACCESS_NONE || {_occupant}) then {
            ["unlock", localize "STR_tlb_keys_core_action_unlock", ICON_UNLOCK, _lockStatement, [false]] call _fnc_action;
        };
    } else {
        {
            _x params ["_claimMode", "_text"];
            if ([_unit, _veh, _claimMode] call tlb_keys_core_fnc_canClaim) then {
                [
                    format ["claim%1", _claimMode], _text, ICON_LOCK,
                    {
                        params ["_veh", "_unit", "_params"];
                        [_unit, _veh, _params select 0] call tlb_keys_core_fnc_claim;
                    },
                    [_claimMode]
                ] call _fnc_action;
            };
        } forEach [
            [MODE_SIDE, format [localize "STR_tlb_keys_core_action_claimSide", [[east, west, independent, civilian] find (side group _unit)] call tlb_keys_core_fnc_sideName]],
            [MODE_SQUAD, localize "STR_tlb_keys_core_action_claimSquad"],
            [MODE_PAIRED, localize "STR_tlb_keys_core_action_claimPaired"]
        ];
    };
} else {
    if (_access > ACCESS_NONE || {_occupant}) then {
        if (_locked) then {
            ["unlock", localize "STR_tlb_keys_core_action_unlock", ICON_UNLOCK, _lockStatement, [false]] call _fnc_action;
        } else {
            ["lock", localize "STR_tlb_keys_core_action_lock", ICON_LOCK, _lockStatement, [true]] call _fnc_action;
        };
    };

    if (_access == ACCESS_MANAGE) then {
        ["manage", localize "STR_tlb_keys_core_action_manage", ICON_MASTER, {}, [], {
            params ["_veh", "_unit"];
            [_veh, _unit] call tlb_keys_core_fnc_menuManage
        }] call _fnc_action;
    };
};

if (!_inside && {_locked} && {_access == ACCESS_NONE} && {([_veh, _unit] call tlb_keys_core_fnc_menuPick) isNotEqualTo []}) then {
    ["pick", localize "STR_tlb_keys_core_action_pick", ICON_PICK, {}, [], {
        params ["_veh", "_unit"];
        [_veh, _unit] call tlb_keys_core_fnc_menuPick
    }] call _fnc_action;
};

if (_inside
    && {tlb_keys_core_allowHotwire}
    && {tlb_keys_core_hotwire}
    && {!(call tlb_keys_core_fnc_deferred)}
    && {_mode != MODE_NONE}
    && {_access == ACCESS_NONE}
    && {!(_veh getVariable ["tlb_keys_hotwired", false])}
    && {driver _veh == _unit}
) then {
    ["hotwire", localize "STR_tlb_keys_core_action_hotwire", ICON_PICK, {
        params ["_veh", "_unit"];
        [_unit, _veh] call tlb_keys_core_fnc_hotwire;
    }] call _fnc_action;
};

["check", localize "STR_tlb_keys_core_action_check", ICON_KEY, {
    params ["_veh", "_unit"];
    hint parseText ([_veh, _unit] call tlb_keys_core_fnc_describeVehicle);
}] call _fnc_action;

_actions
