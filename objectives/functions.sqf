AW_fnc_deleteObjects =
{
	private ["_unitsArray", "_obj", "_isGroup"];
	sleep 600;
	_unitsArray = _this select 0;
	for "_c" from 0 to (count _unitsArray) do
	{
		_obj = _unitsArray select _c;
		_isGroup = false; if (_obj in allGroups) then { _isGroup = true; };
		if (_isGroup) then
		{
			{
				if (!isNull _x) then { deleteVehicle _x; };
			} forEach (units _obj);
		} else {
			if (!isNull _obj) then { deleteVehicle _obj; };
		};
	};
};

AW_fnc_distanceCheck =
{
	private ["_pos", "_distanceChecks"]; _pos = _this select 0; _isGoodPos = true;
	_distanceChecks = [["respawn_west", 1000], ["priorityMarker", 300], [currentAO, PARAMS_AOSize]];
	{
		scopeName "distanceCheck";
		_marker		= _x select 0;
		_distance   = _x select 1;
		if (_priorityPos distance (getMarkerPos _marker) < _distance) then { _isGoodPos = false; breakOut "distanceCheck"; };
	} forEach _distanceChecks;

	{
		scopeName "playerDistanceCheck"; 
		if (_priorityPos distance _x < 500) then { _isGoodPos = false; breakOut "playerDistanceCheck"; };
	} forEach playableUnits;

	_isGoodPos
};