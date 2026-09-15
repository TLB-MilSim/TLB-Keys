#include "..\script_component.hpp"
/*
 * Author: TLB
 * Puts a key in a unit's inventory, or on the ground at its feet when there is
 * no room. Runs where the unit is local.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Key class <STRING>
 * 2: Code <NUMBER> (default: KEY_BLANK)
 * 3: Silent <BOOL> (default: false)
 * 4: Name of whoever handed it over <STRING> (default: "")
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, "tlb_keys_fob", 1234] call tlb_keys_core_fnc_giveKey
 */

params [["_unit", objNull, [objNull]], ["_class", "", [""]], ["_code", KEY_BLANK, [0]], ["_silent", false, [true]], ["_from", "", [""]]];

if (isNull _unit || {_class == ""}) exitWith {};

if (!local _unit) exitWith {
    ["tlb_keys_core_giveKey", [_unit, _class, _code, _silent, _from], _unit] call CBA_fnc_targetEvent;
};

private _name = [_class, _code] call tlb_keys_core_fnc_keyName;

if (_unit canAdd [_class, 1]) then {
    _unit addMagazine [_class, _code];

    if (!_silent) then {
        private _text = if (_from == "") then {
            format [localize "STR_tlb_keys_core_msg_received", _name]
        } else {
            format [localize "STR_tlb_keys_core_msg_receivedFrom", _name, _from]
        };
        [_text] call tlb_keys_core_fnc_notify;
    };
} else {
    private _holder = createVehicle ["GroundWeaponHolder", getPosATL _unit, [], 0, "CAN_COLLIDE"];
    _holder addMagazineAmmoCargo [_class, 1, _code];

    if (isPlayer _unit) then {
        [format [localize "STR_tlb_keys_core_msg_noRoom", _name]] call tlb_keys_core_fnc_notify;
    };
};

_unit setVariable ["tlb_keys_core_keyCache", nil];
