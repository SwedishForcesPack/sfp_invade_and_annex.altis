//by Rarek [AW]

private ["_firstRun","_isGroup","_obj","_position","_flatPos","_nearUnits","_accepted","_debugCounter","_pos","_barrier","_dir","_unitsArray","_randomPos","_spawnGroup","_unit","_targetPos","_debugCount","_radius","_randomWait","_briefing","_flatPosAlt","_flatPosClose","_priorityGroup","_distance","_firingMessages","_completeText"];
_firstRun = true;
_unitsArray = [objNull];
_completeText =
"<t align='center' size='2.2'>Priority Target</t><br/><t size='1.5' color='#08b000'>NEUTRALISED</t><br/>____________________<br/>Incredible job, boys! Make sure you jump on those priority targets quickly; they can really cause havoc if they're left to their own devices.<br/><br/>Keep on with the main objective; we'll tell you if anything comes up.";
while {true} do
{
	_randomWait = (random 4800);
	sleep (600 + _randomWait);
	if (_firstRun) then
	{
		_firstRun = false;
	} else {
		//Delete old PT objects
		for "_c" from 0 to (count _unitsArray) do
		{
			_obj = _unitsArray select _c;
			_isGroup = false;
			if (_obj in allGroups) then { _isGroup = true; } else { _isGroup = false; };
			if (_isGroup) then
			{
				{
					if (!isNull _x) then
					{
						deleteVehicle _x;
					};
				} forEach (units _obj);
				deleteGroup _obj;
			} else {
				if (!isNull _obj) then
				{
					deleteVehicle _obj;
				};
			};
		};
	};
	debugMessage = format["PT: Waiting %1 before next PT.",(_randomWait + 600)];
	publicVariable "debugMessage";
	
	/* ================================ */
	/* ====== CREATE MORTAR TEAM ====== */
	/* ================================ */

	debugMessage = "Priority Target started.";
	publicVariable "debugMessage";
	
	//Define hint
	_briefing = 
	"<t align='center' size='2.2'>Priority Target</t><br/><t size='1.5' color='#b60000'>Enemy Mortars</t><br/>____________________<br/>OPFOR forces are setting up a mortar team to hit you guys damned hard! We've picked up their positions with thermal imaging scans and have marked it on your map.<br/><br/>This is a priority target, boys! They're just setting up now; they'll be firing in about five minutes!";

	/*
		Find flat position that's not near spawn or within (PARAMS_AOSize + 200) of AO
		Possibly change this to include mortar teams spawning on a minimum elevation?
	*/

	_flatPos = [0];
	_accepted = false;
	_debugCounter = 1;
	while {!_accepted} do
	{
		debugMessage = format["PT: Finding flat position.<br/>Attempt #%1",_debugCounter];
		publicVariable "debugMessage";
		_debugCounter = _debugCounter + 1;

		while {(count _flatPos) < 3} do
		{
			_position = [[[getMarkerPos currentAO,2500]],["water","out"]] call BIS_fnc_randomPos;
			_flatPos = _position isFlatEmpty [5, 0, 0.2, 5, 0, false];
		};
		
		if
		((_flatPos distance (getMarkerPos "respawn_west")) > 1000 && (_flatPos distance (getMarkerPos currentAO)) > 800) then {
			_nearUnits = 0;
			{
				if ((_flatPos distance (getPos _x)) < 500) then
				{
					_nearUnits = _nearUnits + 1;
				};
			} forEach playableUnits;
			
			if (_nearUnits == 0) then
			{
				_accepted = true;
			};
		} else {
			_flatPos = [0];
		};
	};
	
	debugMessage = "PT: Spawning mortars, units and fire teams.";
	publicVariable "debugMessage";
	
	//Spawn units
	_flatPosAlt = [(_flatPos select 0) - 2, (_flatPos select 1), (_flatPos select 2)];
	_flatPosClose = [(_flatPos select 0) + 2, (_flatPos select 1), (_flatPos select 2)];
	_priorityGroup = createGroup EAST;
	priorityVeh1 = "O_Mortar_01_F" createVehicle _flatPosAlt;
	priorityVeh2 = "O_Mortar_01_F" createVehicle _flatPosClose;
	priorityVeh1 addEventHandler["Fired",{if (!isPlayer (gunner priorityVeh1)) then { priorityVeh1 setVehicleAmmo 1; };}];
	priorityVeh2 addEventHandler["Fired",{if (!isPlayer (gunner priorityVeh2)) then { priorityVeh2 setVehicleAmmo 1; };}];
	"O_Soldier_F" createUnit [_flatPosAlt, _priorityGroup, "priorityTarget1 = this; this moveInGunner priorityVeh1;"];
	"O_Soldier_F" createUnit [_flatPosClose, _priorityGroup, "priorityTarget2 = this; this moveInGunner priorityVeh2;"];
	waitUntil {alive priorityTarget1 && alive priorityTarget2};
	priorityTargets = [priorityTarget1, priorityTarget2];
	{ publicVariable _x; } forEach ["priorityTarget1", "priorityTarget2", "priorityTargets", "priorityVeh1", "priorityVeh2"];
	
	//Small sleep to let units settle in
	sleep 10;

	//Define unitsArray for deletion after completion
	_unitsArray = [PriorityTarget1, PriorityTarget2, priorityVeh1, priorityVeh2];

	//Spawn H-Barrier cover "Land_HBarrierBig_F"
	_distance = 12;
	_dir = 0;
	for "_c" from 0 to 15 do
	{
		_pos = [_flatPos, _distance, _dir] call BIS_fnc_relPos;
		_barrier = "Land_HBarrier_3_F" createVehicle _pos;
		waitUntil {alive _barrier};
		_barrier setDir _dir;
		_dir = _dir + 22.5;
		
		_unitsArray = _unitsArray + [_barrier];
	};

	//Spawn some enemies protecting the units
	for "_c" from 0 to 2 do
	{
		_randomPos = [[[_flatPos, 50]],["water","out"]] call BIS_fnc_randomPos;
		_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam")] call BIS_fnc_spawnGroup;
		[_spawnGroup, _flatPos] call BIS_fnc_taskDefend;
		
		_unitsArray = _unitsArray + [_spawnGroup];
	};
	
	for "_c" from 0 to 3 do
	{
		_randomPos = [[[_flatPos, 50]],["water","out"]] call BIS_fnc_randomPos;
		_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam")] call BIS_fnc_spawnGroup;
		[_spawnGroup, _pos, 100] call bis_fnc_taskPatrol;
		
		_unitsArray = _unitsArray + [_spawnGroup];
	};

	//Set marker up
	_fuzzyPos = 
	[
		((_flatPos select 0) - 300) + (random 600),
		((_flatPos select 1) - 300) + (random 600),
		0
	];

	{ _x setMarkerPos _fuzzyPos; } forEach ["priorityMarker", "priorityCircle"];
	"priorityMarker" setMarkerText "Priority Target: Mortar Team";
	publicVariable "priorityMarker";
	priorityTargetUp = true;
	priorityTargetText = "Mortar Team";
	publicVariable "priorityTargetUp";
	publicVariable "priorityTargetText";

	//Send Global Hint
	GlobalHint = _briefing; publicVariable "GlobalHint"; hint parseText _briefing;
	showNotification = ["NewPriorityTarget", "Destroy Enemy Mortar Team"]; publicVariable "showNotification";

	debugMessage = "Letting mortars 'set up'.";
	publicVariable "debugMessage";

	//Wait for 1-2 minutes while the mortars "set up"
	sleep (random 60);
	
	//Set mortars attacking while still alive
	_firingMessages = 
	[
		"Thermal scans are picking up those enemy mortars firing! Heads down!",
		"Enemy mortar rounds incoming! Advise you seek cover immediately.",
		"OPFOR mortar rounds incoming! Seek cover immediately!",
		"The mortar team's firing, boys! Down on the ground!",
		"Get that damned mortar team down; they're firing right now! Seek cover!",
		"They're zeroing in! Incoming mortar fire; heads down!"
	];
	_radius = 80; //Declared here so we can "zero in" gradually
	while {alive priorityTarget1 || alive priorityTarget2} do
	{
		_accepted = false;
		_unit = objNull;
		_targetPos = [0,0,0];
		_debugCount = 1;
		while {!_accepted} do
		{
			debugMessage = format["PT: Finding valid target.<br/><br/>Attempt #%1",_debugCount]; publicVariable "debugMessage";

			_unit = (playableUnits select (floor (random (count playableUnits))));
			_targetPos = getPos _unit;
			
			if ((_targetPos distance (getMarkerPos "respawn_west")) > 1000 && vehicle _unit == _unit && side _unit == WEST) then { _accepted = true; };
			
			_debugCount = _debugCount + 1;
		};
		
		debugMessage = "PT: Valid target found; warning players and beginning fire sequence.";
		publicVariable "debugMessage";
		
		if (PARAMS_PriorityTargetTickWarning == 1) then
		{
			hqSideChat = _firingMessages call BIS_fnc_selectRandom; publicVariable "hqSideChat"; [WEST,"HQ"] sideChat hqSideChat;
		};
		
		_dir = [_flatPos, _targetPos] call BIS_fnc_dirTo;
		{ _x setDir _dir; } forEach [priorityVeh1, priorityVeh2];
		sleep 5;
		{
			if (alive _x) then
			{
				for "_c" from 0 to 4 do
				{
					_pos = 
					[
						(_targetPos select 0) - _radius + (2 * random _radius),
						(_targetPos select 1) - _radius + (2 * random _radius),
						0
					];
					_x doArtilleryFire [_pos, "8Rnd_82mm_Mo_shells", 1]; //update so parameter customises mortar rounds?
					sleep 5;
				};
			};
		} forEach priorityTargets;
		if (_radius > 10) then { _radius = _radius - 10; }; /* zeroing in */
		if (PARAMS_PriorityTargetTickTimeMax <= PARAMS_PriorityTargetTickTimeMin) then
		{
			sleep PARAMS_PriorityTargetTickTimeMin;
		} else {
			sleep (PARAMS_PriorityTargetTickTimeMin + (random (PARAMS_PriorityTargetTickTimeMax - PARAMS_PriorityTargetTickTimeMin)));
		};
	};

	//Send completion hint
	GlobalHint = _completeText; publicVariable "GlobalHint"; hint parseText _completeText;
	showNotification = ["CompletedPriorityTarget", "Enemy Mortar Team Neutralised"]; publicVariable "showNotification";
	
	//Set global VAR saying mission is complete
	priorityTargetUp = false;
	publicVariable "priorityTargetUp";

	//Hide priorityMarker
	"priorityMarker" setMarkerPos [0,0,0];
	"priorityCircle" setMarkerPos [0,0,0];
	publicVariable "priorityMarker";
};