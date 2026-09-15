#include "..\script_component.hpp"
/*
 * Author: TLB
 * Hands ownership of a vehicle to another player, with their squad as the
 * vehicle's squad. Keys are not moved: hand them over separately.
 *
 * Arguments:
 * 0: Unit giving it away <OBJECT>
 * 1: Vehicle <OBJECT>
 * 2: New owner <OBJECT>
 *
 * Return Value:
 * None
 */

params ["_unit", "_veh", "_newOwner"];

if (isNull _newOwner || {([_unit, _veh] call tlb_keys_core_fnc_getAccess) < ACCESS_MANAGE}) exitWith {};

private _name = [_veh] call tlb_keys_core_fnc_vehicleName;

_veh setVariable ["tlb_keys_owner", getPlayerUID _newOwner, true];
_veh setVariable ["tlb_keys_ownerName", name _newOwner, true];
_veh setVariable ["tlb_keys_group", group _newOwner, true];

[format [localize "STR_tlb_keys_core_msg_transferred", _name, name _newOwner]] call tlb_keys_core_fnc_notify;
[format [localize "STR_tlb_keys_core_msg_transferredTo", _name, name _unit], _newOwner] call tlb_keys_core_fnc_notify;
