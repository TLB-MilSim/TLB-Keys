#include "..\script_component.hpp"
/*
 * Author: TLB
 * Whether a unit is in, or leads, the squad a vehicle is locked for.
 *
 * The squad is the owner's group when the vehicle was locked, or - with "Squad
 * follows the owner" - whatever group the owner is in now, falling back to the
 * stored group while the owner is not on the server.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Vehicle <OBJECT>
 * 2: Leader only <BOOL> (default: false)
 *
 * Return Value:
 * In the squad (or leading it) <BOOL>
 */

params ["_unit", "_veh", ["_leaderOnly", false]];

private _group = _veh getVariable ["tlb_keys_group", grpNull];

if (tlb_keys_core_squadFollowsOwner == 1) then {
    private _uid = _veh getVariable ["tlb_keys_owner", ""];
    if (_uid != "" && {_uid != OWNER_MASTER}) then {
        private _players = allPlayers;
        private _index = _players findIf {getPlayerUID _x == _uid};
        if (_index != -1) then {
            _group = group (_players select _index);
        };
    };
};

if (isNull _group) exitWith { false };

if (_leaderOnly) exitWith { leader _group == _unit };

group _unit == _group
