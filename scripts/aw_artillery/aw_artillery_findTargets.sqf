//Alex Wise
//Artillery Script
//Arma 3 version

_unit = _this select 0;
_radiusMax = _this select 1;
_radiusMin = _this select 2;
_shellType = if(count _this > 4) then {_this select 3} else {""};
_enemy = if(count _this > 4) then {_this select 4} else {west};
_friend = if(count _this > 5) then {_this select 5} else {east};
_pos = getPos _unit;

if(!isServer) exitWith{};

while{(alive _unit) AND (alive (gunner _unit))} do
{
	_availableTargets = _unit nearTargets 1000;
	{
		if((side _x) == _friend) then {_availableTargets = _availableTargets + (_x nearTargets 2500)};
	}forEach (_unit nearEntities [["Man","Air","Car","Motorcycle","Tank"],_radiusMax]);
	
	
	_target = [];
	if(count _availableTargets != 0) then 
	{
		{
			if(((_x select 2) == _enemy) AND (((_x select 0) distance _pos) > _radiusMin) AND (((_x select 0) distance (getMarkerPos "respawn_west")) > 1000) AND (((_x select 0) distance _pos) < _radiusMax) AND !((_x select 1) isKindOf "Air") AND (({(side _x) == _friend} count ((_x select 0) nearEntities [["Man","Air","Car","Motorcycle","Tank"],100])) == 0)) then
			{
				if(count _target == 0) then {_target = [_x]} else
				{
					if(((_target select 0) select 3) > (_x select 3)) then {_target = [_x]};
				};
			};
		}forEach _availableTargets;
		//Finds the most important target
	};
	
	if(count _target != 0) then
	{
		_targetPosition = ((_target select 0) select 0);
		_range = (_targetPosition distance _pos);
		
		sleep (random 5);
		
		_scatter = 10;
		if(_range < _radiusMax) then {_scatter = 50};
		if(_range < (2 * (_radiusMax / 3))) then {_scatter = 25};
		if(_range < (_radiusMax / 3)) then {_scatter = 10};
		
		if(DEBUG) then {hint "Mortar Firing"};
		_unit doArtilleryFire [[((_targetPosition select 0) - (_scatter / 2)) + random _scatter,((_targetPosition select 1) - (_scatter / 2)) + random _scatter,0], "32Rnd_155mm_Mo_shells",1];
		
		sleep 20 + (random 10);
	};
	//Spawns shell
	
	sleep 5;
};