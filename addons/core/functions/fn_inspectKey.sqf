#include "..\script_component.hpp"
/*
 * Author: TLB
 * "Inspect": what a key is and which vehicles it opens right now, so a key from
 * the Arsenal or a crate shows whether it is linked to anything yet.
 *
 * Arguments:
 * 0: Player <OBJECT>
 * 1: [class, type, side, code] <ARRAY>
 *
 * Return Value:
 * Structured text for parseText <STRING>
 */

#define MAX_LISTED 8

params ["_unit", "_key"];
_key params ["_class", "_type", "_side", "_code"];

private _lines = [format ["<t size='1.2' font='PuristaMedium'>%1</t>", [_class, _code] call tlb_keys_core_fnc_keyName]];
private _assigned = vehicles select {alive _x && {(_x getVariable ["tlb_keys_mode", MODE_NONE]) != MODE_NONE} && {[_x] call tlb_keys_core_fnc_isKeyed}};

private _opens = switch (true) do {
    case (_type == "master"): {
        _lines pushBack (if (!tlb_keys_core_masterEnabled) then {
            localize "STR_tlb_keys_core_inspect_masterOff"
        } else {
            [format [localize "STR_tlb_keys_core_inspect_master", [_side] call tlb_keys_core_fnc_sideName], localize "STR_tlb_keys_core_inspect_masterAll"] select (_side == -1)
        });
        []
    };
    case (_code == KEY_BLANK): {
        if (_type == "fob") exitWith {
            _lines pushBack localize "STR_tlb_keys_core_inspect_blankFob";
            []
        };
        _lines pushBack format [localize "STR_tlb_keys_core_inspect_blank", [_side] call tlb_keys_core_fnc_sideName];
        _assigned select {
            (_x getVariable ["tlb_keys_side", -1]) == _side
            && {
                private _mode = _x getVariable ["tlb_keys_mode", MODE_NONE];
                _mode == MODE_SIDE || {_mode == MODE_SQUAD && {[_unit, _x] call tlb_keys_core_fnc_inSquad}}
            }
        }
    };
    default {
        _lines pushBack format [localize "STR_tlb_keys_core_inspect_cut", (str (10000 + _code)) select [1]];
        if (_type == "fob") then {
            _lines pushBack format [localize "STR_tlb_keys_core_inspect_fob", tlb_keys_core_fobRange];
        };
        _assigned select {_code in (_x getVariable ["tlb_keys_codes", []])}
    };
};

if (_type != "master" && {_code != KEY_BLANK || {_type == "key"}}) then {
    if (_opens isEqualTo []) then {
        _lines pushBack localize (["STR_tlb_keys_core_inspect_opensNothingBlank", "STR_tlb_keys_core_inspect_opensNothing"] select (_code != KEY_BLANK));
    } else {
        _lines pushBack format [localize "STR_tlb_keys_core_inspect_opens", count _opens];
        {
            if (_forEachIndex < MAX_LISTED) then {
                _lines pushBack format [
                    "- %1 (%2, %3)",
                    [_x] call tlb_keys_core_fnc_vehicleName,
                    mapGridPosition _x,
                    localize (["STR_tlb_keys_core_info_unlocked", "STR_tlb_keys_core_info_locked"] select ((locked _x) in [2, 3]))
                ];
            };
        } forEach _opens;
        if (count _opens > MAX_LISTED) then {
            _lines pushBack format [localize "STR_tlb_keys_core_inspect_more", count _opens - MAX_LISTED];
        };
    };
};

_lines joinString "<br/>"
