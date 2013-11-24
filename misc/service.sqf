// Function to finalize repair, rearm and refule
	
fnc_finishService =
{
	private ["_veh"];

	_veh = _this select 0;
	
	if (local _veh) then
	{
		_veh setDamage 0;
		_veh setFuel 1;
		_veh setVehicleAmmo 1;
		// If needed, flip vehicle upright.
		if (((vectorUp _veh) select 2) < 0.5) then
		{
			_veh setVectorUp [0, 0, 1];
			_veh setPos [(getPos _veh) select 0, (getPos _veh) select 1, 0];
		};
	};
};

// PV handler to show notification for service start/finish/interrupt
vehicleServiceNotificationPVHandler =
{
	private ["_veh", "_serviceMode", "_text"];
	
	_veh = (_this select 0) select 0;
	_serviceMode = (_this select 0) select 1;
		
	_text = getText (configFile >> "CfgVehicles" >> (typeOf _veh) >> "displayName");
	
	if (!(isNull _veh)) then
	{
		if
		(
			(alive _veh)
			&&
			(_veh getVariable ["vehSide", Civilian] == sidePlayer)
			&&
			(player distance _veh < 2 * serviceRadius)
		) then
		{
			switch (_serviceMode) do
			{
				case 0: 
				{
					player sideChat format [localize "STR_ServicingVehicle", _text, vehicleServiceTime];
				};
				case 1:
				{
					player sideChat format [localize "STR_ServiceDone", _text];
				};
				case 2:
				{
					player sideChat format [localize "STR_ServiceInterrupted", _text];
				};
			};
		};
	};
	
	if (_serviceMode == 1) then
	{
		[_veh] call fnc_finishService;
	};
};
"vehicleServiceNotification" addPublicVariableEventHandler
{
	[_this select 1] call vehicleServiceNotificationPVHandler;
};

// Function to check if vehicle is a service (repair, rearm and refule) truck
fnc_isServiceTruck =
{
	private ["_veh"];
	
	_veh = _this select 0;
	
	((toLower (typeOf _veh)) == toLower ((vehicleRules select 0) select 0))
	||
	((toLower (typeOf _veh)) == toLower ((vehicleRules select 0) select 1))
};

