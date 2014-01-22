aw_fnc_loiter =
{
	private["_group","_wp","_pos"];
	_group = _this select 0;
	_pos = _this select 1;
	_wp = _group addWaypoint [_pos, 0];
	_wp setWaypointType "LOITER";
};

aw_fnc_fuelMonitor =
{
	if(!isServer OR (vehicle _this == _this)) exitWith {};
	while{(alive _this) AND (({side _x == east} count (crew _this)) > 0)} do
	{
		waitUntil{sleep 2;(fuel _this < 0.1) OR !(alive _this) OR !(({side _x == east} count (crew _this)) > 0)};
		if((alive _this) AND (({side _x == east} count (crew _this)) > 0)) then {_x setFuel 1};
	};
};

aw_fnc_randomPos =
{
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

aw_fnc_spawn2_waypointBehaviour =
{
	if(!isServer) exitWith{};
	while{({alive _x} count (units _this) > 0)} do
	{
		waitUntil{sleep 1;({(_x select 2) == west} count ((leader _this) nearTargets 1000) > 1) OR !({alive _x} count (units _this) > 0)};
		if({alive _x} count (units _this) > 0) then
		{
			{
				if(waypointType _x == "MOVE") then {_x setWaypointBehaviour "SAD"};
				_x setWaypointBehaviour "COMBAT";
				_x setWaypointBehaviour "WEDGE";
			}forEach (waypoints _this);
		};
		waitUntil{sleep 1;({(_x select 2) == west} count ((leader _this) nearTargets 1600) < 1) OR !({alive _x} count (units _this) > 0)};
		if({alive _x} count (units _this) > 0) then
		{
			{
				if(waypointType _x == "SAD") then {_x setWaypointBehaviour "MOVE"};
				_x setWaypointBehaviour "COMBAT";
				_x setWaypointBehaviour "WEDGE";
			}forEach (waypoints _this);
		};
	};
};

aw_fnc_radPos =
{
	if(!isServer) exitWith{};
	private["_center","_radius","_angle","_pos","_exit","_posX","_posY"];
	_center = _this select 0;
	_radius = _this select 1;
	_angle = _this select 2;
	_exit = false;

	while{!_exit} do
	{
		_posX = (_radius * (sin _angle));
		_posY = (_radius * (cos _angle));
		_pos = [_posX + (_center select 0),_posY + (_center select 1),0];
		if(!surfaceIsWater [_pos select 0,_pos select 1]) then {_exit = true} else {_radius = _radius - 1};
		if(_radius == 0) then {_pos = _center;_exit = true};
	};
	_pos;
};

aw_fnc_spawn2_hold =
{
	if(!isServer) exitWith{};
	private["_group","_wp","_pos"];
	_group = _this select 0;
	_pos = _this select 1;

	_wp = _group addWaypoint [_pos, 0];
	_wp setWaypointType "HOLD";
	_wp setWaypointBehaviour "SAFE";
	_wp setWaypointSpeed "LIMITED";
};

aw_fnc_spawn2_randomPatrol =
{
	if(!isServer) exitWith{};
	private["_group","_center","_radius","_wp","_checkDist","_angle","_currentAngle","_pos","_wp1","_x"];
	_group = _this select 0;
	_center = _this select 1;
	_radius = _this select 2;
	_waypointNumbers = if(count _this > 3) then {_this select 3} else {20 + floor ((random 10))};

	for [{_x=1},{_x<=_waypointNumbers},{_x=_x+1}] do
	{
		_pos = [_center,(random _radius),(random 360)] call aw_fnc_radPos;
		_wp = _group addWaypoint [_pos,0];
		_wp setWaypointType "MOVE";
		_wp setWaypointSpeed "LIMITED";
		_wp setWaypointFormation "WEDGE";
		_wp setWaypointBehaviour "AWARE";
		_wp setWaypointTimeOut [0,10,40];

/*		if(DEBUG) then
		{
			_name = format ["%1",_wp];
			createMarkerLocal [_name,waypointPosition _wp];
			_name setMarkerType "mil_dot";
			_name setMarkerText format["%1",_x];
		};*/

		if(_x == 1) then {_wp1 = _wp};
	};

	_wp = _group addWaypoint [waypointPosition _wp1,0];
	_wp setWaypointType "CYCLE";
	_wp setWaypointSpeed "LIMITED";
	_wp setWaypointFormation "STAG COLUMN";
	_wp setWaypointBehaviour "SAFE";

/*	if(DEBUG) then
	{
		_name = format ["%1",_wp];
		createMarkerLocal [_name,waypointPosition _wp];
		_name setMarkerType "mil_dot";
		_name setMarkerText "Cycle";
	};*/

	_group spawn aw_fnc_spawn2_waypointBehaviour;
};

aw_fnc_spawn2_perimeterPatrol =
{
	if(!isServer) exitWith{};
	private["_group","_center","_radius","_wp","_angle","_currentAngle","_wp1","_pos","_x","_toCenter"];
	_group = _this select 0;
	_center = _this select 1;
	_radius = _this select 2;
	_waypointNumbers = if(count _this > 3) then {_this select 3} else {20 + floor ((random 10))};
	_toCenter = if(count _this > 4) then {_this select 4} else {false};

	_angle = 360 / _waypointNumbers;
	_currentAngle = _angle + (random 360);

	for [{_x=1},{_x<=_waypointNumbers},{_x=_x+1}] do
	{
		_pos = [_center,_radius,_currentAngle] call aw_fnc_radPos;
		_wp = _group addWaypoint [_pos,0];
		_wp setWaypointType "MOVE";
		_wp setWaypointSpeed "LIMITED";
		_wp setWaypointFormation "WEDGE";
		_wp setWaypointBehaviour "AWARE";
		_wp setWaypointTimeOut [0,10,40];

/*		if(DEBUG) then
		{
			_name = format ["%1",_wp];
			createMarkerLocal [_name,waypointPosition _wp];
			_name setMarkerType "mil_dot";
			_name setMarkerText format["%1",_x];
		};*/

		if(_x == 1) then {_wp1 = _wp};
		_currentAngle = _currentAngle + _angle;
	};

	if(_toCenter) then
	{
		_wp = _group addWaypoint [_center,0];
		_wp setWaypointType "MOVE";
		_wp setWaypointSpeed "LIMITED";
		_wp setWaypointFormation "WEDGE";
	};

	_wp = _group addWaypoint [waypointPosition _wp1,0];
	_wp setWaypointType "CYCLE";
	_wp setWaypointSpeed "LIMITED";
	_wp setWaypointFormation "WEDGE";

/*	if(DEBUG) then
	{
		_name = format ["%1",_wp];
		createMarkerLocal [_name,waypointPosition _wp];
		_name setMarkerType "mil_dot";
		_name setMarkerText "Cycle";
	};*/

	_group spawn aw_fnc_spawn2_waypointBehaviour;
};

aw_setGroupSkill =
{
	if(!isServer) exitWith{};
	{
		_x setskill ["aimingAccuracy",0.4];
		_x setskill ["aimingShake",0.7];
		_x setskill ["aimingSpeed",0.5];
		_x setskill ["Endurance",0.9];
		_x setskill ["spotDistance",0.9];
		_x setskill ["spotTime",0.8];
		_x setskill ["courage",0.9];
		_x setskill ["reloadSpeed",0.3];
		_x setskill ["commanding",1];
	} forEach (_this select 0);
};

aw_setGroupSkillSpecial =
{
	if(!isServer) exitWith{};
	{
		_x setskill ["aimingAccuracy",0.5];
		_x setskill ["aimingShake",0.7];
		_x setskill ["aimingSpeed",0.5];
		_x setskill ["Endurance",0.9];
		_x setskill ["spotDistance",0.9];
		_x setskill ["spotTime",0.8];
		_x setskill ["courage",0.9];
		_x setskill ["reloadSpeed",0.3];
		_x setskill ["commanding",1];
	} forEach (_this select 0);
};

aw_setGroupSkillSniper =
{
	if(!isServer) exitWith{};
	{
		_x setskill ["aimingAccuracy",0.6];
		_x setskill ["aimingShake",0.7];
		_x setskill ["aimingSpeed",0.5];
		_x setskill ["Endurance",0.9];
		_x setskill ["spotDistance",0.9];
		_x setskill ["spotTime",0.8];
		_x setskill ["courage",0.9];
		_x setskill ["reloadSpeed",0.3];
		_x setskill ["commanding",1];
	} forEach (_this select 0);
};

aw_cleanGroups =
{
	if(!isServer) exitWith{};
	{
		if(count (units _x) == 0) then {deleteGroup _x};
	}forEach allGroups;

};

aw_deleteUnits =
{
	private["_deleteVehicles"];
	if(!isServer) exitWith{};

	_deleteVehicles = if(count _this > 1) then {_this select 1} else {true};

	{
		if(_deleteVehicles) then {deleteVehicle (vehicle _x)} else{moveOut _x};
		deleteVehicle _x;
	}forEach (_this select 0);

	[] spawn aw_cleanGroups;
};

ISSE_Cfg_VehicleInfo = {
    private["_cfg", "_name", "_DescShort", "_DescLong", "_Type", "_MaxSpeed", "_MaxFuel"];
    _name = _this;
    _cfg  = (configFile >>  "CfgVehicles" >>  _name);

    _DescShort = if (isText(_cfg >> "displayName")) then {
        getText(_cfg >> "displayName")
    }
    else {
        "/"
    };

    _DescLong = if (isText(_cfg >> "Library" >> "libTextDesc")) then {
        getText(_cfg >> "Library" >> "libTextDesc")
    }
    else {
        "/"
    };

    _Pic = if (isText(_cfg >> "picture")) then {
        getText(_cfg >> "picture")
    }
    else {
        "/"
    };

    _Type = if (isText(_cfg >> "type")) then {
        parseNumber(getText(_cfg >> "type"))
    }
    else {
        getNumber(_cfg >> "type")
    };

    _MaxSpeed = if (isText(_cfg >> "maxSpeed")) then {
        parseNumber(getText(_cfg >> "maxSpeed"))
    }
    else {
        getNumber(_cfg >> "maxSpeed")
    };

    _MaxFuel = if (isText(_cfg >>    "fuelCapacity")) then {
        parseNumber(getText(_cfg >> "fuelCapacity"))
    }
    else {
        getNumber(_cfg >>"fuelCapacity")
    };

    [_DescShort, _DescLong, _Type, _Pic, _MaxSpeed, _MaxFuel]
};

ISSE_Cfg_Vehicle_GetName  = {
    (_this call ISSE_Cfg_VehicleInfo) select 0
};