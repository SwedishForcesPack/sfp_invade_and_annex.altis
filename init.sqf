/*
      ::: ::: :::             ::: :::             :::
     :+: :+:   :+:           :+:   :+:           :+:
    +:+ +:+     +:+         +:+     +:+         +:+
   +#+ +#+       +#+       +#+       +#+       +#+
  +#+ +#+         +#+     +#+         +#+     +#+
 #+# #+#           #+#   #+#           #+#   #+#
### ###             ### ###             ### ###

| AHOY WORLD | ARMA 3 | ALTIS ANNEX 2.72 | QUIKSILVER EDITED |

Creating working missions of this complexity from
scratch is difficult and time consuming, please
credit http://www.ahoyworld.co.uk for creating and
distibuting this mission when hosting!

This version of Domination was lovingly crafted by
Jack Williams (Rarek) for Ahoy World!

Maintained for Ahoy World by Jester, Razgriz33 and Kamaradski.

Heavily edited version, developed by Quiksilver and chucky. ts3.allfps.com.au:9992. www.allFPS.com.au.
Further edited by razgriz33, big thanks to the guys above for their hard work
*/

// JIP Check

if (!isServer && isNull player) then {isJIP=true;} else {isJIP=false;};

// Wait until player is initialized
if (!isDedicated) then
{
	waitUntil {!isNull player && isPlayer player};
	sidePlayer = side player;
};

_handle = execVM "functions.sqf";
waitUntil {time > 0};
waitUntil{scriptDone _handle};

/* =============================================== */
/* =============== GLOBAL VARIABLES ============== */
/* =============================================== */

private ["_pos","_isAdmin","_i","_isPerpetual","_accepted","_position","_randomWreck","_firstTarget","_validTarget","_targetsLeft","_flatPos","_targetStartText","_lastTarget","_targets","_dt","_enemiesArray","_radioTowerDownText","_targetCompleteText","_null","_unitSpawnPlus","_unitSpawnMinus","_missionCompleteText"];

_initialTargets = [
	"Sofia Radar Station",
	"Research Facility",
	"Feres",
	"Skopos Castle",
	"Zaros Power Station",
	"Factory",
	"Syrta",
	"Zaros",
	"Chalkeia",
	"Aristi Turbines",
	"Dump",
	"Frini",
	"Limni",
	"Rodopoli",
	"Charkia",
	"Alikampos",
	"Neochori",
	"Eginio",
	"Agios Dionysios",
	"Paros",
	"Molos",
	"Didymos Turbines",
	"Delfinaki Outpost",
	"Panochori",
	"The Stadium",
	"Gori Refinery",
	"Negades",
	"Abdera",
	"Kore",
	"Oreokastro",
	"Dorida",
	"Galati Outpost",
	"Frini Woodlands",
	"Nidasos Woodlands",
	"Sofia Powerplant",
	"Gatolia Solar Farm",
	"Vikos Outpost",
	"Sagonisi Outpost",
	"Panagia",
	"Selakano Outpost",
	"Athira",
	"Fotia Turbines",
	"Athanos"
];

_targets = [
	"Sofia Radar Station",
	"Research Facility",
	"Feres",
	"Skopos Castle",
	"Zaros Power Station",
	"Factory",
	"Syrta",
	"Zaros",
	"Chalkeia",
	"Aristi Turbines",
	"Dump",
	"Frini",
	"Limni",
	"Rodopoli",
	"Charkia",
	"Alikampos",
	"Neochori",
	"Eginio",
	"Agios Dionysios",
	"Paros",
	"Molos",
	"Didymos Turbines",
	"Delfinaki Outpost",
	"Panochori",
	"The Stadium",
	"Gori Refinery",
	"Negades",
	"Abdera",
	"Kore",
	"Oreokastro",
	"Dorida",
	"Galati Outpost",
	"Frini Woodlands",
	"Nidasos Woodlands",
	"Sofia Powerplant",
	"Gatolia Solar Farm",
	"Vikos Outpost",
	"Sagonisi Outpost",
	"Panagia",
	"Selakano Outpost",
	"Athira",
	"Fotia Turbines",
	"Athanos"
];

//Grab parameters and put them into readable variables
for [ {_i = 0}, {_i < count(paramsArray)}, {_i = _i + 1} ] do
{
	call compile format
	[
		"PARAMS_%1 = %2",
		(configName ((missionConfigFile >> "Params") select _i)),
		(paramsArray select _i)
	];
};

// Disable saving to save time
enableSaving [false, false];

// Disable automatic radio messages
enableSentences false;

"GlobalHint" addPublicVariableEventHandler
{
	private ["_GHint"];
	_GHint = _this select 1;
	hint parseText format["%1", _GHint];
};

"runOnServer" addPublicVariableEventHandler
{
	if (isServer) then
	{
		private ["_codeToRun"];
		_codeToRun = _this select 1;
		call _codeToRun;
	};
};

"radioTower" addPublicVariableEventHandler
{
	"radioMarker" setMarkerPosLocal (markerPos "radioMarker");
	"radioMarker" setMarkerTextLocal (markerText "radioMarker");
	"radioMineCircle" setMarkerPosLocal (markerPos "radioMineCircle");
};

"refreshMarkers" addPublicVariableEventHandler
{
	{
		_x setMarkerShapeLocal (markerShape _x);
		_x setMarkerSizeLocal (markerSize _x);
		_x setMarkerBrushLocal (markerBrush _x);
		_x setMarkerColorLocal (markerColor _x);
	} forEach _targets;

	{
		_x setMarkerPosLocal (markerPos _x);
		_x setMarkerTextLocal (markerText _x);
	} forEach ["aoMarker","aoCircle"];
};

"showNotification" addPublicVariableEventHandler
{
	private ["_type", "_message"];
	_array = _this select 1;
	_type = _array select 0;
	_message = "";
	if (count _array > 1) then { _message = _array select 1; };
	[_type, [_message]] call bis_fnc_showNotification;
};

