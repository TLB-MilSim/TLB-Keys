#include "..\script_component.hpp"
/*
 * Author: TLB
 * Binds a key to one of the three key slots, or clears a slot. The slot's key
 * binding then locks and unlocks the nearest vehicle that key opens.
 *
 * A key sits in one slot at a time. Slots are kept in the player's profile per
 * mission and map, so they survive respawn and reconnecting.
 *
 * Arguments:
 * 0: Slot, 1 to 3 <NUMBER>
 * 1: [class, code] of the key, or [] to clear the slot <ARRAY> (default: [])
 *
 * Return Value:
 * None
 */

params ["_slot", ["_key", []]];

if (_slot < 1 || {_slot > 3}) exitWith {};

if (_key isNotEqualTo []) then {
    {
        if (_x isEqualTo _key) then { tlb_keys_core_slots set [_forEachIndex, []] };
    } forEach tlb_keys_core_slots;
};

tlb_keys_core_slots set [_slot - 1, _key];
profileNamespace setVariable [tlb_keys_core_slotsVar, +tlb_keys_core_slots];

private _text = if (_key isEqualTo []) then {
    format [localize "STR_tlb_keys_core_msg_unbound", _slot]
} else {
    format [localize "STR_tlb_keys_core_msg_bound", _key call tlb_keys_core_fnc_keyName, _slot]
};

[_text] call tlb_keys_core_fnc_notify;
