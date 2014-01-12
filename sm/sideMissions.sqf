/*
	Insert public variable event handler into player init:

	"sideMarker" addPublicVariableEventHandler
	{
		"sideMarker" setMarkerPos (markerPos "sideMarker");
	};

	Also, we need an event handler for playing custom sounds via SAY.
	Pass the EH a variable that it can use to play the correct sound.

	For the addAction issue, we need to run the addAction command LOCALLY. Using forEach allUnits won't work as the action is still being run on the server.
	So, set up an EH that can add actions to units.

	For deletion of contact (and this applies to AO units, too!)...
		Using []spawn { }; will run code that then ignores the rest of the script!
		AWESOME!

		Major edit by LB Quiksilver
*/

//Create base array of differing side missions

private ["_firstRun","_mission","_isGroup","_obj","_skipTimer","_awayFromBase","_road","_position","_deadHint","_civArray","_briefing","_altPosition","_truck","_chosenCiv","_contactPos","_civ","_flatPos","_accepted","_randomPos","_spawnGroup","_unitsArray","_randomDir","_hangar","_x","_sideMissions","_completeText","_roadList"];
_sideMissions =

[
	"destroyChopper",
	"destroySmallRadar",
	"destroyExplosivesCoast",
	"destroyWeaponsSupply",
	"destroyResearchOutpost",
	"destroyInsurgentHQ",
	"destroyRogueHQ"
];

_mission = "";

_completeText =
"<t align='center'><t size='2.2'>Side Mission</t><br/><t size='1.5' color='#00B2EE'>COMPLETE</t><br/>____________________<br/>Fantastic job, lads! The OPFOR stationed on the island won't last long if you keep that up!<br/><br/>Focus on the main objective for now; we'll relay this success to the intel team and see if there's anything else you can do for us. We'll get back to you in 15 - 30 minutes.</t>";

//Set up some vars
_firstRun = true; //debug
_skipTimer = false;
_roadList = island nearRoads 2000; //change this to the BIS function that creates a trigger covering the map
_contactPos = [0,0,0];
_unitsArray = [sideObj];

