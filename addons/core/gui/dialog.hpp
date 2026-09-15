// TLB Keys - naming dialog for vehicles and key codes. Vanilla controls only.

class RscText;
class RscEdit;
class RscButtonMenuOK;
class RscButtonMenuCancel;

class tlb_keys_RscRename {
    idd = IDD_TLB_KEYS_RENAME;
    movingEnable = 0;
    enableSimulation = 1;
    onLoad = "uiNamespace setVariable ['tlb_keys_core_renameDisplay', _this select 0]";
    onUnload = "_this call tlb_keys_core_fnc_renameClose";

    class controlsBackground {
        class Background: RscText {
            idc = -1;
            x = "0.36 * safezoneW + safezoneX";
            y = "0.42 * safezoneH + safezoneY";
            w = "0.28 * safezoneW";
            h = "0.13 * safezoneH";
            colorBackground[] = {0, 0, 0, 0.85};
        };
    };

    class controls {
        class Title: RscText {
            idc = IDC_RENAME_TITLE;
            text = "";
            x = "0.36 * safezoneW + safezoneX";
            y = "0.42 * safezoneH + safezoneY";
            w = "0.28 * safezoneW";
            h = "0.03 * safezoneH";
            colorBackground[] = {
                "(profilenamespace getvariable ['GUI_BCG_RGB_R',0.13])",
                "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.54])",
                "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.21])",
                1
            };
        };
        class Edit: RscEdit {
            idc = IDC_RENAME_EDIT;
            text = "";
            maxChars = 40;
            x = "0.37 * safezoneW + safezoneX";
            y = "0.462 * safezoneH + safezoneY";
            w = "0.26 * safezoneW";
            h = "0.035 * safezoneH";
        };
        class Cancel: RscButtonMenuCancel {
            x = "0.37 * safezoneW + safezoneX";
            y = "0.508 * safezoneH + safezoneY";
            w = "0.1 * safezoneW";
            h = "0.03 * safezoneH";
        };
        class Ok: RscButtonMenuOK {
            x = "0.53 * safezoneW + safezoneX";
            y = "0.508 * safezoneH + safezoneY";
            w = "0.1 * safezoneW";
            h = "0.03 * safezoneH";
        };
    };
};
