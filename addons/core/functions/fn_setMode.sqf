#include "..\script_component.hpp"
/*
 * Author: TLB
 * Changes who a vehicle opens for.
 *
 * Switching to paired would lock out whoever did it if they only carry a blank
 * key, so their blank key is cut to the vehicle first - and without one to cut
 * the switch is refused. Master keys open it either way.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Vehicle <OBJECT>
 * 2: New mode <NUMBER>
 *
 * Return Value:
 * Changed <BOOL>
 */

params ["_unit", "_veh", "_mode"];

if !([tlb_keys_core_allowSide, tlb_keys_core_allowSquad, tlb_keys_core_allowPaired] select _mode) exitWith { false };
if (([_unit, _veh] call tlb_keys_core_fnc_getAccess) < ACCESS_MANAGE) exitWith { false };

private _keys = [_unit] call tlb_keys_core_fnc_keys;
private _codes = _veh getVariable ["tlb_keys_codes", []];
private _name = [_veh] call tlb_keys_core_fnc_vehicleName;

if (_mode == MODE_PAIRED) then {
    private _hasCut = _keys findIf {(_x select 1) != "master" && {(_x select 3) != KEY_BLANK} && {(_x select 3) in _codes}} != -1;
    private _master = tlb_keys_core_masterEnabled && {_keys findIf {(_x select 1) == "master"} != -1};

    if (!_hasCut && {!_master}) then {
        private _blank = [_unit, _veh getVariable ["tlb_keys_side", -1]] call tlb_keys_core_fnc_blankKey;
        if (_blank isEqualTo []) exitWith { _mode = -2 };

        if (_codes isEqualTo []) then {
            _codes = [[_name] call tlb_keys_core_fnc_newCode];
            _veh setVariable ["tlb_keys_codes", _codes, true];
        };
        [_unit, _blank select 0, KEY_BLANK, _codes select 0] call tlb_keys_core_fnc_cutKey;
    };
};

if (_mode == -2) exitWith {
    [localize "STR_tlb_keys_core_msg_needBlank"] call tlb_keys_core_fnc_notify;
    false
};

// A squad lock needs a squad: the owner's, or the squad of whoever sets it.
if (_mode == MODE_SQUAD && {isNull (_veh getVariable ["tlb_keys_group", grpNull]) || {(_veh getVariable ["tlb_keys_owner", ""]) in ["", OWNER_MASTER]}}) then {
    _veh setVariable ["tlb_keys_group", group _unit, true];
};

_veh setVariable ["tlb_keys_mode", _mode, true];

playSound "ACE_Sound_Click";
[format [localize "STR_tlb_keys_core_msg_modeChanged", _name, localize format ["STR_tlb_keys_core_mode_%1", _mode]]] call tlb_keys_core_fnc_notify;

true
