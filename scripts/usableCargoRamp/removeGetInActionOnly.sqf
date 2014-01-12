// settings
_heli = _this select 0;
_box = _heli getVariable "box";

// remove cargo action
if (vehicle player == _heli) then {
	_box removeAction (_heli getVariable "getInId");
	_heli setVariable ["getInActionExist", 0, false];
};

if (vehicle player == player) then {
	_box removeAction (_heli getVariable "getInId");
	_heli setVariable ["getInActionExist", 0, false];
};