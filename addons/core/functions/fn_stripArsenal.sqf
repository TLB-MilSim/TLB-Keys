#include "..\script_component.hpp"
/*
 * Author: TLB
 * Takes items out of the ACE Arsenal's lists as it opens, before any list is
 * filled:
 *
 *   master keys        while "Master keys in the ACE Arsenal" is off, so they
 *                      only come from modules, Zeus or a crate
 *   the spare kit      the lock pick kit that is not in use, so players never
 *                      see two kits for the same job
 *
 * Zeus always sees everything, and nothing is taken away from a player who is
 * already carrying it, so the Arsenal never strips a key or kit out of a
 * loadout.
 *
 * Runs from ace_arsenal_displayOpened.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 */

if (!isNull (getAssignedCuratorLogic player)) exitWith {};

private _hide = [];
private _keys = [ACE_player] call tlb_keys_core_fnc_keys;

if (!tlb_keys_core_masterInArsenal && {(_keys findIf {(_x select 1) == "master"}) == -1}) then {
    _hide append tlb_keys_core_masterClasses;
};

// With TLB Interactions loaded its board owns picking, and our kit is already
// hidden by the items config, so there is nothing to choose between here.
if (isNil "tlbi_lockpick_fnc_start") then {
    private _tsp = isClass (configFile >> "CfgWeapons" >> "tsp_lockpick");

    private _spare = switch (tlb_keys_core_pickKit) do {
        case 1: { ["tlb_keys_lockpick"] };
        case 2: { ["tsp_lockpick", "tsp_paperclip"] };
        default { [["tsp_lockpick", "tsp_paperclip"], ["tlb_keys_lockpick"]] select _tsp };
    };

    private _items = _hide + (ACE_player call ace_common_fnc_uniqueItems);
    _hide append (_spare select {!(_x in _items)});
};

if (_hide isEqualTo []) exitWith {};

private _fnc_strip = {
    params ["_value"];

    if (_value isEqualType createHashMap) exitWith {
        { _value deleteAt _x } forEach _hide;
        { [_y] call _fnc_strip } forEach _value;
    };

    if (_value isEqualType []) then {
        for "_i" from (count _value - 1) to 0 step -1 do {
            private _entry = _value select _i;
            if (_entry isEqualType "") then {
                if (_entry in _hide) then { _value deleteAt _i };
            } else {
                [_entry] call _fnc_strip;
            };
        };
    };
};

{
    private _list = missionNamespace getVariable _x;
    if (!isNil "_list") then { [_list] call _fnc_strip };
} forEach ["ace_arsenal_virtualItems", "ace_arsenal_virtualItemsFlat", "ace_arsenal_virtualItemsFlatAll"];
