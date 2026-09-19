#include "..\script_component.hpp"
/*
 * Author: TLB
 * Hotwires the vehicle the player is driving, when none of their keys fit it.
 *
 * Sitting in the driver's seat of a vehicle you cannot start is a dead end
 * otherwise: the doors are already open, so there is no lock left to pick. A
 * hotwired vehicle starts without a key until someone with a key locks it
 * again, exactly like one whose lock was picked.
 *
 * Needs "Picked and hotwired vehicles can be driven": with that off, a vehicle
 * without its key never runs, so there is nothing to hotwire.
 *
 * Raises tlb_keys_vehicleHotwired [vehicle, unit] on every machine.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 */

params ["_unit", "_veh"];

if (!tlb_keys_core_allowHotwire || {!tlb_keys_core_hotwire}) exitWith {};
if (isNull _veh || {objectParent _unit != _veh}) exitWith {};
if ((_veh getVariable ["tlb_keys_mode", MODE_NONE]) == MODE_NONE) exitWith {};
if (_veh getVariable ["tlb_keys_hotwired", false]) exitWith {};
if (([_unit, _veh] call tlb_keys_core_fnc_getAccess) > ACCESS_NONE) exitWith {};

[
    tlb_keys_core_hotwireTime max 1,
    [_unit, _veh],
    {
        params ["_args"];
        _args params ["_unit", "_veh"];

        _veh setVariable ["tlb_keys_hotwired", true, true];
        ["tlb_keys_vehicleHotwired", [_veh, _unit]] call CBA_fnc_globalEvent;

        playSound "ACE_Sound_Click";
        [format [localize "STR_tlb_keys_core_msg_hotwired", [_veh] call tlb_keys_core_fnc_vehicleName]] call tlb_keys_core_fnc_notify;
    },
    {},
    localize "STR_tlb_keys_core_progress_hotwire",
    {
        params ["_args"];
        _args params ["_unit", "_veh"];
        alive _veh && {objectParent _unit == _veh}
    },
    ["isNotInside", "isNotSwimming"]
] call ace_common_fnc_progressBar;
