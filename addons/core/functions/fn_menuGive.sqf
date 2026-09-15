#include "..\script_component.hpp"
/*
 * Author: TLB
 * "Hand over key" on another unit: one entry per key the player carries.
 * ACE's keys are items and stay out of it; hand those over the usual way.
 *
 * Arguments:
 * 0: Unit receiving <OBJECT>
 * 1: Player <OBJECT>
 *
 * Return Value:
 * ACE child actions <ARRAY>
 */

params ["_target", "_unit"];

private _actions = [];
private _seen = [];

{
    _x params ["_class", "", "", "_code"];
    if (isClass (configFile >> "CfgMagazines" >> _class) && {!([_class, _code] in _seen)}) then {
        _seen pushBack [_class, _code];
        _actions pushBack [
            [
                format ["give%1", count _seen],
                [_class, _code] call tlb_keys_core_fnc_keyName,
                getText (configFile >> "CfgMagazines" >> _class >> "picture"),
                {
                    params ["_target", "_unit", "_params"];
                    _params params ["_class", "_code"];
                    [_unit, _target, _class, _code] call tlb_keys_core_fnc_handOver;
                },
                {true}, {}, [_class, _code]
            ] call ace_interact_menu_fnc_createAction,
            [],
            _target
        ];
    };
} forEach ([_unit] call tlb_keys_core_fnc_keys);

_actions
