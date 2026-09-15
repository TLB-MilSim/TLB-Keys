#include "..\script_component.hpp"
/*
 * Author: TLB
 * Changes the locks on a vehicle: it gets a new code and stops accepting every
 * key cut for the old ones. The keys the unit doing it carries are re-cut to
 * the new code, as a locksmith hands back the new keys.
 *
 * Blank side keys, squad keys and master keys are not affected: they never
 * depended on the code.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 */

params ["_unit", "_veh"];

if (([_unit, _veh] call tlb_keys_core_fnc_getAccess) < ACCESS_MANAGE) exitWith {};

private _old = _veh getVariable ["tlb_keys_codes", []];
private _name = [_veh] call tlb_keys_core_fnc_vehicleName;
private _code = [_name] call tlb_keys_core_fnc_newCode;

_veh setVariable ["tlb_keys_codes", [_code], true];
_veh setVariable ["tlb_keys_hotwired", nil, true];

// The old codes keep their labels, so the keys still cut for them read as the
// vehicle they used to open.
private _recut = 0;
{
    _x params ["_class", "_type", "", "_keyCode"];
    if (_type != "master" && {_keyCode != KEY_BLANK} && {_keyCode in _old}) then {
        if ([_unit, _class, _keyCode, _code] call tlb_keys_core_fnc_cutKey) then {
            _recut = _recut + 1;
        };
    };
} forEach +([_unit] call tlb_keys_core_fnc_keys);

playSound "ACE_Sound_Click";
[format [localize "STR_tlb_keys_core_msg_locksChanged", _name, _recut]] call tlb_keys_core_fnc_notify;
