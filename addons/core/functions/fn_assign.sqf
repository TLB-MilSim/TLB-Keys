#include "..\script_component.hpp"
/*
 * Author: TLB
 * Sets up a vehicle's keys in one go. Used by claiming, the modules and the
 * Eden attributes, and public for mission scripts.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Mode: MODE_NONE -1, MODE_SIDE 0, MODE_SQUAD 1, MODE_PAIRED 2 <NUMBER> (default: 2)
 * 2: Side number, 0 OPFOR / 1 BLUFOR / 2 Independent / 3 Civilian <NUMBER> (default: -1)
 * 3: Squad <GROUP> (default: grpNull)
 * 4: Owner UID, "" for nobody or "#master" for master keys only <STRING> (default: "")
 * 5: Owner name <STRING> (default: "")
 * 6: Accepted codes <ARRAY of NUMBERs> (default: [])
 * 7: Label <STRING> (default: "", keeps the current label)
 * 8: Lock it <BOOL> (default: true)
 *
 * Return Value:
 * None
 *
 * Example:
 * [car1, 2, 1, grpNull, "#master", "", [1234], "Alpha Hunter", true] call tlb_keys_core_fnc_assign
 */

params [
    ["_veh", objNull, [objNull]],
    ["_mode", MODE_PAIRED, [0]],
    ["_side", -1, [0]],
    ["_group", grpNull, [grpNull]],
    ["_owner", "", [""]],
    ["_ownerName", "", [""]],
    ["_codes", [], [[]]],
    ["_label", "", [""]],
    ["_locked", true, [true]]
];

if (isNull _veh) exitWith {};

_veh setVariable ["tlb_keys_side", _side, true];
_veh setVariable ["tlb_keys_group", _group, true];
_veh setVariable ["tlb_keys_owner", _owner, true];
_veh setVariable ["tlb_keys_ownerName", _ownerName, true];
_veh setVariable ["tlb_keys_codes", _codes, true];
_veh setVariable ["tlb_keys_hotwired", nil, true];

if (_label != "") then {
    _veh setVariable ["tlb_keys_label", _label, true];
};

// Mode last: everything that reads it finds the rest already in place.
_veh setVariable ["tlb_keys_mode", _mode, true];

[_veh, _locked] call tlb_keys_core_fnc_setLock;
