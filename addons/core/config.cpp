#include "script_component.hpp"
#include "..\main\script_version.hpp"

#define VERSION_STR MAJOR.MINOR.PATCHLVL.BUILD
#define VERSION_AR MAJOR,MINOR,PATCHLVL,BUILD

class CfgPatches {
    class tlb_keys_core {
        name = "TLB Keys - Core";
        author = "TLB";
        url = "https://github.com/TLB-MilSim/TLB-Keys";
        units[] = {};
        weapons[] = {};
        requiredVersion = 2.14;
        // ace_vehiclelock so its actions exist to be switched off below.
        requiredAddons[] = {"A3_Ui_F", "tlb_keys_main", "tlb_keys_items", "cba_main", "ace_common", "ace_interact_menu", "ace_interaction", "ace_vehiclelock"};
        version = VERSION_STR;
        versionStr = QUOTE(VERSION_STR);
        versionAr[] = {VERSION_AR};
        skipWhenMissingDependencies = 1;
    };
};

class CfgFunctions {
    class tlb_keys_core {
        tag = "tlb_keys_core";

        class core {
            file = "tlb_keys\addons\core\functions";

            class preInit { preInit = 1; };
            class postInit { postInit = 1; };

            // Keys and access
            class keys {};
            class blankKey {};
            class getAccess {};
            class inSquad {};
            class keyName {};
            class vehicleName {};
            class sideName {};
            class notify {};

            // Vehicle state
            class assign {};
            class canClaim {};
            class claim {};
            class setMode {};
            class setLock {};
            class toggleLock {};
            class changeLocks {};
            class transfer {};
            class release {};
            class newCode {};
            class setCode {};

            // Key items
            class cutKey {};
            class giveKey {};
            class takeKey {};
            class restoreKeys {};
            class handOver {};
            class addKeyForVehicle {};

            // ACE menus
            class menuVehicle {};
            class menuManage {};
            class menuPick {};
            class menuKeys {};
            class menuKey {};
            class menuGive {};
            class describeVehicle {};
            class inspectKey {};
            class rename {};
            class renameClose {};

            // Lockpicking
            class pick {};
            class picked {};
            class hotwire {};

            // Event handlers
            class onEngine {};
            class onInventory {};
            class onRespawn {};
            class onVehicleInit {};
            class onDisconnect {};
            class stripArsenal {};
            class chirp {};

            // Vehicle types and key bindings
            class isKeyed {};
            class keybind {};
            class bindKey {};
        };
    };
};

// --- ACE's own vehicle lock actions ------------------------------------------
// Hidden while "Replace ACE vehicle locking" is on, on vehicle types that use
// keys. The condition reads the settings at the moment the menu opens, so ACE's
// actions come back the moment either is turned off.
#define TLB_KEYS_ACE_ACTIONS \
    class ACE_unlockVehicle { \
        condition = "!((missionNamespace getVariable ['tlb_keys_core_replaceAce', true]) && {[_target] call tlb_keys_core_fnc_isKeyed}) && {([_player, _target] call ace_vehiclelock_fnc_hasKeyForVehicle) && {(locked _target) in [2, 3]}}"; \
    }; \
    class ACE_lockVehicle { \
        condition = "!((missionNamespace getVariable ['tlb_keys_core_replaceAce', true]) && {[_target] call tlb_keys_core_fnc_isKeyed}) && {([_player, _target] call ace_vehiclelock_fnc_hasKeyForVehicle) && {(locked _target) in [0, 1]}}"; \
    }; \
    class ACE_lockpickVehicle { \
        condition = "!((missionNamespace getVariable ['tlb_keys_core_replaceAce', true]) && {[_target] call tlb_keys_core_fnc_isKeyed}) && {[_player, _target, 'canLockpick'] call ace_vehiclelock_fnc_lockpick}"; \
    };

#define TLB_KEYS_ACE_CLASS \
    class ACE_SelfActions { \
        TLB_KEYS_ACE_ACTIONS \
    }; \
    class ACE_Actions { \
        class ACE_MainActions { \
            TLB_KEYS_ACE_ACTIONS \
        }; \
    };

class CfgVehicles {
    class LandVehicle;
    class Car: LandVehicle {
        TLB_KEYS_ACE_CLASS
    };
    class Tank: LandVehicle {
        TLB_KEYS_ACE_CLASS
    };
    class Motorcycle: LandVehicle {
        TLB_KEYS_ACE_CLASS
    };
    class Air;
    class Helicopter: Air {
        TLB_KEYS_ACE_CLASS
    };
    class Plane: Air {
        TLB_KEYS_ACE_CLASS
    };
    class Ship;
    class Ship_F: Ship {
        TLB_KEYS_ACE_CLASS
    };
};

class CfgSounds {
    class tlb_keys_fobLock {
        name = "tlb_keys_fobLock";
        sound[] = {"\tlb_keys\addons\core\sounds\fob_lock.wav", 1, 1, 60};
        titles[] = {};
    };
    class tlb_keys_fobUnlock {
        name = "tlb_keys_fobUnlock";
        sound[] = {"\tlb_keys\addons\core\sounds\fob_unlock.wav", 1, 1, 60};
        titles[] = {};
    };
};

#include "gui\dialog.hpp"
