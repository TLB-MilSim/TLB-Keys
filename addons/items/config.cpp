#include "..\main\script_version.hpp"

#define QUOTE(var1) #var1
#define VERSION_STR MAJOR.MINOR.PATCHLVL.BUILD
#define VERSION_AR MAJOR,MINOR,PATCHLVL,BUILD

// TLB Keys - Items
//
// Every key is a magazine, not an item. A magazine carries a round count through
// crates, dropping, handing over, saved loadouts and respawn loadouts, and that
// count is the key's cut: 9999 (full) is a blank key, anything lower is the code
// of the lock it was cut for. Keys never go in a weapon, and ACE is told never
// to repack them, so the count is only ever changed by this mod.
//
// tlb_keys_type: "key", "master" or "fob". tlb_keys_side: 0 OPFOR, 1 BLUFOR,
// 2 Independent, 3 Civilian (the numbers of BIS_fnc_sideID), -1 for none.
//
// The lock pick kit is the tool for picking a vehicle's lock without TLB
// Interactions. With that mod loaded its own kit and paperclip are used
// instead, so ours still exists (saved loadouts keep working) but is hidden
// from the Arsenal, Zeus and the editor.
//
// The engine answers __has_include when it loads this config, so tools\build.ps1
// ships this file as plain text rather than binarising it: a binarised config
// would freeze whatever the build machine had installed.

#if __has_include("\tlbi\addons\lockpick\script_component.hpp")
    #define TLB_KEYS_PICK_SCOPE 1
#else
    #define TLB_KEYS_PICK_SCOPE 2
#endif

class CfgPatches {
    class tlb_keys_items {
        name = "TLB Keys - Items";
        author = "TLB";
        url = "https://github.com/TLB-MilSim/TLB-Keys";
        units[] = {};
        weapons[] = {"tlb_keys_lockpick"};
        magazines[] = {
            "tlb_keys_key_west", "tlb_keys_key_east", "tlb_keys_key_indep", "tlb_keys_key_civ",
            "tlb_keys_master_west", "tlb_keys_master_east", "tlb_keys_master_indep", "tlb_keys_master_civ",
            "tlb_keys_fob"
        };
        requiredVersion = 2.14;
        requiredAddons[] = {"A3_Weapons_F", "tlb_keys_main", "cba_main", "cba_common"};
        version = VERSION_STR;
        versionStr = QUOTE(VERSION_STR);
        versionAr[] = {VERSION_AR};
        skipWhenMissingDependencies = 1;
    };
};

class CfgMagazines {
    class CA_Magazine;

    class tlb_keys_keyBase: CA_Magazine {
        scope = 1;
        scopeArsenal = 1;
        scopeCurator = 1;
        author = "TLB";
        displayName = "$STR_tlb_keys_items_key_west";
        descriptionShort = "$STR_tlb_keys_items_key_desc";
        picture = "\tlb_keys\addons\items\data\key_west_ca.paa";
        model = "\A3\weapons_F\ammo\mag_univ.p3d";
        count = 9999;
        mass = 0.1;
        ACE_isUnique = 1;
        ace_disableRepacking = 1;
        tlb_keys_type = "key";
        tlb_keys_side = 1;
    };

    class tlb_keys_key_west: tlb_keys_keyBase {
        scope = 2;
        scopeArsenal = 2;
        scopeCurator = 2;
    };
    class tlb_keys_key_east: tlb_keys_key_west {
        displayName = "$STR_tlb_keys_items_key_east";
        picture = "\tlb_keys\addons\items\data\key_east_ca.paa";
        tlb_keys_side = 0;
    };
    class tlb_keys_key_indep: tlb_keys_key_west {
        displayName = "$STR_tlb_keys_items_key_indep";
        picture = "\tlb_keys\addons\items\data\key_indep_ca.paa";
        tlb_keys_side = 2;
    };
    class tlb_keys_key_civ: tlb_keys_key_west {
        displayName = "$STR_tlb_keys_items_key_civ";
        picture = "\tlb_keys\addons\items\data\key_civ_ca.paa";
        tlb_keys_side = 3;
    };

    class tlb_keys_master_west: tlb_keys_key_west {
        displayName = "$STR_tlb_keys_items_master_west";
        descriptionShort = "$STR_tlb_keys_items_master_desc";
        picture = "\tlb_keys\addons\items\data\master_west_ca.paa";
        tlb_keys_type = "master";
        tlb_keys_side = 1;
    };
    class tlb_keys_master_east: tlb_keys_master_west {
        displayName = "$STR_tlb_keys_items_master_east";
        picture = "\tlb_keys\addons\items\data\master_east_ca.paa";
        tlb_keys_side = 0;
    };
    class tlb_keys_master_indep: tlb_keys_master_west {
        displayName = "$STR_tlb_keys_items_master_indep";
        picture = "\tlb_keys\addons\items\data\master_indep_ca.paa";
        tlb_keys_side = 2;
    };
    class tlb_keys_master_civ: tlb_keys_master_west {
        displayName = "$STR_tlb_keys_items_master_civ";
        picture = "\tlb_keys\addons\items\data\master_civ_ca.paa";
        tlb_keys_side = 3;
    };

    class tlb_keys_fob: tlb_keys_key_west {
        displayName = "$STR_tlb_keys_items_fob";
        descriptionShort = "$STR_tlb_keys_items_fob_desc";
        picture = "\tlb_keys\addons\items\data\fob_ca.paa";
        mass = 0.2;
        tlb_keys_type = "fob";
        tlb_keys_side = -1;
    };
};

class CfgWeapons {
    class CBA_MiscItem;
    class CBA_MiscItem_ItemInfo;

    class tlb_keys_lockpick: CBA_MiscItem {
        scope = TLB_KEYS_PICK_SCOPE;
        scopeArsenal = TLB_KEYS_PICK_SCOPE;
        scopeCurator = TLB_KEYS_PICK_SCOPE;
        author = "TLB";
        displayName = "$STR_tlb_keys_items_lockpick";
        descriptionShort = "$STR_tlb_keys_items_lockpick_desc";
        picture = "\tlb_keys\addons\items\data\lockpick_ca.paa";

        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 4;
        };
    };
};
