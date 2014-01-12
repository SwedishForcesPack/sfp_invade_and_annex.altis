EOS_Deactivate = {
	private ["_mkr"];
		_mkr=(_this select 0);

		//hint format ["%1",_mkr];

	{
		_x setmarkercolor "colorblack";
		_x setmarkerAlpha 0;
	}foreach _mkr;
};

EOS_FILLCARGO = {
private ["_cargo","_emptySeats","_vehicle","_debug","_grp","_grpSize"];
	_vehicle=(_this select 0);
	_grpSize=(_this select 1);
	_grp=(_this select 2);
	_cargo=(_this select 3);
	_debug=DEBUG2;

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
			if 	(_grpSize > _emptySeats) then {_grpSize = _emptySeats};
						if (_debug) then {hint format ["Seats Filled : %1",_grpSize];};

						for "_x" from 1 to _grpSize do {
								_unit=_cargo select (floor(random(count _cargo)));
								_unit=_unit createUnit [GETPOS _vehicle, _grp];
								};


	{_x moveincargo _vehicle}foreach units _grp;
	};

};

EOS_debug = {
private ["_note"];
_mkr=(_this select 0);
_n=(_this select 1);
_note=(_this select 2);
_pos=(_this select 3);

_mkrID=format ["%3:%1,%2",_mkr,_n,_note];
deletemarker _mkrID;
_debugMkr = createMarker[_mkrID,_pos];
_mkrID setMarkerType "Mil_dot";
_mkrID setMarkercolor "colorBlue";
_mkrID setMarkerText _mkrID;
_mkrID setMarkerAlpha 0.5;
};

aw_findPos = {
    private["_center","_radius","_exit","_pos","_angle","_posX","_posY","_size","_flatPos"];
    _center = _this select 0;
    _size = if(count _this > 2) then {_this select 2};
    _exit = false;

    while{!_exit} do
    {
        _radius = random (_this select 1);
        _angle = random 360;
        _posX = (_radius * (sin _angle));
        _posY = (_radius * (cos _angle));
        _pos = [_posX + (_center select 0),_posY + (_center select 1),0];
        if(!surfaceIsWater [_pos select 0,_pos select 1]) then
        {
            if(count _this > 2) then
            {
                _flatPos = _pos isFlatEmpty [_size / 2,0,0.7,_size,0,false];
                if(count _flatPos != 0) then
                {
                    _pos = _flatPos;
                    _exit = true
                };
            } else {_exit = true};
        };
    };

    _pos;
};

EOS_Patrol = {

/*
  SHK_patrol

  Based on BIN_taskPatrol by Binesi

  Version 0.22
  Author: Shuko (shuko@quakenet, miika@miikajarvinen.fi)
  http://forums.bistudio.com/showthread.php?163496-SHK_Patrol
	Modified for EOS by Bangabob


  Required Parameters:
    0 Object or Group     The patrolling unit

  Optional Parameters:
    1 Number              Distance from the unit's starting position to create waypoints. Default is 250.
	2 position			Position for to patrol
  Usage:
    Start from group leader's init field or from init.sqf:
      nul = [params] execVM "shk_patrol.sqf";

    Examples:
      nul = this execVM "shk_patrol.sqf";
      nul = [this,350] execVM "shk_patrol.sqf";
      nul = [grpA,300] execVM "shk_patrol.sqf";
*/
//DEBUG = false;

if !isserver exitwith {};

// Handle parameters
private ["_grp","_dst","_pos"];
_dst = 350;
switch (typename _this) do {
  case (typename grpNull): { _grp = _this };
  case (typename objNull): { _grp = group _this };
  case (typename []): {
    _grp = _this select 0;
    if (typename _grp == typename objNull) then {_grp = group _grp};
    if (count _this > 1) then {_dst = _this select 1};
	if (count _this > 2) then {_pos = _this select 2};
  };
};

_grp setBehaviour "AWARE";
_grp setSpeedMode "FULL";
_grp setCombatMode "YELLOW";
_grp setFormation (["STAG COLUMN", "WEDGE", "ECH LEFT", "ECH RIGHT", "VEE", "DIAMOND"] call BIS_fnc_selectRandom);

private ["_cnt","_ang","_wps","_slack","_aos"];
_cnt = 4 + (floor random 3) + (floor (_dst / 100)); // number of waypoints
_ang = (360 / (_cnt - 1)); // split circle depending on number of waypoints
_wps = [];
_slack = _dst / 5.5;
if (_slack < 20) then {_slack = 20};
_aos = random 360;

// Find positions for waypoints
private ["_a","_p"];
//_pos = getpos leader _grp;

while {count _wps < _cnt} do {
    _a = (count _wps * _ang) + _aos;

    _p = [((_pos select 0) - ((sin _a) * _dst)),
          ((_pos select 1) - ((cos _a) * _dst)),
          0];

    _wps set [count _wps, _p];
};

// Create waypoints
private ["_cur","_wp"];
for "_i" from 1 to (_cnt - 1) do {
    _cur = (_wps select _i);

    _wp = _grp addWaypoint [_cur, 0];
    _wp setWaypointType "MOVE";
    _wp setWaypointCompletionRadius (5 + _slack);
    [_grp,_i] setWaypointTimeout [0,2,16];

    // When completing waypoint have 33% chance to choose a random next wp
    [_grp,_i] setWaypointStatements ["true", "if ((random 3) > 2) then { group this setCurrentWaypoint [(group this), (floor (random (count (waypoints (group this)))))];};"];

    if (DEBUG) then {
      private "_m";
      _m = createMarker [format["SHK_patrol_WP%1%2",(floor(_cur select 0)),(floor(_cur select 1))],_cur];
      _m setMarkerShape "Ellipse";
      _m setMarkerSize [20,20];
      _m setmarkerColor "ColorRed";
    };
};

// Cycle in case we reach the end
private "_wp1";
_wp1 = _grp addWaypoint [(_wps select 1), 0];
_wp1 setWaypointType "CYCLE";
_wp1 setWaypointCompletionRadius 50;

if (DEBUG) then {
    while {sleep 5; {alive _x} count (units _grp) > 0} do {
      private ["_m","_p"];
      _p = getpos leader _grp;
      _m = createMarker [format["SHK_patrol_%1%2%3",(floor(_p select 0)),(floor(_p select 1)),floor time],_p];
      _m setMarkerShape "Icon";
      _m setMarkerType "mil_dot";
      _m setmarkerColor "ColorBlue";
    };
};
};