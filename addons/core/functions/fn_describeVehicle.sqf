#include "..\script_component.hpp"
/*
 * Author: TLB
 * "Check lock": what anyone can see by looking at a vehicle's lock, and - for
 * someone whose keys fit - who owns it and which code it takes.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Player <OBJECT>
 *
 * Return Value:
 * Structured text for parseText <STRING>
 */

params ["_veh", "_unit"];

private _mode = _veh getVariable ["tlb_keys_mode", MODE_NONE];
private _locked = (locked _veh) in [2, 3];
private _access = [_unit, _veh] call tlb_keys_core_fnc_getAccess;
private _side = _veh getVariable ["tlb_keys_side", -1];

private _lines = [
    format ["<t size='1.2' font='PuristaMedium'>%1</t>", [_veh] call tlb_keys_core_fnc_vehicleName],
    localize (["STR_tlb_keys_core_info_unlocked", "STR_tlb_keys_core_info_locked"] select _locked)
];

_lines pushBack (switch (_mode) do {
    case MODE_NONE: {
        localize (["STR_tlb_keys_core_info_none", "STR_tlb_keys_core_info_noneLocked"] select _locked)
    };
    case MODE_SIDE: { format [localize "STR_tlb_keys_core_info_side", [_side] call tlb_keys_core_fnc_sideName] };
    case MODE_SQUAD: {
        private _group = _veh getVariable ["tlb_keys_group", grpNull];
        format [localize "STR_tlb_keys_core_info_squad", [_side] call tlb_keys_core_fnc_sideName, [localize "STR_tlb_keys_core_info_unknownSquad", groupId _group] select !isNull _group]
    };
    default { localize "STR_tlb_keys_core_info_paired" };
});

if (_mode != MODE_NONE && {_access > ACCESS_NONE}) then {
    private _owner = _veh getVariable ["tlb_keys_owner", ""];
    _lines pushBack format [localize "STR_tlb_keys_core_info_owner", switch (_owner) do {
        case OWNER_MASTER: { localize "STR_tlb_keys_core_info_ownerMaster" };
        case "": { localize "STR_tlb_keys_core_info_ownerNobody" };
        default { _veh getVariable ["tlb_keys_ownerName", "?"] };
    }];
    _lines pushBack format [localize "STR_tlb_keys_core_info_codes", ((_veh getVariable ["tlb_keys_codes", []]) apply {"#" + ((str (10000 + _x)) select [1])}) joinString ", "];
};

if (_veh getVariable ["tlb_keys_hotwired", false]) then {
    _lines pushBack localize "STR_tlb_keys_core_info_hotwired";
};

_lines pushBack localize (switch (_access) do {
    case ACCESS_MANAGE: { "STR_tlb_keys_core_info_accessManage" };
    case ACCESS_USE: { "STR_tlb_keys_core_info_accessUse" };
    default { ["STR_tlb_keys_core_info_accessNone", "STR_tlb_keys_core_info_accessOpen"] select (_mode == MODE_NONE && {!_locked}) };
});

_lines joinString "<br/>"
