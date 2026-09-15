#include "..\script_component.hpp"
/*
 * Author: TLB
 * Shows a short message as an ACE hint, on the machine of the unit it is for.
 *
 * Arguments:
 * 0: Text <STRING>
 * 1: Unit <OBJECT> (default: the local player)
 *
 * Return Value:
 * None
 */

params ["_text", ["_unit", objNull]];

if (!isNull _unit && {!local _unit}) exitWith {
    ["tlb_keys_core_notify", [_text], _unit] call CBA_fnc_targetEvent;
};

if (!hasInterface) exitWith {};

[_text, 1.5, ACE_player] call ace_common_fnc_displayTextStructured;
