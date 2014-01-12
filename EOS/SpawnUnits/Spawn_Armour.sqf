// SINGLE VEHICLE GROUP
if (!isServer) exitwith {};
private ["_side","_type","_debug","_pos","_faction","_veh"];

_pos=(_this select 0);
_grpSize=(_this select 1);
_faction=(_this select 2);
_side=(_this select 3);

_debug=false;

if (surfaceiswater _pos) then {_type=2;}else{_type=4;};
		_pool=[_faction,_type] call EOS_unit;

					_veh = [_pos, random 360, _pool, _side] call bis_fnc_spawnvehicle;
					
_veh