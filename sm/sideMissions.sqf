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
*/

//Create base array of differing side missions

private ["_firstRun","_mission","_isGroup","_obj","_skipTimer","_awayFromBase","_road","_position","_deadHint","_civArray","_briefing","_altPosition","_truck","_chosenCiv","_contactPos","_civ","_flatPos","_accepted","_randomPos","_spawnGroup","_unitsArray","_randomDir","_hangar","_x","_sideMissions","_completeText","_roadList"];
_sideMissions = 

[
	"destroyChopper",
	"destroySmallRadar",
	"destroyExplosivesCoast"
];

_mission = "";

_completeText = 
"<t align='center'><t size='2.2'>Side Mission</t><br/><t size='1.5' color='#00B2EE'>COMPLETE</t><br/>____________________<br/>Fantastic job, lads! The OPFOR stationed on the island won't last long if you keep that up!<br/><br/>Focus on the main objective for now; we'll relay this success to the intel team and see if there's anything else you can do for us. We'll get back to you in 15 - 30 minutes.</t>";

//Set up some vars
_firstRun = true; //debug
_skipTimer = false;
_roadList = island nearRoads 4000; //change this to the BIS function that creates a trigger covering the map
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
			sleep (900 + (random 900));
			
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
		case "talkToContact":
		{
			_position = [0,0,0];
			
			_civArray = 
			[
				"C_man_1",
				"C_man_polo_1_F",
				"C_man_polo_2_F",
				"C_man_polo_3_F",
				"C_man_polo_4_F",
				"C_man_polo_5_F",
				"C_man_polo_6_F",
				"C_man_1_1_F",
				"C_man_1_2_F",
				"C_man_1_3_F"
			];
				
			_briefing =
			"<t align='center'><t size='2.2'>New Side Mission</t><br/><t size='1.5' color='#00B2EE'>Talk to Contact</t><br/>____________________<br/>Part of the civilian rebellion on the island has agreed to share information with us regarding some enemy plans.<br/><br/>We've marked the location on your map; head over there and find out what he knows.</t>";

			/*
				1.	Find random position on road. Use nearRoads trick
				2.	On that piece of road spawn a 4x4 truck and a single civilian standing near it
				3.	Create 'talkedToContact' bool; set to false
				3.	Add an action to the civilian which simply activates the "talkedToContact" variable
				4.	waitUntil either the civilian is dead or the variable is true
				5.	Get which has happened. If the civilian has died, end there. Otherwise, choose a new side mission there and then.
				6.	Upon selecting the new side mission, have the civilian say something relevant in direct chat while the global hint is displayed on the screen.
			*/

			//Find random position on road
			_awayFromBase = false;
			while {!_awayFromBase} do
			{
				_road = _roadList call BIS_fnc_selectRandom;
				_position = getPos _road;
				
				if (_position distance (getMarkerPos "respawn_west") > 500 && (_position distance (getMarkerPos currentAO)) > 600) then
				{
					_awayFromBase = true;
				};
			};
			
			//Create truck and civilian using set dir (truck turned diagonally just off the road and the civilian standing by it) then wait until it's alive before we continue
			_altPosition = [((_position select 0) + 5), (_position select 1), (_position select 2)];
			_truck = "c_offroad" createVehicle _altPosition;
			waitUntil {alive _truck};
			_truck setDir (random 360);
			_truck setVehicleLock "LOCKED";
			_chosenCiv = _civArray call BIS_fnc_selectRandom;
			sideObj = _chosenCiv createVehicle _position;
			waitUntil {alive sideObj};
			_contactPos = (getPos sideObj);
			"sideMarker" setMarkerPos (getPos sideObj);
			"sideMarker" setMarkerText "Side Mission: Talk to Contact";
			publicVariable "sideMarker";
			publicVariable "sideObj";
			
			//Set up side mission variable
			talkedToContact = false;

			//Add a talking action to our civilian. Script simply has to set talkedToContact to true and PV it
			aw_addAction = [sideObj, "Talk to Contact", "sm\talkedToContact.sqf"];
			publicVariable "aw_addAction";
			
			GlobalHint = _briefing; publicVariable "GlobalHint"; hint parseText _briefing;
			showNotification = ["NewSideMission", "Talk to Contact"]; publicVariable "showNotification";

			sideMissionUp = true;
			publicVariable "sideMissionUp";
			sideMarkerText = "Talk to Contact";
			publicVariable "sideMarkerText";
			
			//Wait until we've talked to the contact or the contact is dead
			waitUntil {sleep 0.5; talkedToContact || !alive sideObj};

			if (!alive sideObj) then
			{
				_deadHint =
				"<t align='center'><t size='2.2'>Side Mission</t><br/><t size='1.5' color='#b60000'>FAILED</t><br/>____________________<br/>Our civilian contact has died! God damnit, men, we're supposed to be protecting these people!<br/><br/>Give us some time here at HQ and we'll figure out something else for you to screw up.<br/><br/>I'm in the right mind to give you a mission to go and tell that poor boy's parents he's dead. Lucky for you I can't be bothered to code that crap.<t/>";

				GlobalHint = _deadHint;
				publicVariable "GlobalHint";
				hint parseText GlobalHint;
				
				"sideMarker" setMarkerPos [0,0,0];
				publicVariable "sideMarker";
				
				aw_removeAction = [sideObj,0];
				publicVariable "aw_removeAction";
				sideObj removeAction 0;
			} else {
				while {_mission == "talkToContact"} do
				{
					_mission = _sideMissions call BIS_fnc_selectRandom;
				};

				_skipTimer = true;
				
				aw_unitSay3D = [sideObj, "nothing"];
				
				switch (_mission) do
				{
					case "destroyChopper":
					{
						aw_unitSay = [sideObj, "contactDestroyChopper"];
					};
					
					case "destroySmallRadar":
					{
						aw_unitSay = [sideObj, "contactDestroySmallRadar"];
					};
					
					case "destroyMortars":
					{
						aw_unitSay = [sideObj, "contactDestroyMortars"];
					};

					case "rescuePilots":
					{
						aw_unitSay = [sideObj, "contactRescuePilots"];
					};

					case "rescueCivs":
					{
						aw_unitSay = [sideObj, "contactRescueCivs"];
					};

					case "convoyKillVIP":
					{
						aw_unitSay = [sideObj, "contactConvoyKillVIP"];
					};
				};
				publicVariable "aw_unitSay";
				sideObj removeAction 0;
			};
			
			sideMissionUp = false;
			publicVariable "sideMissionUp";
			
			_civ = sideObj;
			
			{
				[_x,600] spawn AW_fnc_deleteSingleUnit; //DEBUG! This function needs urgently changing before being reintroduced so that it deletes the group these units created
			} forEach [_civ, _truck];
		}; /* case "talkToContact": */

		case "clearMines":
		{
			//Set up briefing message
			_briefing = 
			"<t align='center'><t size='2.2'>New Side Mission</t><br/><t size='1.5' color='#00B2EE'>Clear Mines</t><br/>____________________<br/>OPFOR forces have been placing mines along the roads in Stratis in a desperate attempt to slow us down. Thermal imaging scans have picked up a lot of troop movement around the area we've marked on your map and we suspect they've been planting mines.<br/><br/>Head over to the marker on the map and disarm any mines you find. We've got convoys waiting, soldier; get going!</t>";
		}; /* case "clearMines": */

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
			sideObj = "O_Ka60_F" createVehicle _flatPos;
			waitUntil {alive sideObj};
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
				_randomPos = [[[getPos sideObj, 50]],["water","out"]] call BIS_fnc_randomPos;
				_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam")] call BIS_fnc_spawnGroup;
				[_spawnGroup, _flatPos] call BIS_fnc_taskDefend;
				
				_unitsArray = _unitsArray + [_spawnGroup];
			};
			
			_x = 0;
			for "_x" from 0 to 2 do
			{
				_randomPos = [[[getPos sideObj, 50]],["water","out"]] call BIS_fnc_randomPos;
				_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam")] call BIS_fnc_spawnGroup;
				[_spawnGroup, _flatPos, 100] call bis_fnc_taskPatrol;
				
				_unitsArray = _unitsArray + [_spawnGroup];
			};
			
			_randomPos = [[[getPos sideObj, 50]],["water","out"]] call BIS_fnc_randomPos;
			_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Motorized_MTP" >> "OIA_MotInfTeam")] call BIS_fnc_spawnGroup;
			[_spawnGroup, _flatPos, 100] call bis_fnc_taskPatrol;
			
			_unitsArray = _unitsArray + [_spawnGroup];

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
			sideObj = "Land_Radar_small_F" createVehicle _flatPos;
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
				_randomPos = [[[getPos sideObj, 50]],["water","out"]] call BIS_fnc_randomPos;
				_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam")] call BIS_fnc_spawnGroup;
				[_spawnGroup, _flatPos] call BIS_fnc_taskDefend;
				
				_unitsArray = _unitsArray + [_spawnGroup];
			};
			
			_x = 0;
			for "_x" from 0 to 2 do
			{
				_randomPos = [[[getPos sideObj, 50]],["water","out"]] call BIS_fnc_randomPos;
				_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam")] call BIS_fnc_spawnGroup;
				[_spawnGroup, _flatPos, 100] call bis_fnc_taskPatrol;
				
				_unitsArray = _unitsArray + [_spawnGroup];
			};
			
			_randomPos = [[[getPos sideObj, 50]],["water","out"]] call BIS_fnc_randomPos;
			_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Motorized_MTP" >> "OIA_MotInfTeam")] call BIS_fnc_spawnGroup;
			[_spawnGroup, _flatPos, 100] call bis_fnc_taskPatrol;
			
			_unitsArray = _unitsArray + [_spawnGroup];

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
				};

				if ((_flatPos distance (getMarkerPos "respawn_west")) > 1000 && (_flatPos distance (getMarkerPos currentAO)) > 500) then //DEBUG - set >500 from AO to (PARAMS_AOSize * 2)
				{
					_accepted = true;
				};
			};
			
			//Spawn Mobile HQ
			_randomDir = (random 360);
			sideObj = "Land_Cargo_HQ_V1_F" createVehicle _flatPos;
			waitUntil {alive sideObj};
			sideObj setDir _randomDir;
			sideObj setPos [(getPos sideObj select 0), (getPos sideObj select 1), ((getPos sideObj select 2) - 0.5)];
			sideObj setVectorUp [0,0,1];
			
			//Spawn some enemies around the objective
			_unitsArray = [sideObj];
			_x = 0;
			for "_x" from 0 to 2 do
			{
				_randomPos = [[[getPos sideObj, 50]],["water","out"]] call BIS_fnc_randomPos;
				_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam")] call BIS_fnc_spawnGroup;
				[_spawnGroup, _flatPos] call BIS_fnc_taskDefend;
				
				_unitsArray = _unitsArray + [_spawnGroup];
			};
			
			_x = 0;
			for "_x" from 0 to 2 do
			{
				_randomPos = [[[getPos sideObj, 50]],["water","out"]] call BIS_fnc_randomPos;
				_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam")] call BIS_fnc_spawnGroup;
				[_spawnGroup, _flatPos, 100] call bis_fnc_taskPatrol;
				
				_unitsArray = _unitsArray + [_spawnGroup];
			};
			
			_randomPos = [[[getPos sideObj, 50]],["water","out"]] call BIS_fnc_randomPos;
			_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Motorized_MTP" >> "OIA_MotInfTeam")] call BIS_fnc_spawnGroup;
			[_spawnGroup, _flatPos, 100] call bis_fnc_taskPatrol;
			
			_unitsArray = _unitsArray + [_spawnGroup];
			
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
			
			//Hide marker
			"sideMarker" setMarkerPos [0,0,0];
			"sideCircle" setMarkerPos [0,0,0];
			sleep 5;
			publicVariable "sideMarker";
		}; /* case "destroyExplosivesCoast": */
	};
};