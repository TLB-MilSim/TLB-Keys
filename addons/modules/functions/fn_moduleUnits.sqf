#include "..\script_component.hpp"
/*
 * Author: TLB
 * The units a key module gives keys to: every unit synced to it, and with
 * "Whole group" every member of their groups.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * Units <ARRAY>
 */

params ["_logic"];

private _wholeGroup = (_logic getVariable ["tlb_keys_give", []]) param [2, false];
private _men = (synchronizedObjects _logic) select {_x isKindOf "CAManBase"};

if (_wholeGroup) then {
    private _all = [];
    { _all append units group _x } forEach _men;
    _men = _all arrayIntersect _all;
};

_men
