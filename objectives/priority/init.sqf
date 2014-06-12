private ["_priortyTargets", "_vars", "_markers", "_tickTime", "_spawnedObjs", "_allobjs", "_priorityObjs", "_randomPriority", "_debugHeader", "_pos", "_PT_Pos", "_PT_Create", "_PT_Run", "_fuzzyMarkerPos", "_outcome", "_title", "_briefMsg", "_successMsg", "_failureMsg", "_genericObjs", "_runningMission", "_hasSucceeded", "_hasFailed", "_groupClass", "_groupCount", "_groupBehaviour", "_groupSpawnDistance", "_groupWaypointDistance", "_randomPos", "_spawnGroup", "_unitsArray"];

_priortyTargets = 
[
	"land_destroyEMP"
];

call compile preProcessFileLineNumbers "functions.sqf";

_vars =
[
	_title,
	_briefMsg,
	_successMsg,
	_failureMsg,
	_PT_Pos,
	_PT_Create,
	_PT_Run
];

_markers = ["priorityMarker", "_priorityCircle"];
_tickTime = PARAMS_PriorityTargetTickTime; /* DEBUG */ _tickTime = 10;

while { true } do
{
	{ _x = nil; } forEach _vars; _spawnedObjs = []; _priorityObjs = []; _pos = []; _unitsArray = [];

	_randomPriority = _priortyTargets select (round(random ((count _priortyTargets) - 1)));
	call compile preProcessFileLineNumbers format["objectives\priority\missions/%1.sqf", _randomPriority];
	_debugHeader = format["Error in <t color='#FF8000'>objectives/priority/missions/%1.sqf</t> mission file.<br/>", _randomPriority];

	{ if (isNull _x) then { debugMessage = format["%1Variable <t color='#FF8000'>%2</t> not found.", _debugHeader, _x]; publicVariable "debugMessage"; }; } forEach _vars;

	while { true } do
	{
		_pos = [] call _PT_Pos;
		_accepted = [_pos] call AW_fnc_distanceCheck;
		if (_accepted) exitWith {};
		sleep 0.5;
	};
	if ((count _pos) < 3) then { debugMessage = format["%1Function <t color='#FF8000'>_PT_Pos</t> not returning valid position.<br/><t color='#FF8000'>Returned:</t> %2", _debugHeader, _pos]; };

	_spawnedObjs = [_pos] call _PT_Create; _priorityObjs = _spawnedObjs select 0; _genericObjs = _spawnedObjs select 1;

	{
		_groupClass = _x select 0;
		_groupCount = _x select 1;
		_groupBehaviour = _x select 2;
		_groupSpawnDistance = _x select 3;
		_groupWaypointDistance = _x select 4;

		for "_c" from 0 to _groupCount do
		{
			_randomPos = [[[_pos, _groupSpawnDistance]],["water","out"]] call BIS_fnc_randomPos;
			_spawnGroup = [_randomPos, EAST, _groupClass] call BIS_fnc_spawnGroup;
			if (_groupBehaviour == "defend") then
			{
				[_spawnGroup, _randomPos] call bis_fnc_taskDefend;
			} else {
				[_spawnGroup, _randomPos, _groupWaypointDistance] call bis_fnc_taskPatrol;
			};

			_unitsArray = _unitsArray + [_spawnGroup];
		};
	} forEach _PT_Enemy;

	_allObjs = _spawnedObjs + _unitsArray;

	_fuzzyMarkerPos =
	[
		((_pos select 0) - 300) + (random 600),
		((_pos select 1) - 300) + (random 600),
		0
	];
	{ _x setMarkerPos _fuzzyMarkerPos; } forEach _markers;
	priorityMarkerText = _title; publicVariable "priorityMarkerText";
	"priorityMarker" setMarkerText format["Priority Target: %1", priorityMarkerText]; publicVariable "priorityMarker";

	priorityTargetUp = true; publicVariable "priorityTargetUp";
	showNotification = ["NewPriorityTarget", _briefMsg]; publicVariable "showNotification";

	_runningMission = [_pos, _priorityObjs] spawn _PT_Run;

	_hasSucceeded = false; _hasFailed = false;
	while { true } do
	{
		sleep 5;
		_hasSucceeded = [_pos, _priorityObjs] call _PT_Success;
		_hasFailed = [_pos, _priorityObjs] call _PT_Failure;
		if (_hasSucceeded || _hasFailed) exitWith {};
	};

	terminate _runningMission;

	if (_hasSucceeded) then
	{
		showNotification = ["CompletedPriorityTarget", _successMsg]; publicVariable "showNotification";
	} else {
		showNotification = ["FailedPriorityTarget", _failureMsg]; publicVariable "showNotification";
	};

	{ _x setMarkerPos [0,0,0]; } forEach _markers;

	priorityTargetUp = false; publicVariable "priorityTargetUp";
	[] spawn { [_allObjs] call AW_fnc_deleteObjects; };

	sleep (random (900 + 2700));
};