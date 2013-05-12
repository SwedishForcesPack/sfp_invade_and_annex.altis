private ["_canDeleteGroup","_group"];
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
	
	for "_c" from 0 to ((count allGroups) - 1) do
	{
		_canDeleteGroup = true;
		_group = (allGroups select _c);
		{
			if (alive _x) then
			{
				_canDeleteGroup = false;
			};
		} forEach (units _group);
		if (_canDeleteGroup) then { deleteGroup _group; };
	};
	
	debugMessage = "Empty groups deleted.";
	publicVariable "debugMessage";
};