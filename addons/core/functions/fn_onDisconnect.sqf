#include "..\script_component.hpp"
/*
 * Author: TLB
 * "Owner leaves": when a player has been off the server for the set number of
 * minutes, their vehicles lose their owner. The locks stay as they are, and
 * anyone whose keys fit may manage them from then on.
 *
 * Runs on the server from the PlayerDisconnected mission event.
 *
 * Arguments:
 * 0: Id <NUMBER>
 * 1: UID <STRING>
 *
 * Return Value:
 * None
 */

params ["", ["_uid", ""]];

if (tlb_keys_core_ownerTimeout <= 0 || {_uid == ""}) exitWith {};

[{
    params ["_uid"];

    if ((allPlayers findIf {getPlayerUID _x == _uid}) != -1) exitWith {};

    {
        if ((_x getVariable ["tlb_keys_owner", ""]) == _uid) then {
            _x setVariable ["tlb_keys_owner", "", true];
            _x setVariable ["tlb_keys_ownerName", "", true];
        };
    } forEach vehicles;
}, [_uid], tlb_keys_core_ownerTimeout * 60] call CBA_fnc_waitAndExecute;
