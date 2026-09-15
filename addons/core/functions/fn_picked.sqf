#include "..\script_component.hpp"
/*
 * Author: TLB
 * A lock was picked: unlock the vehicle and, with "Picked vehicles can be
 * driven" on, mark it hotwired so the ignition lock lets it start until someone
 * with a key locks it again.
 *
 * Raises tlb_keys_vehiclePicked [vehicle, unit] on every machine.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Unit <OBJECT>
 *
 * Return Value:
 * None
 */

params ["_veh", "_unit"];

if (!alive _veh) exitWith {};

[_veh, false] call tlb_keys_core_fnc_setLock;

if (tlb_keys_core_hotwire) then {
    _veh setVariable ["tlb_keys_hotwired", true, true];
};

["tlb_keys_vehiclePicked", [_veh, _unit]] call CBA_fnc_globalEvent;

playSound "ACE_Sound_Click";
[format [localize "STR_tlb_keys_core_msg_picked", [_veh] call tlb_keys_core_fnc_vehicleName]] call tlb_keys_core_fnc_notify;
