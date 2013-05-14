private ["_canDeleteGroup","_group","_groups","_units"];
while {true} do
{
	sleep 600;
	debugMessage = "Cleaning dead bodies and deleting groups...";
	publicVariable "debugMessage";
	{
		deleteVehicle _x;
	} forEach allDead;
	
	debugMessage = "Dead bodies deleted.";
	publicVariable "debugMessage";
	
	_groups = allGroups;

	for "_c" from 0 to ((count _groups) - 1) do
	{
		_canDeleteGroup = true;
		_group = (_groups select _c);
		if (!isNull _group) then
		{
			_units = (units _group);
			{
				if (alive _x) then { _canDeleteGroup = false; };
			} forEach _units;
		};
		if (_canDeleteGroup && !isNull _group) then { deleteGroup _group; };
	};
	
	debugMessage = "Empty groups deleted.";
	publicVariable "debugMessage";
};