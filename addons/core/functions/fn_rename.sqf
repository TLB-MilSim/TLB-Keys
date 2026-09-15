#include "..\script_component.hpp"
/*
 * Author: TLB
 * Opens the small naming dialog for a vehicle or for a key code. The name is
 * applied by fn_renameClose when the dialog closes with OK.
 *
 * A key's label belongs to its code, so every copy of that key shows it.
 * Naming a vehicle also labels its codes, so its keys read as the vehicle.
 *
 * Arguments:
 * 0: "vehicle" or "code" <STRING>
 * 1: Vehicle <OBJECT> or code <NUMBER>
 *
 * Return Value:
 * None
 */

params ["_kind", "_subject"];

private _current = if (_kind == "vehicle") then {
    [_subject] call tlb_keys_core_fnc_vehicleName
} else {
    missionNamespace getVariable [format ["tlb_keys_code_%1", _subject], ""]
};

uiNamespace setVariable ["tlb_keys_core_renameTarget", [_kind, _subject]];

if (!createDialog "tlb_keys_RscRename") exitWith {};

private _display = uiNamespace getVariable ["tlb_keys_core_renameDisplay", displayNull];
if (isNull _display) exitWith {};

(_display displayCtrl IDC_RENAME_TITLE) ctrlSetText localize (["STR_tlb_keys_core_rename_code", "STR_tlb_keys_core_rename_vehicle"] select (_kind == "vehicle"));

private _edit = _display displayCtrl IDC_RENAME_EDIT;
_edit ctrlSetText _current;
ctrlSetFocus _edit;
