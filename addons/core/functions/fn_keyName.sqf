#include "..\script_component.hpp"
/*
 * Author: TLB
 * How a key is named in menus and messages: its item name, then "(blank)" or
 * its code and the label given to that code.
 *
 * Arguments:
 * 0: Key class <STRING>
 * 1: Code <NUMBER> (default: KEY_BLANK)
 *
 * Return Value:
 * Name <STRING>
 */

params ["_class", ["_code", KEY_BLANK]];

private _cfg = configFile >> "CfgMagazines" >> _class;

// ACE's keys are items, and never carry a code.
if (!isClass _cfg) exitWith { getText (configFile >> "CfgWeapons" >> _class >> "displayName") };

private _name = getText (_cfg >> "displayName");

if (getText (_cfg >> "tlb_keys_type") == "master") exitWith { _name };

if (_code == KEY_BLANK) exitWith { format [localize "STR_tlb_keys_core_key_blank", _name] };

private _number = (str (10000 + _code)) select [1];
private _label = missionNamespace getVariable [format ["tlb_keys_code_%1", _code], ""];

if (_label == "") exitWith { format [localize "STR_tlb_keys_core_key_cut", _name, _number] };

format [localize "STR_tlb_keys_core_key_cutLabel", _name, _number, _label]
