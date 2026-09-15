#include "..\script_component.hpp"
/*
 * Author: TLB
 * A vehicle's label, or its display name when nobody has named it.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * Name <STRING>
 */

params ["_veh"];

private _label = _veh getVariable ["tlb_keys_label", ""];

if (_label != "") exitWith { _label };

getText (configOf _veh >> "displayName")
