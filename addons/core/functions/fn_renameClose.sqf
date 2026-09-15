#include "..\script_component.hpp"
/*
 * Author: TLB
 * The naming dialog closed: on OK, apply the name everyone will see.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 * 1: Exit code, 1 for OK <NUMBER>
 *
 * Return Value:
 * None
 */

params ["_display", "_exitCode"];

if (_exitCode != 1) exitWith {};

// Names end up in structured text, so markup characters are dropped.
private _text = ctrlText (_display displayCtrl IDC_RENAME_EDIT);
_text = (_text regexReplace ["[<>""&]", ""]) regexReplace ["^\s+|\s+$", ""];
_text = _text select [0, 40];

(uiNamespace getVariable ["tlb_keys_core_renameTarget", []]) params [["_kind", ""], ["_subject", objNull]];

switch (_kind) do {
    case "vehicle": {
        if (isNull _subject) exitWith {};
        _subject setVariable ["tlb_keys_label", _text, true];

        private _name = [_subject] call tlb_keys_core_fnc_vehicleName;
        {
            missionNamespace setVariable [format ["tlb_keys_code_%1", _x], _name, true];
        } forEach (_subject getVariable ["tlb_keys_codes", []]);

        [format [localize "STR_tlb_keys_core_msg_renamed", _name]] call tlb_keys_core_fnc_notify;
    };
    case "code": {
        missionNamespace setVariable [format ["tlb_keys_code_%1", _subject], _text, true];
        [format [localize "STR_tlb_keys_core_msg_labelled", (str (10000 + _subject)) select [1], _text]] call tlb_keys_core_fnc_notify;
    };
};
