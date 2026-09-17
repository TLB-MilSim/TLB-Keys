#include "..\script_component.hpp"
/*
 * Author: TLB
 * Puts keys back where they came from after fn_cutKey or fn_takeKey took every
 * key of a class out to change one of them.
 *
 * Each key goes back into the same uniform, vest or backpack with its cut.
 * Cargo commands do not check the container's load, so a key that was already
 * carried always fits back in, and never ends up on the ground.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Key class <STRING>
 * 2: Keys, as [code, location] where location is magazinesAmmoFull's
 *    "Uniform", "Vest" or "Backpack" <ARRAY>
 *
 * Return Value:
 * None
 */

params ["_unit", "_class", "_keys"];

{
    _x params ["_code", "_location"];

    private _container = switch (_location) do {
        case "Uniform": { uniformContainer _unit };
        case "Vest": { vestContainer _unit };
        case "Backpack": { backpackContainer _unit };
        default { objNull };
    };

    if (isNull _container) then {
        [_unit, _class, _code, true] call tlb_keys_core_fnc_giveKey;
    } else {
        _container addMagazineAmmoCargo [_class, 1, _code];
    };
} forEach _keys;

_unit setVariable ["tlb_keys_core_keyCache", nil];
