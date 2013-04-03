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

_veh = _this select 0;
_vehType = typeOf _veh;

if (_veh isKindOf "ParachuteBase" || !alive _veh) exitWith {};

_veh setFuel 0;

_veh vehicleChat format ["Repairing and refuelling %1. Stand by...", _vehType];

_damage = getDammage _veh;

while {_damage > 0} do
{
	sleep 2;
	_percentage = 100 - (_damage * 100);
	_veh vehicleChat format ["Repairing (%1%)...", _percentage];
	if ((_damage - 0.05) < 0) then
	{
		_veh setDamage 0;
		_damage = 0;
	} else {
		_veh setDamage (_damage - 0.05);
		_damage = _damage - 0.05;
	};	
};

_veh vehicleChat "Repaired (100%).";

_fuel = fuel _veh;

if (_fuel < 1) then
{
	sleep 5;
	_veh setFuel 1;
};

_veh vehicleChat "Refuelled (100%).";

sleep 2;

_veh vehicleChat format ["%1 successfully repaired and refuelled.", _vehType];