#include "..\script_component.hpp"
/*
 * Author: TLB
 * The ways the player can pick a locked vehicle's lock.
 *
 * Every picking tool the loaded mods provide is offered, so picking works
 * whatever the mod set, and nobody needs a second kit for the same job:
 *
 *   TSP Breach's kit and paperclip      "Use TSP Breach's lock pick kits"
 *   TLB Interactions' kit and paperclip "Use TLB Interactions' lock pick kits"
 *   our own Lock Pick Kit               always; hidden from the Arsenal while
 *                                       either of those mods is loaded
 *   ACE's lockpick                      always
 *
 * With TLB Interactions loaded, the tools open its lockpicking board; without
 * it, a progress bar. Whether its board handles vehicles at all is TLB
 * Interactions' own setting (tlbi_lockpick_vehicles).
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Player <OBJECT>
 *
 * Return Value:
 * ACE child actions, empty when the player cannot pick it <ARRAY>
 */

params ["_veh", "_unit"];

if (!tlb_keys_core_lockpickEnabled || {!(_veh getVariable ["tlb_keys_pickable", true])}) exitWith { [] };
if ((_veh getVariable ["ace_vehiclelock_lockpickStrength", tlb_keys_core_lockpickTime]) < 0) exitWith { [] };

private _board = !isNil "tlbi_lockpick_fnc_start"
    && {missionNamespace getVariable ["tlbi_lockpick_enabled", true]}
    && {missionNamespace getVariable ["tlbi_lockpick_vehicles", true]};

private _items = _unit call ace_common_fnc_uniqueItems;
private _actions = [];

private _statement = {
    params ["_veh", "_unit", "_params"];
    _params params ["_method", "_item"];
    [_unit, _veh, _method, _item] call tlb_keys_core_fnc_pick;
};

// [class, TLB Interactions tool (0 kit, 1 paperclip), allowed by settings]
{
    _x params ["_class", "_tool", "_allowed"];

    if (_allowed && {_class in _items}) then {
        // On the board the tool decides how it is picked; otherwise it is a
        // progress bar either way.
        private _method = [2, _tool] select _board;

        _actions pushBack [
            [
                format ["pick%1", count _actions],
                format [localize "STR_tlb_keys_core_action_pickWith", getText (configFile >> "CfgWeapons" >> _class >> "displayName")],
                ICON_PICK, _statement, {true}, {}, [_method, _class]
            ] call ace_interact_menu_fnc_createAction,
            [],
            _veh
        ];
    };
} forEach [
    ["tsp_lockpick", 0, tlb_keys_core_useTsp],
    ["tsp_paperclip", 1, tlb_keys_core_useTsp],
    ["tlbi_lockpickKit", 0, tlb_keys_core_useTlbiItems],
    ["tlbi_paperclip", 1, tlb_keys_core_useTlbiItems],
    ["tlb_keys_lockpick", 0, true],
    ["ACE_key_lockpick", 0, true]
];

_actions
