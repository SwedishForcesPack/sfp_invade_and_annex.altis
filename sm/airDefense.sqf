#define AIR_TYPE "I_Plane_Fighter_03_CAS_F"
#define SPAWN_LIMIT 3
#define EASY true
#define FIXED_TIME 900
#define RANDOM_TIME 900

waitUntil {sleep 0.5; !(isNil "currentAOUp")};
waitUntil {sleep 0.5; !(isNil "currentAO")};
private ["_priorityMessageJet"];

while {true} do {
	sleep (FIXED_TIME + (random RANDOM_TIME));
    if ((radioTowerAlive) && (({(typeOf _x == AIR_TYPE) && (side _x == independent)} count vehicles) < SPAWN_LIMIT)) then {
		_patrolPos = getMarkerPos currentAO;
		//_helo_in_patrol = true;
		_helo_Patrol = createGroup EAST;
		_helo_Array = [[15000, _patrolPos select 1, 1550], 20, [AIR_TYPE] call BIS_fnc_selectRandom, east] call BIS_fnc_spawnVehicle;
		_helo_Patrol = _helo_Array select 0;
		_helo_crew = _helo_Array select 1;
		[_helo_Array select 2, _patrolPos, 2000] call BIS_fnc_taskPatrol;
		showNotification = ["EnemyJet", "Enemy jet approaching the AO!"]; publicVariable "showNotification";
		_priorityMessageJet =
		"<t align='center' size='2.2'>Priority Target (AO)</t><br/><t size='1.5' color='#b60000'>Enemy Jet Inbound</t><br/>____________________<br/>OPFOR are inbound with CAS to support their infantry forces!<br/><br/>This is a priority target!";
		GlobalHint = _priorityMessageJet; publicVariable "GlobalHint"; hint parseText _priorityMessageJet;
		
		waitUntil {
			sleep 5;
			_helo_Patrol setVehicleAmmo 1;
			sleep 1;
			
			if (EASY) then {
				_helo_Patrol removeMagazineTurret ["2Rnd_LG_scalpel",[0]];
				_helo_Patrol removeMagazines "2Rnd_LG_scalpel";
			};

			!alive _helo_Patrol || {!canMove _helo_Patrol}
		};

		[] call AW_fnc_rewardPlusHintJet;

		sleep 5;
		_helo_Patrol setDamage 1;
		sleep 5;
		deleteVehicle _helo_Patrol;

		{
			_x setDamage 1;
			sleep 5;
			deleteVehicle _x;
		} foreach _helo_crew;
    };
    sleep 10;
};
