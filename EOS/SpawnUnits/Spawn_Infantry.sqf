// SINGLE INFANTRY GROUP
if (!isServer) exitwith {};
private ["_r","_side","_type","_unitType","_grp","_unit","_pool","_n","_grpMax","_grpMin","_grpSize","_debug","_pos","_faction"];

_pos=(_this select 0);
_grpSize=(_this select 1);
_faction=(_this select 2);
_side=(_this select 3);

_grpMin=_grpSize select 0;
_grpMax=_grpSize select 1;
_d=_grpMax-_grpMin;				
_r=floor(random _d);							
_grpSize=_r+_grpMin;

_debug=FALSE;

if (surfaceiswater _pos) then {_type=1;}else{_type=0;};
		_pool=[_faction,_type] call EOS_unit;
		

	_grp=createGroup _side;
	
_n=0;						
	while {_n < _grpSize} do {
		
		_unitType=_pool select (floor(random(count _pool)));
		_unit = _grp createUnit [_unitType, _pos, [], 0, "FORM"];  
		_n=_n+1;
	sleep 0.1;
	};
	
_grp