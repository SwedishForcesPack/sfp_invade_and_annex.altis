// settings
_heli = _this select 0;
_box = _heli getVariable "box";

// add cargo action
_playerVehicle = vehicle player;
_playerAssignedRole = assignedVehicleRole player;
if (count _playerAssignedRole == 0) then {
	_playerAssignedRole = "Outside";
} else {
	_playerAssignedRole = _playerAssignedRole select 0;
};

// if player is in cargo, else if he's outside heli
if ((_playerVehicle == _heli) && (_playerAssignedRole == "Cargo")) then {
	_action = "Get out using cargo ramp";
	if (language == "French") then {_action = "Sortir par la rampe";};
	_action = format ["<t color='#ff1111'>%1</t>", _action];
	
	_id = player addAction [_action, "scripts\usableCargoRamp\getOut.sqf", [_heli], 1.5, false];
	_heli setVariable ["getOutId", _id, false];
} else {
	if ((_heli getVariable "getInActionExist" == 0) && ((_heli emptyPositions "Cargo") != 0)) then {
		_action = "Get in CH-49 Mohawk - cargo ramp";
		if (language == "French") then {_action = "Grimper dans CH-49 Mohawk - par la rampe";};
		_action = format ["<t color='#ff1111'>%1</t>", _action];
		
		_id = _box addAction [_action, "scripts\usableCargoRamp\getIn.sqf", [_heli], 1.5, false, true, "", "_target distance _this < 4"];
		_heli setVariable ["getInId", _id, false];
		_heli setVariable ["getInActionExist", 1, false];
	};
};