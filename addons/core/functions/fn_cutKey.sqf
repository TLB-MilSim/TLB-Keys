#include "..\script_component.hpp"
/*
 * Author: TLB
 * Re-cuts one key a unit carries from one code to another (KEY_BLANK blanks it).
 *
 * There is no command to change one magazine's round count, so every magazine
 * of that class comes out and goes back into the container it was in, with the
 * one count changed (fn_restoreKeys). Runs where the unit is local.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Key class <STRING>
 * 2: Current code <NUMBER>
 * 3: New code <NUMBER>
 *
 * Return Value:
 * Cut (always true when sent to another machine) <BOOL>
 */

params ["_unit", "_class", "_from", "_to"];

if (isNull _unit) exitWith { false };

if (!local _unit) exitWith {
    ["tlb_keys_core_cutKey", [_unit, _class, _from, _to], _unit] call CBA_fnc_targetEvent;
    true
};

private _keys = ((magazinesAmmoFull _unit) select {(_x select 0) == _class && {!(_x select 2)}}) apply {[_x select 1, _x select 4]};
private _index = _keys findIf {(_x select 0) == _from};

if (_index == -1) exitWith { false };

(_keys select _index) set [0, _to];

_unit removeMagazines _class;
[_unit, _class, _keys] call tlb_keys_core_fnc_restoreKeys;

true
