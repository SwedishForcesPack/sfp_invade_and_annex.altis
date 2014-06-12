//------------------
// Validate Config
//------------------

// Remove null object in array
// Usage : '[array] call INS_REV_FNCT_remove_null_objects;'
// Return : array
INS_REV_FNCT_remove_null_objects = {
	private ["_arr", "_result"];
	
	_arr = _this select 0;
	_result = [];
	{
		if (!isNil _x) then {
			if (!isNull call compile format["%1",_x]) then {
				_result = _result + [_x];
			};
		};
	} forEach _arr;
	
	_result
};

// Get param value(number)
// Usage : '["_param","_value",_default] call INS_REV_FNCT_param_to_bool;'
INS_REV_FNCT_param_to_bool = {
	private ["_param","_value","_default"];
	
	_param = _this select 0;
	_value = _this select 1;
	_default = _this select 2;
	
	if (!isNil call compile format["'%1'",_param]) then {
		call compile format["%1 = (%2 == 1)", _value, _param];
	} else {
		if (isNil call compile format["'%1'",_value]) then {
			call compile format["%1 = %2", _value, _default];
		};
	};
};


// Process param to value
// Usage : '["_param","_value",_default] call INS_REV_FNCT_param_to_value;'
INS_REV_FNCT_param_to_value = {
	private ["_param","_value","_default"];
	
	_param = _this select 0;
	_value = _this select 1;
	_default = _this select 2;
	
	if (!isNil call compile format["'%1'",_param]) then {
		call compile format["%1 = %2", _value, _param];
	} else {
		if (isNil call compile format["'%1'",_value]) then {
			call compile format["%1 = %2", _value, _default];
		};
	};
};


INS_REV_CFG_list_of_respawn_locations_blufor = [INS_REV_CFG_list_of_respawn_locations_blufor] call INS_REV_FNCT_remove_null_objects;
INS_REV_CFG_list_of_respawn_locations_opfor = [INS_REV_CFG_list_of_respawn_locations_opfor] call INS_REV_FNCT_remove_null_objects;
//INS_REV_CFG_list_of_ammobox = [INS_REV_CFG_list_of_ammobox] call INS_REV_FNCT_remove_null_objects;

// Get parameter value from description.ext
for [ {_i = 0}, {_i < count(paramsArray)}, {_i = _i + 1} ] do
{
	call compile format 
	[
		"%1 = %2",
		(configName ((missionConfigFile >> "Params") select _i)),
		(paramsArray select _i)
	];
};

// ALLOW TO REVIVE
if (!isNil "INS_REV_PARAM_allow_revive") then {
	// Everyone
	if (INS_REV_PARAM_allow_revive == 0) then {
		INS_REV_CFG_all_player_can_revive = true;
	} else {
		// Medic Only
		if (INS_REV_PARAM_allow_revive == 1) then {
			INS_REV_CFG_all_player_can_revive = false;
			INS_REV_CFG_all_medics_can_revive = true;
		// Pre-Defined
		} else {
			INS_REV_CFG_all_player_can_revive = false;
			INS_REV_CFG_all_medics_can_revive = false;
		};
	};
} else {
	if (isNil "INS_REV_CFG_all_player_can_revive") then {
		INS_REV_CFG_all_player_can_revive = true;
	};
};

// RESPAWN DELAY TIME
["INS_REV_PARAM_respawn_delay",
 "INS_REV_CFG_respawn_delay",
 120 ] call INS_REV_FNCT_param_to_value;

// LIFE TIME FOR REVIVE
["INS_REV_PARAM_life_time",
 "INS_REV_CFG_life_time",
 300 ] call INS_REV_FNCT_param_to_value;

// TAKE TIME TO REVIVE
["INS_REV_PARAM_revive_take_time",
 "INS_REV_CFG_revive_take_time",
 15 ] call INS_REV_FNCT_param_to_value;

// REQUIRES MEDKIT TO REVIVE
["INS_REV_PARAM_require_medkit",
 "INS_REV_CFG_require_medkit",
 false ] call INS_REV_FNCT_param_to_bool;

// PLAYER RESPAWN TYPE
if (!isNil "INS_REV_PARAM_respawn_type") then {
	switch (INS_REV_PARAM_respawn_type) do {
		case 0: {
			// ALL
			INS_REV_CFG_respawn_type = "ALL";
		};
		case 1: {
			// SIDE
			INS_REV_CFG_respawn_type = "SIDE";
		};
		case 2: {
			// GROUP
			INS_REV_CFG_respawn_type = "GROUP";
		};
	};
} else {
	if (isNil "INS_REV_CFG_respawn_type") then {
		INS_REV_CFG_respawn_type = "ALL";
	};
};

