/*
  SHK_patrol

  Based on BIN_taskPatrol by Binesi
  
  Version 0.2
  Author: Shuko (shuko@quakenet, miika@miikajarvinen.fi)

  Required Parameters:
    0 Object or Group     The patrolling unit
      
  Optional Parameters:
    1 Number              Distance from the unit's starting position to create waypoints. Default is 250.

  Usage:
    Start from group leader's init field or from init.sqf:
      nul = [params] execVM "shk_patrol.sqf";
      
    Examples:
      nul = this execVM "shk_patrol.sqf";
      nul = [this,350] execVM "shk_patrol.sqf";
      nul = [grpA,300] execVM "shk_patrol.sqf";
*/

if !isserver exitwith {};

// Handle parameters
private ["_grp","_dst"];
_dst = 250;
switch (typename _this) do {
  case (typename grpNull): { _grp = _this };
  case (typename objNull): { _grp = group _this };
  case (typename []): {
    _grp = _this select 0;
    if (typename _grp == typename objNull) then {_grp = group _grp};
    if (count _this > 1) then {_dst = _this select 1};
  };
};

// Make sure Functions module is loaded
if (isnil "bis_fnc_init") then {
  createcenter sidelogic;
  (creategroup sidelogic) createunit ["FunctionsManager",[1,1,0],[],0,"none"];
};
waituntil {!isnil "BIS_fnc_init"};
waituntil {BIS_fnc_init};

_grp setBehaviour "AWARE";
_grp setSpeedMode "LIMITED";
_grp setCombatMode (["YELLOW", "RED"] call BIS_fnc_selectRandom);
_grp setFormation (["STAG COLUMN", "WEDGE", "ECH LEFT", "ECH RIGHT", "VEE", "DIAMOND"] call BIS_fnc_selectRandom);

private ["_cnt","_ang","_wps","_slack","_aos"];
_cnt = 4 + (floor random 3) + (floor (_dst / 100)); // number of waypoints
_ang = (360 / (_cnt - 1)); // split circle depending on number of waypoints
_wps = [];
_slack = _dst / 5.5;
if (_slack < 20) then {_slack = 20};
_aos = random 360;

// Find positions for waypoints
private ["_a","_p","_pos"];
_pos = getpos leader _grp;

while {count _wps < _cnt} do {
    _a = (count _wps * _ang) + _aos;

    _p = [((_pos select 0) - ((sin _a) * _dst)),
          ((_pos select 1) - ((cos _a) * _dst)),
          0];

    _p = [_p, 0, _slack, 6, 0, 50 * (pi / 180), 0, []] call BIS_fnc_findSafePos;
    _wps set [count _wps, _p];
};

// Create waypoints
private ["_cur","_wp"];
for "_i" from 1 to (_cnt - 1) do {
    _cur = (_wps select _i);

    _wp = _grp addWaypoint [_cur, 0];
    _wp setWaypointType "MOVE";
    _wp setWaypointCompletionRadius (5 + _slack);
    [_grp,_i] setWaypointTimeout [0,0,0];
    
    // When completing waypoint have 33% chance to choose a random next wp
    [_grp,_i] setWaypointStatements ["true", "if ((random 3) > 2) then { group this setCurrentWaypoint [(group this), (floor (random (count (waypoints (group this)))))];};"];
};

// Cycle in case we reach the end
private "_wp1";
_wp1 = _grp addWaypoint [(_wps select 1), 0];
_wp1 setWaypointType "CYCLE";
_wp1 setWaypointCompletionRadius 50;