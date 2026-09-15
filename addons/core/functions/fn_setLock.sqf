#include "..\script_component.hpp"
/*
 * Author: TLB
 * Locks or unlocks a vehicle where it is local, which is where lock has to run.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Locked <BOOL>
 *
 * Return Value:
 * None
 */

params ["_veh", "_locked"];

if (isNull _veh) exitWith {};

if (!local _veh) exitWith {
    ["tlb_keys_core_setLock", [_veh, _locked], _veh] call CBA_fnc_targetEvent;
};

_veh lock ([0, 2] select _locked);
