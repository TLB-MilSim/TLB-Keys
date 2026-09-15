#include "..\script_component.hpp"
/*
 * Author: TLB
 * Every key a unit carries.
 *
 * Keys are magazines whose round count is their cut (see items\config.cpp).
 * ACE's side and master keys count as blank side keys and as a master key for
 * every side while "Accept ACE keys" is on.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 *
 * Return Value:
 * [[class, type, side, code], ...] <ARRAY>
 *   type is "key", "master" or "fob"; side is 0-3, or -1 for none; code is
 *   KEY_BLANK for a blank key
 */

params [["_unit", objNull, [objNull]]];

if (isNull _unit) exitWith { [] };

// ACE menu conditions ask several times per frame, and the inventory cannot
// change in between.
private _cache = _unit getVariable ["tlb_keys_core_keyCache", [-1, []]];
if ((_cache select 0) == diag_frameNo) exitWith { _cache select 1 };

private _keys = [];

{
    _x params ["_class", "_ammo"];

    private _info = tlb_keys_core_typeCache get _class;
    if (isNil "_info") then {
        private _cfg = configFile >> "CfgMagazines" >> _class;
        private _type = getText (_cfg >> "tlb_keys_type");
        _info = [[], [_type, getNumber (_cfg >> "tlb_keys_side")]] select (_type != "");
        tlb_keys_core_typeCache set [_class, _info];
    };

    if (_info isNotEqualTo []) then {
        _keys pushBack [_class, _info select 0, _info select 1, _ammo];
    };
} forEach magazinesAmmoFull _unit;

if (tlb_keys_core_acceptAceKeys) then {
    {
        private _info = tlb_keys_core_aceKeys get _x;
        if (!isNil "_info") then {
            _keys pushBack [_x, _info select 0, _info select 1, KEY_BLANK];
        };
    } forEach ((items _unit) arrayIntersect (keys tlb_keys_core_aceKeys));
};

_unit setVariable ["tlb_keys_core_keyCache", [diag_frameNo, _keys]];

_keys