"showSingleNotification" addPublicVariableEventHandler
{
	/* Slam somethin' 'ere */
};

"sideMarker" addPublicVariableEventHandler
{
	"sideMarker" setMarkerPosLocal (markerPos "sideMarker");
	"sideCircle" setMarkerPosLocal (markerPos "sideCircle");
	"sideMarker" setMarkerTextLocal format["Side Mission: %1",sideMarkerText];
};

"priorityMarker" addPublicVariableEventHandler
{
	"priorityMarker" setMarkerPosLocal (markerPos "priorityMarker");
	"priorityCircle" setMarkerPosLocal (markerPos "priorityCircle");
	"priorityMarker" setMarkerTextLocal format["Priority Target: %1",priorityTargetText];
};

"hqSideChat" addPublicVariableEventHandler
{
	_message = _this select 1;
	[WEST,"HQ"] sideChat _message;
};

"debugMessage" addPublicVariableEventHandler
{
	private ["_isAdmin", "_message"];
	_isAdmin = serverCommandAvailable "#kick";
	if (_isAdmin) then
	{
		if (debugMode) then
		{
			_message = _this select 1;
			[_message] call bis_fnc_error;
		};
	};
};


/* =============================================== */
/* ================ PLAYER SCRIPTS =============== */
/* =============================================== */

[] execvm "scripts\crew.sqf"; 											// vehicle HUD
_null = [] execVM "scripts\group_manager.sqf"; 								// group manager
_null = [] execVM "scripts\restrictions.sqf"; 							// gear restrictions
_null = [] execVM "scripts\pilotCheck.sqf"; 							// pilots only
_null = [] execVM "scripts\grenadeStop.sqf"; 							// spawn protection
_null = [] execVM "scripts\jump.sqf";									// jump action
_null = [] execVM "misc\briefing.sqf";									// diary tabs
_null = [] execVM "vehicle\fastrope\zlt_fastrope.sqf";					// heli rope	
_null = [] execVM "misc\playerMarkers.sqf";								// blufor tracker
call compile preprocessFile "=BTC=_revive\=BTC=_revive_init.sqf";		// revive
tawvd_disablenone = true;												// no-grass disabled


if (!isServer) then
{
	sleep 20;

	waitUntil {sleep 0.5; currentAO != "Nothing"};

	if (radioTowerAlive) then
	{
		"radioMarker" setMarkerPosLocal (getPos radioTower);
		"radioMineCircle" setMarkerPosLocal (getPos radioTower);
		"radioMarker" setMarkerTextLocal (markerText "radioMarker");
	} else {
		"radioMarker" setMarkerPosLocal [-10000,-10000,-10000];
		"radioMineCircle" setMarkerPosLocal [-10000,-10000,-10000];
	};

	if (sideMissionUp) then
	{
		"sideMarker" setMarkerPosLocal (getPos sideObj);
		"sideCircle" setMarkerPosLocal (getPos sideObj);
		"sideMarker" setMarkerTextLocal format["Side Mission: %1",sideMarkerText];
	} else {
		"sideMarker" setMarkerPosLocal [-10000,-10000,-10000];
		"sideCircle" setMarkerPosLocal [-10000,-10000,-10000];
	};

	if (priorityTargetUp) then
	{
		_pos = [-10000,-10000,-10000];
		if (alive priorityTarget1) then
		{
			_pos = getPos priorityTarget1;
		} else {
			_pos = getPos priorityTarget2;
		};
		"priorityMarker" setMarkerPosLocal _pos;
		"priorityCircle" setMarkerPosLocal _pos;
		"priorityMarker" setMarkerTextLocal format["Priority Target: %1",priorityTargetText];
	} else {
		"priorityMarker" setMarkerPosLocal [-10000,-10000,-10000];
		"priorityCircle" setMarkerPosLocal [-10000,-10000,-10000];
	};

	if (currentAOUp) then
	{
		{
			_x setMarkerPosLocal (getMarkerPos currentAO);
		} forEach ["aoCircle","aoMarker"];
		"aoMarker" setMarkerTextLocal format["Take %1",currentAO];
	} else {
		{
			_x setMarkerPosLocal [-10000,-10000,-10000];
		} forEach ["aoCircle","aoMarker"];
	};
};

if (!isServer) exitWith
{
	while {true} do
	{
		waitUntil {sleep 0.5; !alive player};
		waitUntil {sleep 0.5; alive player};
	};
};


/* =============================================== */
/* ============ SERVER INITIALISATION ============ */
/* =============================================== */

//Set a few blank variables for event handlers and solid vars for SM 
publicVariable "debugMode";
eastSide = createCenter EAST;
radioTowerAlive = false;
sideMissionUp = false;
priorityTargetUp = false;
currentAOUp = false;
refreshMarkers = true;
sideObj = objNull;
priorityTargets = ["None"];
smRewards =
[
	["a TO-199 Neophron", "O_Plane_CAS_02_F"],
	["a A-164 Wipeout", "B_Plane_CAS_01_F"],
	["an AH-99 Blackfoot", "B_Heli_Attack_01_F"],
	["an Mi-48 Kajman", "O_Heli_Attack_02_black_F"],
	["an AH-9 Pawnee", "B_Heli_Light_01_armed_F"],
	["a PO-30 Orca", "O_Heli_Light_02_F"],
	["an MQ4A Greyhawk", "B_UAV_02_F"],
	["an MBT-52 Kuma", "I_MBT_03_cannon_F"],
	["an FV-720 Mora", "I_APC_tracked_03_cannon_F"],
	["an AFV-4 Gorgon", "I_APC_Wheeled_03_cannon_F"],
	["an IFV-6a Cheetah", "B_APC_Tracked_01_AA_F"],
	["an MBT-52 Kuma", "I_MBT_03_cannon_F"],
	["an FV-720 Mora", "I_APC_tracked_03_cannon_F"],
	["an AFV-4 Gorgon", "I_APC_Wheeled_03_cannon_F"],
	["an IFV-6a Cheetah", "B_APC_Tracked_01_AA_F"],
	["an M2A1 Slammer (Urban Purpose)", "B_MBT_01_TUSK_F"]
];

