/** points for pilots */
if (isDedicated) exitWith {};

//, "_countPoints", "_getClosestObjective"  ];
PFP_count_players = 0.0;
PFP_getins = []; // array of players getins
//centerposition for distance coef
PFP_max_distance = [0,0,0] distance getArray(configFile/"CfgWorlds"/worldName/"centerPosition");

// [_from, _srcObj, _to, _dstObj ]

PFP_getPenalty = {
	private ["_from","_to","_srcObj","_dsstObj"];
	_from = _this select 0;
	_to = _this select 1;
	_srcObj = _this select 2;
	_dstObj = _this select 3;

	//format ["PFP_getPenalty: dist1 %1, dist %2, penalty: %3", (_from distance _to), 
	// (_srcObj distance _dstObj), (_from distance _to) / (_srcObj distance _dstObj) ] call BIS_fnc_log;

	(_from distance _to) / (_srcObj distance _dstObj)
};

// argument - from 
PFP_getClosestObjective = {
	private ["_from", "_min_dist", "_objs", "_d"];
	_from = _this;
	_min_dist = PFP_max_distance;
	_objs = [ markerPos "respawn_west" ];
	// AHOY
	if (!isNil("currentAOUp")) then { if (currentAOUp) then {_objs set[ count _objs, getMarkerPos currentAO ];}; };
	if (!isNil("priorityTargetUp")) then { if (priorityTargetUp) then { _objs set[ count _objs, markerPos "priorityMarker" ]; }; };
	if (!isNil("sideMissionUp")) then { if (sideMissionUp) then { _objs set[ count _objs, getPos sideObj ]; }; };
	
	{ 
		_d = _this distance _x;
		if ( _d < _min_dist ) then { _min_dist = _d; _from = _x };
	} forEach _objs;
	//format ["from %1 closest is: %2", _this, _from ] call BIS_fnc_log;
	_from
};

PFP_countPoints = {
	private ["_points", "_landedAtPos", "_filtered_getins"];
	_landedAtPos = (position player) call PFP_getClosestObjective;
	_points = 0.0;
	_countGroup = 0;
	_filtered_getins = [];
	_remove = [];
	{
		_getInOutPos = (_x select 1) call PFP_getClosestObjective;

		if ( count _x > 2 && (_landedAtPos distance _getInOutPos) > 0 ) then { //  && 

				if ( (_x select 2) > 0 ) then {
					_points = _points + (_x select 2);
				};
				_countGroup = _countGroup + 1;
			//_remove set [ count _remove, _x ];

		} else {
			_filtered_getins set [count _filtered_getins, _x];
		};
		//format ["PFP_countPoints: x= %1, points =%2", _x, _points] call BIS_fnc_log;
	} forEach PFP_getins;
	
	PFP_getins =+ _filtered_getins;
	//format ["PFP_countPoints: points= %1, getins= %2", _points, PFP_getins] call BIS_fnc_log;
	[ round _points, _countGroup ]
};

//Passed array: [vehicle, position, unit]
PFP_heliOnGetIn = {
	// this player is on drive place
	if (driver (_this select 0) == player) then {
		// but player getin not me
		if ( _this select 2 != player ) then {
			_passageer = _this select 2;
			_idx = count PFP_getins;

			for "_i" from 0 to count PFP_getins step 1 do {
				if ( (PFP_getins select _i) select 0 == _passageer ) exitWith {
					_idx = _i;
				};
			};

			PFP_getins set[ _idx, [ _passageer, position _passageer ] ];
		};
	};
};

//Passed array: [vehicle, position, unit]
PFP_heliOnGetOut = {
	private ["_destObj", "_srcObj", "_idx", "_from", "_points"];
	// this player is on drive place
	if (driver (_this select 0) == player && alive player) then {
		if (_this select 2 != player && alive (_this select 2) ) then {
			_passageer = _this select 2;
			_isIn = { (_x select 0) == _passageer } count PFP_getins;
			if !(isIn) exitWith {};
			
			_idx = [];

			{
				if ( (_x select 0 ) == _passageer ) exitWith {
					_idx = _x;
				};
			} forEach PFP_getins;

			if ( count _idx == 0 ) exitWith {};

			//format ["PFP_heliOnGetOut: _idx= %1, PFP_getins=%2", _idx, PFP_getins] call BIS_fnc_log;
			//PFP_getins = PFP_getins - _idx;
			//format ["PFP_heliOnGetOut: _idx= %1, PFP_getins=%2", _idx, PFP_getins] call BIS_fnc_log;
			
			_from = _idx select 1;

			// drop too close to load
			if ( _from distance (position player) <= 100 ) exitWith {};

			_srcObj = _from call PFP_getClosestObjective;
			_destObj = (position player) call PFP_getClosestObjective;

			_penalty = [_from, position player, _srcObj, _destObj ] call PFP_getPenalty;

			/// 1 point for PFP_max_distance / 2.
			_points = (_srcObj distance _destObj) * _penalty * 2 / PFP_max_distance;

			//hint format["src->dst: %1, _penalty:%2, max: %3. points: %4", 
			//	(_srcObj distance _destObj), _penalty, PFP_max_distance,  _points];
			_idx set[ 1, position _passageer ]; //save dest
			_idx set[ count _idx, _points ]; // [ _passageer, position _passageer, _points ]
			//PFP_getins set[ count PFP_getins, _idx ];
			//format ["PFP_heliOnGetOut: PFP_getins= %1", PFP_getins ] call BIS_fnc_log;
		};
	};
};


//Passed array: [plane, airportID]
PFP_heliOnLandedTouchDown = {

	if (driver (_this select 0) == player && alive player) then {
		_points = call PFP_countPoints;
		//format ["PFP_heliOnLandedTouchDown: points= %1, getins= %2", _points, PFP_getins] call BIS_fnc_log;

		if ( (_points select 0) > 0 ) then {
			addToScore = [player, (_points select 0)]; publicVariable "addToScore";
			["ScoreBonus", [format ["Transported group of %1 soldiers.", _points select 1], _points select 0]] call bis_fnc_showNotification;
		};
	};
};

_this spawn {
	private ["_unit"];
	_unit = _this;
	waitUntil {sleep 0.5; alive player && alive _unit};

	_unit addEventHandler[ "GetIn", PFP_heliOnGetIn ];
	_unit addEventHandler[ "GetOut", PFP_heliOnGetOut ];
	//_unit addEventHandler[ "LandedTouchDown", PFP_heliOnLandedTouchDown ];
	player addEventHandler[ "Respawn", { PFP_getins = []; } ];

	while {true} do {
		sleep 10;
		if ( vehicle player != player ) then {
			[(vehicle player),0] call PFP_heliOnLandedTouchDown;
		};
	};
};
