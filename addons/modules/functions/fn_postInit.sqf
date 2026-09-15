#include "..\script_component.hpp"
// TLB Keys - Modules: hands out the keys of Key Set and Master Key modules.
// Runs via CfgFunctions postInit, on every machine.
//
// The module functions run on the server, set up vehicles and crates, and store
// what each synced unit gets. Every machine then gives those keys to the synced
// units local to it - the server to its AI, a headless client to its AI, a
// player (JIP included) to themselves - once the module says it is ready. A unit
// is marked when it has its keys, so nobody is given them twice.

diag_log text "[TLB Keys] modules postInit";

[
    { !hasInterface || {!isNull player} },
    {
        {
            [
                { (_this select 0) getVariable ["tlb_keys_ready", false] },
                {
                    params ["_logic"];
                    {
                        if (local _x) then {
                            [_x, _logic] call tlb_keys_modules_fnc_giveModuleKeys;
                        };
                    } forEach ([_logic] call tlb_keys_modules_fnc_moduleUnits);
                },
                [_x],
                300
            ] call CBA_fnc_waitUntilAndExecute;
        } forEach ((allMissionObjects "tlb_keys_moduleKeySet") + (allMissionObjects "tlb_keys_moduleMasterKey"));
    }
] call CBA_fnc_waitUntilAndExecute;
