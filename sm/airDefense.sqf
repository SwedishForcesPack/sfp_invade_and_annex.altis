waitUntil {sleep 0.5; !(isNil "currentAOUp")};
waitUntil {sleep 0.5; !(isNil "currentAO")};
private ["_priorityMessageJet"];

while {true} do {
sleep (2000 + (random 600));
    if (radioTowerAlive) then {
        if (radioTowerAlive) then {
            _patrolPos=getMarkerPos currentAO;
            //_helo_in_patrol = true;
			_helo_Patrol = createGroup EAST;
            _helo_Array = [[15000, _patrolPos select 1, 1550], 20, ["I_Plane_Fighter_03_CAS_F"] call BIS_fnc_selectRandom, east] call BIS_fnc_spawnVehicle;
			_helo_Patrol = _helo_Array select 0;
            _helo_crew = _helo_Array select 1;
            [_helo_Array select 2, _patrolPos, 500] call BIS_fnc_taskPatrol;
			showNotification = ["EnemyJet", "Enemy Buzzard approaching to AO over the sky."]; publicVariable "showNotification";
			_priorityMessageJet =
			"<t align='center' size='2.2'>Priority Target (AO)</t><br/><t size='1.5' color='#b60000'>Enemy Jet Inbound</t><br/>____________________<br/>OPFOR forces are inbound with a Buzzard to support their infantry forces!<br/><br/>This is a priority target, boys!<br/><br/>HQ suggests to all Transport Helicopters to return to base until the danger is neutralised!";
			GlobalHint = _priorityMessageJet; publicVariable "GlobalHint"; hint parseText _priorityMessageJet;
            waitUntil {
                sleep 5;
                _helo_Patrol setVehicleAmmo 1;
				_helo_Patrol removeMagazineTurret ["2Rnd_LG_scalpel",[0]];
				_helo_Patrol removeMagazines "2Rnd_LG_scalpel";
				_helo_Patrol removeMagazineTurret ["2Rnd_AAA_missiles",[0]];
				_helo_Patrol removeMagazines "2Rnd_AAA_missiles";
				_helo_Patrol removeMagazineTurret ["120Rnd_CMFlare_Chaff_Magazine",[0]];
				_helo_Patrol removeMagazines "120Rnd_CMFlare_Chaff_Magazine";

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
    };
    sleep 20;
};
