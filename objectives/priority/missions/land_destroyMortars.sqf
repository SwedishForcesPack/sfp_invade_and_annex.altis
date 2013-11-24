_title = "Enemy Mortars";
_briefMsg = "Neutralise the enemy mortar team!";
_successMsg = "Enemy mortar team neutralised!";
_failureMsg = "";

_PT_Pos =
{
	_pos = [];
	while { (count _pos) < 3 } do
	{
		_tempPos = [[[getMarkerPos currentAO, 2500]], ["water", "out"]] call BIS_fnc_randomPos;
		_pos = _tempPos isFlatEmpty [5, 0, 0.3, 5, 0, false];
	};

	_pos
};

_PT_Create =
{
	_pos = _this select 0;

	for "_c" from 1 to 3 do
	{
		call compile format
		[
			"
				_mortar%1 = ""O_Mk6"" createVehicle _pos%1;
				_genericObjs = _genericObjs + [_mortar%1];
				_mortar%1 addEventHandler
				[
					""Fired"", 
					{ if (!isPlayer (gunner _mortar%1)) then { _mortar%1 setVehicleAmmo 1; }; }
				];
				""O_Soldier_F"" createUnit[_pos%1, _group, ""mortarMan%1 = this; this moveInGunner _mortar%1;""];
				waitUntil { alive mortarMan%1 };
				_sideObjs = _sideObjs + [mortarMan%1];
			",
			_c
		];
	};

	/* Spawn H-Barrier Cover */
	_distance = 11;
	_dir = 0;
	for "_c" from 0 to 15 do
	{
		_pos = [_pos, _distance, _dir] call BIS_fnc_relPos;
		_barrier = "Land_HBarrier_3_F" createVehicle _pos;
		waitUntil {alive _barrier};
		_barrier setDir _dir;
		_dir = _dir + 22.5;
		
		_genericObjs = _genericObjs + [_barrier];
	};

	_allObjs = [_sideObjs, _genericObjs]; _allObjs
};

_PT_Run =
{
	_pos = _this select 0; _sideObjs = _this select 1;

	_radius = 80;
	_firingMessages = 
	[
		"Thermal scans are picking up those enemy mortars firing! Heads down!",
		"Enemy mortar rounds incoming! Advise you seek cover immediately.",
		"OPFOR mortar rounds incoming! Seek cover immediately!",
		"The mortar team's firing, boys! Down on the ground!",
		"Get that damned mortar team down; they're firing right now! Seek cover!",
		"They're zeroing in! Incoming mortar fire; heads down!"
	];

	{
		[vehicle _x,3500,200] execVM "scripts\aw_artillery\aw_artillery_findTargets.sqf";
	}forEach _sideObjs;
};

_PT_Success = 
{
	_pos = _this select 0;
	_sideObjs = _this select 1;

	_hasSucceeded = true;
	{ if (alive _x) exitWith { _hasSucceeded = false; }; } forEach _sideObjs;

	_hasSucceeded
};

_PT_Failure =
{
	false
};