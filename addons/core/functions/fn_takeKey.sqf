#include "..\script_component.hpp"
/*
 * Author: TLB
 * Takes one key with a given code out of a local unit's inventory. The unit's
 * other keys of that class go back where they were (fn_restoreKeys).
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Key class <STRING>
 * 2: Code <NUMBER>
 *
 * Return Value:
 * Taken <BOOL>
 */

params ["_unit", "_class", "_code"];

if (isNull _unit || {!local _unit}) exitWith { false };

private _keys = ((magazinesAmmoFull _unit) select {(_x select 0) == _class && {!(_x select 2)}}) apply {[_x select 1, _x select 4]};
private _index = _keys findIf {(_x select 0) == _code};

if (_index == -1) exitWith { false };

_keys deleteAt _index;

_unit removeMagazines _class;
[_unit, _class, _keys] call tlb_keys_core_fnc_restoreKeys;

true
