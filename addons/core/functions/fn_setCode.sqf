#include "..\script_component.hpp"
/*
 * Author: TLB
 * The code of a named key set, created the first time the name is used.
 *
 * Key Set modules and the vehicle attribute "Key set" share keys through this:
 * every vehicle and key that names the same set gets the same code.
 *
 * Arguments:
 * 0: Key set name <STRING>
 * 1: Label for the code when it is created <STRING> (default: the name)
 *
 * Return Value:
 * Code <NUMBER>
 */

params ["_name", ["_label", ""]];

private _var = "tlb_keys_set_" + ((toLower _name) regexReplace ["[^a-z0-9_]", "_"]);
private _code = missionNamespace getVariable [_var, 0];

if (_code == 0) then {
    _code = [[_label, _name] select (_label == "")] call tlb_keys_core_fnc_newCode;
    missionNamespace setVariable [_var, _code, true];
};

_code
