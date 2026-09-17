#include "..\script_component.hpp"
/*
 * Author: TLB
 * Ignition lock: a player whose keys do not fit cannot start a vehicle that has
 * keys, even from the driver's seat. Unassigned and hotwired vehicles start as
 * normal, and AI drivers are left to the mission.
 *
 * Runs from the Engine event, on every machine; acts where the vehicle is local.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Engine on <BOOL>
 *
 * Return Value:
 * None
 */

params ["_veh", "_engineOn"];

if (!_engineOn || {!local _veh} || {!tlb_keys_core_enabled} || {!tlb_keys_core_ignitionLock}) exitWith {};
if ((_veh getVariable ["tlb_keys_mode", MODE_NONE]) == MODE_NONE) exitWith {};
if !([_veh] call tlb_keys_core_fnc_isKeyed) exitWith {};
if (_veh getVariable ["tlb_keys_hotwired", false]) exitWith {};

private _driver = currentPilot _veh;
if (isNull _driver) then { _driver = driver _veh };

if (isNull _driver || {!isPlayer _driver}) exitWith {};
if (([_driver, _veh] call tlb_keys_core_fnc_getAccess) > ACCESS_NONE) exitWith {};

_veh engineOn false;

[format [localize "STR_tlb_keys_core_msg_ignition", [_veh] call tlb_keys_core_fnc_vehicleName], _driver] call tlb_keys_core_fnc_notify;
