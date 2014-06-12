// Configuration file

// RESPAWN LOCATION list
// You can define vehicle or object
INS_REV_CFG_list_of_respawn_locations_blufor = ["base","Pilot_Respawn"];
INS_REV_CFG_list_of_respawn_locations_opfor = [];
INS_REV_CFG_list_of_respawn_locations_civ = [];
INS_REV_CFG_list_of_respawn_locations_guer = [];

// RESPAWN DELAY TIME
// You can define respawn delay time.
//
//INS_REV_CFG_respawn_delay = 120;			// Overrided by decription.ext parameter
//INS_REV_CFG_respawn_delay_blufor = 120;	// If you want to set delay time by each side, uncomment this value.
//INS_REV_CFG_respawn_delay_opfor  = 120;	// If you want to set delay time by each side, uncomment this value.
//INS_REV_CFG_respawn_delay_civ    = 120;	// If you want to set delay time by each side, uncomment this value.
//INS_REV_CFG_respawn_delay_guer   = 120;	// If you want to set delay time by each side, uncomment this value.

// Admin reserved slot
// You can reserve admin slot/
INS_REV_CFG_reserved_slot = true;
INS_REV_CFG_reserved_slot_units = ["admin"];
// LANGUAGE
// Language selection ("en" for english, you can create your own "XX_strings_lang.sqf" file)
INS_REV_CFG_language = "en";

// REVIVE LIFE TIME
// You can define life time for revive.
//
//INS_REV_CFG_life_time = 300;	// Overrided by decription.ext parameter

// How long takes time to revive
// You can define how log takes time to revive.
//
//INS_REV_CFG_revive_take_time = 15;	// Overrided by decription.ext parameter

// REVIVE REQUIRES MEDKIT
// Revive consumes a first aid kit when reviving.
//
//INS_REV_CFG_require_medkit = false;	// Overrided by decription.ext parameter

// DISPLAY RESPAWN LOCATIONS MARKER
// Display Respawn Locations Marker
// Color Index : "ColorOrange","ColorYellow","ColorGreen","ColorPink","ColorBrown","ColorKhaki","ColorBlue","ColorRed","ColorBlack","ColorWhite"
// Type Index : "mil_marker","mil_flag","mil_dot","mil_box","_mil_triangle","mil_destroy","mil_circle"
//
//INS_REV_CFG_displayRespawnLocationMarker = true;	// Overrided by decription.ext parameter
//INS_REV_CFG_respawnLocationMarkerColor = 0;		// Overrided by decription.ext parameter
//INS_REV_CFG_respawnLocationMarkerType = 0;		// Overrided by decription.ext parameter

// DESTROY WHEN BASE VEHICLE CAN"T MOVE
// Destroy when base vehicle can't move
//
//INS_REV_CFG_destroyDamagedVehicle = false;	// Overrided by decription.ext parameter
//INS_REV_CFG_destroyDamagedVehicleDelay = 30;	// Overrided by decription.ext parameter

// PLAYER CAN RESPAWN PLAYER's BODY
// You can define is it possible to respawn player's body.
//
//INS_REV_CFG_can_respawn_player_body = false;	// Overrided by decription.ext parameter

// PLAYER CAN RESPAWN PLAYER's BODY, WHEN HALF OF PLAYERS ARE DEAD
// You can define is it possible to respawn player's body, when half of players are dead.
//
//INS_REV_CFG_half_dead_repsawn_player_body = true;	// Overrided by decription.ext parameter

// PLAYER RESPAWN TYPE
// "ALL" - You can respawn all respawn locations and all alive players.(even if enemy)
// "SIDE" - You can only respawn friendly respawn locations and alive friendly players.
// "GROUP" - You can only repsawn your current group.
//
//INS_REV_CFG_respawn_type = "ALL";	// Overrided by decription.ext parameter

// PLAYER RESPAWN LOCATION
// "BOTH" - Base + Alive Friendldy Unit
// "BASE" - Base Only
// "FRIENDLY_UNIT" - Alive Friendly Unit Only
//
//INS_REV_CFG_respawn_location = "BOTH";	// Overrided by decription.ext parameter

// PLAYER CAN RESPAWN IMMEDIATELY WHEN THERE'S NOT EXIST FRIENDLY UNIT NEAR PLAYER
// There's not exist friendly unit near player, player can respawn immediately.
//
//INS_REV_CFG_respawn_near_friendly = false;	// Overrided by decription.ext parameter
//INS_REV_CFG_respawn_near_friendly_range = 50;	// Overrided by decription.ext parameter

