#include "..\script_component.hpp"
/*
 * Author: TLB
 * A unit locks or unlocks a vehicle: by hand at the vehicle (an ACE progress
 * bar when "Lock and unlock time" is set), from inside, or from a distance with
 * a key fob (instant, with a chirp).
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Vehicle <OBJECT>
 * 2: Lock <BOOL>
 * 3: With a key fob <BOOL> (default: false)
 *
 * Return Value:
 * None
 */

params ["_unit", "_veh", "_lock", ["_remote", false]];

private _done = {
    params ["_unit", "_veh", "_lock", "_remote"];

    [_veh, _lock] call tlb_keys_core_fnc_setLock;

    // Locking with a key puts an end to a hotwire.
    if (_lock) then {
        _veh setVariable ["tlb_keys_hotwired", nil, true];
    };

    if (_remote) then {
        if (tlb_keys_core_fobSound) then {
            ["tlb_keys_core_chirp", [_veh, _lock]] call CBA_fnc_globalEvent;
        };
    } else {
        playSound "ACE_Sound_Click";
    };

    [format [localize (["STR_tlb_keys_core_msg_unlocked", "STR_tlb_keys_core_msg_locked"] select _lock), [_veh] call tlb_keys_core_fnc_vehicleName]] call tlb_keys_core_fnc_notify;
};

if (_remote || {tlb_keys_core_lockTime <= 0} || {!isNull objectParent _unit}) exitWith {
    [_unit, _veh, _lock, _remote] call _done;
};

[
    tlb_keys_core_lockTime,
    [_unit, _veh, _lock, _remote, _done],
    {
        params ["_args"];
        _args params ["_unit", "_veh", "_lock", "_remote", "_done"];
        [_unit, _veh, _lock, _remote] call _done;
    },
    {},
    localize (["STR_tlb_keys_core_progress_unlocking", "STR_tlb_keys_core_progress_locking"] select _lock),
    {
        params ["_args"];
        _args params ["_unit", "_veh"];
        alive _veh && {(_unit distance _veh) < 8}
    },
    ["isNotInside", "isNotSwimming"]
] call ace_common_fnc_progressBar;
