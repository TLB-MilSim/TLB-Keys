#include "script_version.hpp"

#define QUOTE(var1) #var1
#define VERSION MAJOR.MINOR
#define VERSION_STR MAJOR.MINOR.PATCHLVL.BUILD
#define VERSION_AR MAJOR,MINOR,PATCHLVL,BUILD

class CfgPatches {
    class tlb_keys_main {
        name = "TLB Keys - Main";
        author = "TLB";
        url = "https://github.com/TLB-MilSim/TLB-Keys";
        units[] = {};
        weapons[] = {};
        requiredVersion = 2.14;
        requiredAddons[] = {"cba_main"};
        version = VERSION_STR;
        versionStr = QUOTE(VERSION_STR);
        versionAr[] = {VERSION_AR};
        skipWhenMissingDependencies = 1;
    };
};

class CfgSettings {
    class CBA {
        class Versioning {
            class tlb_keys {
                class dependencies {
                    CBA[] = {"cba_main", {3,15,7}, "true"};
                };
            };
        };
    };
};
