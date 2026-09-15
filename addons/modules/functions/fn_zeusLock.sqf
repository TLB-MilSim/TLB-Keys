#include "..\script_component.hpp"
/*
 * Author: TLB
 * Zeus: lock or unlock the vehicle the module is placed on. Its keys do not
 * change. A vehicle without keys that Zeus locks stays locked.
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

private _lock = (locked _veh) in [0, 1];

if ((_veh getVariable ["tlb_keys_mode", MODE_NONE]) == MODE_NONE) then {
    _veh setVariable ["tlb_keys_keepLock", [nil, true] select _lock, true];
};

[_veh, _lock] call tlb_keys_core_fnc_setLock;

[objNull, format [
    localize (["STR_tlb_keys_modules_zeus_unlocked", "STR_tlb_keys_modules_zeus_locked"] select _lock),
    [_veh] call tlb_keys_core_fnc_vehicleName
]] call BIS_fnc_showCuratorFeedbackMessage;
