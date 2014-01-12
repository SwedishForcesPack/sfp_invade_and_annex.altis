// SINGLE VEHICLE GROUP
if (!isServer) exitwith {};
private ["_side","_debug","_pos","_faction","_veh"];

_pos=(_this select 0);
_grpSize=(_this select 1);
_faction=(_this select 2);
_side=(_this select 3);

_debug=false;

		_type=7;
		_pool=[_faction,_type] call EOS_unit;
		
			
					_veh=[_pos, random 360,_pool,_side] call bis_fnc_spawnvehicle;

_veh
