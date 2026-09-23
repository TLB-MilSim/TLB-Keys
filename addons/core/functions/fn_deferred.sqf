#include "..\script_component.hpp"
/*
 * Author: TLB
 * Whether TLB Interactions is the one running vehicle picking and hotwiring.
 *
 * Only one of the two mods runs that system. The switch lives with the mod that
 * owns the board, as its "Pick vehicle locks" setting: on, TLB Interactions
 * takes picking, hotwiring and the ignition lock and this mod stands down; off,
 * or without that mod at all, everything here runs as usual.
 *
 * The keys themselves are never handed over: who holds one is always this mod's
 * answer, and TLB Interactions asks it.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * TLB Interactions owns vehicle picking and hotwiring <BOOL>
 */

if (isNil "tlbi_vehicle_fnc_owns") exitWith { false };

call tlbi_vehicle_fnc_owns
