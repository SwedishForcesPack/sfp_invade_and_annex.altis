/*
      ::: ::: :::             ::: :::             ::: 
     :+: :+:   :+:           :+:   :+:           :+:  
    +:+ +:+     +:+         +:+     +:+         +:+   
   +#+ +#+       +#+       +#+       +#+       +#+    
  +#+ +#+         +#+     +#+         +#+     +#+     
 #+# #+#           #+#   #+#           #+#   #+#      
### ###             ### ###             ### ###      

| AHOY WORLD | ARMA 3 ALPHA | STRATIS DOMI VER 2.82 |

Creating working missions of this complexity from
scratch is difficult and time consuming, please
credit http://www.ahoyworld.co.uk for creating and
distibuting this mission when hosting!

This version of Domination was lovingly crafted by
Jack Williams (Rarek) for Ahoy World!
*/

#define WELCOME_MESSAGE	"Welcome to Ahoy World's Invade & Annex\n" +\
						"by Rarek (Ahoy World)\n\n" +\
						"To follow / aid in the development of this map, please register at\n" +\
						"www.AhoyWorld.co.uk\n\n" +\
						"...and feel free to join us on TeamSpeak at\n" +\
						"ts.ahoyworld.co.uk:9987"
						
						
/* =============================================== */
/* =============== GLOBAL VARIABLES ============== */

/*
	These targets are simply markers on the map with
	the same name.
	
	Each AO will be a randomly-picked "target" from
	this list which will be removed upon completion.
	
	To ensure the mission works, make sure that any
	new targets you add have a relevant marker on
	the mission map.
	
	You can NOT have an AO called "Nothing".
*/

private ["_pos","_uavAction","_isAdmin","_i","_isPerpetual","_accepted","_position","_randomWreck","_firstTarget","_validTarget","_targetsLeft","_flatPos","_targetStartText","_lastTarget","_targets","_dt","_enemiesArray","_radioTowerDownText","_targetCompleteText","_null","_unitSpawnPlus","_unitSpawnMinus","_missionCompleteText"];

/* 
	Custom radio channels to come...

		_mainIndex = radioChannelCreate [
			[1.0, 0.81, 0.06],
			"Main AO Channel",
			"%UNIT_NAME",
			[player]
		];
*/

