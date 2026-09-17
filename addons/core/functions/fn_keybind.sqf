#include "..\script_component.hpp"
/*
 * Author: TLB
 * A TLB Keys key binding was pressed: lock or unlock a vehicle without opening
 * the ACE menu.
 *
 *   slot 0     "Lock/unlock nearest vehicle", with any key carried. In a seat:
 *              the vehicle you are in. Outside: the nearest vehicle your keys
 *              open, within key reach of its side, or within key fob range
 *              when a fob is programmed to it.
 *   slot 1-3   the same, with only the key bound to that slot (fn_bindKey).
 *
 * A fob locks and unlocks instantly with a chirp; a key by hand takes the lock
 * and unlock time.
 *
 * Arguments:
 * 0: Slot, 0 for any key <NUMBER>
 *
 * Return Value:
 * Handled, so the key press is used up <BOOL>
 */

params [["_slot", 0]];

if (!tlb_keys_core_enabled || {!tlb_keys_core_allowKeybinds}) exitWith { false };

private _unit = ACE_player;
if (!alive _unit) exitWith { false };

private _keys = [_unit] call tlb_keys_core_fnc_keys;
private _bound = [];

if (_slot > 0) then {
    _bound = tlb_keys_core_slots param [_slot - 1, []];
    _keys = _keys select {[_x select 0, _x select 3] isEqualTo _bound};
};

// --- In a seat: the vehicle you are in -------------------------------------------
private _parent = objectParent _unit;

if (_slot == 0 && {!isNull _parent}) exitWith {
    if !([_parent] call tlb_keys_core_fnc_isKeyed) exitWith { false };
    if ((_parent getVariable ["tlb_keys_mode", MODE_NONE]) == MODE_NONE && {(locked _parent) in [0, 1]}) exitWith { false };

    if (([_unit, _parent] call tlb_keys_core_fnc_getAccess) == ACCESS_NONE && {!tlb_keys_core_insideUnlock}) exitWith {
        [localize "STR_tlb_keys_core_msg_noFit"] call tlb_keys_core_fnc_notify;
        true
    };

    [_unit, _parent, (locked _parent) in [0, 1]] call tlb_keys_core_fnc_toggleLock;
    true
};

if (_slot > 0 && {_bound isEqualTo []}) exitWith {
    [format [localize "STR_tlb_keys_core_msg_slotEmpty", _slot]] call tlb_keys_core_fnc_notify;
    true
};

if (_keys isEqualTo []) exitWith {
    private _text = if (_slot > 0) then {
        format [localize "STR_tlb_keys_core_msg_slotMissing", _slot, _bound call tlb_keys_core_fnc_keyName]
    } else {
        localize "STR_tlb_keys_core_msg_noKeys"
    };
    [_text] call tlb_keys_core_fnc_notify;
    true
};

// --- Outside: the nearest vehicle these keys open ---------------------------------
private _fobCodes = if (tlb_keys_core_allowFobs) then {
    (_keys select {(_x select 1) == "fob" && {(_x select 3) != KEY_BLANK}}) apply {_x select 3}
} else {
    []
};
private _maxReach = [tlb_keys_core_keyRange, tlb_keys_core_keyRange max tlb_keys_core_fobRange] select (_fobCodes isNotEqualTo []);

private _best = objNull;
private _bestDistance = 1e9;
private _bestByFob = false;

{
    private _veh = _x;
    if (
        alive _veh
        && {[_veh] call tlb_keys_core_fnc_isKeyed}
        && {(_veh getVariable ["tlb_keys_mode", MODE_NONE]) != MODE_NONE || {(locked _veh) in [2, 3]}}
        && {([_unit, _veh, _keys] call tlb_keys_core_fnc_getAccess) > ACCESS_NONE}
    ) then {
        // Measured from roughly the vehicle's side, so a long truck is reached
        // from its door as easily as a quad bike.
        private _distance = (_unit distance _veh) - ((boundingBoxReal _veh) select 2) * 0.5;
        private _byFob = ((_veh getVariable ["tlb_keys_codes", []]) arrayIntersect _fobCodes) isNotEqualTo [];
        private _reach = [tlb_keys_core_keyRange, _maxReach] select _byFob;

        if (_distance <= _reach && {_distance < _bestDistance}) then {
            _best = _veh;
            _bestDistance = _distance;
            _bestByFob = _byFob;
        };
    };
} forEach (_unit nearEntities [["LandVehicle", "Air", "Ship"], _maxReach + 15]);

if (isNull _best) exitWith {
    [localize "STR_tlb_keys_core_msg_nothingInReach"] call tlb_keys_core_fnc_notify;
    true
};

[_unit, _best, (locked _best) in [0, 1], _bestByFob] call tlb_keys_core_fnc_toggleLock;

true
