
IF (isnil "server")then{hint "YOU MUST PLACE A GAME LOGIC NAMED SERVER!";};
EOS_spawnPatrol= compile preprocessfile "eos\functions\infantry_fnc.sqf";
EOS_LightVeh = compile preprocessfile "eos\functions\lightveh_fnc.sqf";
EOS_Armour = compile preprocessfile "eos\functions\heavyveh_fnc.sqf";
EOS_spawnStatic = compile preprocessfile "eos\functions\static_fnc.sqf";
EOS_FILLCARGO = compile preprocessfile "eos\functions\cargo_fnc.sqf";
EOS_Patrol= compile preprocessfile "eos\functions\shk_patrol.sqf";
EOS_Chopper= compile preprocessfile "eos\functions\chopper_fnc.sqf";
SHK_pos= compile preprocessfile "eos\functions\shk_pos.sqf";
callHouseScript = compile preprocessFileLineNumbers "eos\Functions\SHK_buildingpos.sqf";
EOS_unit= compile preprocessfilelinenumbers "eos\UnitPools.sqf";
call compile preprocessfilelinenumbers "eos\AI_Skill.sqf";

EOS_Deactivate = {
	private ["_mkr"];
		_mkr=(_this select 0);

		//hint format ["%1",_mkr];
		
	{
		_x setmarkercolor "colorblack";
		_x setmarkerAlpha 0;
	}foreach _mkr;
};

EOS_debug = {
private ["_note"];
_mkr=(_this select 0);
_n=(_this select 1);
_note=(_this select 2);
_pos=(_this select 3);

_mkrID=format ["%3:%1,%2",_mkr,_n,_note];
deletemarker _mkrID;
_debugMkr = createMarker[_mkrID,_pos];
_mkrID setMarkerType "Mil_dot";
_mkrID setMarkercolor "colorBlue";
_mkrID setMarkerText _mkrID;
_mkrID setMarkerAlpha 0.5;
};