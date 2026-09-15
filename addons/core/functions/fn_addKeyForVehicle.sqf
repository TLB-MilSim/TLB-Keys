#include "..\script_component.hpp"
/*
 * Author: TLB
 * Gives a unit a key cut for a vehicle. A vehicle with no keys yet is paired to
 * a new code first, with no owner, keeping its lock state. Public, for mission
 * scripts - the TLB Keys counterpart of ace_vehiclelock_fnc_addKeyForVehicle.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Vehicle <OBJECT>
 * 2: "key" or "fob" <STRING> (default: "key")
 *
 * Return Value:
 * Code the key was cut to <NUMBER>
 *
 * Example:
 * [player, car1, "fob"] call tlb_keys_core_fnc_addKeyForVehicle
 */

params [["_unit", objNull, [objNull]], ["_veh", objNull, [objNull]], ["_type", "key", [""]]];

if (isNull _unit || {isNull _veh}) exitWith { 0 };

private _codes = _veh getVariable ["tlb_keys_codes", []];

if (_codes isEqualTo []) then {
    private _side = [east, west, independent, civilian] find (side group _unit);
    if (_side == -1) then { _side = ((getNumber (configOf _veh >> "side")) max 0) min 3 };

    _codes = [[[_veh] call tlb_keys_core_fnc_vehicleName] call tlb_keys_core_fnc_newCode];

    private _mode = _veh getVariable ["tlb_keys_mode", MODE_NONE];
    if (_mode == MODE_NONE) then {
        [_veh, MODE_PAIRED, _side, grpNull, "", "", _codes, "", (locked _veh) in [2, 3]] call tlb_keys_core_fnc_assign;
    } else {
        _veh setVariable ["tlb_keys_codes", _codes, true];
    };
};

private _side = _veh getVariable ["tlb_keys_side", 1];
if (_side < 0 || {_side > 3}) then { _side = 1 };

private _class = if (_type == "fob") then { "tlb_keys_fob" } else { tlb_keys_core_keyClasses select _side };

[_unit, _class, _codes select 0, true] call tlb_keys_core_fnc_giveKey;

_codes select 0
