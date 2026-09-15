#include "..\script_component.hpp"
/*
 * Author: TLB
 * Hands one key to another unit, so nobody has to open each other's inventory.
 *
 * Arguments:
 * 0: Unit giving the key <OBJECT>
 * 1: Unit receiving it <OBJECT>
 * 2: Key class <STRING>
 * 3: Code <NUMBER>
 *
 * Return Value:
 * None
 */

params ["_unit", "_target", "_class", "_code"];

if (!tlb_keys_core_allowHandOver || {!alive _target} || {(_unit distance _target) > 5}) exitWith {};

if !([_unit, _class, _code] call tlb_keys_core_fnc_takeKey) exitWith {};

[_target, _class, _code, false, name _unit] call tlb_keys_core_fnc_giveKey;

[format [localize "STR_tlb_keys_core_msg_handed", [_class, _code] call tlb_keys_core_fnc_keyName, name _target]] call tlb_keys_core_fnc_notify;
