/* 
	Test code:

		_aliveMen = allUnits;

		while {true} do
		{
			if (count _aliveMen != count allUnits) then
			{
				_deadMen = _aliveMen - allUnits;
				{
					hideBody _x;
				} forEach _deadMen;
			};

			_aliveMen = allUnits;
		};

	With the code below, we could alternatively use

		hideBody _x;

	Not sure whether hideBody will actually clear the unit
	completely or whether it just sinks it below the ground.
	To be safe (and until someone complains) we'll use 
	deleteVehicle.
*/

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
	
	for "_c" from 0 to (count allGroups) do
	{
		_canDeleteGroup = true;
		_group = (allGroups select _c);
		{
			if (alive _x) then
			{
				_canDeleteGroup = false;
			};
		} forEach (units _group);
		if (_canDeleteGroup) then
		{
			deleteGroup _group;
		};
	};
	
	debugMessage = "Empty groups deleted.";
	publicVariable "debugMessage";
};