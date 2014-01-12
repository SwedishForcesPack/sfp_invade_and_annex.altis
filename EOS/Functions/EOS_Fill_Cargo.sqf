if (!isServer) exitwith {};
private ["_r","_cargo","_emptySeats","_vehicle","_debug","_filled","_unit","_grp","_grpSize","_side"];
	_vehicle=(_this select 0);
	_grpSize=(_this select 1);
	_grp=(_this select 2);
	_cargo=(_this select 3);
	_debug=false;
	
		_side=side (leader _grp);

// FILL EMPTY SEATS		
	_emptySeats=_vehicle emptyPositions "cargo";
	if (_debug) then {hint format ["%1",_emptySeats];};

//GET MIN MAX GROUP
			_grpMin=_grpSize select 0;
			_grpMax=_grpSize select 1;
			_d=_grpMax-_grpMin;				
			_r=floor(random _d);							
			_grpSize=_r+_grpMin;
			
// IF VEHICLE HAS SEATS	
		if (_emptySeats > 0) then {
		
// LIMIT SEATS TO FILL TO GROUP SIZE		
			if (_emptySeats>_grpSize) then {_emptySeats=_grpSize};
									
						if (_debug) then {hint format ["Seats Filled : %1",_emptySeats];};	
								
						_filled=0;											
							while {_filled<_emptySeats} do {
							
								_unit=_cargo select (floor(random(count _cargo)));
								_unit=_unit createUnit [GETPOS _vehicle, _grp];
								_filled=_filled+1;
								sleep 0.1;
								};
								
	{
_x moveincargo _vehicle}foreach units _grp;
	};						
