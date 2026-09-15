#include "..\script_component.hpp"
/*
 * Author: TLB
 * Called by each TLB Keys Eden attribute of a vehicle as the mission loads.
 * Each attribute only stores its value; the vehicle is set up once, on the
 * server, the frame after all of them have been read.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 */

params ["_veh"];

if (is3DEN || {!isServer} || {!isNil {_veh getVariable "tlb_keys_attrPending"}}) exitWith {};

_veh setVariable ["tlb_keys_attrPending", true];

[{ _this call tlb_keys_modules_fnc_applyAttributes }, [_veh]] call CBA_fnc_execNextFrame;
