if(isNil {vas_onRespawn}) then
{
hint "VAS is preloading...\nPlease Wait..";
private["_handle"];
_handle = [] execVM "gear\functions.sqf";
waitUntil {scriptDone _handle};
_handle =[] execVM "gear\config.sqf";
waitUntil {scriptDone _handle;};

if(isClass (configFile >> "CfgWeapons" >> "ACRE_PRC148") || vas_preload) then
{
	if(!vas_preload) then {vas_preload = true;};
	vas_pre_weapons = [] call fnc_gear_weapons;
	vas_pre_mags = [] call fnc_gear_mags;
	vas_pre_items = [] call fnc_gear_items;
	vas_pre_packs = [] call fnc_gear_packs;
	vas_pre_goggles = [] call fnc_gear_goggles;
};
hint "";
};


createDialog "VAS_Diag";
disableSerialization;

ctrlShow [2503,false];
ctrlShow [2507,false];
ctrlShow [2508,false];
ctrlShow [2509,false];