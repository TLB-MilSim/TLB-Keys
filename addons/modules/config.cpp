#include "script_component.hpp"
#include "..\main\script_version.hpp"

#define VERSION_STR MAJOR.MINOR.PATCHLVL.BUILD
#define VERSION_AR MAJOR,MINOR,PATCHLVL,BUILD

class CfgPatches {
    class tlb_keys_modules {
        name = "TLB Keys - Modules";
        author = "TLB";
        url = "https://github.com/TLB-MilSim/TLB-Keys";
        units[] = {
            "tlb_keys_moduleKeySet", "tlb_keys_moduleMasterKey",
            "tlb_keys_moduleZeusLock", "tlb_keys_moduleZeusReset", "tlb_keys_moduleZeusKey", "tlb_keys_moduleZeusMaster"
        };
        weapons[] = {};
        requiredVersion = 2.14;
        requiredAddons[] = {"A3_Modules_F", "A3_Modules_F_Curator", "3DEN", "tlb_keys_core"};
        version = VERSION_STR;
        versionStr = QUOTE(VERSION_STR);
        versionAr[] = {VERSION_AR};
        skipWhenMissingDependencies = 1;
    };
};

class CfgFunctions {
    class tlb_keys_modules {
        tag = "tlb_keys_modules";

        class modules {
            file = "tlb_keys\addons\modules\functions";

            class postInit { postInit = 1; };

            class moduleKeySet {};
            class moduleMasterKey {};
            class moduleUnits {};
            class giveModuleKeys {};
            class attributes {};
            class applyAttributes {};
            class zeusTarget {};
            class zeusLock {};
            class zeusReset {};
            class zeusKey {};
            class zeusMaster {};
        };
    };
};

class CfgFactionClasses {
    class NO_CATEGORY;
    class tlb_keys: NO_CATEGORY {
        displayName = "$STR_tlb_keys_modules_category";
    };
};

#define TLB_KEYS_SIDE_VALUES(AUTO) \
    class Values { \
        class Auto { name = AUTO; value = -1; default = 1; }; \
        class West { name = "$STR_tlb_keys_core_side_1"; value = 1; }; \
        class East { name = "$STR_tlb_keys_core_side_0"; value = 0; }; \
        class Indep { name = "$STR_tlb_keys_core_side_2"; value = 2; }; \
        class Civ { name = "$STR_tlb_keys_core_side_3"; value = 3; }; \
    }

class CfgVehicles {
    class Logic;
    class Module_F: Logic {
        class AttributesBase {
            class Default;
            class Edit;
            class Combo;
            class Checkbox;
            class CheckboxNumber;
            class ModuleDescription;
            class Units;
        };
        class ModuleDescription {
            class AnyBrain;
        };
    };

    // --- Eden: Key Set ----------------------------------------------------------
    class tlb_keys_moduleKeySet: Module_F {
        scope = 2;
        author = "TLB";
        displayName = "$STR_tlb_keys_modules_keySet";
        icon = "\tlb_keys\addons\modules\data\module_keyset_ca.paa";
        category = "tlb_keys";
        function = "tlb_keys_modules_fnc_moduleKeySet";
        functionPriority = 1;
        isGlobal = 0;
        isTriggerActivated = 0;
        isDisposable = 0;
        is3DEN = 0;

