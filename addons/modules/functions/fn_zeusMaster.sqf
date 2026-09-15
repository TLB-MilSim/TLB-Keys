#include "..\script_component.hpp"
/*
 * Author: TLB
 * Zeus: give the unit the module is placed on a master key for its side.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * None
 */

params ["_logic"];

if (!local _logic) exitWith {};

private _unit = effectiveCommander ([_logic] call tlb_keys_modules_fnc_zeusTarget);

if (isNull _unit || {!(_unit isKindOf "CAManBase")} || {!alive _unit}) exitWith {
    [objNull, localize "STR_tlb_keys_modules_zeus_noUnit"] call BIS_fnc_showCuratorFeedbackMessage;
};

private _side = [east, west, independent, civilian] find (side group _unit);
if (_side == -1) then { _side = 3 };

[_unit, tlb_keys_core_masterClasses select _side, KEY_BLANK] call tlb_keys_core_fnc_giveKey;

[objNull, format [localize "STR_tlb_keys_modules_zeus_master", name _unit]] call BIS_fnc_showCuratorFeedbackMessage;
