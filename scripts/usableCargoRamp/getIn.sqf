// settings
_unit = _this select 1;
_heli = (_this select 3) select 0;
_box = _heli getVariable "box";

// getOut
_box removeAction (_heli getVariable "getInId");
_heli setVariable ["getInActionExist", 0, false];

_unit action ["GetInCargo", _heli];
