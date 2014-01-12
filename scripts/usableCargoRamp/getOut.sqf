// settings
_unit = _this select 1;
_heli = (_this select 3) select 0;
_box = _heli getVariable "box";

// getOut
_box removeAction (_heli getVariable "getInId");
_heli setVariable ["getInActionExist", 0, false];

_unit action ["Eject", _heli];
waitUntil {vehicle _unit == _unit};
_rampOutPos = [_heli, 5, ((getDir _heli) + 180)] call BIS_fnc_relPos;
_altitude = getPosATL _heli;
_rampOutPos set [2, (_altitude select 2)];
_unit setPosATL _rampOutPos;
_unit setDir ((getDir _heli) + 180);