        class Attributes: AttributesBase {
            class Name: Edit {
                property = "tlb_keys_moduleKeySet_Name";
                displayName = "$STR_tlb_keys_modules_keySet_name";
                tooltip = "$STR_tlb_keys_modules_keySet_name_desc";
                typeName = "STRING";
                defaultValue = "''";
            };
            class Mode: Combo {
                property = "tlb_keys_moduleKeySet_Mode";
                displayName = "$STR_tlb_keys_modules_keySet_mode";
                tooltip = "$STR_tlb_keys_modules_keySet_mode_desc";
                typeName = "NUMBER";
                defaultValue = "2";
                class Values {
                    class Side { name = "$STR_tlb_keys_core_mode_0"; value = 0; };
                    class Squad { name = "$STR_tlb_keys_core_mode_1"; value = 1; };
                    class Paired { name = "$STR_tlb_keys_core_mode_2"; value = 2; default = 1; };
                };
            };
            class Side: Combo {
                property = "tlb_keys_moduleKeySet_Side";
                displayName = "$STR_tlb_keys_modules_side";
                tooltip = "$STR_tlb_keys_modules_keySet_side_desc";
                typeName = "NUMBER";
                defaultValue = "-1";
                TLB_KEYS_SIDE_VALUES("$STR_tlb_keys_modules_side_auto");
            };
            class Manage: Combo {
                property = "tlb_keys_moduleKeySet_Manage";
                displayName = "$STR_tlb_keys_modules_keySet_manage";
                tooltip = "$STR_tlb_keys_modules_keySet_manage_desc";
                typeName = "NUMBER";
                defaultValue = "0";
                class Values {
                    class Master { name = "$STR_tlb_keys_modules_keySet_manage_0"; value = 0; default = 1; };
                    class Anyone { name = "$STR_tlb_keys_modules_keySet_manage_1"; value = 1; };
                };
            };
            class Locked: Checkbox {
                property = "tlb_keys_moduleKeySet_Locked";
                displayName = "$STR_tlb_keys_modules_keySet_locked";
                tooltip = "$STR_tlb_keys_modules_keySet_locked_desc";
                typeName = "BOOL";
                defaultValue = "true";
            };
            class KeyType: Combo {
                property = "tlb_keys_moduleKeySet_KeyType";
                displayName = "$STR_tlb_keys_modules_keySet_keyType";
                tooltip = "$STR_tlb_keys_modules_keySet_keyType_desc";
                typeName = "NUMBER";
                defaultValue = "0";
                class Values {
                    class Key { name = "$STR_tlb_keys_modules_keySet_keyType_0"; value = 0; default = 1; };
                    class Fob { name = "$STR_tlb_keys_modules_keySet_keyType_1"; value = 1; };
                    class Both { name = "$STR_tlb_keys_modules_keySet_keyType_2"; value = 2; };
                };
            };
            class CrateKeys: Edit {
                property = "tlb_keys_moduleKeySet_CrateKeys";
                displayName = "$STR_tlb_keys_modules_keySet_crateKeys";
                tooltip = "$STR_tlb_keys_modules_keySet_crateKeys_desc";
                typeName = "NUMBER";
                defaultValue = "4";
            };
            class WholeGroup: Checkbox {
                property = "tlb_keys_moduleKeySet_WholeGroup";
                displayName = "$STR_tlb_keys_modules_wholeGroup";
                tooltip = "$STR_tlb_keys_modules_wholeGroup_desc";
                typeName = "BOOL";
                defaultValue = "false";
            };
            class Respawn: Checkbox {
                property = "tlb_keys_moduleKeySet_Respawn";
                displayName = "$STR_tlb_keys_modules_respawn";
                tooltip = "$STR_tlb_keys_modules_respawn_desc";
                typeName = "BOOL";
                defaultValue = "true";
            };
            class ModuleDescription: ModuleDescription {};
        };

        class ModuleDescription: ModuleDescription {
            description = "$STR_tlb_keys_modules_keySet_desc";
            sync[] = {"AnyVehicle", "AnyBrain"};
        };
    };

    // --- Eden: Master Key -------------------------------------------------------
    class tlb_keys_moduleMasterKey: Module_F {
        scope = 2;
        author = "TLB";
        displayName = "$STR_tlb_keys_modules_masterKey";
        icon = "\tlb_keys\addons\modules\data\module_master_ca.paa";
        category = "tlb_keys";
        function = "tlb_keys_modules_fnc_moduleMasterKey";
        functionPriority = 1;
        isGlobal = 0;
        isTriggerActivated = 0;
        isDisposable = 0;
        is3DEN = 0;

        class Attributes: AttributesBase {
            class Side: Combo {
                property = "tlb_keys_moduleMasterKey_Side";
                displayName = "$STR_tlb_keys_modules_side";
                tooltip = "$STR_tlb_keys_modules_masterKey_side_desc";
                typeName = "NUMBER";
                defaultValue = "-1";
                TLB_KEYS_SIDE_VALUES("$STR_tlb_keys_modules_side_unit");
            };
            class WholeGroup: Checkbox {
                property = "tlb_keys_moduleMasterKey_WholeGroup";
                displayName = "$STR_tlb_keys_modules_wholeGroup";
                tooltip = "$STR_tlb_keys_modules_wholeGroup_desc";
                typeName = "BOOL";
                defaultValue = "false";
            };
            class Respawn: Checkbox {
                property = "tlb_keys_moduleMasterKey_Respawn";
                displayName = "$STR_tlb_keys_modules_respawn";
                tooltip = "$STR_tlb_keys_modules_respawn_desc";
                typeName = "BOOL";
                defaultValue = "true";
            };
            class ModuleDescription: ModuleDescription {};
        };

        class ModuleDescription: ModuleDescription {
            description = "$STR_tlb_keys_modules_masterKey_desc";
            sync[] = {"AnyBrain"};
        };
    };

