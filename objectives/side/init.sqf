/***********************************************
|
|	TITLE: Side Mission Template
|	LOCATION: objectives/side/init.sqf
|	AUTHOR: Rarek [AW]
|	
|	DESCRIPTION
|		|	Initialises a Side Mission using this
|		|	template coupled with a "content" file
|		|	which is randomly selected from a folder.
|		└---------------------------------------
|
***********************************************/

private ["_sideObjs", "_genericObjs", "_sideMissions", "_missionDetails", "_spawnedObjects", "_title", "_briefObj", "_successMsg", "_failureMsg", "_posConditions", "_enemies", "_SM_Create", "_SM_Success", "_SM_Failure", "_enemiesArray"];

/***********************************************
|
|	You should only edit this part of the template
|	to include more Side Missions in I&A.
|
|	Editing any other part of this file may result
|	in your mission breaking.
*/
	_sideMissions = 
	[
		"land_destroyChopper",
		"land_destroyRadar",
		"land_destroyAntannae",
		"land_destroySmuggledExplosives",
		"land_disarmMines",
		"sea_disarmMines",
		"sea_recoverIntel"
	];
/*
|
|	It should be of note that you can name these
|	missions anything you like, so long as files
|	with identical names are placed in the relative
|	missions/ folder.
|
***********************************************/

AW_fnc_deleteObjects =
{
	/* Deletes all objects / groups in the passed array */
	private	["_unitsArray"];
	_unitsArray = _this select 0;

	for "_c" from 0 to (count _unitsArray) do
	{
		_obj = _unitsArray select _c;
		_isGroup = false;
		if (_obj in allGroups) then { _isGroup = true; } else { _isGroup = false; };
		if (_isGroup) then
		{
			{
				if (!isNull _x) then { deleteVehicle _x; };
			} forEach (units _obj);
			deleteGroup _obj;
		} else {
			if (!isNull _obj) then { deleteVehicle _obj; };
		};
	};
};

AW_fnc_distanceCheck =
{
	private ["_pos", "_distanceChecks"]; _pos = _this select 0; _isGoodPos = true;
	_distanceChecks = [["respawn_west", 1000], ["priorityMarker", 300], [currentAO, PARAMS_AOSize]];
	{
		scopeName "distanceCheck";
		_marker		= _x select 0;
		_distance   = _x select 1;
		if (_sidePos distance (getMarkerPos _marker) < _distance) then { _isGoodPos = false; breakOut "distanceCheck"; };
	} forEach _distanceChecks;

	{
		scopeName "playerDistanceCheck"; 
		if (_sidePos distance _x < 500) then { _isGoodPos = false; breakOut "playerDistanceCheck"; };
	} forEach playableUnits;

	_isGoodPos
};

{ _x = nil; } forEach [_title, _briefObj, _successMsg, _failureMsg, _posType, _mustBeFlat, _SM_Create, _SM_Enemies, _SM_Success, _SM_Failure];
_sideObjs = [];
_enemiesArray = [];
_randomSideIndex = _sideMissions select (round(random ((count _sideMissions) - 1)));
call compile preProcessFileLineNumbers format["objectives/side/missions/%1.sqf", _randomSideIndex];

{
	if (isNull _x) exitWith { /* Log debug error message here */ };
} forEach [_title, _briefObj, _successMsg, _posType, _mustBeFlat, _SM_Create, _SM_Enemies, _SM_Success, _SM_Failure];

/* Find our position */
_sidePos = []; _isGoodPos = false;
switch (_posType) do
{
	case "land":
	{
		while {!_isGoodPos} do
		{
			_isGoodPos = true; _sidePos = [];
			while {(count _sidePos) < 1} do
			{
				_randomPos = [] call BIS_fnc_randomPos;
				_sidePos = _randomPos isFlatEmpty [5, 1, 0.5, 10, 0, false];
			};
			_isGoodPos = [_sidePos] call AW_fnc_distanceCheck;
		};
	};

	case "road":
	{
		_roadList = island nearRoads 4000; /* Change to island-cover function */
		while {!_isGoodPos} do
		{
			_road = _roadList call BIS_fnc_selectRandom;
			_sidePos = getPos _road;
			_isGoodPos = [_sidePos] call AW_fnc_distanceCheck;
		};
	};

	case "shore":
	{
		/* Use Explosives Coast as an example */
	};

	case "water":
	{
		/* Whitelist water / blacklist land etc */
	};

	case "urban":
	{
		/* Central positions of all urban areas e.g.cities, towns etc */
	};

	case "custom":
	{
		_sidePos = [] call _SM_Pos;
	};
};

_spawnedObjects = [_sidePos] call _SM_Create;
_sideObjs = _spawnedObjects select 0;
_genericObjs = _spawnedObjects select 1;

{
	_groupClass = _x select 0;
	_groupCount = _x select 1;
	_groupBehaviour = _x select 2;
	_groupSpawnDistance = _x select 3;
	_groupWaypointDistance = _x select 4;

	for "_c" from 0 to _groupCount do
	{
		_randomPos = [[[_sidePos, _groupSpawnDistance]],["water","out"]] call BIS_fnc_randomPos;
		_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSquad")] call BIS_fnc_spawnGroup;
		if (_groupBehaviour == "defend") then
		{
			[_spawnGroup, _randomPos] call bis_fnc_taskDefend;
		} else {
			[_spawnGroup, _randomPos, _groupWaypointDistance] call bis_fnc_taskPatrol;
		};

		_enemiesArray = _enemiesArray + [_spawnGroup];
	};
} forEach _SM_Enemies;

_fuzzyPos =
[
	((_sidePos select 0) - 300) + (random 600),
	((_sidePos select 1) - 300) + (random 600),
	0
];

{ _x setMarkerPos _fuzzyPos; } forEach ["sideMarker", "sideCircle"];
"sideMarker" setMarkerText format["Side Mission: %1", _title]; publicVariable "sideMarker";
sideMarkerText = _title; publicVariable "sideMarkerText";

sideMissionUp = true; publicVariable "sideMissionUp";
showNotification = ["NewSideMission", _briefObj]; publicVariable "showNotification";

_hasSucceeded = false; _hasFailed = false;

while {sideMissionUp} do
{
	sleep 5;
	_hasSucceeded = false; _hasSucceeded = [_sideObjs] call _SM_Success;
	_hasFailed = false; _hasFailed = [_sideObjs] call _SM_Failure;
	if (_hasSucceeded || _hasFailed) then { sideMissionUp = false; publicVariable "sideMissionUp"; };
};

if (_hasSucceeded) then
{
	showNotification = ["CompletedSideMission", _successMsg]; publicVariable "showNotification";

	_veh = smRewards call BIS_fnc_selectRandom;
	_vehName = _veh select 0;
	_vehClassName = _veh select 1;

	_reward = createVehicle [_vehClassName, getMarkerPos "smReward1", smMarkerList, 0, "NONE"];
	waitUntil {alive _reward};
	_reward setDir 284;

	showNotification = ["Reward", format["Your team received %1!", _vehName]]; publicVariable "showNotification";
} else {
	_notifMsg = _briefObj; if (!isNil _failureMsg) then { _notifMsg = _failureMsg; };
	showNotification = ["FailedSideMission", _notifMsg]; publicVariable "showNotification";
};

[] spawn { [_sideObjs] call AW_fnc_deleteObjects; };
[] spawn { [_genericObjs] call AW_fnc_deleteObjects; };

{ _x setMarkerPos [0,0,0]; } forEach ["sideMarker", "sideCircle"]; publicVariable "sideMarker";