smMarkerList =
["smReward1","smReward2","smReward3","smReward4","smReward5","smReward6","smReward7","smReward8","smReward9","smReward10","smReward11","smReward12","smReward13","smReward14","smReward15","smReward16","smReward17","smReward18","smReward19","smReward20","smReward21","smReward22","smReward23","smReward24","smReward25","smReward26","smReward27"];

//Run a few miscellaneous server-side scripts
_null = [] execVM "misc\clearBodies.sqf";
_null = [] execVM "misc\clearItems.sqf";

// AI retake AO start
[]execVM "eos\OpenMe.sqf";

// Urban Missions
if (PARAMS_UrbanMissions == 1) then { _null = [2700] execVM "sm\sideMission_Init.sqf"; };

_isPerpetual = false;

if (PARAMS_Perpetual == 1) then
{
	_isPerpetual = true;
};

currentAO = "Nothing";
publicVariable "currentAO";
_lastTarget = "Nothing";
_targetsLeft = count _targets;

"TakeMarker" addPublicVariableEventHandler
{
	createMarker [((_this select 1) select 0), getMarkerPos ((_this select 1) select 1)];
	"theTakeMarker" setMarkerShape "ICON";
	"theTakeMarker" setMarkerType "o_unknown";
	"theTakeMarker" setMarkerColor "ColorOPFOR";
	"theTakeMarker" setMarkerText format["Take %1", ((_this select 1) select 1)];
};

"addToScore" addPublicVariableEventHandler
{
	((_this select 1) select 0) addScore ((_this select 1) select 1);
};

#define MINE_TYPES "APERSBoundingMine","APERSMine","ATMine"
AW_fnc_minefield = {
    _centralPos = _this select 0;
    _unitsArray = [];
    for "_x" from 0 to 59 do 
    {
        _mine = createMine [[MINE_TYPES] call BIS_fnc_selectrandom, _centralPos, [], 38];
        _unitsArray = _unitsArray + [_mine];
    };

    _distance = 40;
    _dir = 180;
    for "_c" from 0 to 23 do
    {
        _pos = [_flatPos, _distance, _dir] call BIS_fnc_relPos;
        _sign = "Land_Razorwire_F" createVehicle _pos;
        waitUntil {alive _sign};
        _sign setDir _dir;
		_sign enableSimulation false;
		_sign allowDamage false;
        _dir = _dir + 15;
        
        _unitsArray = _unitsArray + [_sign];
    };


    _unitsArray
};

AW_fnc_deleteOldAOUnits =
{
	private ["_unitsArray", "_obj", "_isGroup"];
	sleep 600;
	_unitsArray = _this select 0;
	for "_c" from 0 to (count _unitsArray) do
	{
		_obj = _unitsArray select _c;
		_isGroup = false; if (_obj in allGroups) then { _isGroup = true; };
		if (_isGroup) then
		{
			{
				if (!isNull _x) then { deleteVehicle _x; };
			} forEach (units _obj);
		} else {
			if (!isNull _obj) then { deleteVehicle _obj; };
		};
	};
};

GC_fnc_deleteOldUnitsAndVehicles = {
    {
	sleep 1;
        if (typeName _x == "GROUP") then {
            {
                if (vehicle _x != _x) then {
                    deleteVehicle (vehicle _x);
                };
                deleteVehicle _x;
            } forEach (units _x);
        } else {
            if (vehicle _x != _x) then {
                deleteVehicle (vehicle _x);
            };
            if !(_x isKindOf "Man") then {
                {
                    deleteVehicle _x;
                } forEach (crew _x)
            };
            deleteVehicle _x;
        };
    } forEach (_this select 0);
};

AW_fnc_deleteOldSMUnits =
{
	private ["_unitsArray", "_obj", "_isGroup"];
	sleep 1;
	_unitsArray = _this select 0;
	for "_c" from 0 to (count _unitsArray) do
	{
		_obj = _unitsArray select _c;
		_isGroup = false;
		if (_obj in allGroups) then { _isGroup = true; };
		if (_isGroup) then
		{
			{
				if (!isNull _x) then { deleteVehicle _x; };
			} forEach (units _obj);
		} else {
			if (!isNull _obj) then { deleteVehicle _obj; };
		};
	};
};

AW_fnc_deleteSingleUnit = {

private ["_obj","_time"];
_obj = _this select 0;
	_time = _this select 1;
	sleep _time;
	deleteVehicle _obj;
};

AW_fnc_rewardPlusHint = {

private ["_veh","_vehName","_vehVarname","_completeText","_reward"];
_veh = smRewards call BIS_fnc_selectRandom;
	_vehName = _veh select 0;
	_vehVarname = _veh select 1;

	_completeText = format[
	"<t align='center'><t size='2.2'>Side Mission</t><br/><t size='1.5' color='#00B2EE'>COMPLETE</t><br/>____________________<br/>Fantastic job, lads! The OPFOR stationed on the island won't last long if you keep that up!<br/><br/>We've given you %1 to help with the fight. You'll find it at base.<br/><br/>Focus on the main objective for now; we'll relay this success to the intel team and see if there's anything else you can do for us. We'll get back to you in 15 - 30 minutes.</t>",_vehName];

	_reward = createVehicle [_vehVarname, getMarkerPos "smReward1",smMarkerList,0,"NONE"];
	if (_reward isKindOf "UAV") then {createVehicleCrew _reward;} else {sleep 1;};
	waitUntil {!isNull _reward};
	_reward setDir 284;

	GlobalHint = _completeText; publicVariable "GlobalHint"; hint parseText _completeText;
	showNotification = ["CompletedSideMission", sideMarkerText]; publicVariable "showNotification";
	showNotification = ["Reward", format["Your team received %1!", _vehName]]; publicVariable "showNotification";
};