    // --- Zeus -----------------------------------------------------------------
    // Placed on a vehicle or unit. They run on the Zeus's machine and delete
    // themselves, like ACE's Zeus modules.
    class tlb_keys_moduleZeusBase: Module_F {
        scope = 1;
        scopeCurator = 1;
        author = "TLB";
        category = "tlb_keys";
        function = "";
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 0;
        curatorCanAttach = 1;
        icon = "\tlb_keys\addons\modules\data\module_lock_ca.paa";
    };
    class tlb_keys_moduleZeusLock: tlb_keys_moduleZeusBase {
        scopeCurator = 2;
        displayName = "$STR_tlb_keys_modules_zeusLock";
        function = "tlb_keys_modules_fnc_zeusLock";
    };
    class tlb_keys_moduleZeusReset: tlb_keys_moduleZeusBase {
        scopeCurator = 2;
        displayName = "$STR_tlb_keys_modules_zeusReset";
        function = "tlb_keys_modules_fnc_zeusReset";
        icon = "\tlb_keys\addons\core\data\icon_unlock_ca.paa";
    };
    class tlb_keys_moduleZeusKey: tlb_keys_moduleZeusBase {
        scopeCurator = 2;
        displayName = "$STR_tlb_keys_modules_zeusKey";
        function = "tlb_keys_modules_fnc_zeusKey";
        icon = "\tlb_keys\addons\modules\data\module_keyset_ca.paa";
    };
    class tlb_keys_moduleZeusMaster: tlb_keys_moduleZeusBase {
        scopeCurator = 2;
        displayName = "$STR_tlb_keys_modules_zeusMaster";
        function = "tlb_keys_modules_fnc_zeusMaster";
        icon = "\tlb_keys\addons\modules\data\module_master_ca.paa";
    };
};

// --- Eden attributes on every vehicle ------------------------------------------
// Stored on the vehicle as the mission loads; fn_applyAttributes turns them into
// keys on the server once every attribute of the vehicle has been read.

class Cfg3DEN {
    class Object {
        class AttributeCategories {
            class tlb_keys_attributes {
                displayName = "$STR_tlb_keys_modules_attr_category";
                collapsed = 1;

                class Attributes {
                    class tlb_keys_attrMode {
                        displayName = "$STR_tlb_keys_modules_attr_mode";
                        tooltip = "$STR_tlb_keys_modules_attr_mode_desc";
                        property = "tlb_keys_attrMode";
                        control = "Combo";
                        expression = "_this setVariable ['tlb_keys_attrMode', _value]; [_this] call tlb_keys_modules_fnc_attributes";
                        defaultValue = "-1";
                        typeName = "NUMBER";
                        condition = "objectVehicle";
                        class Values {
                            class None { name = "$STR_tlb_keys_modules_attr_modeNone"; value = -1; };
                            class Side { name = "$STR_tlb_keys_core_mode_0"; value = 0; };
                            class Squad { name = "$STR_tlb_keys_core_mode_1"; value = 1; };
                            class Paired { name = "$STR_tlb_keys_core_mode_2"; value = 2; };
                        };
                    };
                    class tlb_keys_attrSide {
                        displayName = "$STR_tlb_keys_modules_side";
                        tooltip = "$STR_tlb_keys_modules_attr_side_desc";
                        property = "tlb_keys_attrSide";
                        control = "Combo";
                        expression = "_this setVariable ['tlb_keys_attrSide', _value]; [_this] call tlb_keys_modules_fnc_attributes";
                        defaultValue = "-1";
                        typeName = "NUMBER";
                        condition = "objectVehicle";
                        class Values {
                            class Auto { name = "$STR_tlb_keys_modules_side_vehicle"; value = -1; };
                            class West { name = "$STR_tlb_keys_core_side_1"; value = 1; };
                            class East { name = "$STR_tlb_keys_core_side_0"; value = 0; };
                            class Indep { name = "$STR_tlb_keys_core_side_2"; value = 2; };
                            class Civ { name = "$STR_tlb_keys_core_side_3"; value = 3; };
                        };
                    };
                    class tlb_keys_attrSet {
                        displayName = "$STR_tlb_keys_modules_attr_set";
                        tooltip = "$STR_tlb_keys_modules_attr_set_desc";
                        property = "tlb_keys_attrSet";
                        control = "Edit";
                        expression = "_this setVariable ['tlb_keys_attrSet', _value]; [_this] call tlb_keys_modules_fnc_attributes";
                        defaultValue = "''";
                        typeName = "STRING";
                        condition = "objectVehicle";
                    };
                    class tlb_keys_attrLocked {
                        displayName = "$STR_tlb_keys_modules_attr_locked";
                        tooltip = "$STR_tlb_keys_modules_attr_locked_desc";
                        property = "tlb_keys_attrLocked";
                        control = "Checkbox";
                        expression = "_this setVariable ['tlb_keys_attrLocked', _value]; [_this] call tlb_keys_modules_fnc_attributes";
                        defaultValue = "false";
                        typeName = "BOOL";
                        condition = "objectVehicle";
                    };
                    class tlb_keys_attrPickable {
                        displayName = "$STR_tlb_keys_modules_attr_pickable";
                        tooltip = "$STR_tlb_keys_modules_attr_pickable_desc";
                        property = "tlb_keys_attrPickable";
                        control = "Checkbox";
                        expression = "_this setVariable ['tlb_keys_attrPickable', _value]; [_this] call tlb_keys_modules_fnc_attributes";
                        defaultValue = "true";
                        typeName = "BOOL";
                        condition = "objectVehicle";
                    };
                };
            };
        };
    };
};
