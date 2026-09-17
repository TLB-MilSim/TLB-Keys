#include "..\script_component.hpp"
/*
 * Author: TLB
 * What the player can do with one key: lock and unlock its vehicles with a fob,
 * inspect it, put it in a key slot, label it, wipe it blank.
 *
 * Arguments:
 * 0: Player <OBJECT>
 * 1: Player <OBJECT>
 * 2: [class, type, side, code] <ARRAY>
 *
 * Return Value:
 * ACE child actions <ARRAY>
 */

params ["_unit", "", "_params"];
_params params ["_class", "_type", "_side", "_code"];

private _actions = [];

private _fnc_action = {
    params ["_name", "_text", "_icon", "_statement", ["_actionParams", _params], ["_children", {}]];
    _actions pushBack [
        [_name, _text, _icon, _statement, {true}, _children, _actionParams] call ace_interact_menu_fnc_createAction,
        [],
        _unit
    ];
};

// --- A programmed fob: lock and unlock its vehicles in range -----------------------
if (_type == "fob" && {_code != KEY_BLANK} && {tlb_keys_core_allowFobs}) then {
    {
        private _veh = _x;
        if (alive _veh && {[_veh] call tlb_keys_core_fnc_isKeyed} && {_code in (_veh getVariable ["tlb_keys_codes", []])}) then {
            private _lock = (locked _veh) in [0, 1];
            [
                format ["fob%1", _forEachIndex],
                format [
                    localize (["STR_tlb_keys_core_action_fobUnlock", "STR_tlb_keys_core_action_fobLock"] select _lock),
                    [_veh] call tlb_keys_core_fnc_vehicleName,
                    round (_unit distance _veh)
                ],
                [ICON_UNLOCK, ICON_LOCK] select _lock,
                {
                    params ["_unit", "", "_actionParams"];
                    _actionParams params ["_veh"];
                    if ((_unit distance _veh) > tlb_keys_core_fobRange + 5) exitWith {};
                    [_unit, _veh, (locked _veh) in [0, 1], true] call tlb_keys_core_fnc_toggleLock;
                },
                [_veh]
            ] call _fnc_action;
        };
    } forEach (_unit nearEntities [["LandVehicle", "Air", "Ship"], tlb_keys_core_fobRange]);
};

["inspect", localize "STR_tlb_keys_core_action_inspect", ICON_KEY, {
    params ["_unit", "", "_params"];
    hint parseText ([_unit, _params] call tlb_keys_core_fnc_inspectKey);
}] call _fnc_action;

// --- Key slots, for the key bindings (fn_bindKey) ---------------------------------
if (tlb_keys_core_allowKeybinds) then {
    ["slots", localize "STR_tlb_keys_core_action_slots", ICON_KEY, {}, _params, {
        params ["_unit", "", "_params"];
        _params params ["_class", "", "", "_code"];
        private _key = [_class, _code];

        private _children = [1, 2, 3] apply {
            private _current = tlb_keys_core_slots select (_x - 1);
            private _text = if (_current isEqualTo []) then {
                format [localize "STR_tlb_keys_core_action_slotEmpty", _x]
            } else {
                format [localize "STR_tlb_keys_core_action_slotUsed", _x, _current call tlb_keys_core_fnc_keyName]
            };
            [
                [
                    format ["slot%1", _x], _text, "\tlb_keys\addons\core\data\icon_key_ca.paa",
                    {
                        params ["", "", "_actionParams"];
                        _actionParams call tlb_keys_core_fnc_bindKey;
                    },
                    {true}, {}, [_x, _key]
                ] call ace_interact_menu_fnc_createAction,
                [],
                _unit
            ]
        };

        private _index = tlb_keys_core_slots find _key;
        if (_index != -1) then {
            _children pushBack [
                [
                    "unbind", format [localize "STR_tlb_keys_core_action_unbind", _index + 1], "\tlb_keys\addons\core\data\icon_unlock_ca.paa",
                    {
                        params ["", "", "_actionParams"];
                        [_actionParams select 0, []] call tlb_keys_core_fnc_bindKey;
                    },
                    {true}, {}, [_index + 1]
                ] call ace_interact_menu_fnc_createAction,
                [],
                _unit
            ];
        };

        _children
    }] call _fnc_action;
};

// Only a cut magazine key has a code to label or wipe.
if (_type != "master" && {_code != KEY_BLANK} && {isClass (configFile >> "CfgMagazines" >> _class)}) then {
    ["label", localize "STR_tlb_keys_core_action_label", ICON_KEY, {
        params ["", "", "_params"];
        ["code", _params select 3] call tlb_keys_core_fnc_rename;
    }] call _fnc_action;

    if (tlb_keys_core_allowWipe) then {
        ["wipe", localize "STR_tlb_keys_core_action_wipe", ICON_UNLOCK, {
            params ["_unit", "", "_params"];
            _params params ["_class", "", "", "_code"];
            if ([_unit, _class, _code, KEY_BLANK] call tlb_keys_core_fnc_cutKey) then {
                [format [localize "STR_tlb_keys_core_msg_wiped", [_class, KEY_BLANK] call tlb_keys_core_fnc_keyName]] call tlb_keys_core_fnc_notify;
            };
        }] call _fnc_action;
    };
};

_actions
