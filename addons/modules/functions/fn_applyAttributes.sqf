#include "..\script_component.hpp"
/*
 * Author: TLB
 * Turns a vehicle's TLB Keys Eden attributes into keys:
 *
 *   Mode       side, squad or paired; "none" leaves it unassigned
 *   Side       whose keys fit; "vehicle" uses the faction it was built for
 *   Key set    vehicles, and Key Set modules, with the same name share a code
 *              (a key set without a mode is paired)
 *   Locked     starts locked; an unassigned vehicle stays locked too
 *   Pickable   whether its lock can be picked
 *
 * Vehicles set up here are managed by master keys only. Runs on the server.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 */

params ["_veh"];

if (isNull _veh) exitWith {};

private _mode = _veh getVariable ["tlb_keys_attrMode", MODE_NONE];
private _side = _veh getVariable ["tlb_keys_attrSide", -1];
private _set = _veh getVariable ["tlb_keys_attrSet", ""];
private _locked = _veh getVariable ["tlb_keys_attrLocked", false];
private _pickable = _veh getVariable ["tlb_keys_attrPickable", true];

if (!_pickable) then {
    _veh setVariable ["tlb_keys_pickable", false, true];
};

if (_mode == MODE_NONE && {_set != ""}) then { _mode = MODE_PAIRED };

if (_mode == MODE_NONE) exitWith {
    if (_locked) then {
        _veh setVariable ["tlb_keys_keepLock", true, true];
        [_veh, true] call tlb_keys_core_fnc_setLock;
    };
};

if (_side == -1) then {
    _side = getNumber (configOf _veh >> "side");
    if (_side < 0 || {_side > 3}) then { _side = 3 };
};

private _code = if (_set != "") then {
    [_set] call tlb_keys_core_fnc_setCode
} else {
    [[_veh] call tlb_keys_core_fnc_vehicleName] call tlb_keys_core_fnc_newCode
};

private _codes = +(_veh getVariable ["tlb_keys_codes", []]);
_codes pushBackUnique _code;

// A crewed vehicle locked for the squad belongs to its crew's group.
private _group = [grpNull, group effectiveCommander _veh] select (!isNull effectiveCommander _veh);

[_veh, _mode, _side, _group, OWNER_MASTER, "", _codes, "", _locked] call tlb_keys_core_fnc_assign;
