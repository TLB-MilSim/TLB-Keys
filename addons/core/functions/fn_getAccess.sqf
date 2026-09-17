#include "..\script_component.hpp"
/*
 * Author: TLB
 * What a unit may do with a vehicle, going by the keys it carries.
 *
 *   master key   manages every vehicle of its side, however it is locked
 *   cut key/fob  opens any vehicle that accepts its code, in any mode
 *   blank key    opens its side's vehicles locked for the side, and for the
 *                squad when the unit is in the vehicle's squad
 *
 * Opening a vehicle lets a unit lock, unlock and drive it. Managing it also
 * depends on who owns it and the "Who may manage" setting.
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Vehicle <OBJECT>
 * 2: Only these keys, as fn_keys returns them <ARRAY> (default: every key carried)
 *
 * Return Value:
 * ACCESS_NONE, ACCESS_USE or ACCESS_MANAGE <NUMBER>
 */

params [["_unit", objNull, [objNull]], ["_veh", objNull, [objNull]], "_onlyKeys"];

if (isNull _unit || {isNull _veh} || {!tlb_keys_core_enabled}) exitWith { ACCESS_NONE };

private _keys = if (isNil "_onlyKeys") then { [_unit] call tlb_keys_core_fnc_keys } else { _onlyKeys };
private _mode = _veh getVariable ["tlb_keys_mode", MODE_NONE];
private _side = _veh getVariable ["tlb_keys_side", -1];

// ACE's master key has no side and opens everything; so does any master key on
// a vehicle nobody has given a side yet.
if (tlb_keys_core_masterEnabled && {
    _keys findIf {
        (_x select 1) == "master" && {(_x select 2) == -1 || {_side == -1} || {(_x select 2) == _side}}
    } != -1
}) exitWith { ACCESS_MANAGE };

if (_mode == MODE_NONE) exitWith { ACCESS_NONE };

private _codes = _veh getVariable ["tlb_keys_codes", []];

private _use = _keys findIf {
    (_x select 1) != "master" && {(_x select 3) != KEY_BLANK} && {(_x select 3) in _codes}
} != -1;

if (!_use && {_mode != MODE_PAIRED}) then {
    private _fits = _keys findIf {
        (_x select 1) == "key"
        && {(_x select 2) == _side}
        && {(_x select 3) == KEY_BLANK || {tlb_keys_core_pairedAsSide}}
    } != -1;

    _use = _fits && {_mode == MODE_SIDE || {[_unit, _veh] call tlb_keys_core_fnc_inSquad}};
};

if (!_use) exitWith { ACCESS_NONE };

private _owner = _veh getVariable ["tlb_keys_owner", ""];

private _manage = switch (true) do {
    case (_owner == OWNER_MASTER): { false };
    case (_owner == ""): { true };
    case (_owner == getPlayerUID _unit): { true };
    case (tlb_keys_core_managePerms == 2): { true };
    case (tlb_keys_core_managePerms == 1): { [_unit, _veh, true] call tlb_keys_core_fnc_inSquad };
    default { false };
};

[ACCESS_USE, ACCESS_MANAGE] select _manage