_targets = [
	"Agia Marina and Firing Range",
	"Camp Rogain",
	"Kamino Firing Range",
	"Air Station Mike 26",
	"Camp Maxwell",
	"Girna",
	"Camp Tempest"
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

"GlobalHint" addPublicVariableEventHandler
{
	private ["_GHint"];
	_GHint = _this select 1;
	hint parseText format["%1", _GHint];
};

"radioTower" addPublicVariableEventHandler
{
	"radioMarker" setMarkerPosLocal (markerPos "radioMarker");
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

"sideMarker" addPublicVariableEventHandler
{
	"sideMarker" setMarkerPosLocal (markerPos "sideMarker");
	"sideMarker" setMarkerTextLocal format["Side Mission: %1",sideMarkerText];
};

"priorityMarker" addPublicVariableEventHandler
{
	"priorityMarker" setMarkerPosLocal (markerPos "priorityMarker");
	"priorityMarker" setMarkerTextLocal format["Priority Target: %1",priorityTargetText];
};

"aw_addAction" addPublicVariableEventHandler
{
	_obj = (_this select 1) select 0;
	_actionArray = [(_this select 1) select 1, (_this select 1) select 2];
	_obj addAction _actionArray;
};

"aw_removeAction" addPublicVariableEventHandler
{
	_obj = (_this select 1) select 0;
	_id = (_this select 1) select 1;
	_obj removeAction _id;
};

"aw_unitSay" addPublicVariableEventHandler
{
	_obj = (_this select 1) select 0;
	_sound = (_this select 1) select 1;
	_obj say [_sound,15];
};

"hqSideChat" addPublicVariableEventHandler
{
	_message = _this select 1;
	[WEST,"HQ"] sideChat _message;
};

"debugMessage" addPublicVariableEventHandler
{
	_isAdmin = serverCommandAvailable "#kick";
	if (_isAdmin) then
	{
		if (debugMode) then
		{
			_message = _this select 1;
			hint parseText format["<t size='2.2' align='center'>Debug Mode</t><br/>____________________<br/>%1",_message];
		};
	};
};


/* =============================================== */
/* ================ PLAYER SCRIPTS =============== */

if (PARAMS_SpawnProtection == 1) then { _null = [] execVM "grenadeStop.sqf"; };
if (PARAMS_ViewDistance == 1) then { _null = [] execVM "taw_vd\init.sqf"; };
if (PARAMS_PilotsOnly == 1) then { _null = [] execVM "pilotCheck.sqf"; };
if (PARAMS_ReviveEnabled == 1) then 
{
	call compile preprocessFile "=BTC=_revive\=BTC=_revive_init.sqf";

	if (PARAMS_MedicMarkers == 1) then
	{
		_null = [] execVM "misc\medicMarkers.sqf";
	};
};
if (PARAMS_PlayerMarkers == 1) then { _null = [] execVM "misc\playerMarkers.sqf"; };

[] spawn {
	scriptName "initMission.hpp: mission start";
	["rsc\FinalComp.ogv", false] spawn BIS_fnc_titlecard;
	waitUntil {!(isNil "BIS_fnc_titlecard_finished")};
	[[1864.000,5565.000,0],"We've gotten a foot-hold on the island,|but we need to take the rest.|Listen to HQ and neutralise all enemies designated."] spawn BIS_fnc_establishingShot;
	titleText [WELCOME_MESSAGE, "PLAIN", 3];
};

if (!isServer) then
{
	if (radioTowerAlive) then
	{
		"radioMarker" setMarkerPosLocal (getPos radioTower);
	} else {
		"radioMarker" setMarkerPosLocal [0,0,0];
	};
	
	if (sideMissionUp) then
	{
		"sideMarker" setMarkerPosLocal (getPos sideObj);
		"sideMarker" setMarkerTextLocal format["Side Mission: %1",sideMarkerText];
	} else {
		"sideMarker" setMarkerPosLocal [0,0,0];
	};
	
	if (priorityTargetUp) then
	{
		_pos = [0,0,0];
		if (alive priorityTarget1) then
		{
			_pos = getPos priorityTarget1;
		} else {
			_pos = getPos priorityTarget2;
		};
		"priorityMarker" setMarkerPosLocal _pos;
		"priorityMarker" setMarkerTextLocal format["Priority Target: %1",priorityTargetText];
	} else {
		"priorityMarker" setMarkerPosLocal [0,0,0];
	};

	if (currentAOUp) then
	{
		{
			_x setMarkerPosLocal (getMarkerPos currentAO);
		} forEach ["aoCircle","aoMarker"];
		"aoMarker" setMarkerTextLocal format["Take %1",currentAO];
	} else {
		{
			_x setMarkerPosLocal [0,0,0];
		} forEach ["aoCircle","aoMarker"];
	};
	
	_uavAction = player addAction 
	[
		"<t color='#FFCF11'>Activate Personal UAV</t>",
		"uavView.sqf",
		[
			currentAO
		],
		0,
		false,
		true
	];
};

if (!isServer) exitWith
{
	_spawnBuildings = nearestObjects [(getMarkerPos "respawn_west"), ["building"], 800];

	{
		_x allowDamage false;
	} forEach _spawnBuildings;

	while {true} do
	{
		_isAdmin = serverCommandAvailable "#kick";
		if (_isAdmin) then
		{
			1 setRadioMsg "Toggle Debug Mode";
			2 setRadioMsg "Debug Information";
			3 setRadioMsg "Skip AO (N/A)";
			4 setRadioMsg "Destroy Side Mission";
			5 setRadioMsg "Skip Priority Target (N/A)";
		} else {
			{ _x setRadioMsg "NULL"; } forEach [1,2,3,4,5];
		};
		waitUntil {!alive player};
		waitUntil {alive player};
		_uavAction = player addAction 
		[
			"<t color='#FFCF11'>Activate Personal UAV</t>",
			"uavView.sqf",
			[
				currentAO
			],
			0,
			false,
			true
		];
	};
};


/* =============================================== */
/* ============ SERVER INITIALISATION ============ */

//Set a few blank variables for event handlers and solid vars for SM
debugMode = false;
eastSide = createCenter EAST;
sideMissionUp = false;
refreshMarkers = true;
sideObj = objNull;
priorityTargets = ["None"];
smRewards = 
[
	["an AH-9", "B_AH9_F"],
	["an MH-9", "B_MH9_F"],
	["a Hunter GMG", "B_Hunter_RCWS_F"],
	["a Hunter HMG", "B_Hunter_HMG_F"],
	["an off-road jeep", "c_offroad"]
];
smMarkerList = 
["smReward1","smReward2","smReward3","smReward4","smReward5","smReward6","smReward7","smReward8","smReward9","smReward10","smReward11","smReward12","smReward13","smReward14","smReward15","smReward16","smReward17","smReward18","smReward19","smReward20","smReward21","smReward22","smReward23","smReward24","smReward25","smReward26","smReward27"];

//Run a few miscellaneous server-side scripts
_null = [] execVM "misc\clearBodies.sqf";
_null = [] execVM "misc\clearItems.sqf";

/* PARAM-DEPENDANT SETTINGS */
if (PARAMS_FPSSaver == 1) then { [2500] execfsm "misc\fpsManager.fsm"; };

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

AW_fnc_markerActivate = {
	
private ["_mrk"];
_mrk = _this select 0;
	_mrk setMarkerShape "ELLIPSE";
	_mrk setMarkerSize [PARAMS_AOSize, PARAMS_AOSize];
	_mrk setMarkerBrush "FDiagonal";
	_mrk setMarkerColor "ColorRed";
	publicVariable _mrk;
};

AW_fnc_markerDeactivate = {
	
private ["_mrk"];
_mrk = _this select 0;
	_mrk setMarkerShape "ICON";
	_mrk setMarkerSize [1, 1];
	_mrk setMarkerType "Empty";
	_mrk setMarkerColor "Default";
	publicVariable _mrk;
};

AW_fnc_deleteOldAOUnits = {
	
private ["_group","_groupsToKill","_c"];
_groupsToKill = _this select 0;
	_c = 0;
	
	sleep 600;
	
	debugMessage = "Deleting old AO units...";
	publicVariable "debugMessage";
	
	for "_c" from 0 to (count _groupsToKill) do
	{
		_group = _groupsToKill select _c;
		{
			deleteVehicle _x;
		} forEach (units _group);
		waitUntil {(count (units _group)) == 0};
		deleteGroup _group;
	};
	
	debugMessage = "Old AO units deleted.";
	publicVariable "debugMessage";
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
	waitUntil {alive _reward};
	_reward setDir 284;
	
	GlobalHint = _completeText;
	publicVariable "GlobalHint";
	hint parseText _completeText;
};

_unitSpawnPlus = PARAMS_AOSize;
_unitSpawnMinus = _unitSpawnPlus - (_unitSpawnPlus * 2);

AW_fnc_spawnUnits = {
	
private ["_randomPos","_spawnGroup","_pos","_x"];
_pos = getMarkerPos (_this select 0);
	_enemiesArray = [grpNull];
	
	_x = 0;
	for "_x" from 0 to PARAMS_SquadsPatrol do {
		_randomPos = [[[getMarkerPos currentAO, PARAMS_AOSize],_dt],["water","out"]] call BIS_fnc_randomPos;
		_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSquad")] call BIS_fnc_spawnGroup;
		[_spawnGroup, _pos, 200] call bis_fnc_taskPatrol;
		
		_enemiesArray = _enemiesArray + [_spawnGroup];
	}; 
	
	_x = 0;
	for "_x" from 0 to PARAMS_SquadsDefend do {
		_randomPos = [[[getMarkerPos currentAO, PARAMS_AOSize],_dt],["water","out"]] call BIS_fnc_randomPos;
		_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSquad")] call BIS_fnc_spawnGroup;
		[_spawnGroup, _pos] call BIS_fnc_taskDefend;
		
		_enemiesArray = _enemiesArray + [_spawnGroup];
	};
	
	x = 0;
	for "_x" from 0 to PARAMS_TeamsPatrol do {
		_randomPos = [[[getMarkerPos currentAO, 20],_dt],["water","out"]] call BIS_fnc_randomPos;
		_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam")] call BIS_fnc_spawnGroup;
		[_spawnGroup, _pos, 200] call bis_fnc_taskPatrol;
		
		_enemiesArray = _enemiesArray + [_spawnGroup];
	};
	
	_x = 0;
	for "_x" from 0 to PARAMS_CarsPatrol do {
		_randomPos = [[[getMarkerPos currentAO, PARAMS_AOSize],_dt],["water","out"]] call BIS_fnc_randomPos;
		_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Motorized_MTP" >> "OIA_MotInfTeam")] call BIS_fnc_spawnGroup;
		[_spawnGroup, _pos, 200] call bis_fnc_taskPatrol;
		
		_enemiesArray = _enemiesArray + [_spawnGroup];
	};
	
	_enemiesArray
};

//Set time of day
skipTime PARAMS_TimeOfDay;

//Set weather
0 setWindForce random 1;
0 setWindDir random 360;
0 setGusts random 1;

switch (PARAMS_Weather) do 
{
	case 1: {
		0 setOvercast 0;
		0 setRain 0;
		0 setFog 0;
	};
	
	case 2: {
		0 setOvercast 1;
		0 setRain 1;
		0 setFog 0.2;
		0 setGusts 1;
		0 setLightnings 1;
		0 setWaves 1;
		0 setWindForce 1;
	};
	
	case 3: {
		0 setOvercast 0.7;
		0 setRain 0;
		0 setFog 0;
		0 setGusts 0.7;
		0 setWaves 0.7;
		0 setWindForce 0.7;
	};
	
	case 4: {
		0 setOvercast 0.7;
		0 setRain 1;
		0 setFog 0.7;
	};
};

//Spawn random wrecks
if (PARAMS_PriorityTargets == 1) then
{
	{
		_accepted = false;
		_position = [0,0,0];
		while {!_accepted} do
		{
			_position = [] call BIS_fnc_randomPos;
			if (_position distance (getMarkerPos "respawn_west") > 800) then
			{
				_accepted = true;
			};
		};
		_randomWreck = _x createVehicle _position;
		_randomWreck setDir (random 360);
	} forEach ["Land_Wreck_Commanche_F","Land_UWreck_Mv22_F","Land_UWreck_Mv22_F","Land_Wreck_Offroad_F","Land_Wreck_Offroad_F","Land_Wreck_Offroad_F","Land_Wreck_Offroad_F","Land_Wreck_Offroad_F","Land_Wreck_Truck_dropside_F","Land_Wreck_Truck_F","Land_Wreck_Car_F","Land_Wreck_Car2_F","Land_Wreck_Car3_F"];
};

//Begin generating side missions
if (PARAMS_SideMissions == 1) then { _null = [] execVM "sm\sideMissions.sqf"; };

//Begin generating priority targets
if (PARAMS_PriorityTargets == 1) then { _null = [] execVM "sm\priorityTargets.sqf"; };

//Begin creating random patrols
// _null = [] execVM "randomPatrols.sqf";

_firstTarget = true;

while {count _targets > 0} do
{
	//Wait a small while before assigning a new target
	if (!_firstTarget) then
	{
		debugMessage = "Not first target; waiting between 10 and 120 seconds before assigning new AO.";
		publicVariable "debugMessage";
		sleep (10 + (random 110));
	} else {
		debugMessage = "First target. Waiting 10 seconds before assigning new AO.";
		publicVariable "debugMessage";
		sleep 10;
		_firstTarget = false;
	};
	
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
	
	//Set currentAO for UAVs and JIP updates
	publicVariable "currentAO";
	currentAOUp = true;
	publicVariable "currentAOUp";
	
	//Edit and place markers for new target
	//_marker = [currentAO] call AW_fnc_markerActivate;
	{_x setMarkerPos (getMarkerPos currentAO);} forEach ["aoCircle","aoMarker"];
	"aoMarker" setMarkerText format["Take %1",currentAO];
	sleep 5;
	publicVariable "refreshMarkers";
	
	//Create AO detection trigger
	_dt = createTrigger ["EmptyDetector", getMarkerPos currentAO];
	_dt setTriggerArea [PARAMS_AOSize, PARAMS_AOSize, 0, false];
	_dt setTriggerActivation ["EAST", "PRESENT", false];
	_dt setTriggerStatements ["this","",""];
	
	//Spawn radiotower
	_position = [[[getMarkerPos currentAO, PARAMS_AOSize],_dt],["water","out"]] call BIS_fnc_randomPos;
	_flatPos = _position isFlatEmpty[3, 1, 0.7, 20, 0, false];
		
	while {(count _flatPos) < 1} do
	{
		_position = [[[getMarkerPos currentAO, PARAMS_AOSize],_dt],["water","out"]] call BIS_fnc_randomPos;
		_flatPos = _position isFlatEmpty[3, 1, 0.7, 20, 0, false];	
	};
	
	radioTower = "Land_TTowerBig_2_F" createVehicle _flatPos;
	waitUntil {alive radioTower};
	radioTower setVectorUp [0,0,1];
	publicVariable "radioTower";
	radioTowerAlive = true;
	publicVariable "radioTowerAlive";
	"radioMarker" setMarkerPos (getPos radioTower);
	
	//Spawn enemies
	_enemiesArray = [currentAO] call AW_fnc_spawnUnits;
	
	//Set target start text
	_targetStartText = format
	[
		"<t align='center' size='2.2'>New Target</t><br/><t size='1.5' align='center' color='#FFCF11'>%1</t><br/>____________________<br/>We did a good job with the last target, lads. I want to see the same again. Get yourselves over to %1 and take 'em all down!<br/><br/>Remember to take down that radio tower so you can use your Personal UAVs, too.",
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
	GlobalHint = _targetStartText;
	publicVariable "GlobalHint";
	hint parseText GlobalHint;
	
	/* =============================================== */
	/* ========= WAIT FOR TARGET COMPLETION ========== */
	waitUntil {count list _dt > PARAMS_EnemyLeftThreshhold};
	waitUntil {!alive radioTower};
	radioTowerAlive = false;
	publicVariable "radioTowerAlive";
	"radioMarker" setMarkerPos [0,0,0];
	_radioTowerDownText = 
		"<t align='center' size='2.2'>Radio Tower</t><br/><t size='1.5' color='#08b000' align='center'>DESTROYED</t><br/>____________________<br/>The enemy radio tower has been destroyed! Fantastic job, lads! You're now all free to use your Personal UAVs!<br/><br/>Keep up the good work, lads; we're countin' on you.";
	GlobalHint = _radioTowerDownText;
	publicVariable "GlobalHint";
	hint parseText GlobalHint;
	
	waitUntil {count list _dt < PARAMS_EnemyLeftThreshhold};
	
	//Set enemy kill timer
	[_enemiesArray] spawn AW_fnc_deleteOldAOUnits;

	//Delete markers and trigger
	if (_isPerpetual) then 
	{
		//_perimeterMarker = [currentAO] call AW_fnc_markerDeactivate;
		_lastTarget = currentAO;
		publicVariable "refreshMarkers";
	} else {
		_targets = _targets - [currentAO];
		//deleteMarker currentAO;
	};
	
	{_x setMarkerPos [0,0,0];} forEach ["aoCircle","aoMarker"];
	
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
	
	//Show global target completion hint
	GlobalHint = _targetCompleteText;
	publicVariable "GlobalHint";
	hint parseText GlobalHint;
};

//Set completion text
_missionCompleteText = "<t align='center' size='2.0'>Congratulations!</t><br/>
<t size='1.2' align='center'>You've successfully completed Ahoy World Invade &amp; Annex!</t><br/>
____________________<br/>
<br/>
Thank you so much for playing and we hope to see you in the future. For more and to aid in the development of this mission, please visit www.AhoyWorld.co.uk.<br/>
<br/>
The game will return to the mission screen in 30 seconds. Consider turning Perpetual Mode on in the parameters to make the game play infinitely.";
	
//Show global mission completion hint
GlobalHint = _missionCompleteText;
publicVariable "GlobalHint";
hint parseText GlobalHint;

//Wait 30 seconds
sleep 30;

//End mission
endMission "END1";