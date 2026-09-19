#include "..\script_component.hpp"
// TLB Keys - Core: settings. Runs via CfgFunctions preInit.
//
// Every setting is server-forced (isGlobal 1): the server or the mission
// decides how keys work, so each unit tailors the mod in its own settings file.

diag_log text "[TLB Keys] core preInit";

// Master keys, by side number (BIS_fnc_sideID: 0 OPFOR, 1 BLUFOR, 2 Independent, 3 Civilian).
tlb_keys_core_masterClasses = ["tlb_keys_master_east", "tlb_keys_master_west", "tlb_keys_master_indep", "tlb_keys_master_civ"];
tlb_keys_core_keyClasses = ["tlb_keys_key_east", "tlb_keys_key_west", "tlb_keys_key_indep", "tlb_keys_key_civ"];

// ACE's side keys, accepted as blank side keys when the setting allows it.
tlb_keys_core_aceKeys = createHashMapFromArray [
    ["ACE_key_east", ["key", 0]],
    ["ACE_key_west", ["key", 1]],
    ["ACE_key_indp", ["key", 2]],
    ["ACE_key_civ", ["key", 3]],
    ["ACE_key_master", ["master", -1]]
];

// Magazine class -> [type, side], or [] for anything that is not a key.
tlb_keys_core_typeCache = createHashMap;

// Hard defaults, overwritten by addSetting below.
tlb_keys_core_enabled = true;
tlb_keys_core_replaceAce = true;
tlb_keys_core_acceptAceKeys = true;
tlb_keys_core_startState = 0;
tlb_keys_core_lockInventory = true;
tlb_keys_core_ignitionLock = true;
tlb_keys_core_insideUnlock = true;
tlb_keys_core_lockTime = 0;
tlb_keys_core_allowSide = true;
tlb_keys_core_allowSquad = true;
tlb_keys_core_allowPaired = true;
tlb_keys_core_claimKey = 1;
tlb_keys_core_claimWho = 0;
tlb_keys_core_squadFollowsOwner = 0;
tlb_keys_core_managePerms = 0;
tlb_keys_core_allowSpare = true;
tlb_keys_core_allowWipe = true;
tlb_keys_core_pairedAsSide = false;
tlb_keys_core_allowHandOver = true;
tlb_keys_core_ownerTimeout = 0;
tlb_keys_core_masterEnabled = true;
tlb_keys_core_masterInArsenal = true;
tlb_keys_core_allowFobs = true;
tlb_keys_core_fobRange = 15;
tlb_keys_core_fobSound = true;
tlb_keys_core_lockpickEnabled = true;
tlb_keys_core_useTsp = true;
tlb_keys_core_useTlbiItems = true;
tlb_keys_core_lockpickTime = 20;
tlb_keys_core_hotwire = true;
tlb_keys_core_allowHotwire = true;
tlb_keys_core_hotwireTime = 25;
tlb_keys_core_vehCars = true;
tlb_keys_core_vehApcs = true;
tlb_keys_core_vehTanks = true;
tlb_keys_core_vehHelicopters = true;
tlb_keys_core_vehPlanes = true;
tlb_keys_core_vehBoats = true;
tlb_keys_core_allowKeybinds = true;
tlb_keys_core_keyRange = 5;

// Key slots for the key bindings, filled in post-init from the profile.
tlb_keys_core_slots = [[], [], []];
tlb_keys_core_slotsVar = "";

private _fnc_add = {
    params ["_name", "_type", "_sub", "_value"];
    [
        "tlb_keys_core_" + _name, _type,
        ["$STR_tlb_keys_core_set_" + _name, "$STR_tlb_keys_core_set_" + _name + "_desc"],
        ["$STR_tlb_keys_settings_category", "$STR_tlb_keys_core_settings_" + _sub],
        _value, 1
    ] call CBA_fnc_addSetting;
};

// --- General ----------------------------------------------------------------
["enabled", "CHECKBOX", "general", true] call _fnc_add;
["replaceAce", "CHECKBOX", "general", true] call _fnc_add;
["acceptAceKeys", "CHECKBOX", "general", true] call _fnc_add;
["startState", "LIST", "general", [[0, 1], ["$STR_tlb_keys_core_startState_0", "$STR_tlb_keys_core_startState_1"], 0]] call _fnc_add;
["lockInventory", "CHECKBOX", "general", true] call _fnc_add;
["ignitionLock", "CHECKBOX", "general", true] call _fnc_add;
["insideUnlock", "CHECKBOX", "general", true] call _fnc_add;
["lockTime", "SLIDER", "general", [0, 10, 0, 1]] call _fnc_add;

