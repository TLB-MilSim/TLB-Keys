#include "..\script_component.hpp"
/*
 * Author: TLB
 * The blank key a unit would cut: one of the given side first, then any blank
 * side key, then a blank key fob. ACE's keys are items and cannot be cut.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Preferred side number <NUMBER> (default: -1)
 * 2: Fobs count <BOOL> (default: true, still subject to "Allow key fobs")
 * 3: Keys count <BOOL> (default: true)
 *
 * Return Value:
 * [class, type, side, code], or [] when the unit has none <ARRAY>
 */

params ["_unit", ["_side", -1], ["_fobs", true], ["_keysToo", true]];

private _fobs = _fobs && {tlb_keys_core_allowFobs};

private _blank = ([_unit] call tlb_keys_core_fnc_keys) select {
    (_x select 3) == KEY_BLANK
    && {(_keysToo && {(_x select 0) in tlb_keys_core_keyClasses}) || {_fobs && {(_x select 1) == "fob"}}}
};

if (_blank isEqualTo []) exitWith { [] };

private _index = _blank findIf {(_x select 1) == "key" && {(_x select 2) == _side}};
if (_index == -1) then { _index = _blank findIf {(_x select 1) == "key"} };
if (_index == -1) then { _index = 0 };

_blank select _index