// PLAYER RESPAWN LOCATION
if (!isNil "INS_REV_PARAM_respawn_location") then {
	switch (INS_REV_PARAM_respawn_location) do {
		case 0: {
			// Base + Alive friendly unit
			INS_REV_CFG_respawn_location = "BOTH";
		};
		case 1: {
			// Base
			INS_REV_CFG_respawn_location = "BASE";
		};
		case 2: {
			// Alive Friendly Unit
			INS_REV_CFG_respawn_location = "FRIENDLY_UNIT";
		};
	};
} else {
	if (isNil "INS_REV_CFG_respawn_location") then {
		INS_REV_CFG_respawn_location = "BOTH";
	};
};

// DISPLAY RESPAWN LOCATIONS MARKER
["INS_REV_PARAM_displayRespawnLocationMarker",
 "INS_REV_CFG_displayRespawnLocationMarker",
 true ] call INS_REV_FNCT_param_to_bool;

//  - Marker Color
["INS_REV_PARAM_respawnLocationMarkerColor",
 "INS_REV_CFG_respawnLocationMarkerColor",
 0 ] call INS_REV_FNCT_param_to_value;

//  - Marker Type
["INS_REV_PARAM_respawnLocationMarkerType",
 "INS_REV_CFG_respawnLocationMarkerType",
 0 ] call INS_REV_FNCT_param_to_value;

// DESTROY WHEN BASE VEHICLE CAN"T MOVE
["INS_REV_PARAM_destroyDamagedVehicle",
 "INS_REV_CFG_destroyDamagedVehicle",
 false ] call INS_REV_FNCT_param_to_bool;

//  - Delay Time
["INS_REV_PARAM_destroyDamagedVehicleDelay",
 "INS_REV_CFG_destroyDamagedVehicleDelay",
 30 ] call INS_REV_FNCT_param_to_value;

// JIP TELEPORT ACTION
["INS_REV_PARAM_jip_action",
 "INS_REV_CFG_JIP_Teleport_Action",
 1 ] call INS_REV_FNCT_param_to_value;

// ALLOW TO DRAG BODY
["INS_REV_PARAM_can_drag_body",
 "INS_REV_CFG_player_can_drag_body",
 true ] call INS_REV_FNCT_param_to_bool;

// ALLOW TO CARRY BODY
["INS_REV_PARAM_can_carry_body",
 "INS_REV_CFG_player_can_carry_body",
 true ] call INS_REV_FNCT_param_to_bool;

// Allow to load Body (MEDEVAC)
["INS_REV_PARAM_medevac",
 "INS_REV_CFG_medevac",
 true ] call INS_REV_FNCT_param_to_bool;

// PLAYER CAN RESPAWN PLAYER's BODY
["INS_REV_PARAM_can_respawn_player_body",
 "INS_REV_CFG_can_respawn_player_body",
 false ] call INS_REV_FNCT_param_to_bool;

// PLAYER CAN RESPAWN PLAYER's BODY, WHEN HALF OF PLAYERS ARE DEAD
["INS_REV_PARAM_half_dead_repsawn_player_body",
 "INS_REV_CFG_half_dead_repsawn_player_body",
 false ] call INS_REV_FNCT_param_to_bool;

// PLAYER CAN RESPAWN IMMEDIATELY WHEN THERE'S NOT EXIST FRIENDLY UNIT NEAR PLAYER
["INS_REV_PARAM_near_friendly",
 "INS_REV_CFG_respawn_near_friendly",
 false ] call INS_REV_FNCT_param_to_bool;

// PLAYER CAN RESPAWN IMMEDIATELY WHEN ALL PLAYERS ARE DEAD
["INS_REV_PARAM_all_dead_respawn",
 "INS_REV_CFG__all_dead_respawn",
 true ] call INS_REV_FNCT_param_to_bool;

// Friendly unit search distnace
["INS_REV_PARAM_near_friendly_distance",
 "INS_REV_CFG_respawn_near_friendly_range",
 50 ] call INS_REV_FNCT_param_to_value;

// PLAYER CANNOT RESPAWN, IF EXIST ENEMY UNIT NEAR PLAYER
["INS_REV_PARAM_near_enemy",
 "INS_REV_CFG_near_enemy",
 true ] call INS_REV_FNCT_param_to_bool;

// Enemy unit search distance
["INS_REV_PARAM_near_enemy_distance",
 "INS_REV_CFG_near_enemy_range",
 50 ] call INS_REV_FNCT_param_to_value;

// Restore loadout on respawn : Core Version
["INS_REV_PARAM_loadout_on_respawn",
 "INS_REV_CFG_loadout_on_respawn",
 false ] call INS_REV_FNCT_param_to_bool;

