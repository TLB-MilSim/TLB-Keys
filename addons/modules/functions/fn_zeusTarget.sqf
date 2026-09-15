#include "..\script_component.hpp"
/*
 * Author: TLB
 * The object a Zeus module was placed on, and the module deleted - it has
 * done its job the moment it is placed.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 *
 * Return Value:
 * Object, or objNull when placed on nothing <OBJECT>
 */

params ["_logic"];

private _mouseOver = missionNamespace getVariable ["bis_fnc_curatorObjectPlaced_mouseOver", [""]];
private _object = [objNull, _mouseOver param [1, objNull]] select ((_mouseOver select 0) == "OBJECT");

deleteVehicle _logic;

_object
