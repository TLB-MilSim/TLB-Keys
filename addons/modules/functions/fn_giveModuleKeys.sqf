#include "..\script_component.hpp"
/*
 * Author: TLB
 * Gives a local unit the keys a module hands out, once per unit and module,
 * and records them for respawn when the module says so.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Module logic <OBJECT>
 *
 * Return Value:
 * None
 */

params ["_unit", "_logic"];

if (isNull _unit || {!local _unit}) exitWith {};

private _flag = "tlb_keys_given_" + (_logic getVariable ["tlb_keys_id", "0"]);
if (_unit getVariable [_flag, false]) exitWith {};
_unit setVariable [_flag, true, true];

(_logic getVariable ["tlb_keys_give", []]) params [["_give", []], ["_respawn", true]];

private _given = [];

{
    _x params ["_class", "_code"];

    if (_class == "#master") then {
        private _side = _code;
        if (_side == -1) then { _side = [east, west, independent, civilian] find (side group _unit) };
        _class = if (_side == -1) then { "" } else { tlb_keys_core_masterClasses select _side };
        _code = KEY_BLANK;
    };

    if (_class != "") then {
        [_unit, _class, _code, true] call tlb_keys_core_fnc_giveKey;
        _given pushBack [_class, _code];
    };
} forEach _give;

if (_respawn && {_given isNotEqualTo []}) then {
    _unit setVariable ["tlb_keys_respawnKeys", (_unit getVariable ["tlb_keys_respawnKeys", []]) + _given, true];
};
