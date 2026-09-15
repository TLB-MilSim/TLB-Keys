#include "..\script_component.hpp"
/*
 * Author: TLB
 * Whether a unit may lock an unassigned vehicle in a mode, which is how a
 * vehicle gets its owner, side and first key.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Vehicle <OBJECT>
 * 2: Mode <NUMBER>
 *
 * Return Value:
 * May claim <BOOL>
 */

params ["_unit", "_veh", "_mode"];

if (!tlb_keys_core_enabled) exitWith { false };
if ((_veh getVariable ["tlb_keys_mode", MODE_NONE]) != MODE_NONE) exitWith { false };
if !([tlb_keys_core_allowSide, tlb_keys_core_allowSquad, tlb_keys_core_allowPaired] select _mode) exitWith { false };

private _keys = [_unit] call tlb_keys_core_fnc_keys;
private _master = tlb_keys_core_masterEnabled && {_keys findIf {(_x select 1) == "master"} != -1};

// A vehicle the mission locked without giving it keys stays shut to all but a master key.
if ((locked _veh) in [2, 3] && {!_master}) exitWith { false };

private _allowed = switch (tlb_keys_core_claimWho) do {
    case 1: { _master || {leader group _unit == _unit} };
    case 2: { _master };
    default { true };
};

if (!_allowed) exitWith { false };

private _side = [east, west, independent, civilian] find (side group _unit);

// Locking to one key cuts a blank key, so there has to be one to cut.
if (_mode == MODE_PAIRED) exitWith {
    ([_unit, _side] call tlb_keys_core_fnc_blankKey) isNotEqualTo []
};

tlb_keys_core_claimKey == 0
|| {_master}
|| {_keys findIf {(_x select 1) == "key" && {(_x select 2) == _side} && {(_x select 3) == KEY_BLANK}} != -1}
