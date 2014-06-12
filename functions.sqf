aw_fnc_MPaddAction = {
private["_object","_screenMsg","_scriptToCall"];
_object = _this select 0;
_screenMsg = _this select 1;
_scriptToCall = _this select 2;

if(isNull _object) exitWith {};

_object addaction [_screenMsg,_scriptToCall];
};

QS_setSkill1 =
{
	if(!isServer) exitWith{};
	{
		_x setSkill ["aimingAccuracy", 0.3];
		_x setSkill ["aimingShake", 0.7];
		_x setSkill ["aimingSpeed", 0.4];
		_x setSkill ["commanding", 1];
		_x setSkill ["courage", 1];
		_x setSkill ["endurance", 1];
		_x setSkill ["general", 1];
		_x setSkill ["reloadSpeed", 1];
		_x setSkill ["spotDistance", 0.8];
		_x setSkill ["spotTime", 0.6];
	} forEach (_this select 0);
};
	
QS_setSkill2 =
{
	if(!isServer) exitWith{};
	{
		_x setSkill ["aimingAccuracy", 0.4];
		_x setSkill ["aimingShake", 0.8];
		_x setSkill ["aimingSpeed", 0.55];
		_x setSkill ["commanding", 1];
		_x setSkill ["courage", 1];
		_x setSkill ["endurance", 1];
		_x setSkill ["general", 1];
		_x setSkill ["reloadSpeed", 1];
		_x setSkill ["spotDistance", 0.8];
		_x setSkill ["spotTime", 0.7];
	} forEach (_this select 0);
};
	
QS_setSkill3 =
{
	if(!isServer) exitWith{};
	{
		_x setSkill ["aimingAccuracy", 0.5];
		_x setSkill ["aimingShake", 0.9];
		_x setSkill ["aimingSpeed", 0.7];
		_x setSkill ["commanding", 1];
		_x setSkill ["courage", 1];
		_x setSkill ["endurance", 1];
		_x setSkill ["general", 1];
		_x setSkill ["reloadSpeed", 1];
		_x setSkill ["spotDistance", 1];
		_x setSkill ["spotTime", 0.9];
	} forEach (_this select 0);
};

QS_setSkill4 =
{
	if(!isServer) exitWith{};
	{
		_x setSkill ["aimingAccuracy", 1];
		_x setSkill ["aimingShake", 1];
		_x setSkill ["aimingSpeed", 1];
		_x setSkill ["commanding", 1];
		_x setSkill ["courage", 1];
		_x setSkill ["endurance", 1];
		_x setSkill ["general", 1];
		_x setSkill ["reloadSpeed", 1];
		_x setSkill ["spotDistance", 1];
		_x setSkill ["spotTime", 1];
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

aw_serverMapTP =
{
	if(!serverCommandAvailable "#kick") exitWith{};
	onMapSingleClick "player setPos _pos;onMapSingleClick '';true";
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