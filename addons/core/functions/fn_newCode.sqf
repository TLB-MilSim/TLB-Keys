#include "..\script_component.hpp"
/*
 * Author: TLB
 * A lock code nobody else is using, reserved for the whole mission.
 *
 * Each code in use has a public tlb_keys_code_N variable holding its label, so
 * a JIP player's keys are named and a new code never repeats an old one while
 * there are free codes left.
 *
 * Arguments:
 * 0: Label for the code <STRING> (default: "")
 *
 * Return Value:
 * Code, 1 to KEY_CODE_MAX <NUMBER>
 */

params [["_label", ""]];

private _code = 0;

for "_i" from 1 to 200 do {
    private _try = 1 + floor random KEY_CODE_MAX;
    if (isNil {missionNamespace getVariable format ["tlb_keys_code_%1", _try]}) exitWith {
        _code = _try;
    };
};

// Two hundred misses means the codes are close to used up; share one rather
// than fail.
if (_code == 0) then {
    _code = 1 + floor random KEY_CODE_MAX;
};

missionNamespace setVariable [format ["tlb_keys_code_%1", _code], _label, true];

_code
