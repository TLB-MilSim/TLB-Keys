#include "..\script_component.hpp"
/*
 * Author: TLB
 * Whether a vehicle's type uses keys, by the "Vehicle types" settings.
 *
 * A type that is switched off is left alone completely: no TLB Keys menu, no
 * ignition or inventory lock, modules and attributes give it no keys, and ACE's
 * own lock actions stay available on it.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * Uses keys <BOOL>
 */

params [["_veh", objNull, [objNull]]];

if (isNull _veh || {_veh isKindOf "StaticWeapon"} || {unitIsUAV _veh}) exitWith { false };

switch (true) do {
    case (_veh isKindOf "Wheeled_APC_F"): { tlb_keys_core_vehApcs };
    case (_veh isKindOf "Car" || {_veh isKindOf "Motorcycle"}): { tlb_keys_core_vehCars };
    case (_veh isKindOf "Tank"): { tlb_keys_core_vehTanks };
    case (_veh isKindOf "Helicopter"): { tlb_keys_core_vehHelicopters };
    case (_veh isKindOf "Plane"): { tlb_keys_core_vehPlanes };
    case (_veh isKindOf "Ship"): { tlb_keys_core_vehBoats };
    default { false };
}
