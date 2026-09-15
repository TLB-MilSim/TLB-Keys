#include "..\script_component.hpp"
/*
 * Author: TLB
 * The key fob chirp at a vehicle: two beeps to lock, one to unlock. Runs on
 * every machine through the tlb_keys_core_chirp event.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Locked <BOOL>
 *
 * Return Value:
 * None
 */

params ["_veh", "_locked"];

if (!hasInterface || {isNull _veh}) exitWith {};

_veh say3D [["tlb_keys_fobUnlock", "tlb_keys_fobLock"] select _locked, 60];