_unitSpawnPlus = PARAMS_AOSize;
_unitSpawnMinus = _unitSpawnPlus - (_unitSpawnPlus * 2);

AW_fnc_rewardPlusHintJet = {

private ["_veh","_vehName","_vehVarname","_completeTextJet","_reward"];

	_completeTextJet = format[
	"<t align='center'><t size='2.2'>Priority AO Target</t><br/><t size='1.5' color='#00B2EE'>Enemy Jet Neutralized</t><br/>____________________<br/>Fantastic job, lads! The OPFOR stationed on the island won't last long if you keep that up!<br/><br/>Focus on the main objective for now.</t>"];

	GlobalHint = _completeTextJet; publicVariable "GlobalHint"; hint parseText _completeTextJet;
	showNotification = ["EnemyJetDown", "Enemy Buzzard is down. Well Done!"]; publicVariable "showNotification";
};

AW_fnc_garrisonBuildings =
{
	_building = _this select 0;
	_faction = "OPF_F";
	_coef = 1;

	BIS_getRelPos = {
		_relDir = [_this, player] call BIS_fnc_relativeDirTo;
		_dist = [_this, player] call BIS_fnc_distance2D;
		_elev = ((getPosASL _this) select 2) - ((getPosASL player) select 2);
		_dir = (direction player) - direction _this;

		[_relDir, _dist, _elev, _dir];
	};

	_buildings = [
		"Land_Cargo_House_V1_F", [
			[216.049,-1.5,-1.0721207,-173.782],
			[-216.049,-0.5,-1.0721207,-173.782]
		],
		"Land_Cargo_House_V2_F", [
			[216.049,-0.5,-1.0721207,-173.782],
			[-216.049,-0.5,-1.0721207,-173.782]
		],
		"Land_Cargo_House_V3_F", [
			[216.049,-0.5,-1.0721207,-173.782],
			[-216.049,-0.5,-1.0721207,-173.782]
		],
		"Land_Cargo_HQ_V1_F", [
			[-89.3972,5.45408,-0.724457,-89.757],
			[160.876,5.95225,-0.59613,-0.245575],
			[30.379,5.37352,-3.03543,-32.9396],
			[49.9438,7.04951,-3.03488,1.15405],
			[109.73,7.20652,-3.12396,-273.082],
			[190.289,6.1683,-3.12094,-181.174],
			[212.535,6.83544,-3.1217,-154.507]
		],
		"Land_Cargo_HQ_V2_F", [
			[-89.3972,5.45408,-0.724457,-89.757],
			[160.876,5.95225,-0.59613,-0.245575],
			[30.379,5.37352,-3.03543,-32.9396],
			[49.9438,7.04951,-3.03488,1.15405],
			[109.73,7.20652,-3.12396,-273.082],
			[190.289,6.1683,-3.12094,-181.174],
			[212.535,6.83544,-3.1217,-154.507]
		],
		"Land_Cargo_HQ_V3_F", [
			[-89.3972,5.45408,-0.724457,-89.757],
			[160.876,5.95225,-0.59613,-0.245575],
			[30.379,5.37352,-3.03543,-32.9396],
			[49.9438,7.04951,-3.03488,1.15405],
			[109.73,7.20652,-3.12396,-273.082],
			[190.289,6.1683,-3.12094,-181.174],
			[212.535,6.83544,-3.1217,-154.507]
		],
		"Land_Cargo_Patrol_V1_F", [
			[84.1156,2.21253,-4.1396,88.6112],
			[316.962,3.81801,-4.14061,270.592],
			[31.6563,3.91418,-4.13602,-0.194908]

		],
		"Land_Cargo_Patrol_V2_F", [
			[84.1156,2.21253,-4.1396,88.6112],
			[316.962,3.81801,-4.14061,270.592],
			[31.6563,3.91418,-4.13602,-0.194908]

		],
		"Land_Cargo_Patrol_V3_F", [
			[84.1156,2.21253,-4.1396,88.6112],
			[316.962,3.81801,-4.14061,270.592],
			[31.6563,3.91418,-4.13602,-0.194908]

		],
		"Land_Cargo_Tower_V1_F", [
			[99.5325,3.79597,-4.62543,-271,3285],
			[-65.1654,4.17803,-8.59327,2,79],
			[-50.097,4.35226,-12.7691,2,703],
			[115.749,5.55055,-12.7623,-270,6282],
			[-143.89,7.92183,-12.9027,-180,867],
			[67.2957,6.75608,-15.4993,-270,672],
			[-68.9994,7.14031,-15.507,-88,597],
			[195.095,7.46374,-17.792,-182,651],
			[-144.962,8.67736,-17.7939,-178,337],
			[111.831,6.52689,-17.7889,-271,5161],
			[-48.2151,6.2476,-17.7976,-1,334],
			[-24.622,4.62995,-17.796,1,79]
		],
		"Land_Cargo_Tower_V2_F", [
			[99.5325,3.79597,-4.62543,-271,3285],
			[-65.1654,4.17803,-8.59327,2,79],
			[-50.097,4.35226,-12.7691,2,703],
			[115.749,5.55055,-12.7623,-270,6282],
			[-143.89,7.92183,-12.9027,-180,867],
			[67.2957,6.75608,-15.4993,-270,672],
			[-68.9994,7.14031,-15.507,-88,597],
			[195.095,7.46374,-17.792,-182,651],
			[-144.962,8.67736,-17.7939,-178,337],
			[111.831,6.52689,-17.7889,-271,5161],
			[-48.2151,6.2476,-17.7976,-1,334],
			[-24.622,4.62995,-17.796,1,79]
		],
		"Land_Cargo_Tower_V3_F", [
			[99.5325,3.79597,-4.62543,-271,3285],
			[-65.1654,4.17803,-8.59327,2,79],
			[-50.097,4.35226,-12.7691,2,703],
			[115.749,5.55055,-12.7623,-270,6282],
			[-143.89,7.92183,-12.9027,-180,867],
			[67.2957,6.75608,-15.4993,-270,672],
			[-68.9994,7.14031,-15.507,-88,597],
			[195.095,7.46374,-17.792,-182,651],
			[-144.962,8.67736,-17.7939,-178,337],
			[111.831,6.52689,-17.7889,-271,5161],
			[-48.2151,6.2476,-17.7976,-1,334],
			[-24.622,4.62995,-17.796,1,79]
		],
		"Land_i_Barracks_V1_F", [
			[66.6219,14.8599,-3.8678,94.6476],
			[52.0705,10.0203,-3.86142,4.09206],
			[11.4515,6.26249,-3.85385,1.42117],
			[306.455,10.193,-3.84314,0.0715332],
			[294.846,14.2778,-3.83774,-91.0892],
			[7.04782,1.86908,-0.502411,-90.3917],
			[86.3556,7.98911,-0.510651,129.846]
		],
		"Land_i_Barracks_V2_F", [
			[66.6219,14.8599,-3.8678,94.6476],
			[52.0705,10.0203,-3.86142,4.09206],
			[11.4515,6.26249,-3.85385,1.42117],
			[306.455,10.193,-3.84314,0.0715332],
			[294.846,14.2778,-3.83774,-91.0892],
			[7.04782,1.86908,-0.502411,-90.3917],
			[86.3556,7.98911,-0.510651,129.846]
		]
	];

	if (!(typeOf _building in _buildings)) exitWith {_newGrp = objNull; _newGrp};

	_paramsArray = (_buildings select ((_buildings find (typeOf _building)) + 1));
	_finalCnt = count _paramsArray;

	_newGrp = createGroup EAST;

	_units = ["O_Soldier_GL_F", "O_Soldier_AR_F"];

	{
		_pos =  [_building, _x select 1, (_x select 0) + direction _building] call BIS_fnc_relPos;
		_pos = [_pos select 0, _pos select 1, ((getPosASL _building) select 2) - (_x select 2)];
		_units select floor random 2 createUnit [_pos, _newGrp, "BIS_currentDude = this"];
		doStop BIS_currentDude;
		commandStop BIS_currentDude;
		BIS_currentDude setPosASL _pos;
		BIS_currentDude setUnitPos "UP";
		BIS_currentDude doWatch ([BIS_currentDude, 1000, direction _building + (_x select 3)] call BIS_fnc_relPos);
		BIS_currentDude setDir direction _building + (_x select 3);
	} forEach _paramsArray;
	[(units _newGrp)] call QS_setSkill2;
	_newGrp
};

