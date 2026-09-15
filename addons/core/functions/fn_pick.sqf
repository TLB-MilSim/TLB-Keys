#include "..\script_component.hpp"
/*
 * Author: TLB
 * Starts picking a vehicle's lock.
 *
 * TLB Interactions' board is built for doors: it rolls the lock from a building
 * and walks away when the player strays 4 m from the door. A vehicle's centre
 * can be further than that from where the player stands, so the board is given
 * an invisible local helpad at the player's feet as its "building", and the
 * helper is deleted when the board closes.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Vehicle <OBJECT>
 * 2: Method: 0 kit, 1 paperclip (TLB Interactions), 2 ACE lockpick <NUMBER>
 * 3: Item used <STRING>
 *
 * Return Value:
 * None
 */

params ["_unit", "_veh", "_method", ["_item", ""]];

if ((locked _veh) in [0, 1]) exitWith {};

if (_method < 2) exitWith {
    private _helper = "Land_HelipadEmpty_F" createVehicleLocal [0, 0, 0];
    _helper setPosASL getPosASL _unit;

    private _opened = [
        _unit, _helper, "tlb_keys_vehicle", _method, _item,
        {
            params ["_veh", "_unit"];
            [_veh, _unit] call tlb_keys_core_fnc_picked;
        },
        [_veh, _unit]
    ] call tlbi_lockpick_fnc_start;

    if (!_opened) exitWith { deleteVehicle _helper };

    [
        { isNull (uiNamespace getVariable ["tlbi_lockpick_display", displayNull]) },
        { deleteVehicle _this },
        _helper
    ] call CBA_fnc_waitUntilAndExecute;
};

private _time = _veh getVariable ["ace_vehiclelock_lockpickStrength", tlb_keys_core_lockpickTime];
if (_time < 0) exitWith {};

[
    _time max 1,
    [_unit, _veh],
    {
        params ["_args"];
        _args params ["_unit", "_veh"];
        [_veh, _unit] call tlb_keys_core_fnc_picked;
    },
    {},
    localize "STR_tlb_keys_core_progress_picking",
    {
        params ["_args"];
        _args params ["_unit", "_veh"];
        alive _veh && {(_unit distance _veh) < 6} && {speed _veh < 1}
    },
    ["isNotSwimming"]
] call ace_common_fnc_progressBar;
