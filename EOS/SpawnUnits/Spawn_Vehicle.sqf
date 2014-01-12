// SINGLE VEHICLE GROUP
if (!isServer) exitwith {};
private ["_cargo","_side","_type","_unit","_grpSize","_debug","_pos","_faction","_veh","_vehicle","_grp"];

_pos=(_this select 0);
_grpSize=(_this select 1);
_faction=(_this select 2);
_side=(_this select 3);

_debug=false;

if (surfaceiswater _pos) then {_type=2;}else{_type=3;};


		_pool=[_faction,_type] call EOS_unit;
		_unit=_pool select 0;_unit=_unit select 0;
		
		_cargo=_pool select 1;

					_veh= [_pos, random 360, _unit, _side] call bis_fnc_spawnvehicle;
					_vehicle = _veh select 0;
					_grp = _veh select 2;					

// SPAWN WITH CARGO	
if ((_vehicle emptyPositions "cargo") > 0) then {

		0=[_vehicle,_grpSize,_grp,_cargo] call EOS_FILLCARGO;
						};

_veh