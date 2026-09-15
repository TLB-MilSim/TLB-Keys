#include "..\script_component.hpp"
/*
 * Author: TLB
 * Gives back the keys a module handed out (tlb_keys_respawnKeys) after respawn.
 * A respawn loadout usually restores them already - keys keep their cut in a
 * saved loadout - so only the ones still missing are added.
 *
 * Arguments:
 * 0: New unit <OBJECT>
 * 1: Corpse <OBJECT>
 *
 * Return Value:
 * None
 */

params ["_unit", "_corpse"];

if (!local _unit || {isNull _corpse}) exitWith {};

private _keys = _corpse getVariable ["tlb_keys_respawnKeys", []];
if (_keys isEqualTo []) exitWith {};

_unit setVariable ["tlb_keys_respawnKeys", _keys, true];

// Give respawn templates and loadout scripts time to dress the unit first.
[{
    params ["_unit", "_keys"];

    if (!alive _unit) exitWith {};

    private _have = (magazinesAmmoFull _unit) apply {[_x select 0, _x select 1]};
    {
        _x params ["_class", "_code"];
        private _index = _have find [_class, _code];
        if (_index == -1) then {
            [_unit, _class, _code, true] call tlb_keys_core_fnc_giveKey;
        } else {
            _have deleteAt _index;
        };
    } forEach _keys;
}, [_unit, _keys], 3] call CBA_fnc_waitAndExecute;
