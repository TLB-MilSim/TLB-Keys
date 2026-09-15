#include "..\script_component.hpp"
/*
 * Author: TLB
 * Master Key module: every unit synced to it starts with a master key - of its
 * own side, or of the side set on the module.
 *
 * Runs on the server. Units receive their keys from fn_postInit.
 *
 * Arguments:
 * 0: Module logic <OBJECT>
 * 1: Synced units <ARRAY>
 * 2: Activated <BOOL>
 *
 * Return Value:
 * None
 */

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

if (!isServer || {!_activated} || {isNull _logic}) exitWith {};

tlb_keys_modules_nextId = (missionNamespace getVariable ["tlb_keys_modules_nextId", 0]) + 1;

// "#master" is resolved per unit by fn_giveModuleKeys; the number is the side,
// -1 for the unit's own.
_logic setVariable ["tlb_keys_id", str tlb_keys_modules_nextId, true];
_logic setVariable ["tlb_keys_give", [
    [["#master", _logic getVariable ["Side", -1]]],
    _logic getVariable ["Respawn", true],
    _logic getVariable ["WholeGroup", false]
], true];
_logic setVariable ["tlb_keys_ready", true, true];
