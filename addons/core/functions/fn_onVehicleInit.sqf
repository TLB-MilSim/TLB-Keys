#include "..\script_component.hpp"
/*
 * Author: TLB
 * "Vehicles without keys start unlocked": a vehicle the mission left locked but
 * gave no keys is unlocked, so nobody finds a car no key in the mission opens.
 *
 * Runs on the server for every vehicle, a moment after it is created so that
 * modules, Eden attributes and init scripts have had their say.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 */

params ["_veh"];

if (!tlb_keys_core_enabled || {tlb_keys_core_startState != 0}) exitWith {};

[{
    params ["_veh"];

    if (!alive _veh || {!([_veh] call tlb_keys_core_fnc_isKeyed)}) exitWith {};
    if ((_veh getVariable ["tlb_keys_mode", MODE_NONE]) != MODE_NONE) exitWith {};
    if (_veh getVariable ["tlb_keys_keepLock", false]) exitWith {};

    if ((locked _veh) in [2, 3]) then {
        [_veh, false] call tlb_keys_core_fnc_setLock;
    };
}, [_veh], 2] call CBA_fnc_waitAndExecute;
