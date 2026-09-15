#include "..\script_component.hpp"
/*
 * Author: TLB
 * "Master keys in the Arsenal" off: takes the master keys out of the ACE
 * Arsenal's item lists as it opens, before any list is filled. Zeus still sees
 * them, and so does anyone already carrying one, so the Arsenal never strips a
 * master key a module or Zeus handed out.
 *
 * Runs from ace_arsenal_displayOpened.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 */

if (tlb_keys_core_masterInArsenal) exitWith {};
if (!isNull (getAssignedCuratorLogic player)) exitWith {};
if ((([ACE_player] call tlb_keys_core_fnc_keys) findIf {(_x select 1) == "master"}) != -1) exitWith {};

private _masters = tlb_keys_core_masterClasses;

private _fnc_strip = {
    params ["_value"];

    if (_value isEqualType createHashMap) exitWith {
        { _value deleteAt _x } forEach _masters;
        { [_y] call _fnc_strip } forEach _value;
    };

    if (_value isEqualType []) then {
        for "_i" from (count _value - 1) to 0 step -1 do {
            private _entry = _value select _i;
            if (_entry isEqualType "") then {
                if (_entry in _masters) then { _value deleteAt _i };
            } else {
                [_entry] call _fnc_strip;
            };
        };
    };
};

{
    private _list = missionNamespace getVariable _x;
    if (!isNil "_list") then { [_list] call _fnc_strip };
} forEach ["ace_arsenal_virtualItems", "ace_arsenal_virtualItemsFlat", "ace_arsenal_virtualItemsFlatAll"];
