// TLB Keys - Core
// Shared constants for config and SQF. Macro-light, like TLB Interactions:
// built without a P: drive.

#define QUOTE(var1) #var1
#define PATHTOF(var1) \tlb_keys\addons\core\var1
#define QPATHTOF(var1) QUOTE(PATHTOF(var1))

// --- Icons ------------------------------------------------------------------
#define ICON_KEY     "\tlb_keys\addons\core\data\icon_key_ca.paa"
#define ICON_MASTER  "\tlb_keys\addons\core\data\icon_master_ca.paa"
#define ICON_GIVE    "\tlb_keys\addons\core\data\icon_give_ca.paa"
#define ICON_LOCK    "\tlb_keys\addons\core\data\icon_lock_ca.paa"
#define ICON_UNLOCK  "\tlb_keys\addons\core\data\icon_unlock_ca.paa"
#define ICON_FOB     "\tlb_keys\addons\core\data\icon_fob_ca.paa"
#define ICON_PICK    "\tlb_keys\addons\core\data\icon_pick_ca.paa"

// --- Keys -------------------------------------------------------------------
// A key's round count is its cut. Full is blank; 1..9998 is a lock code.
#define KEY_BLANK       9999
#define KEY_CODE_MAX    9998

// --- Vehicle access modes (tlb_keys_mode) -----------------------------------
#define MODE_NONE       -1  // unassigned: nobody's key, open unless locked by the mission
#define MODE_SIDE       0   // any blank key of the vehicle's side
#define MODE_SQUAD      1   // a blank key of the vehicle's side, held by the vehicle's squad
#define MODE_PAIRED     2   // only keys cut to the vehicle

// --- What a unit may do with a vehicle ---------------------------------------
#define ACCESS_NONE     0
#define ACCESS_USE      1   // lock, unlock, drive
#define ACCESS_MANAGE   2   // change mode, cut keys, change locks, rename, give away

// tlb_keys_owner: a player UID, "" for nobody (anyone with access manages) or
// this for vehicles only master keys may manage.
#define OWNER_MASTER    "#master"

// --- Rename dialog ----------------------------------------------------------
#define IDD_TLB_KEYS_RENAME     716000
#define IDC_RENAME_TITLE        716001
#define IDC_RENAME_EDIT         716002
