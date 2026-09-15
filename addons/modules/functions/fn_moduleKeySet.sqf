#include "..\script_component.hpp"
/*
 * Author: TLB
 * Key Set module: one set of keys for everything synced to it.
 *
 *   vehicles  take the set's mode, side and code, and start locked or not
 *   crates    get the set number of keys (and/or fobs) cut to the code
 *   units     get one key (and/or fob) each, again after respawn if set
 *
 * Two Key Set modules with the same name share one code, and so does a
 * vehicle whose "Key set" attribute names it.
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

private _name = _logic getVariable ["Name", ""];
private _mode = _logic getVariable ["Mode", MODE_PAIRED];
private _side = _logic getVariable ["Side", -1];
private _manage = _logic getVariable ["Manage", 0];
private _locked = _logic getVariable ["Locked", true];
private _keyType = _logic getVariable ["KeyType", 0];
private _crateKeys = round (_logic getVariable ["CrateKeys", 4]);
private _wholeGroup = _logic getVariable ["WholeGroup", false];
private _respawn = _logic getVariable ["Respawn", true];

private _synced = synchronizedObjects _logic;
private _men = _synced select {_x isKindOf "CAManBase"};
private _vehicles = _synced select {
    (_x isKindOf "LandVehicle" || {_x isKindOf "Air"} || {_x isKindOf "Ship"}) && {!(_x isKindOf "StaticWeapon")}
};
private _crates = _synced select {
    !(_x isKindOf "CAManBase") && {!(_x in _vehicles)} && {!(_x isKindOf "Logic")} && {!(_x isKindOf "EmptyDetector")}
};

// Auto: the side of the first synced unit, else the first vehicle's faction.
if (_side == -1) then {
    if (_men isNotEqualTo []) then {
        _side = [east, west, independent, civilian] find (side group (_men select 0));
    };
    if (_side == -1 && {_vehicles isNotEqualTo []}) then {
        _side = getNumber (configOf (_vehicles select 0) >> "side");
    };
    if (_side < 0 || {_side > 3}) then { _side = 1 };
};

private _label = _name;
if (_label == "" && {_vehicles isNotEqualTo []}) then {
    _label = [_vehicles select 0] call tlb_keys_core_fnc_vehicleName;
};

private _code = if (_name != "") then {
    [_name] call tlb_keys_core_fnc_setCode
} else {
    [_label] call tlb_keys_core_fnc_newCode
};

private _group = [grpNull, group (_men param [0, objNull])] select (_men isNotEqualTo []);
private _owner = [OWNER_MASTER, ""] select (_manage == 1);

{
    // A vehicle in two sets opens for both.
    private _codes = +(_x getVariable ["tlb_keys_codes", []]);
    _codes pushBackUnique _code;
    [_x, _mode, _side, _group, _owner, "", _codes, "", _locked] call tlb_keys_core_fnc_assign;
} forEach _vehicles;

private _classes = [];
if (_keyType in [0, 2]) then { _classes pushBack (tlb_keys_core_keyClasses select _side) };
if (_keyType in [1, 2]) then { _classes pushBack "tlb_keys_fob" };

if (_crateKeys > 0) then {
    {
        private _crate = _x;
        {
            _crate addMagazineAmmoCargo [_x, _crateKeys, _code];
        } forEach _classes;
    } forEach _crates;
};

tlb_keys_modules_nextId = (missionNamespace getVariable ["tlb_keys_modules_nextId", 0]) + 1;

_logic setVariable ["tlb_keys_id", str tlb_keys_modules_nextId, true];
_logic setVariable ["tlb_keys_give", [_classes apply {[_x, _code]}, _respawn, _wholeGroup], true];
_logic setVariable ["tlb_keys_ready", true, true];

diag_log text format ["[TLB Keys] Key Set '%1': code %2, %3 vehicles, %4 crates, %5 units", _label, _code, count _vehicles, count _crates, count _men];
