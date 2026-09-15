#include "..\script_component.hpp"
/*
 * Author: TLB
 * Gives a vehicle up: no owner, no mode, no accepted codes, and unlocked, as it
 * was before anyone locked it. Keys cut for it stay in pockets but fit nothing.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 */

params ["_unit", "_veh"];

if (([_unit, _veh] call tlb_keys_core_fnc_getAccess) < ACCESS_MANAGE) exitWith {};

private _name = [_veh] call tlb_keys_core_fnc_vehicleName;

[_veh, MODE_NONE, -1, grpNull, "", "", [], "", false] call tlb_keys_core_fnc_assign;

playSound "ACE_Sound_Click";
[format [localize "STR_tlb_keys_core_msg_released", _name]] call tlb_keys_core_fnc_notify;
