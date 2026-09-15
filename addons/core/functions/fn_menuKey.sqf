#include "..\script_component.hpp"
/*
 * Author: TLB
 * What the player can do with one key: inspect it, label it, wipe it blank.
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
    params ["_name", "_text", "_icon", "_statement"];
    _actions pushBack [
        [_name, _text, _icon, _statement, {true}, {}, _params] call ace_interact_menu_fnc_createAction,
        [],
        _unit
    ];
};

["inspect", localize "STR_tlb_keys_core_action_inspect", ICON_KEY, {
    params ["_unit", "", "_params"];
    hint parseText ([_unit, _params] call tlb_keys_core_fnc_inspectKey);
}] call _fnc_action;

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