// --- Locking a vehicle ------------------------------------------------------
["allowSide", "CHECKBOX", "claim", true] call _fnc_add;
["allowSquad", "CHECKBOX", "claim", true] call _fnc_add;
["allowPaired", "CHECKBOX", "claim", true] call _fnc_add;
["claimKey", "LIST", "claim", [[0, 1], ["$STR_tlb_keys_core_claimKey_0", "$STR_tlb_keys_core_claimKey_1"], 1]] call _fnc_add;
["claimWho", "LIST", "claim", [[0, 1, 2], ["$STR_tlb_keys_core_claimWho_0", "$STR_tlb_keys_core_claimWho_1", "$STR_tlb_keys_core_claimWho_2"], 0]] call _fnc_add;
["squadFollowsOwner", "LIST", "claim", [[0, 1], ["$STR_tlb_keys_core_squadFollowsOwner_0", "$STR_tlb_keys_core_squadFollowsOwner_1"], 0]] call _fnc_add;

// --- Keys and management ----------------------------------------------------
["managePerms", "LIST", "keys", [[0, 1, 2], ["$STR_tlb_keys_core_managePerms_0", "$STR_tlb_keys_core_managePerms_1", "$STR_tlb_keys_core_managePerms_2"], 0]] call _fnc_add;
["allowSpare", "CHECKBOX", "keys", true] call _fnc_add;
["allowWipe", "CHECKBOX", "keys", true] call _fnc_add;
["pairedAsSide", "CHECKBOX", "keys", false] call _fnc_add;
["allowHandOver", "CHECKBOX", "keys", true] call _fnc_add;
["ownerTimeout", "SLIDER", "keys", [0, 60, 0, 0]] call _fnc_add;

// --- Master keys ------------------------------------------------------------
["masterEnabled", "CHECKBOX", "master", true] call _fnc_add;
["masterInArsenal", "CHECKBOX", "master", true] call _fnc_add;

// --- Key fobs ---------------------------------------------------------------
["allowFobs", "CHECKBOX", "fob", true] call _fnc_add;
["fobRange", "SLIDER", "fob", [5, 50, 15, 0]] call _fnc_add;
["fobSound", "CHECKBOX", "fob", true] call _fnc_add;

// --- Lockpicking ------------------------------------------------------------
["lockpickEnabled", "CHECKBOX", "pick", true] call _fnc_add;
["useTsp", "CHECKBOX", "pick", true] call _fnc_add;
["useTlbiItems", "CHECKBOX", "pick", true] call _fnc_add;
["lockpickTime", "SLIDER", "pick", [1, 120, 20, 0]] call _fnc_add;
["hotwire", "CHECKBOX", "pick", true] call _fnc_add;
["allowHotwire", "CHECKBOX", "pick", true] call _fnc_add;
["hotwireTime", "SLIDER", "pick", [5, 300, 25, 0]] call _fnc_add;

// --- Vehicle types ----------------------------------------------------------
// Which kinds of vehicle use keys at all (fn_isKeyed).
["vehCars", "CHECKBOX", "vehicles", true] call _fnc_add;
["vehApcs", "CHECKBOX", "vehicles", true] call _fnc_add;
["vehTanks", "CHECKBOX", "vehicles", true] call _fnc_add;
["vehHelicopters", "CHECKBOX", "vehicles", true] call _fnc_add;
["vehPlanes", "CHECKBOX", "vehicles", true] call _fnc_add;
["vehBoats", "CHECKBOX", "vehicles", true] call _fnc_add;

// --- Key bindings -----------------------------------------------------------
["allowKeybinds", "CHECKBOX", "keybinds", true] call _fnc_add;
["keyRange", "SLIDER", "keybinds", [2, 15, 5, 1]] call _fnc_add;

// --- ACE's vehicle lock -----------------------------------------------------
// Registered here, before ACE's post-init handler, so ACE sees these values when
// it decides whether to lock vehicles at start and guard their inventory with
// its own keys. Both jobs are ours while ACE is replaced.
["CBA_settingsInitialized", {
    if (missionNamespace getVariable ["tlb_keys_core_replaceAce", true]) then {
        ace_vehiclelock_lockVehicleInventory = false;
        ace_vehiclelock_vehicleStartingLockState = -1;
    };
}] call CBA_fnc_addEventHandler;
