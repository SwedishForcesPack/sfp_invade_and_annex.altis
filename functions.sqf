INS_REV_FNCT_get_group_color_index = {
	private ["_phoneticCode", "_found", "_index", "_result", "_i", "_j"];
	
	// Set variable
	_unit = _this select 0;
	_phoneticCode = ["Alpha","Bravo","Charlie","Delta","Echo","Foxtrot","Golf"];
	_found = false;
	_index = 0;
	
	// Find group name
	{
		for "_i" from 1 to 4 do {
		 	for "_j" from 1 to 3 do {
		 		_groupName = format["%1 %2-%3", _x, _i, _j];
		 		if (format["b %1",_groupName] == str(group _unit) || format["o %1",_groupName] == str(group _unit)) exitWith {
		 			_found = true;
		 		};
		 		_index = _index + 1;
			};
			if (_found) exitWith {};
		};
		if (_found) exitWith {};
	} forEach _phoneticCode;
	
	// If not found, return 0
	if (!_found) then {
		_result = 0;
	} else {
		_result = _index % 10;
	};
	
	_result
};

// Get group color
// Usage : '[unit] call FNC_GET_GROUP_COLOR;'
// Return : string
INS_REV_FNCT_get_group_color = {
	private ["_unit", "_colors", "_colorIndex", "_result"];
	
	// Set varialble
	_unit = _this select 0;
	_colors = ["ColorGreen","ColorYellow","ColorOrange","ColorPink","ColorBrown","ColorKhaki","ColorBlue","ColorRed","ColorBlack","ColorWhite"];
	_colorIndex = [_unit] call INS_REV_FNCT_get_group_color_index;
	
	// Set color
	_result = _colors select _colorIndex;
	
	// Return value
	_result
};