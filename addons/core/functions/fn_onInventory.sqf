#include "..\script_component.hpp"
/*
 * Author: TLB
 * Keeps a locked vehicle's cargo shut to anyone whose keys do not fit, from
 * outside. Closes the vehicle's inventory and opens the player's own, the way
 * ACE does it (which keeps ACRE happy).
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Container <OBJECT>
 * 2: Second container <OBJECT>
 *
 * Return Value:
 * None
 */

params ["_unit", "_container", ["_second", objNull]];

if (_unit != ACE_player || {!tlb_keys_core_enabled} || {!tlb_keys_core_lockInventory}) exitWith {};

private _index = [_container, _second] findIf {
    !isNull _x
    && {_x isKindOf "LandVehicle" || {_x isKindOf "Air"} || {_x isKindOf "Ship"}}
    && {!(_x isKindOf "StaticWeapon")}
};
if (_index == -1) exitWith {};

private _veh = [_container, _second] select _index;

if !([_veh] call tlb_keys_core_fnc_isKeyed) exitWith {};
if (objectParent _unit == _veh) exitWith {};
if !((locked _veh) in [2, 3]) exitWith {};
if (([_unit, _veh] call tlb_keys_core_fnc_getAccess) > ACCESS_NONE) exitWith {};

playSound "ACE_Sound_Click";
[localize "STR_tlb_keys_core_msg_inventoryLocked"] call tlb_keys_core_fnc_notify;

[
    { !isNull (findDisplay 602) },
    {
        (findDisplay 602) closeDisplay 0;
        [{ ACE_player action ["Gear", objNull] }] call CBA_fnc_execNextFrame;
    },
    [],
    5
] call CBA_fnc_waitUntilAndExecute;
