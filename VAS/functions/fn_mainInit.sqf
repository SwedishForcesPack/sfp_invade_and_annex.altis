/*
	@version: 1.1
	@file_name: fn_mainInit.sqf
	@file_author: TAW_Tonic
	@file_edit: 5/27/2013
	@file_description: Only called once during the initialization of VAS and uses compileFinal on all VAS functions.
*/
[] spawn
{
	private["_handle"];
	VAS_init_complete = false;
	[] execVM "VAS\functions\misc_functions.sqf";
	_handle = [] execVM "VAS\KRON_Strings.sqf";
	waitUntil {scriptDone _handle};
	_handle = [] execVM "VAS\config.sqf";
	waitUntil {scriptDone _handle;};
	["CfgWeapons"] call VAS_fnc_buildConfig;
	["CfgMagazines"] call VAS_fnc_buildConfig;
	["CfgVehicles"] call VAS_fnc_buildConfig;
	["CfgGlasses"] call VAS_fnc_buildConfig;
	VAS_init_complete = true;
};

/*
VAS_fnc_onRespawn = compileFinal PreprocessFileLineNumbers "gear\func\load_onrespawn.sqf";
VAS_fnc_deleteGear = compileFinal PreprocessFileLineNumbers "gear\func\delete_gear.sqf";
VAS_fnc_loadGear = compileFinal PreprocessFileLineNumbers "gear\func\load_format.sqf";
VAS_fnc_loadoutInfo = compileFinal PreprocessFileLineNumbers "gear\func\show_list.sqf";
VAS_fnc_saveGear = compileFinal PreprocessFileLineNumbers "gear\func\save_format.sqf";
VAS_fnc_SaveLoad = compileFinal PreprocessFileLineNumbers "gear\func\save_load_menu.sqf";
VAS_fnc_details = compileFinal PreprocessFileLineNumbers "gear\func\details.sqf";
VAS_fnc_removeGear = compileFinal PreprocessFileLineNumbers "gear\func\remove_gear.sqf";
VAS_fnc_addGear = compileFinal PreprocessFileLineNumbers "gear\func\add_gear.sqf";
VAS_fnc_handleItem = compileFinal PreprocessFileLineNumbers "gear\func\handle_item.sqf";
VAS_fnc_filterShow = compileFinal PreprocessFileLineNumbers "gear\func\filter_show.sqf";
VAS_fnc_filterMenu = compileFinal PreprocessFileLineNumbers "gear\func\filter_menu.sqf";
VAS_fnc_fetchCfg = compileFinal PreprocessFileLineNumbers "gear\func\fetch_config.sqf";
VAS_fnc_fetchCfgDetails = compileFinal PreprocessFileLineNumbers "gear\func\fetch_config_details.sqf";
VAS_fnc_buildConfig = compileFinal PreprocessFileLineNumbers "gear\func\build_config.sqf";
VAS_fnc_filter = compileFinal PreProcessFileLineNumbers "gear\func\filter.sqf";
VAS_fnc_fetchPlayerGear = compileFinal PreprocessFileLineNumbers "gear\func\player_gear.sqf";
VAS_main_display = compileFinal PreprocessFileLineNumbers "gear\func\main_list.sqf";
*/
