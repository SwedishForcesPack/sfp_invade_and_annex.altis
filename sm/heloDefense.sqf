waitUntil {sleep 0.5; !(isNil "currentAOUp")};
waitUntil {sleep 0.5; !(isNil "currentAO")};
private ["_priorityMessageHelo"];

while {true} do {
sleep (600 + (random 660));
    if (radioTowerAlive) then {
        if (radioTowerAlive) then {
            _patrolPos=getMarkerPos currentAO;
            //_helo_in_patrol = true;
            _helo_Patrol = createGroup EAST;
            _helo_Array = [[10000, _patrolPos select 1, 550], 20, ["O_Heli_Attack_02_F"] call BIS_fnc_selectRandom, east] call BIS_fnc_spawnVehicle;
            _helo_Patrol = _helo_Array select 0;
            _helo_crew = _helo_Array select 1;
            [_helo_Array select 2, _patrolPos, 500] call BIS_fnc_taskPatrol;
			showNotification = ["EnemyHeavyHelo", "Enemy Mi-48 Kajman approaching to AO."]; publicVariable "showNotification";
			_priorityMessageHelo =
			"<t align='center' size='2.2'>Priority Target (AO)</t><br/><t size='1.5' color='#b60000'>Enemy Mi-48 Kajman Inbound</t><br/>____________________<br/>OPFOR forces are inbound with a Buzzard to support their infantry forces!<br/><br/>This is a priority target, boys!<br/><br/>HQ suggests to all Transport Helicopters to return to base until the danger is neutralised!";
			GlobalHint = _priorityMessageHelo; publicVariable "GlobalHint"; hint parseText _priorityMessageHelo;
            waitUntil {
                sleep 5;
                _helo_Patrol setVehicleAmmo 1;
				sleep 1;
				//_helo_Patrol removeMagazineTurret ["8Rnd_LG_scalpel",[0]];
				//_helo_Patrol removeMagazines "8Rnd_LG_scalpel";
				// _helo_Patrol removeMagazineTurret ["38Rnd_80mm_rockets",[0]];
				// _helo_Patrol removeMagazines "38Rnd_80mm_rockets";
								/*if(alive _helo_Patrol) then
								{
									_name = format ["%1%2",name _helo_Patrol,_helo_crew];
									createMarker [_name,getPos _helo_Patrol];
									_name setMarkerType "o_unknown";
									_name setMarkerText format ["Air %1",_helo_crew];;
									_name setMarkerColor "ColorRed";
									[_helo_Patrol,_name] spawn
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
								};*/

                !alive _helo_Patrol || {!canMove _helo_Patrol}
            };

		 [] call AW_fnc_rewardPlusHintMI;

            sleep 10;
            _helo_Patrol setDamage 1;
            sleep 10;
            deleteVehicle _helo_Patrol;

            {
                _x setDamage 1;
                sleep 10;
                deleteVehicle _x;
            } foreach _helo_crew;
        };
    };
    sleep 10;
};
