_title = "EMP Device";
_briefMsg = "Destroy the enemy EMP device!";
_successMsg = "EMP device neutralised!";
_failureMsg = "";

_PT_Pos =
{
	_pos = [];
	while { (count _pos) < 3 } do
	{
		_tempPos = [] call BIS_fnc_randomPos;
		_pos = _tempPos isFlatEmpty [5, 1, 0.4, 2, 0, false];
	};

	_pos
};

_PT_Create =
{
	_pos = _this select 0;
	_priorityObjs = []; _genericObjs = [];

	_controller = "Land_Lighthouse_small_F" createVehicle _pos;
	_controller allowDamage false;
	_controller setPos [(getPos _controller select 0), (getPos _controller select 1), ((getPos _controller select 2) - 1.5)];
	_controller setVectorUp [0, 0, 1];

	deviceDown = false; publicVariable "deviceDown";
	deviceGrounded = false; publicVariable "deviceGrounded";
	deviceDisabled = false; publicVariable "deviceDisabled";
	_controller addAction
	[
		"<t color='#FF8000'>Bring down EMP Device</t>",
		{
			runOnServer =
			{
				deviceDown = true; publicVariable "deviceDown";
				_device = "Land_Bucket_F" createVehicle [0,0,0];
				_device setPos [((_pos select 0) - 150) + (random 300), ((_pos select 1) - 150) + (random 300), ((_pos select 2) + 1000)];
				[_device, 5, time, false, true] spawn BIS_Effects_Burn;
				_device setVelocity [(-30 + (random 60)), (-30 + (random 60)), -50];

				waitUntil { isTouchingGround _device };

				_explosion = "Bo_GBU12_LGB" createVehicle (getPos _device); _explosion setVelocity [0, 0, -50];

				sleep 2;

				while
				{
					((velocity _device select 0) > 0.1) ||
					((velocity _device select 1) > 0.1) ||
					((velocity _device select 2) > 0.1)
				} do {
					waitUntil { isTouchingGround _device };
					_explosion = "GrenadeBase" createVehicle (getPos _device); _explosion setVelocity [0, 0, -50];
					waitUntil { !isTouchingGround _device };
					sleep (1 + (random 9));
				};

				_groundedPos = (getPos _device);

				if ((random 1) < 0.5) then
				{
					deviceGrounded = true; publicVariable "deviceGrounded";
					_device addAction
					[
						"<t color='#FF8000'>Manually Disable Device</t>",
						{
							deviceDisabled = true; publicVariable "deviceDisabled";
							(_this select 0) removeAction (_this select 2);
							sleep 300;
							deleteVehicle _device;
						}
					];
				} else {
					_explosion = "HelicopterExploBig" createVehicle _groundedPos; _explosion setVelocity [0, 0, -50];
					sleep 0.5;
					_device setPos _groundedPos;
					deviceDisabled = true; publicVariable "deviceDisabled";
					sleep 300;
					deleteVehicle _device;
				};		


			}; publicVariable "runOnServer";
			(_this select 0) removeAction (_this select 2);
		}
	];

	_allObjs = [[_controller], [_controller]];

	_allObjs
};

_PT_Enemy =
{
	[
		(configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSquad"),
		2, "patrol", 200, 50
	],

	[
		(configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSquad"),
		1, "defend", 100, 0
	],

	[
		(configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Motorized_MTP" >> "OIA_MotInf_Team"),
		1, "patrol", 300, 50
	]
};

_PT_Run =
{
	_pos = _this select 0;
	_priorityObjs = _this select 1;

	while { true } do
	{
		_next = time + PARAMS_PriorityTargetTickTime;
		waitUntil { time >= _next || deviceDown };

		if ((!deviceDown || deviceGrounded) && !deviceDisabled) then
		{
			{
				if (alive _x) then
				{
					[_x] spawn
					{
						private ["_fuelLevel", "_veh"];
						_veh = _this select 0;
						_fuelLevel = fuel _veh;
						_veh setFuel 0;
						sleep (5 + (random 10));
						_veh setFuel _fuelLevel;
					};
				};
			} forEach vehicles;
		};
	};
};

_PT_Success =
{
	if (deviceDisabled) then { true } else { false };
};

_PT_Failure =
{
	false
};