/*
      ::: ::: :::             ::: :::             ::: 
     :+: :+:   :+:           :+:   :+:           :+:  
    +:+ +:+     +:+         +:+     +:+         +:+   
   +#+ +#+       +#+       +#+       +#+       +#+    
  +#+ +#+         +#+     +#+         +#+     +#+     
 #+# #+#           #+#   #+#           #+#   #+#      
### ###             ### ###             ### ###      

| AHOY WORLD | ARMA 3 ALPHA | STRATIS DOMI VER 2.7 |

Creating working missions of this complexity from
scratch is difficult and time consuming, please
credit http://www.ahoyworld.co.uk for creating and
distibuting this mission when hosting!

This version of Domination was lovingly crafted by
Jack Williams (Rarek) for Ahoy World!
*/


private ["_damage","_percentage","_veh","_vehType","_fuel"];
_veh = _this select 0;
_vehType = typeOf _veh;

if (_veh isKindOf "ParachuteBase" || !alive _veh) exitWith {};

if !(_veh isKindOf "Helicopter") exitWith { _veh vehicleChat "This pad is for chopper repairs only, soldier!"; };

_veh engineOn false;

_veh vehicleChat format ["Repairing and refuelling %1. Stand by...", _vehType];

_damage = getDammage _veh;

while {_damage > 0} do
{
	_veh engineOn false;
	sleep 1;
	_percentage = 100 - (_damage * 100);
	_veh vehicleChat format ["Repairing (%1%)...", _percentage];
	if ((_damage - 0.01) < 0) then
	{
		_veh setDamage 0;
		_damage = 0;
	} else {
		_veh setDamage (_damage - 0.01);
		_damage = _damage - 0.01;
	};
};

_veh vehicleChat "Repaired (100%).";

_fuel = fuel _veh;

while {_fuel < 1} do
{
	_veh engineOn false;
	sleep 1;
	_percentage = (_fuel * 100);
	_veh vehicleChat format["Refuelling (%1%)...", _percentage];
	if ((_fuel + 0.01) > 1) then
	{
		_veh setFuel 1;
		_fuel = 1;
	} else {
		_veh setFuel (_fuel + 0.01);
		_fuel = _fuel + 0.01;
	};
};

_veh vehicleChat "Refuelled (100%).";

sleep 2;

_veh vehicleChat format ["%1 successfully repaired and refuelled.", _vehType];