AW_fnc_spawnUnits = {

private ["_randomPos","_spawnGroup","_pos","_x","_staticGroup","_static","_static2","_static3","_carGroup","_car","_apcGroup","_apc","_armourGroup","_armour","_aaGroup","_aa","_airGroup","_air","_airType","_blacklist","_overwatchGroup","_hawk","_hawkGroup","_wp","_sniperGroup","_reconGroup","_scoutGroup","_harass"];
_pos = getMarkerPos (_this select 0);
	_enemiesArray = [grpNull];
	_x = 0;

	for "_x" from 1 to PARAMS_SquadsPatrol do {
		_randomPos = [[[getMarkerPos currentAO, (PARAMS_AOSize / 1.2)],_dt],["water","out"]] call BIS_fnc_randomPos;
		_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSquad")] call BIS_fnc_spawnGroup;
		[_spawnGroup, getMarkerPos currentAO, 500] call BIS_fnc_taskPatrol;
		[(units _spawnGroup)] call QS_setSkill1;

		_enemiesArray = _enemiesArray + [_spawnGroup];
	};
	
	for "_x" from 1 to PARAMS_SquadsDefend do {
		_randomPos = [[[getMarkerPos currentAO, (PARAMS_AOSize / 4)],_dt],["water","out"]] call BIS_fnc_randomPos;
		_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "UInfantry" >> "OIA_GuardSquad")] call BIS_fnc_spawnGroup;
		[_spawnGroup, getMarkerPos currentAO, 200] call BIS_fnc_taskPatrol;	
		[(units _spawnGroup)] call QS_setSkill1;

		_enemiesArray = _enemiesArray + [_spawnGroup];
	};
	
	for "_x" from 1 to PARAMS_TeamsPatrol do {
		_randomPos = [[[getMarkerPos currentAO, PARAMS_AOSize],_dt],["water","out"]] call BIS_fnc_randomPos;
		_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam")] call BIS_fnc_spawnGroup;
		[_spawnGroup, getMarkerPos currentAO, 800] call BIS_fnc_taskPatrol;
		[(units _spawnGroup)] call QS_setSkill1;

		_enemiesArray = _enemiesArray + [_spawnGroup];
	};
	
	for "_x" from 1 to PARAMS_SniperTeamsPatrol do {
		_sniperGroup = createGroup east;
		_randomPos = [getMarkerPos currentAO, 1200, 100, 10] call BIS_fnc_findOverwatch;
		_sniperGroup = [_randomPos, EAST,(configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OI_SniperTeam")] call BIS_fnc_spawnGroup;
		[(units _sniperGroup)] call QS_setSkill3;
		_sniperGroup setBehaviour "COMBAT";
		
		_enemiesArray = _enemiesArray + [_sniperGroup];
	};
	
	for "_x" from 1 to PARAMS_ReconTeamsPatrol do {
		_reconGroup = createGroup east;
		_randomPos = [[[getMarkerPos currentAO, (PARAMS_AOSize * 1.25)],_dt],["water","out"]] call BIS_fnc_randomPos;
		_reconGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OI_reconTeam")] call BIS_fnc_spawnGroup;
		[_reconGroup, getMarkerPos currentAO, 1000] call BIS_fnc_taskPatrol;
		[(units _reconGroup)] call QS_setSkill2;

		_enemiesArray = _enemiesArray + [_reconGroup];
	};

	for "_x" from 1 to PARAMS_AirDefenseTeams do {
		_randomPos = [[[getMarkerPos currentAO, (PARAMS_AOSize * 1.1)],_dt],["water","out"]] call BIS_fnc_randomPos;
		_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam_AA")] call BIS_fnc_spawnGroup;
		[_spawnGroup, getMarkerPos currentAO, 1000] call BIS_fnc_taskPatrol;
		[(units _spawnGroup)] call QS_setSkill1;

		_enemiesArray = _enemiesArray + [_spawnGroup];
	};

	for "_x" from 1 to PARAMS_StaticMG do {
		_staticGroup = createGroup east;
		_randomPos = [getMarkerPos currentAO, 500, 10] call BIS_fnc_findOverwatch;
		_static = "O_HMG_01_high_F" createVehicle _randomPos;
		waitUntil{!isNull _static};
		
			"O_support_MG_F" createUnit [_randomPos,_staticGroup];
			((units _staticGroup) select 0) assignAsGunner _static;
			((units _staticGroup) select 0) moveInGunner _static;
		
		[(units _staticGroup)] call QS_setSkill2;
		_staticGroup setBehaviour "COMBAT";
		_static lock 3;
	
		_enemiesArray = _enemiesArray + [_staticGroup];
	};
	
	for "_x" from 1 to PARAMS_Overwatch do {
		_overwatchGroup = createGroup east;
		_randomPos = [getMarkerPos currentAO, 600, 50, 10] call BIS_fnc_findOverwatch;
		_overwatchGroup = [_randomPos, East, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam")] call BIS_fnc_spawnGroup;
		[_overwatchGroup, _randomPos, 50] call BIS_fnc_taskPatrol;
		[(units _overwatchGroup)] call QS_setSkill1;

		_enemiesArray = _enemiesArray + [_overwatchGroup];
	};
	
	for "_x" from 1 to PARAMS_CarsPatrol do {
		_carGroup = createGroup east;
		_randomPos = [[[getMarkerPos currentAO, PARAMS_AOSize],_dt],["water","out"]] call BIS_fnc_randomPos;
		if(random 1 < 0.75) then {_car = "O_MRAP_02_hmg_F" createVehicle _randomPos} else {_car = "O_MRAP_02_gmg_F" createVehicle _randomPos};
		waitUntil{!isNull _car};

			"O_Soldier_TL_F" createUnit [_randomPos,_carGroup];
			"O_soldier_repair_F" createUnit [_randomPos,_carGroup];
			((units _carGroup) select 0) assignAsDriver _car;
			((units _carGroup) select 1) assignAsGunner _car;
			((units _carGroup) select 0) moveInDriver _car;
			((units _carGroup) select 1) moveInGunner _car;
		
		[_carGroup, getMarkerPos currentAO, 700] call BIS_fnc_taskPatrol;

		[(units _carGroup)] call QS_setSkill1;
		_car lock 3;
	
		_enemiesArray = _enemiesArray + [_carGroup];
	};
	
	for "_x" from 1 to PARAMS_APCPatrol do {
		_apcGroup = createGroup east;
		_randomPos = [[[getMarkerPos currentAO, PARAMS_AOSize],_dt],["water","out"]] call BIS_fnc_randomPos;
		if(random 1 <= 0.50) then {_apc = "O_APC_Tracked_02_cannon_F" createVehicle _randomPos} else {_apc = "I_APC_tracked_03_cannon_F" createVehicle _randomPos};
		waitUntil{!isNull _apc};

			"O_officer_F" createUnit [_randomPos,_apcGroup];
			"O_soldier_repair_F" createUnit [_randomPos,_apcGroup];
			"O_officer_F" createUnit [_randomPos,_apcGroup];
			"O_Soldier_F" createUnit [_randomPos, _apcGroup];
			"O_Soldier_repair_F" createUnit [_randomPos, _apcGroup];
			"O_Soldier_repair_F" createUnit [_randomPos, _apcGroup];
			"O_Soldier_F" createUnit [_randomPos, _apcGroup];
			((units _apcGroup) select 0) assignAsDriver _apc;
			((units _apcGroup) select 1) assignAsGunner _apc;
			((units _apcGroup) select 2) assignAsCommander _apc;
			((units _apcGroup) select 0) moveInDriver _apc;
			((units _apcGroup) select 1) moveInGunner _apc;
			((units _apcGroup) select 2) moveInCommander _apc;

		[_apcGroup, getMarkerPos currentAO, 600] call BIS_fnc_taskPatrol;
		[(units _apcGroup)] call QS_setSkill1;
		_apc lock 3;
		
		_enemiesArray = _enemiesArray + [_apcGroup];
	};	

	for "_x" from 1 to PARAMS_ArmourPatrol do {
		_armourGroup = createGroup east;
		_randomPos = [[[getMarkerPos currentAO, (PARAMS_AOSize / 2)],_dt],["water","out"]] call BIS_fnc_randomPos;
		if(random 1 <= 0.5) then {_armour = "O_MBT_02_cannon_F" createVehicle _randomPos} else {_armour = "I_MBT_03_cannon_F" createVehicle _randomPos};
		waitUntil{!isNull _armour};

			"O_officer_F" createUnit [_randomPos,_armourGroup];
			"O_soldier_repair_F" createUnit [_randomPos,_armourGroup];
			"O_officer_F" createUnit [_randomPos,_armourGroup];
			"O_Soldier_repair_F" createUnit [_randomPos, _armourGroup];
			"O_Soldier_LAT_F" createUnit [_randomPos, _armourGroup];
			"O_Soldier_AR_F" createUnit [_randomPos, _armourGroup];
			"O_Soldier_AR_F" createUnit [_randomPos, _armourGroup];
			((units _armourGroup) select 0) assignAsDriver _armour;
			((units _armourGroup) select 1) assignAsGunner _armour;
			((units _armourGroup) select 2) assignAsCommander _armour;
			((units _armourGroup) select 0) moveInDriver _armour;
			((units _armourGroup) select 1) moveInGunner _armour;
			((units _armourGroup) select 2) moveInCommander _armour;
		
		[_armourGroup, getMarkerPos currentAO, 400] call BIS_fnc_taskPatrol;
		[(units _armourGroup)] call QS_setSkill2;
		_armour lock 3;
		
		_enemiesArray = _enemiesArray + [_armourGroup];
	};
	
	for "_x" from 1 to PARAMS_AAPatrol do {
		_aaGroup = createGroup east;
		_randomPos = [[[getMarkerPos currentAO, (PARAMS_AOSize / 2)],_dt],["water","out"]] call BIS_fnc_randomPos;
		_aa = "O_APC_Tracked_02_AA_F" createVehicle _randomPos;
		waitUntil{!isNull _aa};

			"O_officer_F" createUnit [_randomPos,_aaGroup];
			"O_soldier_repair_F" createUnit [_randomPos,_aaGroup];
			"O_officer_F" createUnit [_randomPos,_aaGroup];
			"O_Soldier_repair_F" createUnit [_randomPos, _aaGroup];
			"O_Soldier_F" createUnit [_randomPos, _aaGroup];
			((units _aaGroup) select 0) assignAsDriver _aa;
			((units _aaGroup) select 1) assignAsGunner _aa;
			((units _aaGroup) select 2) assignAsCommander _aa;
			((units _aaGroup) select 0) moveInDriver _aa;
			((units _aaGroup) select 1) moveInGunner _aa;
			((units _aaGroup) select 2) moveInCommander _aa;
		
		[_aaGroup, getMarkerPos currentAO, 500] call BIS_fnc_taskPatrol;
		[(units _aaGroup)] call QS_setSkill4;
		_aa lock 3;
		
		_enemiesArray = _enemiesArray + [_aaGroup];
	};
	
	if((random 10 <= PARAMS_AirPatrol)) then {
		_airGroup = createGroup east;
		_randomPos = [[[getMarkerPos currentAO, PARAMS_AOSize],_dt],["water","out"]] call BIS_fnc_randomPos;
		_airType = ["O_Heli_Attack_02_F","I_Heli_light_03_F"] call BIS_fnc_selectRandom;
		_air = _airType createVehicle [_randomPos select 0,_randomPos select 1,1000];
		waitUntil{!isNull _air};
		_air engineOn true;
		_air lock 3;
		_air setPos [_randomPos select 0,_randomPos select 1,300];

		_air spawn
		{
			private["_x"];
			for [{_x=0},{_x<=200},{_x=_x+1}] do
			{
				_this setVelocity [0,0,0];
				sleep 0.1;
			};
		};

		"O_helipilot_F" createUnit [_randomPos,_airGroup];
		((units _airGroup) select 0) assignAsDriver _air;
		((units _airGroup) select 0) moveInDriver _air;
		"O_helipilot_F" createUnit [_randomPos,_airGroup];
		((units _airGroup) select 1) assignAsGunner _air;
		((units _airGroup) select 1) moveInGunner _air;

		[_airGroup, getMarkerPos currentAO, 800] call BIS_fnc_taskPatrol;
		_air flyInHeight 300;
		[(units _airGroup)] call QS_setSkill4;
		
		_enemiesArray = _enemiesArray + [_airGroup];
	};

	{
		_newGrp = [_x] call AW_fnc_garrisonBuildings;
		if (!isNull _newGrp) then { _enemiesArray = _enemiesArray + [_newGrp]; };
	} forEach (getMarkerPos currentAO nearObjects ["House", 800]);

	_enemiesArray
};

//Set time of day
skipTime PARAMS_TimeOfDay;

//Begin generating side missions
if (PARAMS_SideMissions == 1) then { _null = [] execVM "sm\sideMissions.sqf"; };

//Begin generating priority targets
if (PARAMS_PriorityTargets == 1) then { _null = [] execVM "sm\priorityTargets.sqf"; };

_firstTarget = true;
_lastTarget = "Nothing";

while {count _targets > 0} do
{
	sleep 10;

	//Set new current target and calculate targets left
	if (_isPerpetual) then
	{
		_validTarget = false;
		while {!_validTarget} do
		{
			currentAO = _targets call BIS_fnc_selectRandom;
			if (currentAO != _lastTarget) then
			{
				_validTarget = true;
			};
			debugMessage = format["_validTarget = %1; %2 was our last target.",_validTarget,currentAO];
			publicVariable "debugMessage";
		};
	} else {
		currentAO = _targets call BIS_fnc_selectRandom;
		_targetsLeft = count _targets;
	};

	//Set currentAO for JIP updates
	publicVariable "currentAO";
	currentAOUp = true;
	publicVariable "currentAOUp";

	//Edit and place markers for new target
	{_x setMarkerPos (getMarkerPos currentAO);} forEach ["aoCircle","aoMarker"];
	"aoMarker" setMarkerText format["Take %1",currentAO];
	sleep 5;
	publicVariable "refreshMarkers";

	//Create AO detection trigger
	_dt = createTrigger ["EmptyDetector", getMarkerPos currentAO];
	_dt setTriggerArea [PARAMS_AOSize, PARAMS_AOSize, 0, false];
	_dt setTriggerActivation ["EAST", "PRESENT", false];
	_dt setTriggerStatements ["this","",""];

	//Spawn enemies
	_enemiesArray = [currentAO] call AW_fnc_spawnUnits;

	//Spawn radiotower
	_position = [[[getMarkerPos currentAO, PARAMS_AOSize],_dt],["water","out"]] call BIS_fnc_randomPos;
	_flatPos = _position isFlatEmpty[3, 1, 0.3, 30, 0, false];

	while {(count _flatPos) < 1} do
	{
		_position = [[[getMarkerPos currentAO, PARAMS_AOSize],_dt],["water","out"]] call BIS_fnc_randomPos;
		_flatPos = _position isFlatEmpty[3, 1, 0.3, 30, 0, false];
	};

	radioTower = "Land_TTowerBig_2_F" createVehicle _flatPos;
	waitUntil {sleep 0.5; alive radioTower};
	radioTower setVectorUp [0,0,1];
	radioTowerAlive = true;
	publicVariable "radioTowerAlive";
	"radioMarker" setMarkerPos (getPos radioTower);

	//Spawn mines
	_chance = random 10;
	if (_chance < PARAMS_RadioTowerMineFieldChance) then
	{
		_mines = [_flatPos] call AW_fnc_minefield;
		_enemiesArray = _enemiesArray + _mines;
		"radioMineCircle" setMarkerPos (getPos radioTower);
		"radioMarker" setMarkerText "Radiotower (Minefield)";
	} else {
		"radioMarker" setMarkerText "Radiotower";
	};

	publicVariable "radioTower";

	//Set target start text
	_targetStartText = format
	[
		"<t align='center' size='2.2'>New Target</t><br/><t size='1.5' align='center' color='#FFCF11'>%1</t><br/>____________________<br/>We did a good job with the last target, lads. I want to see the same again. Get yourselves over to %1 and take 'em all down!<br/><br/>Remember to take down that radio tower to stop the enemy from calling in CAS.",
		currentAO
	];

	if (!_isPerpetual) then
	{
		_targetStartText = format
		[
			"%1 Only %2 more targets to go!",
			_targetStartText,
			_targetsLeft
		];
	};

	//Show global target start hint
	GlobalHint = _targetStartText; publicVariable "GlobalHint"; hint parseText GlobalHint;
	showNotification = ["NewMain", currentAO]; publicVariable "showNotification";
	showNotification = ["NewSub", "Destroy the enemy radio tower."]; publicVariable "showNotification";
	
	if (PARAMS_AOReinforcementJet == 1) then { _null = [] execVM "sm\airDefense.sqf"; };

	/* =============================================== */
	/* ========= WAIT FOR TARGET COMPLETION ========== */
	/* =============================================== */
	
	waitUntil {sleep 5; count list _dt > PARAMS_EnemyLeftThreshhold};
	waitUntil {sleep 0.5; !alive radioTower};
	radioTowerAlive = false;
	publicVariable "radioTowerAlive";
	"radioMarker" setMarkerPos [-10000,-10000,-10000];
	_radioTowerDownText =
		"<t align='center' size='2.2'>Radio Tower</t><br/><t size='1.5' color='#08b000' align='center'>DESTROYED</t><br/>____________________<br/>The enemy radio tower has been destroyed! Fantastic job, lads!<br/><br/><t size='1.2' color='#08b000' align='center'> The enemy cannot call in anymore air support now!</t><br/>";
	GlobalHint = _radioTowerDownText; publicVariable "GlobalHint"; hint parseText GlobalHint;
	showNotification = ["CompletedSub", "Enemy radio tower destroyed."]; publicVariable "showNotification";

	waitUntil {sleep 5; count list _dt < PARAMS_EnemyLeftThreshhold};

	if (_isPerpetual) then
	{
		_lastTarget = currentAO;
		if ((count (_targets)) == 1) then
		{
			_targets = _initialTargets;
		} else {
			_targets = _targets - [currentAO];
		};
	} else {
		_targets = _targets - [currentAO];
	};

	publicVariable "refreshMarkers";
	currentAOUp = false;
	publicVariable "currentAOUp";

	//Delete detection trigger and markers
	deleteVehicle _dt;
	radioTowerAlive = true;
	publicVariable "radioTowerAlive";

	//Small sleep to let deletions process
	sleep 5;

	//Set target completion text
	_targetCompleteText = format
	[
		"<t align='center' size='2.2'>Target Taken</t><br/><t size='1.5' align='center' color='#FFCF11'>%1</t><br/>____________________<br/><t align='left'>Fantastic job taking %1, boys! Give us a moment here at HQ and we'll line up your next target for you.</t>",
		currentAO
	];

	{_x setMarkerPos [-10000,-10000,-10000];} forEach ["aoCircle","aoMarker","radioMineCircle"];

	//Show global target completion hint
	GlobalHint = _targetCompleteText; publicVariable "GlobalHint"; hint parseText GlobalHint;
	showNotification = ["CompletedMain", currentAO]; publicVariable "showNotification";

	//Set enemy kill timer
	[_enemiesArray] spawn AW_fnc_deleteOldAOUnits;

	// AI Retaliation by Jester [AW]
	if (PARAMS_DefendAO == 1) then
	{
	_aoUnderAttack = [] execVM "sm\aoRetake.sqf";
	waitUntil {scriptDone _aoUnderAttack};
	};
	
	publicVariable "refreshMarkers";
	currentAOUp = false;
	publicVariable "currentAOUp";

	//Delete detection trigger and markers
	deleteVehicle _dt;

	//Small sleep to let deletions process
	sleep 1;

	//Set target completion text
	_targetCompleteText = format
	[
		"<t align='center' size='2.2'>Target Defended</t><br/><t size='1.5' align='center' color='#00FF80'>%1</t><br/>____________________<br/><t align='left'>Fantastic job defending %1, boys! Give us a moment here at HQ and we'll line up your next target for you.</t>",
		currentAO
	];

	{_x setMarkerPos [-10000,-10000,-10000];} forEach ["aoCircle_2","aoMarker_2"];


	//Show global target completion hint
	GlobalHint = _targetCompleteText; publicVariable "GlobalHint"; hint parseText GlobalHint;
	showNotification = ["CompletedMainDefended", currentAO]; publicVariable "showNotification";
	sleep 5;
};
