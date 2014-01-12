if (!isserver) exitwith {};
	sleep 3;
	if(random 1 >= 0.0) then   //chance AI will re-attack
		{
			_defendMessages =
			[
				"OPFOR Forces incoming! Seek cover immediately and defend the target!"
			];

			_targetStartText = format
			[
				"<t align='center' size='2.2'>Defend Target</t><br/><t size='1.5' align='center' color='#0d4e8f'>%1</t><br/>____________________<br/>We got a problem. The enemy managed to call in land reinforcements. They are on the way to take back the last target. You need to defend it at all costs!<br/><br/>If the last man of BluFor dies in the target area the enemy have won.<br/><br/>Forces are expected to be there in a couple minutes, hurry up!",
				currentAO
			];

			GlobalHint = _targetStartText; publicVariable "GlobalHint"; hint parseText GlobalHint;
			showNotification = ["NewMainDefend", currentAO]; publicVariable "showNotification";

			{_x setMarkerPos (getMarkerPos currentAO);} forEach ["aoCircle_2","aoMarker_2"];
			"aoMarker_2" setMarkerText format["Defend %1",currentAO];

			sleep 10;
			publicVariable "refreshMarkers";
			publicVariable "currentAO";
			currentAOUp = true;
			publicVariable "currentAOUp";
			radioTowerAlive = false;
			publicVariable "radioTowerAlive";

			//Timer
			END_TIME = 60; //When mission should end in seconds.
			ELAPSED_TIME = 0;
			if (isServer) then {
			  [] spawn
			    {
			        START_TIME = diag_tickTime;
			        while {ELAPSED_TIME < END_TIME} do
			        {
			            ELAPSED_TIME = diag_tickTime - START_TIME;
			            publicVariable "ELAPSED_TIME";
			            sleep 1;
			        };
			    };
			};

			if!(isDedicated) then
			{
			    [] spawn
			    {
			        while{ELAPSED_TIME < END_TIME } do
			        {
			            _time = END_TIME - ELAPSED_TIME;
			            _finish_time_minutes = floor(_time / 60);
			            _finish_time_seconds = floor(_time) - (60 * _finish_time_minutes);
			            if(_finish_time_seconds < 10) then
			            {
			                _finish_time_seconds = format ["0%1", _finish_time_seconds];
			            };
			            if(_finish_time_minutes < 10) then
			            {
			                _finish_time_minutes = format ["0%1", _finish_time_minutes];
			            };
			            formatted_time = format ["%1:%2", _finish_time_minutes, _finish_time_seconds];
			            publicVariable "formatted_time";
			           //titleText [format ["Time until\n counter attack ends:\n%1", formatted_time], "PLAIN DOWN"];
			           //hintSilent format ["Time left:\n%1", formatted_time];
			            sleep 1;
			        };
			    };
			};

			//check for online players
			players_online = West countSide allunits;
			publicVariable "players_online";

			_playersOnline = format
			[
				"Soldiers Count: %1x Difficulty level. - Target: %2! Get ready boys - 2 minutes left! - UAVs available.",
				players_online, currentAO
			];

			_playersOnlineHint = format
			[
				"<t align='left' color='#0061E0' size='1.2'>Soldiers Online:</t><t size='1'>%1</t><br/><br/><t align='left' color='#0061E0' size='1.2'>Difficulty:</t><t size='1'>%1x Soldiers.</t><br/><br/><br/><t size='1.5' align='left' color='#C92626'>Target:</t>%2!<br/><br/>____________________<br/>Get ready boys they are almost there! - UAVs available.",
				players_online, currentAO
			];

			//hintSilent format ["Player Count:\n%1", players_online];

			hqSideChat = _playersOnline; publicVariable "hqSideChat"; [WEST,"HQ"] sideChat hqSideChat;
			GlobalHint = _playersOnlineHint; publicVariable "GlobalHint"; hint parseText GlobalHint;

			sleep 10; // sleep before they spawn

			hqSideChat = _defendMessages call BIS_fnc_selectRandom; publicVariable "hqSideChat"; [WEST,"HQ"] sideChat hqSideChat;

		GC_fnc_spawnUnitsDefend =
			{
				private ["_AOrandom","_randomSquad","_spawnGroup","_AOrandomCars","_randomSquadCars","_spawnGroupCars","_pos","_pos2","_x","_way1","_way3","_wp","_wpCars","_flatPos","_accepted"];

				// Attack waves main
				_pos = getMarkerPos (currentAO);
				_pos2 = getMarkerPos "aoMarker_2";
				_enemiesArrayDefend = [grpNull];
				_x = 0;
				_ticker = 0;

				AOnord = "Nothing";
				AOost = "Nothing";
				AOsued = "Nothing";
				AOwest = "Nothing";
				AOnord = [getMarkerPos currentAO select 0,(getMarkerPos currentAO select 1)-750 + (random 100)];
				AOost = [(getMarkerPos currentAO select 0)+750 + (random 100),getMarkerPos currentAO select 1];
				AOsued = [getMarkerPos currentAO select 0,(getMarkerPos currentAO select 1)+750 + (random 100)];
				AOwest = [(getMarkerPos currentAO select 0)-750 + (random 100),getMarkerPos currentAO select 1];

				AOnordCars = [getMarkerPos currentAO select 0,(getMarkerPos currentAO select 1)-850 + (random 100)];
				AOostCars = [(getMarkerPos currentAO select 0)+800 + (random 100),getMarkerPos currentAO select 1];
				AOsuedCars = [getMarkerPos currentAO select 0,(getMarkerPos currentAO select 1)+750 + (random 100)];
				AOwestCars = [(getMarkerPos currentAO select 0)-750 + (random 100),getMarkerPos currentAO select 1];

				for "_x" from 1 to players_online do
					{
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

								if ((_flatPos distance (getMarkerPos currentAO)) > 700) then //DEBUG - set >500 from AO to (PARAMS_AOSize * 2)
								{
									_accepted = true;
								};
							};

						_AOrandom = [AOnord, AOost, AOsued, AOwest] call BIS_fnc_selectRandom;
						_randomSquad = ["OIA_InfSquad", "OIA_InfSquad_Weapons", "OIA_InfTeam", "OIA_InfTeam_AT","OI_reconTeam","OI_reconPatrol"] call BIS_fnc_selectRandom;
						_spawnGroup = [_AOrandom, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> _randomSquad)] call BIS_fnc_spawnGroup;
						[(units _spawnGroup)] call aw_setGroupSkill;

						[_spawnGroup, _pos2] call BIS_fnc_taskAttack;
						_way1 = _spawnGroup addWaypoint [_pos2,0];
						_way1 setWaypointSpeed "FULL";
						_way1 setWaypointType "MOVE";
						_way1 setWaypointBehaviour "aware";
						_way1 setWaypointCombatMode "yellow";
						_wp = _spawnGroup addWaypoint [_pos2,0];

						if(DEBUG2) then
						{
							_name = format ["%1",_way1];
							createMarkerLocal [_name,waypointPosition _way1];
							_name setMarkerType "mil_dot";
							_name setMarkerText format["%1",_x];
						};

						if(DEBUG2) then
						{
							_name = format ["%1%2",name (leader _spawnGroup),_x];
							createMarker [_name,getPos (leader _spawnGroup)];
							_name setMarkerType "o_unknown";
							_name setMarkerText format ["Reinforcement Troops %1",_x];
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

						_AOrandomCars = [AOnordCars, AOostCars, AOsuedCars, AOwestCars] call BIS_fnc_selectRandom;
						_randomSquadCars = ["OIA_InfSquad", "OIA_InfSquad_Weapons", "OIA_InfTeam"] call BIS_fnc_selectRandom;
						_spawnGroupCars = [_AOrandomCars, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> _randomSquadCars)] call BIS_fnc_spawnGroup;
						[(units _spawnGroupCars)] call aw_setGroupSkill;

						[_spawnGroupCars, _pos2] call BIS_fnc_taskAttack;
						_way2 = _spawnGroupCars addWaypoint [_pos2,0];
						_way2 setWaypointBehaviour "aware";
						_way2 setWaypointCombatMode "RED";
						_way2 setWaypointFormation "ECH LEFT";
						_way2 setWaypointSpeed "FULL";
						_wpCars = _spawnGroupCars addWaypoint [_pos2,0];

						if(DEBUG2) then
						{
							_name = format ["%1",_way2];
							createMarkerLocal [_name,waypointPosition _way2];
							_name setMarkerType "mil_dot";
							_name setMarkerText format["%1",_x];
						};

						if(DEBUG2) then
						{
							_name = format ["%1%2",name (leader _spawnGroupCars),_x];
							createMarker [_name,getPos (leader _spawnGroupCars)];
							_name setMarkerType "o_unknown";
							_name setMarkerText format ["Reinforcement Cars %1",_x];
							_name setMarkerColor "ColorRed";
							[_spawnGroupCars,_name] spawn
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

						_enemiesArrayDefend = _enemiesArrayDefend + [_spawnGroup];
						sleep 2;
						_enemiesArrayDefend = _enemiesArrayDefend + [_spawnGroupCars];
					};
				_enemiesArrayDefend
			};

			_enemiesArrayDefend = [currentAO] call GC_fnc_spawnUnitsDefend;

			waitUntil {ELAPSED_TIME >= END_TIME };
			[] spawn aw_cleanGroups;
			[_enemiesArrayDefend] spawn AW_fnc_deleteOldAOUnits;
			sleep .5;
			[_enemiesArrayDefend] spawn GC_fnc_deleteOldUnitsAndVehicles;
			publicVariable "refreshMarkers";
			currentAOUp = false;
			publicVariable "currentAOUp";

			//Delete detection trigger and markers
			deleteVehicle _dt;

			//radioTowerAlive = true;
			//publicVariable "radioTowerAlive";

			//Small sleep to let deletions process
			sleep 1;

			//Set target completion text
			_targetCompleteText = format
			[
				"<t align='center' size='2.2'>Target Defended</t><br/><t size='1.5' align='center' color='#00FF80'>%1</t><br/>____________________<br/><t align='left'>Fantastic job defending %1, boys! Give us a moment here at HQ and we'll line up your next target for you.</t>",
				currentAO
			];

			{_x setMarkerPos [-10000,-10000,-10000];} forEach ["aoCircle_2","aoMarker_2"];

			/*[] spawn aw_cleanGroups;
			//[] call AW_fnc_rewardPlusHintDefended;
			[_enemiesArrayDefend] spawn AW_fnc_deleteOldAOUnits;
			[_enemiesArrayDefend] spawn GC_fnc_deleteOldUnitsAndVehicles;*/


			//Show global target completion hint
			GlobalHint = _targetCompleteText; publicVariable "GlobalHint"; hint parseText GlobalHint;
			showNotification = ["CompletedMainDefended", currentAO]; publicVariable "showNotification";
			sleep 5;

		};

