#include "..\script_component.hpp"
/*
 * Author: TLB
 * Takes one key with a given code out of a local unit's inventory.
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

private _counts = ((magazinesAmmoFull _unit) select {(_x select 0) == _class && {!(_x select 2)}}) apply {_x select 1};
private _index = _counts find _code;

if (_index == -1) exitWith { false };

_counts deleteAt _index;

_unit removeMagazines _class;
{
    [_unit, _class, _x, true] call tlb_keys_core_fnc_giveKey;
} forEach _counts;

_unit setVariable ["tlb_keys_core_keyCache", nil];

true
