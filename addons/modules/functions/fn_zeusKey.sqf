#include "..\script_component.hpp"
/*
 * Author: TLB
 * Zeus: a key for the vehicle the module is placed on, dropped on the ground
 * beside it. A vehicle without keys is first paired to a new code, managed by
 * master keys only, keeping its lock state.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * None
 */

params ["_logic"];

if (!local _logic) exitWith {};

private _veh = [_logic] call tlb_keys_modules_fnc_zeusTarget;

if (isNull _veh || {!(_veh isKindOf "LandVehicle" || {_veh isKindOf "Air"} || {_veh isKindOf "Ship"})}) exitWith {
    [objNull, localize "STR_tlb_keys_modules_zeus_noVehicle"] call BIS_fnc_showCuratorFeedbackMessage;
};

private _name = [_veh] call tlb_keys_core_fnc_vehicleName;
private _codes = _veh getVariable ["tlb_keys_codes", []];

if (_codes isEqualTo []) then {
    _codes = [[_name] call tlb_keys_core_fnc_newCode];

    if ((_veh getVariable ["tlb_keys_mode", MODE_NONE]) == MODE_NONE) then {
        private _side = getNumber (configOf _veh >> "side");
        if (_side < 0 || {_side > 3}) then { _side = 3 };
        [_veh, MODE_PAIRED, _side, grpNull, OWNER_MASTER, "", _codes, "", (locked _veh) in [2, 3]] call tlb_keys_core_fnc_assign;
    } else {
        _veh setVariable ["tlb_keys_codes", _codes, true];
    };
};

private _side = _veh getVariable ["tlb_keys_side", 1];
if (_side < 0 || {_side > 3}) then { _side = 1 };

private _pos = _veh getPos [((boundingBoxReal _veh) select 2) * 0.6 + 1, getDir _veh + 90];
private _holder = createVehicle ["GroundWeaponHolder", _pos, [], 0, "CAN_COLLIDE"];
_holder addMagazineAmmoCargo [tlb_keys_core_keyClasses select _side, 1, _codes select 0];

[objNull, format [localize "STR_tlb_keys_modules_zeus_key", _name]] call BIS_fnc_showCuratorFeedbackMessage;