// PLAYER CANNOT RESPAWN, IF EXIST ENEMY UNIT NEAR PLAYER
// If exist enemy unit near player, player cannot respawn.
//
//INS_REV_CFG_near_enemy = false;		// Overrided by decription.ext parameter
//INS_REV_CFG_near_enemy_range = 50;	// Overrided by decription.ext parameter

// PLAYER CAN RESPAWN IMMEDIATELY WHEN ALL PLAYERS ARE DEAD
// When all players are dead, player can respawn immediately.
//
//INS_REV_CFG__all_dead_respawn = true;	// Overrided by decription.ext parameter

// JIP TELEPORT ACTION
// True to allow JIP to use teleport action menu with in 3 minutes.
// False to when JIP connected, he will be shown respawn display.
// 0 is none
// 1 is add 'Teleport to teammate' action
// 2 is dead camera
//
//INS_REV_CFG_JIP_Teleport_Action = 1;	// Overrided by decription.ext parameter

// ALLOW TO DRAG BODY
// True to allow any player to drag unconscious bodies
// The value can be changed with an external script at any time with an instant effect
//
//INS_REV_CFG_player_can_drag_body = true;	// Overrided by decription.ext parameter

// ALLOW TO CARRY BODY
// True to allow any player to carry unconscious bodies
// The value can be changed with an external script at any time with an instant effect
//
//INS_REV_CFG_player_can_carry_body = true;	// Overrided by decription.ext parameter

// ALLOW TO LOAD BODY
// True to allow any player to load unconscious bodies to vehicle
// The value can be changed with an external script at any time with an instant effect
//
//INS_REV_CFG_medevac = true;	// Overrided by decription.ext parameter

// NUMBER OF REVIVES (Not implemented yet)
// Maximal number of revives for a player
//
//INS_REV_CFG_number_of_revives = 3;

/**
 * ALLOW TO REVIVE (system with three variables)
 * There are different ways to define who can revive unconscious bodies.
 *
 * The variable INS_REV_CFG_list_of_classnames_who_can_revive contains the list of classnames (i.e. the types of soldiers) who can revive.
 * To allow every soldiers to revive, you can write : INS_REV_CFG_list_of_classnames_who_can_revive = ["CAManBase"];
 * To allow USMC officers and medics, you can write : INS_REV_CFG_list_of_classnames_who_can_revive = ["USMC_Soldier_Officer", "USMC_Soldier_Medic"];
 * To not use the classnames to specify who can revive, you can write an empty list : INS_REV_CFG_list_of_classnames_who_can_revive = [];
 * To know the different classnames of soldiers, you can visit this page : http://browser.six-projects.net/cfg_vehicles/tree?utf8=%E2%9C%93&version=67
 *
 * The variable INS_REV_CFG_list_of_slots_who_can_revive contains the list of named slots (or units) who can revive.
 * For example, consider that you have two playable units named "medic1" and "medic2" in your mission editor.
 * To allow these two medics to revive, you can write : INS_REV_CFG_list_of_slots_who_can_revive = [medic1, medic2];
 * To not use the slots list to specify who can revive, you can write an empty list : INS_REV_CFG_list_of_slots_who_can_revive = [];
 *
 * The variable INS_REV_CFG_all_medics_can_revive is a boolean to allow all medics to revive.
 *
 * These three variables can be used together. The players who can revive are the union of the allowed players for each variable.
 * For example, if you set :
 *   INS_REV_CFG_all_player_can_revive = false;
 *   INS_REV_CFG_all_medics_can_revive = true;
 *   INS_REV_CFG_list_of_classnames_who_can_revive = ["USMC_Soldier_Officer"];
 *   INS_REV_CFG_list_of_slots_who_can_revive = [special_slot1, special_slot2];
 * then all the medics, all the "USMC_Soldier_Officer" and the players at special_slot1, special_slot1 can revive.
 * If a player "appears" in two categories (e.g. he is an "USMC_Soldier_Officer" at the slot named "special_slot2"),
 * it is not a matter. He will be allowed to revive without problem.
 *
 * The value of the three variables can be changed with an external script at any time with an instant effect.
 */
//
//INS_REV_CFG_all_player_can_revive = true;	// Overrided by decription.ext parameter
//INS_REV_CFG_all_medics_can_revive = true;	// Overrided by decription.ext parameter
INS_REV_CFG_list_of_classnames_who_can_revive = [];
INS_REV_CFG_list_of_slots_who_can_revive = [];


// Validate Config
#include "validate_cfg.sqf"
