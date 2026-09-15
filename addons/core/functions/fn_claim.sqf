#include "..\script_component.hpp"
/*
 * Author: TLB
 * Locks an unassigned vehicle for the first time. The unit becomes its owner,
 * the vehicle takes the unit's side and squad, and in paired mode one of the
 * unit's blank keys is cut to it.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Vehicle <OBJECT>
 * 2: Mode <NUMBER>
 *
 * Return Value:
 * Claimed <BOOL>
 */

params ["_unit", "_veh", "_mode"];

if !([_unit, _veh, _mode] call tlb_keys_core_fnc_canClaim) exitWith { false };

private _side = [east, west, independent, civilian] find (side group _unit);
if (_side == -1) then {
    // A renegade or a logic: fall back to the side the vehicle was built for.
    _side = ((getNumber (configOf _veh >> "side")) max 0) min 3;
};

private _name = [_veh] call tlb_keys_core_fnc_vehicleName;
private _code = [_name] call tlb_keys_core_fnc_newCode;
private _blank = [];

if (_mode == MODE_PAIRED) then {
    _blank = [_unit, _side] call tlb_keys_core_fnc_blankKey;
};

[_veh, _mode, _side, group _unit, getPlayerUID _unit, name _unit, [_code], "", true] call tlb_keys_core_fnc_assign;

if (_blank isNotEqualTo []) then {
    [_unit, _blank select 0, KEY_BLANK, _code] call tlb_keys_core_fnc_cutKey;
};

playSound "ACE_Sound_Click";

private _text = switch (_mode) do {
    case MODE_SIDE: { format [localize "STR_tlb_keys_core_msg_claimedSide", _name, [_side] call tlb_keys_core_fnc_sideName] };
    case MODE_SQUAD: { format [localize "STR_tlb_keys_core_msg_claimedSquad", _name, groupId group _unit] };
    default { format [localize "STR_tlb_keys_core_msg_claimedPaired", _name, [_blank select 0, _code] call tlb_keys_core_fnc_keyName] };
};
[_text] call tlb_keys_core_fnc_notify;

true
