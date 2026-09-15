#include "..\script_component.hpp"
/*
 * Author: TLB
 * The "Manage keys" menu, for owners and master keys: who it opens for, cutting
 * keys and programming fobs, changing the locks, naming it, giving it away and
 * releasing it.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Player <OBJECT>
 *
 * Return Value:
 * ACE child actions <ARRAY>
 */

params ["_veh", "_unit"];

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
private _codes = _veh getVariable ["tlb_keys_codes", []];
private _keys = [_unit] call tlb_keys_core_fnc_keys;

// --- Who it opens for -------------------------------------------------------
private _modes = [MODE_SIDE, MODE_SQUAD, MODE_PAIRED] select {
    _x != _mode && {[tlb_keys_core_allowSide, tlb_keys_core_allowSquad, tlb_keys_core_allowPaired] select _x}
};

if (_modes isNotEqualTo []) then {
    ["mode", format [localize "STR_tlb_keys_core_action_mode", localize format ["STR_tlb_keys_core_mode_%1", _mode]], ICON_KEY, {}, [_modes], {
        params ["_veh", "", "_params"];
        (_params select 0) apply {
            [
                [
                    format ["mode%1", _x],
                    localize format ["STR_tlb_keys_core_mode_%1", _x],
                    "\tlb_keys\addons\core\data\icon_key_ca.paa",
                    {
                        params ["_veh", "_unit", "_params"];
                        [_unit, _veh, _params select 0] call tlb_keys_core_fnc_setMode;
                    },
                    {true}, {}, [_x]
                ] call ace_interact_menu_fnc_createAction,
                [],
                _veh
            ]
        }
    }] call _fnc_action;
};

// --- Cut keys and program fobs ----------------------------------------------
// Every magazine key the player carries that does not already fit: blank keys
// become spares, keys cut for another vehicle are re-cut, fobs are programmed.
if (_codes isNotEqualTo []) then {
    private _seen = [];
    private _cuttable = [];
    {
        _x params ["_class", "_type", "", "_code"];
        private _allowed = (_type == "key" && {tlb_keys_core_allowSpare} && {_class in tlb_keys_core_keyClasses})
            || {_type == "fob" && {tlb_keys_core_allowFobs}};
        if (_allowed && {!(_code in _codes)} && {!([_class, _code] in _seen)}) then {
            _seen pushBack [_class, _code];
            _cuttable pushBack [_class, _type, _code];
        };
    } forEach _keys;

    if (_cuttable isNotEqualTo []) then {
        ["cut", localize "STR_tlb_keys_core_action_cut", ICON_KEY, {}, [_cuttable], {
            params ["_veh", "", "_params"];
            private _index = -1;
            (_params select 0) apply {
                _x params ["_class", "_type", "_code"];
                _index = _index + 1;
                private _textKey = switch (true) do {
                    case (_type == "fob"): { "STR_tlb_keys_core_action_program" };
                    case (_code == KEY_BLANK): { "STR_tlb_keys_core_action_cutBlank" };
                    default { "STR_tlb_keys_core_action_recut" };
                };
                [
                    [
                        format ["cut%1", _index],
                        format [localize _textKey, [_class, _code] call tlb_keys_core_fnc_keyName],
                        getText (configFile >> "CfgMagazines" >> _class >> "picture"),
                        {
                            params ["_veh", "_unit", "_params"];
                            _params params ["_class", "_code"];
                            private _codes = _veh getVariable ["tlb_keys_codes", []];
                            if (_codes isEqualTo [] || {([_unit, _veh] call tlb_keys_core_fnc_getAccess) < ACCESS_MANAGE}) exitWith {};
                            if ([_unit, _class, _code, _codes select 0] call tlb_keys_core_fnc_cutKey) then {
                                playSound "ACE_Sound_Click";
                                [format [
                                    localize "STR_tlb_keys_core_msg_cut",
                                    [_class, _codes select 0] call tlb_keys_core_fnc_keyName,
                                    [_veh] call tlb_keys_core_fnc_vehicleName
                                ]] call tlb_keys_core_fnc_notify;
                            };
                        },
                        {true}, {}, [_class, _code]
                    ] call ace_interact_menu_fnc_createAction,
                    [],
                    _veh
                ]
            }
        }] call _fnc_action;
    };
};

// --- Change the locks -------------------------------------------------------
["changeLocks", localize "STR_tlb_keys_core_action_changeLocks", ICON_LOCK, {
    params ["_veh", "_unit"];
    [_unit, _veh] call tlb_keys_core_fnc_changeLocks;
}] call _fnc_action;

// --- Name it ----------------------------------------------------------------
["rename", localize "STR_tlb_keys_core_action_rename", ICON_KEY, {
    params ["_veh"];
    ["vehicle", _veh] call tlb_keys_core_fnc_rename;
}] call _fnc_action;

// --- Give it away -----------------------------------------------------------
// Not for vehicles only master keys may manage: those stay the mission's.
if ((_veh getVariable ["tlb_keys_owner", ""]) != OWNER_MASTER) then {
    private _players = (_unit nearEntities [["CAManBase"], 10]) select {
        _x != _unit && {alive _x} && {isPlayer _x}
    };

    if (_players isNotEqualTo []) then {
        ["transfer", localize "STR_tlb_keys_core_action_transfer", ICON_GIVE, {}, [_players], {
            params ["_veh", "", "_params"];
            (_params select 0) apply {
                [
                    [
                        format ["to%1", _x call BIS_fnc_netId],
                        name _x,
                        "\tlb_keys\addons\core\data\icon_give_ca.paa",
                        {
                            params ["_veh", "_unit", "_params"];
                            [_unit, _veh, _params select 0] call tlb_keys_core_fnc_transfer;
                        },
                        {true}, {}, [_x]
                    ] call ace_interact_menu_fnc_createAction,
                    [],
                    _veh
                ]
            }
        }] call _fnc_action;
    };
};

// --- Give it up -------------------------------------------------------------
["release", localize "STR_tlb_keys_core_action_release", ICON_UNLOCK, {
    params ["_veh", "_unit"];
    [_unit, _veh] call tlb_keys_core_fnc_release;
}] call _fnc_action;

_actions
