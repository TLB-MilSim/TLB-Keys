#include "..\script_component.hpp"
/*
 * Author: TLB
 * Name of a side number (BIS_fnc_sideID: 0 OPFOR, 1 BLUFOR, 2 Independent,
 * 3 Civilian).
 *
 * Arguments:
 * 0: Side number <NUMBER>
 *
 * Return Value:
 * Name <STRING>
 */

params ["_side"];

if (_side < 0 || {_side > 3}) exitWith { localize "STR_tlb_keys_core_side_none" };

localize format ["STR_tlb_keys_core_side_%1", _side]