// Teamkiller Lock System
["INS_REV_PARAM_teamkiller_lock",
 "INS_REV_CFG_teamkiller_lock",
 true ] call INS_REV_FNCT_param_to_bool;

// Teamkill Limit
["INS_REV_PARAM_teamkill_limit",
 "INS_REV_CFG_teamkill_limit",
 3 ] call INS_REV_FNCT_param_to_value;

// Virtual Ammobox System
["INS_REV_PARAM_virtual_ammobox",
 "INS_REV_CFG_virtual_ammobox",
 true ] call INS_REV_FNCT_param_to_bool;

// - Protect ammobox
["INS_REV_PARAM_vas_protect_ammobox",
 "INS_REV_CFG_vas_protect_ammobox",
 true ] call INS_REV_FNCT_param_to_bool;

// TAW View Distance Script
["INS_REV_PARAM_taw_view",
 "INS_REV_CFG_taw_view",
 true ] call INS_REV_FNCT_param_to_bool;

// Squad Management Script
["INS_REV_PARAM_squad_management",
 "INS_REV_CFG_squad_management",
 true ] call INS_REV_FNCT_param_to_bool;

// DOM Repair
["INS_REV_PARAM_repair_system",
 "INS_REV_CFG_dom_repair",
 true ] call INS_REV_FNCT_param_to_bool;

// Repair delay time
["INS_REV_PARAM_repair_system_delay",
 "INS_REV_CFG_dom_repair_delay",
 120 ] call INS_REV_FNCT_param_to_value;

// - Push Boat
["INS_REV_PARAM_repair_push_boat",
 "INS_REV_CFG_dom_repair_push_boat",
 true ] call INS_REV_FNCT_param_to_bool;

// - Flip Vehicle
["INS_REV_PARAM_repair_flip_vehicle",
 "INS_REV_CFG_dom_repair_flip_vehicle",
 true ] call INS_REV_FNCT_param_to_bool;

// - Only engineer can repair
["INS_REV_PARAM_repair_engineer_only",
 "INS_REV_CFG_dom_repair_engineer_only",
 false ] call INS_REV_FNCT_param_to_bool;

// Manual NV Goggle sensitivity
["INS_REV_PARAM_s_nvg",
 "INS_REV_CFG_s_nvg",
 true ] call INS_REV_FNCT_param_to_bool;

// Player Name Tag
["INS_REV_PARAM_name_tag",
 "INS_REV_CFG_name_tag",
 true ] call INS_REV_FNCT_param_to_bool;

// Player Marker
["INS_REV_PARAM_player_marker",
 "INS_REV_CFG_player_marker",
 true ] call INS_REV_FNCT_param_to_bool;

// Player Marker Process Method
["INS_REV_PARAM_player_marker_method",
 "INS_REV_CFG_player_marker_serverSide",
 true ] call INS_REV_FNCT_param_to_bool;
// Override player marker process method depend on Respawn Faction
if (INS_REV_CFG_respawn_type != "ALL") then {
	INS_REV_CFG_player_marker_serverSide = false;
};

// Personal UAV
["INS_REV_PARAM_uav_recon",
 "INS_REV_CFG_uav",
 true ] call INS_REV_FNCT_param_to_bool;

//  - UAV delay time
["INS_REV_PARAM_uav_delay",
 "INS_REV_CFG_uav_delay",
 120 ] call INS_REV_FNCT_param_to_value;

// Only squad leader can use the UAV
["INS_REV_PARAM_uav_squadleader_only",
 "INS_REV_CFG_uav_squadleader_only",
 true ] call INS_REV_FNCT_param_to_bool;

// - Enable UAV Setting Dialog
["INS_REV_PARAM_uav_setting_dialog",
 "INS_REV_CFG_uav_setting_dialog",
 false ] call INS_REV_FNCT_param_to_bool;

// - Allow map click UAV position
["INS_REV_PARAM_uav_allow_map_click",
 "INS_REV_CFG_uav_allow_map_click",
 false ] call INS_REV_FNCT_param_to_bool;

// - Personal UAV enemy marker
["INS_REV_PARAM_uav_recon_enemy_marker",
 "INS_REV_CFG_uav_enemy_marker",
 false ] call INS_REV_FNCT_param_to_bool;

//  - UAV default altitude
["INS_REV_PARAM_uav_altitude",
 "INS_REV_CFG_uav_altitude",
 300 ] call INS_REV_FNCT_param_to_value;

//  - UAV default radius of the circular movement
["INS_REV_PARAM_uav_circle",
 "INS_REV_CFG_uav_circle",
 250 ] call INS_REV_FNCT_param_to_value;

// UAV Briefing
["INS_REV_PARAM_uav_briefing",
 "INS_REV_CFG_uav_briefing",
 false ] call INS_REV_FNCT_param_to_bool;