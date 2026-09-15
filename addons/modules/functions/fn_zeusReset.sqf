#include "..\script_component.hpp"
/*
 * Author: TLB
 * Zeus: take every key off the vehicle the module is placed on. It is left
 * unlocked with no owner, as if nobody had ever locked it.
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

_veh setVariable ["tlb_keys_keepLock", nil, true];
[_veh, MODE_NONE, -1, grpNull, "", "", [], "", false] call tlb_keys_core_fnc_assign;

[objNull, format [localize "STR_tlb_keys_modules_zeus_reset", [_veh] call tlb_keys_core_fnc_vehicleName]] call BIS_fnc_showCuratorFeedbackMessage;