while {true} do
{
	if (_firstRun) then
	{
		//Debug if statement only...
		_firstRun = false;
		sleep 10;
		//Select random mission from the SM list
		_mission = _sideMissions call BIS_fnc_selectRandom;
	} else {
		if (!_skipTimer) then
		{
			//Wait between 15-30 minutes before assigning a mission
			sleep (600 + (random 600));

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

			//Select random mission from the SM list
			_mission = _sideMissions call BIS_fnc_selectRandom;
		} else {
			//Reset skipTimer
			_skipTimer = false;
		};
	};

	//Grab the code for the selected mission
	switch (_mission) do
	{
		case "destroyChopper":
		{
			//Set up briefing message
			_briefing =
			"<t align='center'><t size='2.2'>New Side Mission</t><br/><t size='1.5' color='#00B2EE'>Destroy Chopper</t><br/>____________________<br/>OPFOR forces have been provided with a new prototype attack chopper and they're keeping it in a hangar somewhere on the island.<br/><br/>We've marked the suspected location on your map; head to the hangar and destroy that chopper. Fly it into the sea if you have to, just get rid of it.</t>";

			_flatPos = [0,0,0];
			_accepted = false;
			while {!_accepted} do
			{
				_position = [] call BIS_fnc_randomPos;
				_flatPos = _position isFlatEmpty
				[
					5,
					0,
					0.3,
					10,
					0,
					false
				];

				while {(count _flatPos) < 3} do
				{
					_position = [] call BIS_fnc_randomPos;
					_flatPos = _position isFlatEmpty
					[
						5,
						0,
						0.3,
						10,
						0,
						false
					];
				};

				if ((_flatPos distance (getMarkerPos "respawn_west")) > 1000 && (_flatPos distance (getMarkerPos currentAO)) > 500) then //DEBUG - set >500 from AO to (PARAMS_AOSize * 2)
				{
					_accepted = true;
				};
			};

			//Spawn hangar and chopper
			_randomDir = (random 360);
			_hangar = "Land_TentHangar_V1_F" createVehicle _flatPos;
			waitUntil {alive _hangar};
			_hangar setPos [(getPos _hangar select 0), (getPos _hangar select 1), ((getPos _hangar select 2) - 1)];
			sideObj = "O_Heli_Attack_02_black_F" createVehicle _flatPos;
			waitUntil {!isNull sideObj};

			sideObj lock 3;
			{_x setDir _randomDir} forEach [sideObj,_hangar];
			sideObj setVehicleLock "LOCKED";
			_fuzzyPos =
			[
				((_flatPos select 0) - 300) + (random 600),
				((_flatPos select 1) - 300) + (random 600),
				0
			];

			{ _x setMarkerPos _fuzzyPos; } forEach ["sideMarker", "sideCircle"];
			"sideMarker" setMarkerText "Side Mission: Destroy Chopper";
			publicVariable "sideMarker";
			publicVariable "sideObj";

			//Spawn some enemies around the objective
			_unitsArray = [sideObj];
			_x = 0;
			for "_x" from 0 to 2 do
			{
				_randomPos = [_flatPos, 50] call aw_fnc_randomPos;
				_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam_AA")] call BIS_fnc_spawnGroup;
				[_spawnGroup, _flatPos,50] call aw_fnc_spawn2_perimeterPatrol;
				[(units _spawnGroup)] call aw_setGroupSkill;

						if(DEBUG) then
		{
			_name = format ["%1%2",name (leader _spawnGroup),_x];
			createMarker [_name,getPos (leader _spawnGroup)];
			_name setMarkerType "o_unknown";
			_name setMarkerText format ["Squad Patrol %1",_x];
			_name setMarkerColor "ColorRed";
			[_spawnGroup,_name] spawn
			{
				private["_group","_marker"];
				_group = _this select 0;
				_marker = _this select 1;

				while{count (units _group) > 0} do
				{
					_marker setMarkerPos (getPos (leader _group));
					sleep 0.1;
				};
				deleteMarker _marker;
			};
		};

				_unitsArray = _unitsArray + [_spawnGroup];
			};

			_x = 0;
			for "_x" from 0 to 1 do
			{
				_randomPos = [_flatPos, 50] call aw_fnc_randomPos;
				_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam_AT")] call BIS_fnc_spawnGroup;
				[_spawnGroup, _flatPos, 100] call aw_fnc_spawn2_randomPatrol;
				[(units _spawnGroup)] call aw_setGroupSkill;

						if(DEBUG) then
		{
			_name = format ["%1%2",name (leader _spawnGroup),_x];
			createMarker [_name,getPos (leader _spawnGroup)];
			_name setMarkerType "o_unknown";
			_name setMarkerText format ["Squad Patrol %1",_x];
			_name setMarkerColor "ColorRed";
			[_spawnGroup,_name] spawn
			{
				private["_group","_marker"];
				_group = _this select 0;
				_marker = _this select 1;

				while{count (units _group) > 0} do
				{
					_marker setMarkerPos (getPos (leader _group));
					sleep 0.1;
				};
				deleteMarker _marker;
			};
		};

				_unitsArray = _unitsArray + [_spawnGroup];
			};

			_x = 0;
			for "_x" from 0 to 1 do
			{
				_randomPos = [_flatPos, 50] call aw_fnc_randomPos;
				_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OI_SniperTeam")] call BIS_fnc_spawnGroup;
				[_spawnGroup, _flatPos, 100] call aw_fnc_spawn2_randomPatrol;
				[(units _spawnGroup)] call aw_setGroupSkillSniper;

				_unitsArray = _unitsArray + [_spawnGroup];
			};

			_spawnGroup = createGroup east;
			_randomPos = [_flatPos, 100,10] call aw_fnc_randomPos;
			_armour = "O_APC_Tracked_02_AA_F" createVehicle _randomPos;
			waitUntil{!isNull _armour};

			"O_soldier_repair_F" createUnit [_randomPos,_spawnGroup];
			"O_crew_F" createUnit [_randomPos,_spawnGroup];
			"O_crew_F" createUnit [_randomPos,_spawnGroup];

			((units _spawnGroup) select 0) assignAsDriver _armour;
			((units _spawnGroup) select 1) assignAsGunner _armour;
			((units _spawnGroup) select 2) assignAsCommander _armour;
			((units _spawnGroup) select 0) moveInDriver _armour;
			((units _spawnGroup) select 1) moveInGunner _armour;
			((units _spawnGroup) select 2) moveInCommander _armour;
			[_spawnGroup, _flatPos, 300] call aw_fnc_spawn2_randomPatrol;
			_armour spawn aw_fnc_fuelMonitor;
			_unitsArray = _unitsArray + [_spawnGroup];
			//[(units _spawnGroup)] call aw_setGroupSkill;
			_armour lock true;

			_spawnGroup = createGroup east;
			_randomPos = [_flatPos, 100,10] call aw_fnc_randomPos;
			_armour = "O_APC_Tracked_02_cannon_F" createVehicle _randomPos;
			waitUntil{!isNull _armour};

			"O_soldier_repair_F" createUnit [_randomPos,_spawnGroup];
			"O_crew_F" createUnit [_randomPos,_spawnGroup];
			"O_crew_F" createUnit [_randomPos,_spawnGroup];
			"O_Soldier_F" createUnit [_randomPos,_spawnGroup];
			"O_Soldier_F" createUnit [_randomPos,_spawnGroup];
			"O_Soldier_AR_F" createUnit [_randomPos,_spawnGroup];
			"O_soldier_repair_F" createUnit [_randomPos,_spawnGroup];
			"O_medic_F" createUnit [_randomPos,_spawnGroup];

			((units _spawnGroup) select 0) assignAsDriver _armour;
			((units _spawnGroup) select 1) assignAsGunner _armour;
			((units _spawnGroup) select 2) assignAsCommander _armour;
			((units _spawnGroup) select 3) assignAsCargo _armour;
			((units _spawnGroup) select 4) assignAsCargo _armour;
			((units _spawnGroup) select 5) assignAsCargo _armour;
			((units _spawnGroup) select 6) assignAsCargo _armour;
			((units _spawnGroup) select 7) assignAsCargo _armour;
			((units _spawnGroup) select 0) moveInDriver _armour;
			((units _spawnGroup) select 1) moveInGunner _armour;
			((units _spawnGroup) select 2) moveInCommander _armour;
			((units _spawnGroup) select 3) moveInCargo _armour;
			((units _spawnGroup) select 4) moveInCargo _armour;
			((units _spawnGroup) select 5) moveInCargo _armour;
			((units _spawnGroup) select 6) moveInCargo _armour;
			((units _spawnGroup) select 7) moveInCargo _armour;
			[_spawnGroup, _flatPos, 300] call aw_fnc_spawn2_randomPatrol;
			_armour spawn aw_fnc_fuelMonitor;
			_unitsArray = _unitsArray + [_spawnGroup];
			//[(units _spawnGroup)] call aw_setGroupSkill;
			_armour lock true;
					if(DEBUG) then
		{
			_name = format ["%1%2",name (leader _spawnGroup),_x];
			createMarker [_name,getPos (leader _spawnGroup)];
			_name setMarkerType "o_unknown";
			_name setMarkerText format ["Squad Patrol %1",_x];
			_name setMarkerColor "ColorRed";
			[_spawnGroup,_name] spawn
			{
				private["_group","_marker"];
				_group = _this select 0;
				_marker = _this select 1;

				while{count (units _group) > 0} do
				{
					_marker setMarkerPos (getPos (leader _group));
					sleep 0.1;
				};
				deleteMarker _marker;
			};
		};

			//Send new side mission hint
			GlobalHint = _briefing; publicVariable "GlobalHint"; hint parseText _briefing;
			showNotification = ["NewSideMission", "Destroy Enemy Chopper"]; publicVariable "showNotification";

			sideMissionUp = true;
			publicVariable "sideMissionUp";
			sideMarkerText = "Destroy Chopper";
			publicVariable "sideMarkerText";

			//Wait until objective is destroyed
			waitUntil {sleep 0.5; !alive sideObj};

			sideMissionUp = false;
			publicVariable "sideMissionUp";

			//Send completion hint
			[] call AW_fnc_rewardPlusHint;

			[_unitsArray] spawn GC_fnc_deleteOldUnitsAndVehicles;
			[_unitsArray] spawn AW_fnc_deleteOldSMUnits;
			deleteVehicle sideObj;

			//Hide SM marker
			"sideMarker" setMarkerPos [0,0,0];
			"sideCircle" setMarkerPos [0,0,0];
			publicVariable "sideMarker";

			//PROCESS REWARD HERE
		}; /* case "destroyChopper": */

		case "destroySmallRadar":
		{
			//Set up briefing message
			_briefing =
			"<t align='center'><t size='2.2'>New Side Mission</t><br/><t size='1.5' color='#00B2EE'>Destroy Radar</t><br/>____________________<br/>OPFOR forces have erected a small radar on the island as part of a project to keep friendly air support at bay.<br/><br/>We've marked the position on your map; head over there and take down that radar.</t>";

			_flatPos = [0,0,0];
			_accepted = false;
			while {!_accepted} do
			{
				//Get random safe position somewhere on the island
				_position = [] call BIS_fnc_randomPos;
				_flatPos = _position isFlatEmpty
				[
					5, //minimal distance from another object
					1, //try and find nearby positions if original is incorrect
					0.5, //30% max gradient
					sizeOf "Land_Radar_small_F", //gradient must be consistent for entirety of object
					0, //no water
					false //don't find positions near the shoreline
				];

				while {(count _flatPos) < 1} do
				{
					_position = [] call BIS_fnc_randomPos;
					_flatPos = _position isFlatEmpty
					[
						10, //minimal distance from another object
						1, //try and find nearby positions if original is incorrect
						0.5, //30% max gradient
						sizeOf "Land_Radar_small_F", //gradient must be consistent for entirety of object
						0, //no water
						false //don't find positions near the shoreline
					];
				};

				if ((_flatPos distance (getMarkerPos "respawn_west")) > 1000 && (_flatPos distance (getMarkerPos currentAO)) > 500) then //DEBUG - set >500 from AO to (PARAMS_AOSize * 2)
				{
					_accepted = true;
				};
			};

			//Spawn radar, set vector and add marker
			sideObj = "Land_Radar_Small_F" createVehicle _flatPos;
			waitUntil {alive sideObj};
			sideObj setPos [(getPos sideObj select 0), (getPos sideObj select 1), ((getPos sideObj select 2) - 2)];
			sideObj setVectorUp [0,0,1];
			_fuzzyPos =
			[
				((_flatPos select 0) - 300) + (random 600),
				((_flatPos select 1) - 300) + (random 600),
				0
			];

			{ _x setMarkerPos _fuzzyPos; } forEach ["sideMarker", "sideCircle"];
			"sideMarker" setMarkerText "Side Mission: Destroy Radar";
			publicVariable "sideMarker";
			publicVariable "sideObj";

			//Spawn some enemies around the objective
			_unitsArray = [sideObj];
			_x = 0;
			for "_x" from 0 to 2 do
			{
				_randomPos = [_flatPos, 50] call aw_fnc_randomPos;
				_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam_AA")] call BIS_fnc_spawnGroup;
				[_spawnGroup, _flatPos,50] call aw_fnc_spawn2_perimeterPatrol;
				[(units _spawnGroup)] call aw_setGroupSkill;

						if(DEBUG) then
		{
			_name = format ["%1%2",name (leader _spawnGroup),_x];
			createMarker [_name,getPos (leader _spawnGroup)];
			_name setMarkerType "o_unknown";
			_name setMarkerText format ["Squad Patrol %1",_x];
			_name setMarkerColor "ColorRed";
			[_spawnGroup,_name] spawn
			{
				private["_group","_marker"];
				_group = _this select 0;
				_marker = _this select 1;

				while{count (units _group) > 0} do
				{
					_marker setMarkerPos (getPos (leader _group));
					sleep 0.1;
				};
				deleteMarker _marker;
			};
		};

				_unitsArray = _unitsArray + [_spawnGroup];
			};

			_x = 0;
			for "_x" from 0 to 1 do
			{
				_randomPos = [_flatPos, 50] call aw_fnc_randomPos;
				_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam_AT")] call BIS_fnc_spawnGroup;
				[_spawnGroup, _flatPos, 300] call aw_fnc_spawn2_randomPatrol;
				[(units _spawnGroup)] call aw_setGroupSkill;

						if(DEBUG) then
		{
			_name = format ["%1%2",name (leader _spawnGroup),_x];
			createMarker [_name,getPos (leader _spawnGroup)];
			_name setMarkerType "o_unknown";
			_name setMarkerText format ["Squad Patrol %1",_x];
			_name setMarkerColor "ColorRed";
			[_spawnGroup,_name] spawn
			{
				private["_group","_marker"];
				_group = _this select 0;
				_marker = _this select 1;

				while{count (units _group) > 0} do
				{
					_marker setMarkerPos (getPos (leader _group));
					sleep 0.1;
				};
				deleteMarker _marker;
			};
		};

				_unitsArray = _unitsArray + [_spawnGroup];
			};

			_x = 0;
			for "_x" from 0 to 1 do
			{
				_randomPos = [_flatPos, 50] call aw_fnc_randomPos;
				_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "UInfantry" >> "OIA_GuardTeam")] call BIS_fnc_spawnGroup;
				[_spawnGroup, _flatPos, 300] call aw_fnc_spawn2_randomPatrol;
				[(units _spawnGroup)] call aw_setGroupSkill;

						if(DEBUG) then
		{
			_name = format ["%1%2",name (leader _spawnGroup),_x];
			createMarker [_name,getPos (leader _spawnGroup)];
			_name setMarkerType "o_unknown";
			_name setMarkerText format ["Squad Patrol %1",_x];
			_name setMarkerColor "ColorRed";
			[_spawnGroup,_name] spawn
			{
				private["_group","_marker"];
				_group = _this select 0;
				_marker = _this select 1;

				while{count (units _group) > 0} do
				{
					_marker setMarkerPos (getPos (leader _group));
					sleep 0.1;
				};
				deleteMarker _marker;
			};
		};

				_unitsArray = _unitsArray + [_spawnGroup];
			};

			_spawnGroup = createGroup east;
			_randomPos = [_flatPos, 100,10] call aw_fnc_randomPos;
			_armour = "O_APC_Tracked_02_AA_F" createVehicle _randomPos;
			waitUntil{!isNull _armour};

			"O_soldier_repair_F" createUnit [_randomPos,_spawnGroup];
			"O_crew_F" createUnit [_randomPos,_spawnGroup];
			"O_crew_F" createUnit [_randomPos,_spawnGroup];

			((units _spawnGroup) select 0) assignAsDriver _armour;
			((units _spawnGroup) select 1) assignAsGunner _armour;
			((units _spawnGroup) select 2) assignAsCommander _armour;
			((units _spawnGroup) select 0) moveInDriver _armour;
			((units _spawnGroup) select 1) moveInGunner _armour;
			((units _spawnGroup) select 2) moveInCommander _armour;
			[_spawnGroup, _flatPos, 300] call aw_fnc_spawn2_randomPatrol;
			_armour spawn aw_fnc_fuelMonitor;
			_unitsArray = _unitsArray + [_spawnGroup];
			//[(units _spawnGroup)] call aw_setGroupSkill;
			_armour lock true;

			_spawnGroup = createGroup east;
			_randomPos = [_flatPos, 100,10] call aw_fnc_randomPos;
			_armour = "O_APC_Tracked_02_cannon_F" createVehicle _randomPos;
			waitUntil{!isNull _armour};

			"O_soldier_repair_F" createUnit [_randomPos,_spawnGroup];
			"O_crew_F" createUnit [_randomPos,_spawnGroup];
			"O_crew_F" createUnit [_randomPos,_spawnGroup];
			"O_Soldier_F" createUnit [_randomPos,_spawnGroup];
			"O_Soldier_F" createUnit [_randomPos,_spawnGroup];
			"O_Soldier_AR_F" createUnit [_randomPos,_spawnGroup];
			"O_soldier_repair_F" createUnit [_randomPos,_spawnGroup];
			"O_medic_F" createUnit [_randomPos,_spawnGroup];

			((units _spawnGroup) select 0) assignAsDriver _armour;
			((units _spawnGroup) select 1) assignAsGunner _armour;
			((units _spawnGroup) select 2) assignAsCommander _armour;
			((units _spawnGroup) select 3) assignAsCargo _armour;
			((units _spawnGroup) select 4) assignAsCargo _armour;
			((units _spawnGroup) select 5) assignAsCargo _armour;
			((units _spawnGroup) select 6) assignAsCargo _armour;
			((units _spawnGroup) select 7) assignAsCargo _armour;
			((units _spawnGroup) select 0) moveInDriver _armour;
			((units _spawnGroup) select 1) moveInGunner _armour;
			((units _spawnGroup) select 2) moveInCommander _armour;
			((units _spawnGroup) select 3) moveInCargo _armour;
			((units _spawnGroup) select 4) moveInCargo _armour;
			((units _spawnGroup) select 5) moveInCargo _armour;
			((units _spawnGroup) select 6) moveInCargo _armour;
			((units _spawnGroup) select 7) moveInCargo _armour;
			[_spawnGroup, _flatPos, 300] call aw_fnc_spawn2_randomPatrol;
			_armour spawn aw_fnc_fuelMonitor;
			_unitsArray = _unitsArray + [_spawnGroup];
			//[(units _spawnGroup)] call aw_setGroupSkill;
			_armour lock true;

		if(DEBUG) then
		{
			_name = format ["%1%2",name (leader _spawnGroup),_x];
			createMarker [_name,getPos (leader _spawnGroup)];
			_name setMarkerType "o_unknown";
			_name setMarkerText format ["Squad Patrol %1",_x];
			_name setMarkerColor "ColorRed";
			[_spawnGroup,_name] spawn
			{
				private["_group","_marker"];
				_group = _this select 0;
				_marker = _this select 1;

				while{count (units _group) > 0} do
				{
					_marker setMarkerPos (getPos (leader _group));
					sleep 0.1;
				};
				deleteMarker _marker;
			};
		};

			//Throw out objective hint
			GlobalHint = _briefing; publicVariable "GlobalHint"; hint parseText GlobalHint;
			showNotification = ["NewSideMission", "Destroy Enemy Radar"]; publicVariable "showNotification";

			sideMissionUp = true;
			publicVariable "sideMissionUp";
			sideMarkerText = "Destroy Radar";
			publicVariable "sideMarkerText";

			waitUntil {sleep 0.5; !alive sideObj}; //wait until the objective is destroyed

			sideMissionUp = false;
			publicVariable "sideMissionUp";

			//Throw out objective completion hint
			[] call AW_fnc_rewardPlusHint;

			[_unitsArray] spawn GC_fnc_deleteOldUnitsAndVehicles;
			[_unitsArray] spawn AW_fnc_deleteOldSMUnits;
			deleteVehicle sideObj;
			//Hide marker
			"sideMarker" setMarkerPos [0,0,0];
			"sideCircle" setMarkerPos [0,0,0];
			publicVariable "sideMarker";

			//provide players with reward. Place an MH-9 in the hangar, maybe?
		}; /* case "destroySmallRadar": */

		case "destroyExplosivesCoast":
		{
			//Set up briefing message
			_briefing =
			"<t align='center'><t size='2.2'>New Side Mission</t><br/><t size='1.5' color='#00B2EE'>Destroy Smuggled Explosives</t><br/>____________________<br/>The OPFOR have been smuggling explosives onto the island and hiding them in a Mobile HQ on the coastline.<br/><br/>We've marked the building on your map; head over there and destroy their stock. Keep well back when you blow it; there's a lot of stuff in that building.</t>";

			_flatPos = [0,0,0];
			_accepted = false;

			while {!_accepted} do
			{
				_position = [[[getPos island,4000]],["water","out"]] call BIS_fnc_randomPos;
				_flatPos = _position isFlatEmpty
				[
					2,
					0,
					0.3,
					1,
					1,
					true
				];

				while {(count _flatPos) < 1} do
				{
					_position = [[[getPos island,16000]],["water","out"]] call BIS_fnc_randomPos;
					_flatPos = _position isFlatEmpty
					[
						2,
						0,
						0.3,
						1,
						1,
						true
					];
				};

				if ((_flatPos distance (getMarkerPos "respawn_west")) > 1700 && (_flatPos distance (getMarkerPos currentAO)) > 500) then //DEBUG - set >500 from AO to (PARAMS_AOSize * 2)
				{
					_accepted = true;
				};
			};

			//Spawn Mobile HQ
			_randomDir = (random 360);
			sideObj = "Land_research_hq_f" createVehicle _flatPos;
			waitUntil {alive sideObj};
			sideObj setDir _randomDir;
			sideObj setPos [(getPos sideObj select 0), (getPos sideObj select 1), ((getPos sideObj select 2) - 0.5)];
			sideObj setVectorUp [0,0,1];

			//Spawn some enemies around the objective
			_unitsArray = [sideObj];
			_x = 0;
			for "_x" from 0 to 2 do
			{
				_randomPos = [_flatPos, 50] call aw_fnc_randomPos;
				_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam_AA")] call BIS_fnc_spawnGroup;
				[_spawnGroup, _flatPos,50] call aw_fnc_spawn2_perimeterPatrol;
				[(units _spawnGroup)] call aw_setGroupSkill;

		if(DEBUG) then
		{
			_name = format ["%1%2",name (leader _spawnGroup),_x];
			createMarker [_name,getPos (leader _spawnGroup)];
			_name setMarkerType "o_unknown";
			_name setMarkerText format ["Squad Patrol %1",_x];
			_name setMarkerColor "ColorRed";
			[_spawnGroup,_name] spawn
			{
				private["_group","_marker"];
				_group = _this select 0;
				_marker = _this select 1;

				while{count (units _group) > 0} do
				{
					_marker setMarkerPos (getPos (leader _group));
					sleep 0.1;
				};
				deleteMarker _marker;
			};
		};

				_unitsArray = _unitsArray + [_spawnGroup];
			};

			_x = 0;
			for "_x" from 0 to 2 do
			{
				_randomPos = [_flatPos, 50] call aw_fnc_randomPos;
				_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam_AT")] call BIS_fnc_spawnGroup;
				[_spawnGroup, _flatPos, 300] call aw_fnc_spawn2_randomPatrol;
				[(units _spawnGroup)] call aw_setGroupSkill;

						if(DEBUG) then
		{
			_name = format ["%1%2",name (leader _spawnGroup),_x];
			createMarker [_name,getPos (leader _spawnGroup)];
			_name setMarkerType "o_unknown";
			_name setMarkerText format ["Squad Patrol %1",_x];
			_name setMarkerColor "ColorRed";
			[_spawnGroup,_name] spawn
			{
				private["_group","_marker"];
				_group = _this select 0;
				_marker = _this select 1;

				while{count (units _group) > 0} do
				{
					_marker setMarkerPos (getPos (leader _group));
					sleep 0.1;
				};
				deleteMarker _marker;
			};
		};

				_unitsArray = _unitsArray + [_spawnGroup];
			};

			_x = 0;
			for "_x" from 0 to 1 do
			{
				_randomPos = [_flatPos, 50] call aw_fnc_randomPos;
				_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "SpecOps" >> "OI_diverTeam")] call BIS_fnc_spawnGroup;
				[_spawnGroup, _flatPos, 300] call aw_fnc_spawn2_randomPatrol;
				[(units _spawnGroup)] call aw_setGroupSkill;

						if(DEBUG) then
		{
			_name = format ["%1%2",name (leader _spawnGroup),_x];
			createMarker [_name,getPos (leader _spawnGroup)];
			_name setMarkerType "o_unknown";
			_name setMarkerText format ["Squad Patrol %1",_x];
			_name setMarkerColor "ColorRed";
			[_spawnGroup,_name] spawn
			{
				private["_group","_marker"];
				_group = _this select 0;
				_marker = _this select 1;

				while{count (units _group) > 0} do
				{
					_marker setMarkerPos (getPos (leader _group));
					sleep 0.1;
				};
				deleteMarker _marker;
			};
		};

				_unitsArray = _unitsArray + [_spawnGroup];
			};

			_spawnGroup = createGroup east;
			_randomPos = [_flatPos, 100,10] call aw_fnc_randomPos;
			_armour = "O_APC_Tracked_02_AA_F" createVehicle _randomPos;
			waitUntil{!isNull _armour};

			"O_soldier_repair_F" createUnit [_randomPos,_spawnGroup];
			"O_crew_F" createUnit [_randomPos,_spawnGroup];
			"O_crew_F" createUnit [_randomPos,_spawnGroup];

			((units _spawnGroup) select 0) assignAsDriver _armour;
			((units _spawnGroup) select 1) assignAsGunner _armour;
			((units _spawnGroup) select 2) assignAsCommander _armour;
			((units _spawnGroup) select 0) moveInDriver _armour;
			((units _spawnGroup) select 1) moveInGunner _armour;
			((units _spawnGroup) select 2) moveInCommander _armour;
			[_spawnGroup, _flatPos, 300] call aw_fnc_spawn2_randomPatrol;
			_armour spawn aw_fnc_fuelMonitor;
			_unitsArray = _unitsArray + [_spawnGroup];
			//[(units _spawnGroup)] call aw_setGroupSkill;
			_armour lock true;

			_spawnGroup = createGroup east;
			_randomPos = [_flatPos, 100,10] call aw_fnc_randomPos;
			_armour = "O_APC_Wheeled_02_rcws_F" createVehicle _randomPos;
			waitUntil{!isNull _armour};

			"O_soldier_repair_F" createUnit [_randomPos,_spawnGroup];
			"O_crew_F" createUnit [_randomPos,_spawnGroup];
			"O_crew_F" createUnit [_randomPos,_spawnGroup];
			"O_Soldier_F" createUnit [_randomPos,_spawnGroup];
			"O_Soldier_F" createUnit [_randomPos,_spawnGroup];
			"O_Soldier_AR_F" createUnit [_randomPos,_spawnGroup];
			"O_soldier_repair_F" createUnit [_randomPos,_spawnGroup];
			"O_medic_F" createUnit [_randomPos,_spawnGroup];

			((units _spawnGroup) select 0) assignAsDriver _armour;
			((units _spawnGroup) select 1) assignAsGunner _armour;
			((units _spawnGroup) select 2) assignAsCommander _armour;
			((units _spawnGroup) select 3) assignAsCargo _armour;
			((units _spawnGroup) select 4) assignAsCargo _armour;
			((units _spawnGroup) select 5) assignAsCargo _armour;
			((units _spawnGroup) select 6) assignAsCargo _armour;
			((units _spawnGroup) select 7) assignAsCargo _armour;
			((units _spawnGroup) select 0) moveInDriver _armour;
			((units _spawnGroup) select 1) moveInGunner _armour;
			((units _spawnGroup) select 2) moveInCommander _armour;
			((units _spawnGroup) select 3) moveInCargo _armour;
			((units _spawnGroup) select 4) moveInCargo _armour;
			((units _spawnGroup) select 5) moveInCargo _armour;
			((units _spawnGroup) select 6) moveInCargo _armour;
			((units _spawnGroup) select 7) moveInCargo _armour;
			[_spawnGroup, _flatPos, 300] call aw_fnc_spawn2_randomPatrol;
			_armour spawn aw_fnc_fuelMonitor;
			_unitsArray = _unitsArray + [_spawnGroup];
			//[(units _spawnGroup)] call aw_setGroupSkill;
			_armour lock true;

		if(DEBUG) then
		{
			_name = format ["%1%2",name (leader _spawnGroup),_x];
			createMarker [_name,getPos (leader _spawnGroup)];
			_name setMarkerType "o_unknown";
			_name setMarkerText format ["Squad Patrol %1",_x];
			_name setMarkerColor "ColorRed";
			[_spawnGroup,_name] spawn
			{
				private["_group","_marker"];
				_group = _this select 0;
				_marker = _this select 1;

				while{count (units _group) > 0} do
				{
					_marker setMarkerPos (getPos (leader _group));
					sleep 0.1;
				};
				deleteMarker _marker;
			};
		};

			//Set marker up
			_fuzzyPos =
			[
				((_flatPos select 0) - 300) + (random 600),
				((_flatPos select 1) - 300) + (random 600),
				0
			];

			{ _x setMarkerPos _fuzzyPos; } forEach ["sideMarker", "sideCircle"];
			"sideMarker" setMarkerText "Side Mission: Destroy Smuggled Explosives";
			publicVariable "sideMarker";
			publicVariable "sideObj";

			//Throw briefing hint
			GlobalHint = _briefing; publicVariable "GlobalHint"; hint parseText GlobalHint;
			showNotification = ["NewSideMission", "Destroy Smuggled Explosives"]; publicVariable "showNotification";

			sideMissionUp = true;
			publicVariable "sideMissionUp";
			sideMarkerText = "Destroy Smuggled Explosives";
			publicVariable "sideMarkerText";

			//Wait for boats to be dead
			waitUntil {sleep 0.5; !alive sideObj};

			sideMissionUp = false;
			publicVariable "sideMissionUp";

			//Improve this to do some randomised mortar explosions quite quickly after the killing of the building in a small radius

			//Throw completion hint
			[] call AW_fnc_rewardPlusHint;

			[_unitsArray] spawn GC_fnc_deleteOldUnitsAndVehicles;
			[_unitsArray] spawn AW_fnc_deleteOldSMUnits;
			deleteVehicle sideObj;
			//Hide marker
			"sideMarker" setMarkerPos [0,0,0];
			"sideCircle" setMarkerPos [0,0,0];
			sleep 5;
			publicVariable "sideMarker";
			[] spawn aw_cleanGroups;
		}; /* case "destroyExplosivesCoast": */

		case "destroyResearchOutpost":
		{
			//Set up briefing message
			_briefing =
			"<t align='center'><t size='2.2'>New Side Mission</t><br/><t size='1.5' color='#00B2EE'>Destroy Research Outpost</t><br/>____________________<br/>The OPFOR are conducting biological weapons testing in a small building somewhere on Altis.<br/><br/>We've marked the approximate location on your map; head over there and destroy their work before it's too late!</t>";

			_flatPos = [0,0,0];
			_accepted = false;

			while {!_accepted} do
			{
				_position = [[[getPos island,16000]],["water","out"]] call BIS_fnc_randomPos;
				_flatPos = _position isFlatEmpty
				[
					2,
					0,
					0.3,
					1,
					0,
					false
				];

				while {(count _flatPos) < 1} do
				{
					_position = [[[getPos island,16000]],["water","out"]] call BIS_fnc_randomPos;
					_flatPos = _position isFlatEmpty
					[
						2,
						0,
						0.3,
						1,
						0,
						false
					];
				};

				if ((_flatPos distance (getMarkerPos "respawn_west")) > 1700 && (_flatPos distance (getMarkerPos currentAO)) > 500) then //DEBUG - set >500 from AO to (PARAMS_AOSize * 2)
				{
					_accepted = true;
				};
			};

			//Spawn Research HQ
			_randomDir = (random 360);
			sideObj = "Land_Medevac_house_V1_F" createVehicle _flatPos;
			waitUntil {alive sideObj};
			sideObj setDir _randomDir;
			sideObj setPos [(getPos sideObj select 0), (getPos sideObj select 1), ((getPos sideObj select 2) - 0.5)];
			sideObj setVectorUp [0,0,1];

			//Spawn some enemies around the objective
			_unitsArray = [sideObj];
			_x = 0;
			for "_x" from 0 to 2 do
			{
				_randomPos = [_flatPos, 50] call aw_fnc_randomPos;
				_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam_AA")] call BIS_fnc_spawnGroup;
				[_spawnGroup, _flatPos,50] call aw_fnc_spawn2_perimeterPatrol;
				[(units _spawnGroup)] call aw_setGroupSkill;

						if(DEBUG) then
		{
			_name = format ["%1%2",name (leader _spawnGroup),_x];
			createMarker [_name,getPos (leader _spawnGroup)];
			_name setMarkerType "o_unknown";
			_name setMarkerText format ["Squad Patrol %1",_x];
			_name setMarkerColor "ColorRed";
			[_spawnGroup,_name] spawn
			{
				private["_group","_marker"];
				_group = _this select 0;
				_marker = _this select 1;

				while{count (units _group) > 0} do
				{
					_marker setMarkerPos (getPos (leader _group));
					sleep 0.1;
				};
				deleteMarker _marker;
			};
		};

				_unitsArray = _unitsArray + [_spawnGroup];
			};

			_x = 0;
			for "_x" from 0 to 2 do
			{
				_randomPos = [_flatPos, 250] call aw_fnc_randomPos;
				_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OI_reconSentry")] call BIS_fnc_spawnGroup;
				[_spawnGroup, _flatPos, 300] call aw_fnc_spawn2_perimeterPatrol;
				[(units _spawnGroup)] call aw_setGroupSkill;

						if(DEBUG) then
		{
			_name = format ["%1%2",name (leader _spawnGroup),_x];
			createMarker [_name,getPos (leader _spawnGroup)];
			_name setMarkerType "o_unknown";
			_name setMarkerText format ["Squad Patrol %1",_x];
			_name setMarkerColor "ColorRed";
			[_spawnGroup,_name] spawn
			{
				private["_group","_marker"];
				_group = _this select 0;
				_marker = _this select 1;

				while{count (units _group) > 0} do
				{
					_marker setMarkerPos (getPos (leader _group));
					sleep 0.1;
				};
				deleteMarker _marker;
			};
		};

				_unitsArray = _unitsArray + [_spawnGroup];
			};

			_x = 0;
			for "_x" from 0 to 1 do
			{
				_randomPos = [_flatPos, 200] call aw_fnc_randomPos;
				_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OI_reconTeam")] call BIS_fnc_spawnGroup;
				[_spawnGroup, _flatPos, 150] call aw_fnc_spawn2_perimeterPatrol;
				[(units _spawnGroup)] call aw_setGroupSkillSpecial;

				_unitsArray = _unitsArray + [_spawnGroup];
			};

			_spawnGroup = createGroup east;
			_randomPos = [_flatPos, 100,10] call aw_fnc_randomPos;
			_armour = "O_APC_Tracked_02_AA_F" createVehicle _randomPos;
			waitUntil{!isNull _armour};

			"O_soldier_repair_F" createUnit [_randomPos,_spawnGroup];
			"O_crew_F" createUnit [_randomPos,_spawnGroup];
			"O_crew_F" createUnit [_randomPos,_spawnGroup];

			((units _spawnGroup) select 0) assignAsDriver _armour;
			((units _spawnGroup) select 1) assignAsGunner _armour;
			((units _spawnGroup) select 2) assignAsCommander _armour;
			((units _spawnGroup) select 0) moveInDriver _armour;
			((units _spawnGroup) select 1) moveInGunner _armour;
			((units _spawnGroup) select 2) moveInCommander _armour;
			[_spawnGroup, _flatPos, 300] call aw_fnc_spawn2_randomPatrol;
			_armour spawn aw_fnc_fuelMonitor;
			_unitsArray = _unitsArray + [_spawnGroup];
			//[(units _spawnGroup)] call aw_setGroupSkill;
			_armour lock true;

			_spawnGroup = createGroup east;
			_randomPos = [_flatPos, 100,10] call aw_fnc_randomPos;
			_armour = "O_MRAP_02_hmg_F" createVehicle _randomPos;
			waitUntil{!isNull _armour};

			"O_soldier_repair_F" createUnit [_randomPos,_spawnGroup];
			"O_crew_F" createUnit [_randomPos,_spawnGroup];

			((units _spawnGroup) select 0) assignAsDriver _armour;
			((units _spawnGroup) select 1) assignAsGunner _armour;
			((units _spawnGroup) select 0) moveInDriver _armour;
			((units _spawnGroup) select 1) moveInGunner _armour;
			[_spawnGroup, _flatPos, 300] call aw_fnc_spawn2_randomPatrol;
			_armour spawn aw_fnc_fuelMonitor;
			_unitsArray = _unitsArray + [_spawnGroup];
			//[(units _spawnGroup)] call aw_setGroupSkill;
			_armour lock true;

			_spawnGroup = createGroup east;
			_randomPos = [_flatPos, 100,10] call aw_fnc_randomPos;
			_armour = "O_MRAP_02_hmg_F" createVehicle _randomPos;
			waitUntil{!isNull _armour};

			"O_soldier_repair_F" createUnit [_randomPos,_spawnGroup];
			"O_crew_F" createUnit [_randomPos,_spawnGroup];

			((units _spawnGroup) select 0) assignAsDriver _armour;
			((units _spawnGroup) select 1) assignAsGunner _armour;
			((units _spawnGroup) select 0) moveInDriver _armour;
			((units _spawnGroup) select 1) moveInGunner _armour;
			[_spawnGroup, _flatPos, 300] call aw_fnc_spawn2_randomPatrol;
			_armour spawn aw_fnc_fuelMonitor;
			_unitsArray = _unitsArray + [_spawnGroup];
			//[(units _spawnGroup)] call aw_setGroupSkill;
			_armour lock true;

			_spawnGroup = createGroup east;
			_randomPos = [_flatPos, 20,10] call aw_fnc_randomPos;
			_armour = "C_SUV_01_F" createVehicle _randomPos;
			waitUntil{!isNull _armour};

			"O_officer_F" createUnit [_randomPos,_spawnGroup];
			"O_soldierU_medic_F" createUnit [_randomPos,_spawnGroup];
			"O_soldier_repair_F" createUnit [_randomPos,_spawnGroup];

			((units _spawnGroup) select 0) assignAsCargo _armour;
			((units _spawnGroup) select 1) assignAsCargo _armour;
			((units _spawnGroup) select 2) assignAsCargo _armour;
			((units _spawnGroup) select 0) moveInCargo _armour;
			((units _spawnGroup) select 1) moveInCargo _armour;
			((units _spawnGroup) select 2) moveInCargo _armour;

			((units _spawnGroup) select 0) moveInDriver _armour;
			[_spawnGroup, _flatPos, 300] call aw_fnc_spawn2_randomPatrol;
			_armour spawn aw_fnc_fuelMonitor;
			_unitsArray = _unitsArray + [_spawnGroup];
			//[(units _spawnGroup)] call aw_setGroupSkill;
			_armour lock true;

		if(DEBUG) then
		{
			_name = format ["%1%2",name (leader _spawnGroup),_x];
			createMarker [_name,getPos (leader _spawnGroup)];
			_name setMarkerType "o_unknown";
			_name setMarkerText format ["Squad Patrol %1",_x];
			_name setMarkerColor "ColorRed";
			[_spawnGroup,_name] spawn
			{
				private["_group","_marker"];
				_group = _this select 0;
				_marker = _this select 1;

				while{count (units _group) > 0} do
				{
					_marker setMarkerPos (getPos (leader _group));
					sleep 0.1;
				};
				deleteMarker _marker;
			};
		};

			//Set marker up
			_fuzzyPos =
			[
				((_flatPos select 0) - 300) + (random 600),
				((_flatPos select 1) - 300) + (random 600),
				0
			];

			{ _x setMarkerPos _fuzzyPos; } forEach ["sideMarker", "sideCircle"];
			"sideMarker" setMarkerText "Side Mission: Destroy Research Outpost";
			publicVariable "sideMarker";
			publicVariable "sideObj";

			//Throw briefing hint
			GlobalHint = _briefing; publicVariable "GlobalHint"; hint parseText GlobalHint;
			showNotification = ["NewSideMission", "Destroy Research Outpost"]; publicVariable "showNotification";

			sideMissionUp = true;
			publicVariable "sideMissionUp";
			sideMarkerText = "Destroy Research Outpost";
			publicVariable "sideMarkerText";

			//Wait for boats to be dead
			waitUntil {sleep 0.5; !alive sideObj};

			sideMissionUp = false;
			publicVariable "sideMissionUp";

			//Improve this to do some randomised mortar explosions quite quickly after the killing of the building in a small radius

			//Throw completion hint
			[] call AW_fnc_rewardPlusHint;

			[_unitsArray] spawn GC_fnc_deleteOldUnitsAndVehicles;
			[_unitsArray] spawn AW_fnc_deleteOldSMUnits;
			deleteVehicle sideObj;
			//Hide marker
			"sideMarker" setMarkerPos [0,0,0];
			"sideCircle" setMarkerPos [0,0,0];
			sleep 5;
			publicVariable "sideMarker";
			[] spawn aw_cleanGroups;
		}; /* case "destroyResearchOutpost": */

		case "destroyWeaponsSupply":
		{
			//Set up briefing message
			_briefing =
			"<t align='center'><t size='2.2'>New Side Mission</t><br/><t size='1.5' color='#00B2EE'>Intercept Weapons Transfer</t><br/>____________________<br/>Rogue Independents are supplying OPFOR with advanced weapons and intel.<br/><br/>We've marked the transfer building on your map. They are using an old cargo house. Head over there and destroy it before the transfer is complete!</t>";

			_flatPos = [0,0,0];
			_accepted = false;
			while {!_accepted} do
			{
				_position = [] call BIS_fnc_randomPos;
				_flatPos = _position isFlatEmpty
				[
					5,
					1,
					0.5,
					sizeOf "Land_research_hq_f",
					0,
					false
				];

				while {(count _flatPos) < 1} do
				{
					_position = [] call BIS_fnc_randomPos;
					_flatPos = _position isFlatEmpty
					[
						10,
						1,
						0.5,
						sizeOf "Land_research_hq_f",
						0,
						false
					];
				};

				if ((_flatPos distance (getMarkerPos "respawn_west")) > 1700 && (_flatPos distance (getMarkerPos currentAO)) > 500) then //DEBUG - set >500 from AO to (PARAMS_AOSize * 2)
				{
					_accepted = true;
				};
			};

			//Spawn Weapons Supply House
			sideObj = "Land_research_hq_f" createVehicle _flatPos;
			waitUntil {alive sideObj};
			sideObj setPos [(getPos sideObj select 0), (getPos sideObj select 1), ((getPos sideObj select 2)-0.25)];
			sideObj setVectorUp [0,0,1];
			_fuzzyPos =
			[
				((_flatPos select 0) - 300) + (random 600),
				((_flatPos select 1) - 300) + (random 600),
				0
			];

			{ _x setMarkerPos _fuzzyPos; } forEach ["sideMarker", "sideCircle"];
			"sideMarker" setMarkerText "Side Mission: Destroy Weapons Depot";
			publicVariable "sideMarker";
			publicVariable "sideObj";

			//Spawn some enemies around the objective
			_unitsArray = [sideObj];
			_x = 0;
			for "_x" from 0 to 1 do
			{
				_randomPos = [_flatPos, 100] call aw_fnc_randomPos;
				_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Infantry" >> "HAF_InfTeam")] call BIS_fnc_spawnGroup;
				[_spawnGroup, _flatPos,100] call aw_fnc_spawn2_perimeterPatrol;
				[(units _spawnGroup)] call aw_setGroupSkill;

						if(DEBUG) then
		{
			_name = format ["%1%2",name (leader _spawnGroup),_x];
			createMarker [_name,getPos (leader _spawnGroup)];
			_name setMarkerType "o_unknown";
			_name setMarkerText format ["Squad Patrol %1",_x];
			_name setMarkerColor "ColorRed";
			[_spawnGroup,_name] spawn
			{
				private["_group","_marker"];
				_group = _this select 0;
				_marker = _this select 1;

				while{count (units _group) > 0} do
				{
					_marker setMarkerPos (getPos (leader _group));
					sleep 0.1;
				};
				deleteMarker _marker;
			};
		};

				_unitsArray = _unitsArray + [_spawnGroup];
			};

			_x = 0;
			for "_x" from 0 to 2 do
			{
				_randomPos = [_flatPos, 100] call aw_fnc_randomPos;
				_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Infantry" >> "HAF_InfTeam_AA")] call BIS_fnc_spawnGroup;
				[_spawnGroup, _flatPos, 300] call aw_fnc_spawn2_randomPatrol;
				[(units _spawnGroup)] call aw_setGroupSkill;

						if(DEBUG) then
		{
			_name = format ["%1%2",name (leader _spawnGroup),_x];
			createMarker [_name,getPos (leader _spawnGroup)];
			_name setMarkerType "o_unknown";
			_name setMarkerText format ["Squad Patrol %1",_x];
			_name setMarkerColor "ColorRed";
			[_spawnGroup,_name] spawn
			{
				private["_group","_marker"];
				_group = _this select 0;
				_marker = _this select 1;

				while{count (units _group) > 0} do
				{
					_marker setMarkerPos (getPos (leader _group));
					sleep 0.1;
				};
				deleteMarker _marker;
			};
		};

				_unitsArray = _unitsArray + [_spawnGroup];
			};

			_x = 0;
			for "_x" from 0 to 1 do
			{
				_randomPos = [_flatPos, 100] call aw_fnc_randomPos;
				_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Infantry" >> "HAF_InfSquad")] call BIS_fnc_spawnGroup;
				[_spawnGroup, _flatPos, 300] call aw_fnc_spawn2_randomPatrol;
				[(units _spawnGroup)] call aw_setGroupSkill;

						if(DEBUG) then
		{
			_name = format ["%1%2",name (leader _spawnGroup),_x];
			createMarker [_name,getPos (leader _spawnGroup)];
			_name setMarkerType "o_unknown";
			_name setMarkerText format ["Squad Patrol %1",_x];
			_name setMarkerColor "ColorRed";
			[_spawnGroup,_name] spawn
			{
				private["_group","_marker"];
				_group = _this select 0;
				_marker = _this select 1;

				while{count (units _group) > 0} do
				{
					_marker setMarkerPos (getPos (leader _group));
					sleep 0.1;
				};
				deleteMarker _marker;
			};
		};

				_unitsArray = _unitsArray + [_spawnGroup];
			};

			_spawnGroup = createGroup east;
			_randomPos = [_flatPos, 100,10] call aw_fnc_randomPos;
			_armour = "O_APC_Tracked_02_AA_F" createVehicle _randomPos;
			waitUntil{!isNull _armour};

			"O_soldier_repair_F" createUnit [_randomPos,_spawnGroup];
			"O_crew_F" createUnit [_randomPos,_spawnGroup];
			"O_crew_F" createUnit [_randomPos,_spawnGroup];

			((units _spawnGroup) select 0) assignAsDriver _armour;
			((units _spawnGroup) select 1) assignAsGunner _armour;
			((units _spawnGroup) select 2) assignAsCommander _armour;
			((units _spawnGroup) select 0) moveInDriver _armour;
			((units _spawnGroup) select 1) moveInGunner _armour;
			((units _spawnGroup) select 2) moveInCommander _armour;
			[_spawnGroup, _flatPos, 300] call aw_fnc_spawn2_randomPatrol;
			_armour spawn aw_fnc_fuelMonitor;
			_unitsArray = _unitsArray + [_spawnGroup];
			//[(units _spawnGroup)] call aw_setGroupSkill;
			_armour lock true;

			_spawnGroup = createGroup east;
			_randomPos = [_flatPos, 100,10] call aw_fnc_randomPos;
			_armour = "I_MRAP_03_hmg_F" createVehicle _randomPos;
			waitUntil{!isNull _armour};

			"I_crew_F" createUnit [_randomPos,_spawnGroup];
			"I_crew_F" createUnit [_randomPos,_spawnGroup];
			"I_crew_F" createUnit [_randomPos,_spawnGroup];

			((units _spawnGroup) select 0) assignAsDriver _armour;
			((units _spawnGroup) select 1) assignAsGunner _armour;
			((units _spawnGroup) select 2) assignAsCommander _armour;
			((units _spawnGroup) select 0) moveInDriver _armour;
			((units _spawnGroup) select 1) moveInGunner _armour;
			((units _spawnGroup) select 2) moveInCommander _armour;
			[_spawnGroup, _flatPos, 300] call aw_fnc_spawn2_randomPatrol;
			_armour spawn aw_fnc_fuelMonitor;
			_unitsArray = _unitsArray + [_spawnGroup];
			//[(units _spawnGroup)] call aw_setGroupSkill;
			_armour lock true;

			_spawnGroup = createGroup east;
			_randomPos = [_flatPos, 100,30] call aw_fnc_randomPos;
			_armour = "I_APC_tracked_03_cannon_F" createVehicle _randomPos;
			waitUntil{!isNull _armour};

			"O_soldier_repair_F" createUnit [_randomPos,_spawnGroup];
			"I_crew_F" createUnit [_randomPos,_spawnGroup];
			"I_crew_F" createUnit [_randomPos,_spawnGroup];

			((units _spawnGroup) select 0) assignAsDriver _armour;
			((units _spawnGroup) select 1) assignAsGunner _armour;
			((units _spawnGroup) select 2) assignAsCommander _armour;
			((units _spawnGroup) select 0) moveInDriver _armour;
			((units _spawnGroup) select 1) moveInGunner _armour;
			((units _spawnGroup) select 2) moveInCommander _armour;
			[_spawnGroup, _flatPos, 300] call aw_fnc_spawn2_randomPatrol;
			_armour spawn aw_fnc_fuelMonitor;
			_unitsArray = _unitsArray + [_spawnGroup];
			//[(units _spawnGroup)] call aw_setGroupSkill;
			_armour lock true;

		if(DEBUG) then
		{
			_name = format ["%1%2",name (leader _spawnGroup),_x];
			createMarker [_name,getPos (leader _spawnGroup)];
			_name setMarkerType "o_unknown";
			_name setMarkerText format ["Squad Patrol %1",_x];
			_name setMarkerColor "ColorRed";
			[_spawnGroup,_name] spawn
			{
				private["_group","_marker"];
				_group = _this select 0;
				_marker = _this select 1;

				while{count (units _group) > 0} do
				{
					_marker setMarkerPos (getPos (leader _group));
					sleep 0.1;
				};
				deleteMarker _marker;
			};
		};

			//Throw briefing hint
			GlobalHint = _briefing; publicVariable "GlobalHint"; hint parseText GlobalHint;
			showNotification = ["NewSideMission", "Destroy Weapons Depot"]; publicVariable "showNotification";

			sideMissionUp = true;
			publicVariable "sideMissionUp";
			sideMarkerText = "Destroy Weapons Depot";
			publicVariable "sideMarkerText";

			//Wait for boats to be dead
			waitUntil {sleep 0.5; !alive sideObj};

			sideMissionUp = false;
			publicVariable "sideMissionUp";

			//Improve this to do some randomised mortar explosions quite quickly after the killing of the building in a small radius

			//Throw completion hint
			[] call AW_fnc_rewardPlusHint;

			[_unitsArray] spawn GC_fnc_deleteOldUnitsAndVehicles;
			[_unitsArray] spawn AW_fnc_deleteOldSMUnits;
			deleteVehicle sideObj;
			//Hide marker
			"sideMarker" setMarkerPos [0,0,0];
			"sideCircle" setMarkerPos [0,0,0];
			sleep 5;
			publicVariable "sideMarker";
			[] spawn aw_cleanGroups;
		}; /* case "destroyWeaponsSupply": */

		case "destroyInsurgentHQ":
		{
			//Set up briefing message
			_briefing =
			"<t align='center'><t size='2.2'>New Side Mission</t><br/><t size='1.5' color='#00B2EE'>Destroy Insurgency HQ</t><br/>____________________<br/>OPFOR are training an insurgency on Altis.<br/><br/>We've marked the position on your map; head over there, sanitize the area and destroy their HQ.</t>";

			_flatPos = [0,0,0];
			_accepted = false;
			while {!_accepted} do
			{
				//Get random safe position somewhere on the island
				_position = [] call BIS_fnc_randomPos;
				_flatPos = _position isFlatEmpty
				[
					5, //minimal distance from another object
					1, //try and find nearby positions if original is incorrect
					0.5, //30% max gradient
					sizeOf "Land_Cargo_HQ_V2_F",
					0, //no water
					false //don't find positions near the shoreline
				];

				while {(count _flatPos) < 1} do
				{
					_position = [] call BIS_fnc_randomPos;
					_flatPos = _position isFlatEmpty
					[
						10, //minimal distance from another object
						1, //try and find nearby positions if original is incorrect
						0.5, //30% max gradient
						sizeOf "Land_Cargo_HQ_V2_F",
						0, //no water
						false //don't find positions near the shoreline
					];
				};

				if ((_flatPos distance (getMarkerPos "respawn_west")) > 1000 && (_flatPos distance (getMarkerPos currentAO)) > 500) then //DEBUG - set >500 from AO to (PARAMS_AOSize * 2)
				{
					_accepted = true;
				};
			};

			//Spawn HQ, set vector and add marker
			sideObj = "Land_Cargo_HQ_V2_F" createVehicle _flatPos;
			waitUntil {alive sideObj};
			sideObj setPos [(getPos sideObj select 0), (getPos sideObj select 1), ((getPos sideObj select 2) - 0.05)];
			sideObj setVectorUp [0,0,1];
			_fuzzyPos =
			[
				((_flatPos select 0) - 300) + (random 600),
				((_flatPos select 1) - 300) + (random 600),
				0
			];

			{ _x setMarkerPos _fuzzyPos; } forEach ["sideMarker", "sideCircle"];
			"sideMarker" setMarkerText "Side Mission: Destroy Insurgency HQ";
			publicVariable "sideMarker";
			publicVariable "sideObj";

			//Spawn some enemies around the objective
			_unitsArray = [sideObj];
			_x = 0;
			for "_x" from 0 to 1 do
			{
				_randomPos = [_flatPos, 100] call aw_fnc_randomPos;
				_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "West" >> "Guerilla" >> "Infantry" >> "IRG_InfSquad")] call BIS_fnc_spawnGroup;
				[_spawnGroup, _flatPos,200] call aw_fnc_spawn2_perimeterPatrol;
				[(units _spawnGroup)] call aw_setGroupSkill;

						if(DEBUG) then
		{
			_name = format ["%1%2",name (leader _spawnGroup),_x];
			createMarker [_name,getPos (leader _spawnGroup)];
			_name setMarkerType "o_unknown";
			_name setMarkerText format ["Squad Patrol %1",_x];
			_name setMarkerColor "ColorRed";
			[_spawnGroup,_name] spawn
			{
				private["_group","_marker"];
				_group = _this select 0;
				_marker = _this select 1;

				while{count (units _group) > 0} do
				{
					_marker setMarkerPos (getPos (leader _group));
					sleep 0.1;
				};
				deleteMarker _marker;
			};
		};

				_unitsArray = _unitsArray + [_spawnGroup];
			};

			_x = 0;
			for "_x" from 0 to 2 do
			{
				_randomPos = [_flatPos, 50] call aw_fnc_randomPos;
				_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "West" >> "Guerilla" >> "Infantry" >> "IRG_InfTeam_AT")] call BIS_fnc_spawnGroup;
				[_spawnGroup, _flatPos, 300] call aw_fnc_spawn2_randomPatrol;
				[(units _spawnGroup)] call aw_setGroupSkill;

						if(DEBUG) then
		{
			_name = format ["%1%2",name (leader _spawnGroup),_x];
			createMarker [_name,getPos (leader _spawnGroup)];
			_name setMarkerType "o_unknown";
			_name setMarkerText format ["Squad Patrol %1",_x];
			_name setMarkerColor "ColorRed";
			[_spawnGroup,_name] spawn
			{
				private["_group","_marker"];
				_group = _this select 0;
				_marker = _this select 1;

				while{count (units _group) > 0} do
				{
					_marker setMarkerPos (getPos (leader _group));
					sleep 0.1;
				};
				deleteMarker _marker;
			};
		};

				_unitsArray = _unitsArray + [_spawnGroup];
			};

			_x = 0;
			for "_x" from 0 to 1 do
			{
				_randomPos = [_flatPos, 50] call aw_fnc_randomPos;
				_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "West" >> "Guerilla" >> "Infantry" >> "IRG_InfSentry")] call BIS_fnc_spawnGroup;
				[_spawnGroup, _flatPos, 300] call aw_fnc_spawn2_perimeterPatrol;
				[(units _spawnGroup)] call aw_setGroupSkill;

						if(DEBUG) then
		{
			_name = format ["%1%2",name (leader _spawnGroup),_x];
			createMarker [_name,getPos (leader _spawnGroup)];
			_name setMarkerType "o_unknown";
			_name setMarkerText format ["Squad Patrol %1",_x];
			_name setMarkerColor "ColorRed";
			[_spawnGroup,_name] spawn
			{
				private["_group","_marker"];
				_group = _this select 0;
				_marker = _this select 1;

				while{count (units _group) > 0} do
				{
					_marker setMarkerPos (getPos (leader _group));
					sleep 0.1;
				};
				deleteMarker _marker;
			};
		};

				_unitsArray = _unitsArray + [_spawnGroup];
			};

			_x = 0;
			for "_x" from 0 to 1 do
			{
				_randomPos = [_flatPos, 50] call aw_fnc_randomPos;
				_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OI_reconPatrol")] call BIS_fnc_spawnGroup;
				[_spawnGroup, _flatPos, 300] call aw_fnc_spawn2_randomPatrol;
				[(units _spawnGroup)] call aw_setGroupSkillSpecial;

				_unitsArray = _unitsArray + [_spawnGroup];
			};

			_spawnGroup = createGroup east;
			_randomPos = [_flatPos, 100,10] call aw_fnc_randomPos;
			_armour = "O_APC_Tracked_02_AA_F" createVehicle _randomPos;
			waitUntil{!isNull _armour};

			"O_soldier_repair_F" createUnit [_randomPos,_spawnGroup];
			"O_crew_F" createUnit [_randomPos,_spawnGroup];
			"O_crew_F" createUnit [_randomPos,_spawnGroup];

			((units _spawnGroup) select 0) assignAsDriver _armour;
			((units _spawnGroup) select 1) assignAsGunner _armour;
			((units _spawnGroup) select 2) assignAsCommander _armour;
			((units _spawnGroup) select 0) moveInDriver _armour;
			((units _spawnGroup) select 1) moveInGunner _armour;
			((units _spawnGroup) select 2) moveInCommander _armour;
			[_spawnGroup, _flatPos, 300] call aw_fnc_spawn2_randomPatrol;
			_armour spawn aw_fnc_fuelMonitor;
			_unitsArray = _unitsArray + [_spawnGroup];
			//[(units _spawnGroup)] call aw_setGroupSkill;
			_armour lock true;

			_spawnGroup = createGroup east;
			_randomPos = [_flatPos, 100,10] call aw_fnc_randomPos;
			_armour = "B_G_Offroad_01_armed_F" createVehicle _randomPos;
			waitUntil{!isNull _armour};

			"O_soldier_repair_F" createUnit [_randomPos,_spawnGroup];
			"O_crew_F" createUnit [_randomPos,_spawnGroup];
			"O_crew_F" createUnit [_randomPos,_spawnGroup];

			((units _spawnGroup) select 0) assignAsDriver _armour;
			((units _spawnGroup) select 1) assignAsGunner _armour;
			((units _spawnGroup) select 2) assignAsCommander _armour;
			((units _spawnGroup) select 0) moveInDriver _armour;
			((units _spawnGroup) select 1) moveInGunner _armour;
			((units _spawnGroup) select 2) moveInCommander _armour;
			[_spawnGroup, _flatPos, 300] call aw_fnc_spawn2_randomPatrol;
			_armour spawn aw_fnc_fuelMonitor;
			_unitsArray = _unitsArray + [_spawnGroup];
			//[(units _spawnGroup)] call aw_setGroupSkillSpecial;
			_armour lock true;

			_spawnGroup = createGroup east;
			_randomPos = [_flatPos, 100,10] call aw_fnc_randomPos;
			_armour = "B_G_Offroad_01_armed_F" createVehicle _randomPos;
			waitUntil{!isNull _armour};

			"O_soldier_repair_F" createUnit [_randomPos,_spawnGroup];
			"O_crew_F" createUnit [_randomPos,_spawnGroup];
			"O_crew_F" createUnit [_randomPos,_spawnGroup];

			((units _spawnGroup) select 0) assignAsDriver _armour;
			((units _spawnGroup) select 1) assignAsGunner _armour;
			((units _spawnGroup) select 2) assignAsCommander _armour;
			((units _spawnGroup) select 0) moveInDriver _armour;
			((units _spawnGroup) select 1) moveInGunner _armour;
			((units _spawnGroup) select 2) moveInCommander _armour;
			[_spawnGroup, _flatPos, 300] call aw_fnc_spawn2_randomPatrol;
			_armour spawn aw_fnc_fuelMonitor;
			_unitsArray = _unitsArray + [_spawnGroup];
			//[(units _spawnGroup)] call aw_setGroupSkillSpecial;
			_armour lock true;

			//Throw out objective hint
			GlobalHint = _briefing; publicVariable "GlobalHint"; hint parseText GlobalHint;
			showNotification = ["NewSideMission", "Destroy Insurgency HQ"]; publicVariable "showNotification";

			sideMissionUp = true;
			publicVariable "sideMissionUp";
			sideMarkerText = "Destroy Insurgency HQ";
			publicVariable "sideMarkerText";

			waitUntil {sleep 0.5; !alive sideObj}; //wait until the objective is destroyed

			sideMissionUp = false;
			publicVariable "sideMissionUp";

			//Throw out objective completion hint
			[] call AW_fnc_rewardPlusHint;

			[_unitsArray] spawn GC_fnc_deleteOldUnitsAndVehicles;
			[_unitsArray] spawn AW_fnc_deleteOldSMUnits;
			deleteVehicle sideObj;
			//Hide marker
			"sideMarker" setMarkerPos [0,0,0];
			"sideCircle" setMarkerPos [0,0,0];
			publicVariable "sideMarker";

		}; /* case "destroyInsurgentHQ": */

		case "destroyRogueHQ":
		{
			//Set up briefing message
			_briefing =
			"<t align='center'><t size='2.2'>New Side Mission</t><br/><t size='1.5' color='#00B2EE'>Eliminate Rogue BLUFOR Unit</t><br/>____________________<br/>Treason! A section of BLUFOR soldiers have gone rogue and are working with OPFOR!  <br/><br/>Take them out and destroy their HQ!</t>";

			_flatPos = [0,0,0];
			_accepted = false;
			while {!_accepted} do
			{
				_position = [] call BIS_fnc_randomPos;
				_flatPos = _position isFlatEmpty
				[
					5, //minimal distance from another object
					0, //try and find nearby positions if original is incorrect
					0.5, //30% max gradient
					1,
					0, //no water
					false //don't find positions near the shoreline
				];

				while {(count _flatPos) < 1} do
				{
				_position = [] call BIS_fnc_randomPos;
				_flatPos = _position isFlatEmpty
					[
						10, //minimal distance from another object
						0, //try and find nearby positions if original is incorrect
						0.5, //30% max gradient
						1,
						0, //no water
						false //don't find positions near the shoreline
					];
				};

				if ((_flatPos distance (getMarkerPos "respawn_west")) > 1000 && (_flatPos distance (getMarkerPos currentAO)) > 500) then //DEBUG - set >500 from AO to (PARAMS_AOSize * 2)
				{
					_accepted = true;
				};
			};

			//Spawn HQ, set vector and add marker
			sideObj = "Land_research_hq_f" createVehicle _flatPos;
			waitUntil {alive sideObj};
			sideObj setPos [(getPos sideObj select 0), (getPos sideObj select 1), ((getPos sideObj select 2) - 0.5)];
			sideObj setVectorUp [0,0,1];
			_fuzzyPos =
			[
				((_flatPos select 0) - 300) + (random 600),
				((_flatPos select 1) - 300) + (random 600),
				0
			];

			{ _x setMarkerPos _fuzzyPos; } forEach ["sideMarker", "sideCircle"];
			"sideMarker" setMarkerText "Side Mission: Eliminate Rogue HQ";
			publicVariable "sideMarker";
			publicVariable "sideObj";

			//Spawn some enemies around the objective
			_unitsArray = [sideObj];
			_x = 0;
			for "_x" from 0 to 1 do
			{
				_randomPos = [_flatPos, 50] call aw_fnc_randomPos;
				_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfTeam")] call BIS_fnc_spawnGroup;
				[_spawnGroup, _flatPos,200] call aw_fnc_spawn2_perimeterPatrol;
				[(units _spawnGroup)] call aw_setGroupSkill;

						if(DEBUG) then
		{
			_name = format ["%1%2",name (leader _spawnGroup),_x];
			createMarker [_name,getPos (leader _spawnGroup)];
			_name setMarkerType "o_unknown";
			_name setMarkerText format ["Squad Patrol %1",_x];
			_name setMarkerColor "ColorRed";
			[_spawnGroup,_name] spawn
			{
				private["_group","_marker"];
				_group = _this select 0;
				_marker = _this select 1;

				while{count (units _group) > 0} do
				{
					_marker setMarkerPos (getPos (leader _group));
					sleep 0.1;
				};
				deleteMarker _marker;
			};
		};

				_unitsArray = _unitsArray + [_spawnGroup];
			};

			_x = 0;
			for "_x" from 0 to 2 do
			{
				_randomPos = [_flatPos, 50] call aw_fnc_randomPos;
				_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfTeam_AA")] call BIS_fnc_spawnGroup;
				[_spawnGroup, _flatPos, 300] call aw_fnc_spawn2_randomPatrol;
				[(units _spawnGroup)] call aw_setGroupSkill;

						if(DEBUG) then
		{
			_name = format ["%1%2",name (leader _spawnGroup),_x];
			createMarker [_name,getPos (leader _spawnGroup)];
			_name setMarkerType "o_unknown";
			_name setMarkerText format ["Squad Patrol %1",_x];
			_name setMarkerColor "ColorRed";
			[_spawnGroup,_name] spawn
			{
				private["_group","_marker"];
				_group = _this select 0;
				_marker = _this select 1;

				while{count (units _group) > 0} do
				{
					_marker setMarkerPos (getPos (leader _group));
					sleep 0.1;
				};
				deleteMarker _marker;
			};
		};

				_unitsArray = _unitsArray + [_spawnGroup];
			};

			_x = 0;
			for "_x" from 0 to 1 do
			{
				_randomPos = [_flatPos, 50] call aw_fnc_randomPos;
				_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfTeam_AT")] call BIS_fnc_spawnGroup;
				[_spawnGroup, _flatPos, 300] call aw_fnc_spawn2_perimeterPatrol;
				[(units _spawnGroup)] call aw_setGroupSkill;

						if(DEBUG) then
		{
			_name = format ["%1%2",name (leader _spawnGroup),_x];
			createMarker [_name,getPos (leader _spawnGroup)];
			_name setMarkerType "o_unknown";
			_name setMarkerText format ["Squad Patrol %1",_x];
			_name setMarkerColor "ColorRed";
			[_spawnGroup,_name] spawn
			{
				private["_group","_marker"];
				_group = _this select 0;
				_marker = _this select 1;

				while{count (units _group) > 0} do
				{
					_marker setMarkerPos (getPos (leader _group));
					sleep 0.1;
				};
				deleteMarker _marker;
			};
		};

				_unitsArray = _unitsArray + [_spawnGroup];
			};

			_x = 0;
			for "_x" from 0 to 1 do
			{
				_randomPos = [_flatPos, 50] call aw_fnc_randomPos;
				_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSentry")] call BIS_fnc_spawnGroup;
				[_spawnGroup, _flatPos, 300] call aw_fnc_spawn2_randomPatrol;
				[(units _spawnGroup)] call aw_setGroupSkill;

						if(DEBUG) then
		{
			_name = format ["%1%2",name (leader _spawnGroup),_x];
			createMarker [_name,getPos (leader _spawnGroup)];
			_name setMarkerType "o_unknown";
			_name setMarkerText format ["Squad Patrol %1",_x];
			_name setMarkerColor "ColorRed";
			[_spawnGroup,_name] spawn
			{
				private["_group","_marker"];
				_group = _this select 0;
				_marker = _this select 1;

				while{count (units _group) > 0} do
				{
					_marker setMarkerPos (getPos (leader _group));
					sleep 0.1;
				};
				deleteMarker _marker;
			};
		};

				_unitsArray = _unitsArray + [_spawnGroup];
			};

			_spawnGroup = createGroup east;
			_randomPos = [_flatPos, 100,30] call aw_fnc_randomPos;
			_armour = "B_APC_Tracked_01_AA_F" createVehicle _randomPos;
			waitUntil{!isNull _armour};

			"B_crew_F" createUnit [_randomPos,_spawnGroup];
			"B_crew_F" createUnit [_randomPos,_spawnGroup];
			"B_crew_F" createUnit [_randomPos,_spawnGroup];

			((units _spawnGroup) select 0) assignAsDriver _armour;
			((units _spawnGroup) select 1) assignAsGunner _armour;
			((units _spawnGroup) select 2) assignAsCommander _armour;
			((units _spawnGroup) select 0) moveInDriver _armour;
			((units _spawnGroup) select 1) moveInGunner _armour;
			((units _spawnGroup) select 2) moveInCommander _armour;
			[_spawnGroup, _flatPos, 300] call aw_fnc_spawn2_randomPatrol;
			_armour spawn aw_fnc_fuelMonitor;
			_unitsArray = _unitsArray + [_spawnGroup];
			//[(units _spawnGroup)] call aw_setGroupSkillSpecial;
			_armour lock true;

			_spawnGroup = createGroup east;
			_randomPos = [_flatPos, 100,50] call aw_fnc_randomPos;
			_armour = "B_MRAP_01_hmg_F" createVehicle _randomPos;
			waitUntil{!isNull _armour};

			"B_G_engineer_F" createUnit [_randomPos,_spawnGroup];
			"B_G_Soldier_F" createUnit [_randomPos,_spawnGroup];
			"B_G_Soldier_F" createUnit [_randomPos,_spawnGroup];
			"B_medic_F" createUnit [_randomPos,_spawnGroup];

			((units _spawnGroup) select 0) assignAsDriver _armour;
			((units _spawnGroup) select 1) assignAsGunner _armour;
			((units _spawnGroup) select 2) assignAsCargo _armour;
			((units _spawnGroup) select 3) assignAsCargo _armour;

			((units _spawnGroup) select 0) moveInDriver _armour;
			((units _spawnGroup) select 1) moveInGunner _armour;
			((units _spawnGroup) select 2) moveInCargo _armour;
			((units _spawnGroup) select 2) moveInCargo _armour;
			[_spawnGroup, _flatPos, 300] call aw_fnc_spawn2_randomPatrol;
			_armour spawn aw_fnc_fuelMonitor;
			_unitsArray = _unitsArray + [_spawnGroup];
			//[(units _spawnGroup)] call aw_setGroupSkill;

			_spawnGroup = createGroup east;
			_randomPos = [_flatPos, 100,50] call aw_fnc_randomPos;
			_armour = "B_MRAP_01_hmg_F" createVehicle _randomPos;
			waitUntil{!isNull _armour};

			"B_G_engineer_F" createUnit [_randomPos,_spawnGroup];
			"B_G_Soldier_F" createUnit [_randomPos,_spawnGroup];
			"B_G_Soldier_F" createUnit [_randomPos,_spawnGroup];
			"B_medic_F" createUnit [_randomPos,_spawnGroup];

			((units _spawnGroup) select 0) assignAsDriver _armour;
			((units _spawnGroup) select 1) assignAsGunner _armour;
			((units _spawnGroup) select 2) assignAsCargo _armour;
			((units _spawnGroup) select 3) assignAsCargo _armour;

			((units _spawnGroup) select 0) moveInDriver _armour;
			((units _spawnGroup) select 1) moveInGunner _armour;
			((units _spawnGroup) select 2) moveInCargo _armour;
			((units _spawnGroup) select 2) moveInCargo _armour;
			[_spawnGroup, _flatPos, 300] call aw_fnc_spawn2_randomPatrol;
			_armour spawn aw_fnc_fuelMonitor;
			_unitsArray = _unitsArray + [_spawnGroup];
			//[(units _spawnGroup)] call aw_setGroupSkill;

			_spawnGroup = createGroup east;
			_randomPos = [_flatPos, 100,50] call aw_fnc_randomPos;
			_armour = "B_APC_Tracked_01_rcws_F" createVehicle _randomPos;
			waitUntil{!isNull _armour};

			"O_soldier_repair_F" createUnit [_randomPos,_spawnGroup];
			"O_crew_F" createUnit [_randomPos,_spawnGroup];
			"O_crew_F" createUnit [_randomPos,_spawnGroup];
			"O_Soldier_F" createUnit [_randomPos,_spawnGroup];
			"O_Soldier_F" createUnit [_randomPos,_spawnGroup];
			"O_Soldier_AR_F" createUnit [_randomPos,_spawnGroup];
			"O_soldier_repair_F" createUnit [_randomPos,_spawnGroup];
			"O_medic_F" createUnit [_randomPos,_spawnGroup];

			((units _spawnGroup) select 0) assignAsDriver _armour;
			((units _spawnGroup) select 1) assignAsGunner _armour;
			((units _spawnGroup) select 2) assignAsCommander _armour;
			((units _spawnGroup) select 3) assignAsCargo _armour;
			((units _spawnGroup) select 4) assignAsCargo _armour;
			((units _spawnGroup) select 5) assignAsCargo _armour;
			((units _spawnGroup) select 6) assignAsCargo _armour;
			((units _spawnGroup) select 7) assignAsCargo _armour;
			((units _spawnGroup) select 0) moveInDriver _armour;
			((units _spawnGroup) select 1) moveInGunner _armour;
			((units _spawnGroup) select 2) moveInCommander _armour;
			((units _spawnGroup) select 3) moveInCargo _armour;
			((units _spawnGroup) select 4) moveInCargo _armour;
			((units _spawnGroup) select 5) moveInCargo _armour;
			((units _spawnGroup) select 6) moveInCargo _armour;
			((units _spawnGroup) select 7) moveInCargo _armour;
			[_spawnGroup, _flatPos, 300] call aw_fnc_spawn2_randomPatrol;
			_armour spawn aw_fnc_fuelMonitor;
			_unitsArray = _unitsArray + [_spawnGroup];
			//[(units _spawnGroup)] call aw_setGroupSkill;

			spawnGroup = createGroup east;
			_randomPos = [_flatPos, 30,30] call aw_fnc_randomPos;
			_armour = "B_Truck_01_ammo_F" createVehicle _randomPos;
			waitUntil{!isNull _armour};

			"O_soldier_repair_F" createUnit [_randomPos,_spawnGroup];

			((units _spawnGroup) select 0) assignAsCargo _armour;
			((units _spawnGroup) select 0) moveInCargo _armour;

			[_spawnGroup, _flatPos, 20] call aw_fnc_spawn2_perimeterPatrol;
			_armour spawn aw_fnc_fuelMonitor;
			_unitsArray = _unitsArray + [_spawnGroup];
			//[(units _spawnGroup)] call aw_setGroupSkill;
			_armour lock true;

		if(DEBUG) then
		{
			_name = format ["%1%2",name (leader _spawnGroup),_x];
			createMarker [_name,getPos (leader _spawnGroup)];
			_name setMarkerType "o_unknown";
			_name setMarkerText format ["Squad Patrol %1",_x];
			_name setMarkerColor "ColorRed";
			[_spawnGroup,_name] spawn
			{
				private["_group","_marker"];
				_group = _this select 0;
				_marker = _this select 1;

				while{count (units _group) > 0} do
				{
					_marker setMarkerPos (getPos (leader _group));
					sleep 0.1;
				};
				deleteMarker _marker;
			};
		};

			//Throw out objective hint
			GlobalHint = _briefing; publicVariable "GlobalHint"; hint parseText GlobalHint;
			showNotification = ["NewSideMission", "Destroy Rogue HQ"]; publicVariable "showNotification";

			sideMissionUp = true;
			publicVariable "sideMissionUp";
			sideMarkerText = "Destroy Rogue HQ";
			publicVariable "sideMarkerText";

			waitUntil {sleep 0.5; !alive sideObj}; //wait until the objective is destroyed

			sideMissionUp = false;
			publicVariable "sideMissionUp";

			//Throw out objective completion hint
			[] call AW_fnc_rewardPlusHint;

			[_unitsArray] spawn GC_fnc_deleteOldUnitsAndVehicles;
			[_unitsArray] spawn AW_fnc_deleteOldSMUnits;
			deleteVehicle sideObj;
			//Hide marker
			"sideMarker" setMarkerPos [0,0,0];
			"sideCircle" setMarkerPos [0,0,0];
			publicVariable "sideMarker";

		}; /* case "destroyRogueHQ": */
	};
};