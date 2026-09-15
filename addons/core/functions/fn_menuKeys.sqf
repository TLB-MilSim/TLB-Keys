#include "..\script_component.hpp"
/*
 * Author: TLB
 * The player's own "Vehicle Keys" menu (ACE self-interaction): key fob buttons
 * for paired vehicles in range, then every key carried, one entry per key and
 * code.
 *
 * Arguments:
 * 0: Player <OBJECT>
 *
 * Return Value:
 * ACE child actions <ARRAY>
 */

params ["_unit"];

private _actions = [];
private _keys = [_unit] call tlb_keys_core_fnc_keys;

// --- Key fob ----------------------------------------------------------------
if (tlb_keys_core_allowFobs) then {
    private _fobCodes = (_keys select {(_x select 1) == "fob" && {(_x select 3) != KEY_BLANK}}) apply {_x select 3};

    if (_fobCodes isNotEqualTo []) then {
        {
            private _veh = _x;
            if (alive _veh && {((_veh getVariable ["tlb_keys_codes", []]) arrayIntersect _fobCodes) isNotEqualTo []}) then {
                private _lock = (locked _veh) in [0, 1];
                _actions pushBack [
                    [
                        format ["fob%1", _forEachIndex],
                        format [
                            localize (["STR_tlb_keys_core_action_fobUnlock", "STR_tlb_keys_core_action_fobLock"] select _lock),
                            [_veh] call tlb_keys_core_fnc_vehicleName,
                            round (_unit distance _veh)
                        ],
                        [ICON_UNLOCK, ICON_LOCK] select _lock,
                        {
                            params ["_unit", "", "_params"];
                            _params params ["_veh"];
                            if ((_unit distance _veh) > tlb_keys_core_fobRange + 5) exitWith {};
                            [_unit, _veh, (locked _veh) in [0, 1], true] call tlb_keys_core_fnc_toggleLock;
                        },
                        {true}, {}, [_veh]
                    ] call ace_interact_menu_fnc_createAction,
                    [],
                    _unit
                ];
            };
        } forEach (_unit nearEntities [["LandVehicle", "Air", "Ship"], tlb_keys_core_fobRange]);
    };
};

// --- Keys carried -----------------------------------------------------------
private _counts = createHashMap;
private _unique = [];

{
    _x params ["_class", "", "", "_code"];
    private _id = format ["%1:%2", _class, _code];
    if (_id in _counts) then {
        _counts set [_id, (_counts get _id) + 1];
    } else {
        _counts set [_id, 1];
        _unique pushBack _x;
    };
} forEach _keys;

{
    _x params ["_class", "_type", "_side", "_code"];

    private _text = [_class, _code] call tlb_keys_core_fnc_keyName;
    private _count = _counts get format ["%1:%2", _class, _code];
    if (_count > 1) then { _text = format ["%1 (x%2)", _text, _count] };

    private _cfg = configFile >> "CfgMagazines" >> _class;
    if (!isClass _cfg) then { _cfg = configFile >> "CfgWeapons" >> _class };

    _actions pushBack [
        [
            format ["key%1", _forEachIndex], _text, getText (_cfg >> "picture"), {}, {true},
            { _this call tlb_keys_core_fnc_menuKey },
            [_class, _type, _side, _code]
        ] call ace_interact_menu_fnc_createAction,
        [],
        _unit
    ];
} forEach _unique;

_actions