if (isServer) then
{

	// Function to handle base servicing (repairing, rearming and refueling) of vehicles (no service truck)
	
	fnc_handleBaseService =
	{
		private ["_veh"];
		
		_veh = _this select 0;
		
		if (!(isNull (_veh getVariable ["servicingTruck", objNull]))) then
		{
			if
			(
				(({alive _x} count crew _veh) > 0)
				||
				(!([_veh] call fnc_isAlive))
				||
				(!([_veh] call fnc_isSpawnProtected))
				||
				(isEngineOn _veh)
			) then
			{
				vehicleServiceNotification = [_veh, 2];
				publicVariable "vehicleServiceNotification";
				if (!isDedicated) then
				{
						[vehicleServiceNotification] call vehicleServiceNotificationPVHandler;
				};
				_veh setVariable ["servicingTruck", objNull];
			}
			else
			{
				if (time > (_veh getVariable "serviceEndTime")) then
				{
					vehicleServiceNotification = [_veh, 1];
					publicVariable "vehicleServiceNotification";
					if (!isDedicated) then
					{
						[vehicleServiceNotification] call vehicleServiceNotificationPVHandler;
					};
					_veh setVariable ["servicingTruck", objNull];
					_veh setVariable ["canBeServicedTime", time + 20];

					// Do the repair, rearm and refuel
					[_veh] call fnc_finishService;
				};			
			};
		}
		else
		{
			if
			(
				(time > (_veh getVariable ["canBeServicedTime", 0]))
				&&
				(({alive _x} count crew _veh) == 0)
				&&
				([_veh] call fnc_isAlive)
				&&
				([_veh] call fnc_isSpawnProtected)
				&&
				(!(isEngineOn _veh))
			) then
			{
				_veh setVariable ["serviceEndTime", time + vehicleServiceTime];
				_veh setVariable ["servicingTruck", _veh];
				vehicleServiceNotification = [_veh, 0];
				publicVariable "vehicleServiceNotification";
				if (!isDedicated) then
				{
					[vehicleServiceNotification] call vehicleServiceNotificationPVHandler;
				};				
			};
		};
	};
	
	// Function to handle servicing (repairing, rearming and refueling) of vehicles using a service truck
	
	fnc_handleServiceTruck =
	{
		private ["_serviceTruck", "_servicedVeh", "_i", "_maxi", "_testVeh", "_vehicles"];
		
		_serviceTruck = _this select 0;
		
		if (time > (_serviceTruck getVariable ["canServiceTime", 0])) then
		{
			_servicedVeh = _serviceTruck getVariable ["servicingVeh", objNull];
			
			if (!(isNull _servicedVeh)) then
			{
				if
				(
					(({alive _x} count crew _servicedVeh) > 0)
					||
					(({alive _x} count crew _serviceTruck) > 0)
					||
					(!([_servicedVeh] call fnc_isAlive))
					||
					((_servicedVeh distance _serviceTruck) > serviceRadius)
					||
					(isEngineOn _servicedVeh)
					||
					(isEngineOn _serviceTruck)
				) then
				{
					vehicleServiceNotification = [_servicedVeh, 2];
					publicVariable "vehicleServiceNotification";
					if (!isDedicated) then
					{
							[vehicleServiceNotification] call vehicleServiceNotificationPVHandler;
					};
					_servicedVeh setVariable ["servicingTruck", objNull];
					_serviceTruck setVariable ["servicingVeh", objNull];
					_servicedVeh = objNull;
				}
				else
				{
					if (time > (_servicedVeh getVariable "serviceEndTime")) then
					{
						vehicleServiceNotification = [_servicedVeh, 1];
						publicVariable "vehicleServiceNotification";
						if (!isDedicated) then
						{
							[vehicleServiceNotification] call vehicleServiceNotificationPVHandler;
						};
						_servicedVeh setVariable ["servicingTruck", objNull];
						_servicedVeh setVariable ["canBeServicedTime", time + 20];
						_serviceTruck setVariable ["canServiceTime", time + 20];
						_serviceTruck setVariable ["servicingVeh", objNull];
	
						// Do the repair, rearm and refuel
						[_servicedVeh] call fnc_finishService;
					};
				};
			}
			else
			{
				_vehicles = nearestObjects [getPos _serviceTruck, ["Car", "Armored", "Air", "Ship"], serviceRadius];
				_vehicles = _vehicles - [_serviceTruck];
				_vehicles set [count _vehicles, _serviceTruck];
				_i = 0;
				_maxi = count _vehicles;
				while {(isNull _servicedVeh) && (_i < _maxi)} do
				{
					_testVeh = _vehicles select _i;
					if (!(isNull _testVeh)) then
					{
						if
						(
							([_testVeh] call fnc_isAlive)
							&&
							(({alive _x} count crew _testVeh) == 0)
							&&
							(({alive _x} count crew _serviceTruck) == 0)
							&&
							(isNull (_testVeh getVariable ["servicingTruck", objNull]))
							&&
							(time > (_testVeh getVariable ["canBeServicedTime", 0]))
							&&
							(!([_testVeh] call fnc_isSpawnProtected))
							&&
							(!(isEngineOn _testVeh))
							&&
							(!(isEngineOn _serviceTruck))
						) then
						{
							_servicedVeh = _testVeh;
							_servicedVeh setVariable ["serviceEndTime", time + vehicleServiceTime];
							_servicedVeh setVariable ["servicingTruck", _serviceTruck];
							_serviceTruck setVariable ["servicingVeh", _servicedVeh];
							vehicleServiceNotification = [_servicedVeh, 0];
							publicVariable "vehicleServiceNotification";
							if (!isDedicated) then
							{
								[vehicleServiceNotification] call vehicleServiceNotificationPVHandler;
							};						
						};
					};
					
					_i = _i + 1;
				};
			};
		};
	};
};