if (!isServer) exitwith {};
private ["_aGroup","_side","_activateCondition","_enemyFaction","_mkrAlphaHighlight","_mkrAlpha","_distance","_grp","_AV","_LV","_CHType","_time","_timeout","_faction"];

_mkr=(_this select 0);
_basePos=markerpos(_this select 0);
_mkrSizeX=getMarkerSize _mkr select 0;
_mkrSizeY=getMarkerSize _mkr select 1;

_infantry=(_this select 1);
_PApatrols=_infantry select 0;
_PAgroupSize=_infantry select 1;

_LVeh=(_this select 2);
_LVehGroups=_LVeh select 0;
_LVgroupSize=_LVeh select 1;

_AVeh=(_this select 3);
_AVehGroups=_AVeh select 0;
_AVgroupSize=_AVeh select 1;

_SVeh=(_this select 4);
_CHGroups=_SVeh select 0;
_CHgroupSize=_SVeh select 1;

_settings=(_this select 5);
_faction=_settings select 0;
_alpha=_settings select 1;
_distance=_settings select 2;
_side=_settings select 3;

_timeout=160;
_Placement=700;

_debug=false;
switch (_alpha) do {case 0:{_mkrAlphaHighlight = 1;_mkrAlpha = 0.5;};case 1:{_mkrAlphaHighlight = 0;_mkrAlpha = 0;};case 2:{_mkrAlphaHighlight = 0.5;_mkrAlpha = 0.5;};};
switch (_side) do{case EAST:{_enemyFaction="east";};case WEST:{_enemyFaction="west";};case INDEPENDENT:{_enemyFaction="GUER";};case CIVILIAN:{_enemyFaction="civ";};};

	if ismultiplayer then { _activateCondition="{vehicle _x in thisList && isplayer _x} count playableunits > 0";
							}else{ _activateCondition="{vehicle _x in thisList && isplayer _x} count allUnits > 0";};

				_bastTaken = createTrigger ["EmptyDetector",_basePos];
				_bastTaken setTriggerArea [_mkrSizeX,_mkrSizeY,0,true];
				_bastTaken setTriggerActivation ["ANY","PRESENT",true];
				_bastTaken setTriggerStatements [_activateCondition,"",""];

	_mkr setmarkercolor bastionColor;
	_mkr setmarkeralpha _mkrAlpha;

waituntil {triggeractivated _bastTaken};
	_mkr setmarkercolor bastionColor;
	_mkr setmarkeralpha _mkrAlphaHighlight;

						_bastActive = createTrigger ["EmptyDetector",_basePos];
						_bastActive setTriggerArea [(_distance+_mkrSizeX),(_distance+_mkrSizeY),0,true];
						_bastActive setTriggerActivation ["any","PRESENT",true];
						_bastActive setTriggerTimeout [1, 1, 1, true];
						_bastActive setTriggerStatements [_activateCondition,"",""];

							_bastClear = createTrigger ["EmptyDetector",_basePos];
							_bastClear setTriggerArea [_mkrSizeX,_mkrSizeY,0,true];
							_bastClear setTriggerActivation [_enemyFaction,"NOT PRESENT",true];
							_bastClear setTriggerStatements ["this","",""];

	_n=0;
	_aGroup=[];
		while {_n < _PApatrols} do
		{
		_n=_n+1;
						_pos = [_basePos, _Placement, random 360] call BIS_fnc_relPos;
						_pos = [_pos,0,20,5,1,20,0] call BIS_fnc_findSafePos;
							_grp=[_pos,_PAgroupSize,_faction,_side] call EOS_spawnPatrol;
							_aGroup=_aGroup+[_grp];
								sleep 0.1;
									if (_debug) then {hint "Spawning patrol";
										0= [_mkr,_n,"patrol",getpos (leader _grp)] call EOS_debug};
		};

	_lv=[];

	while {(count _lv) < _LVehGroups} do
		{
				_pos = [_basePos, _Placement, random 360] call BIS_fnc_relPos;
				_pos = [_pos,0,20,5,1,20,0] call BIS_fnc_findSafePos;

					_bGroup=[_pos,_PAgroupSize,_faction,_side] call EOS_LightVeh;
			_lv=_lv+[_bGroup];
			sleep 0.1;
				if (_debug) then {player sidechat format ["Light Vehicle:%1 - r%2",(count _lv),_LVehGroups];
				0= [_mkr,(count _lv),"Light Veh",(getpos leader (_bGroup select 2))] call EOS_debug
								};
		};

//SPAWN ARMOURED VEHICLES
	_AV=[];
		while {(count _AV) < _AVehGroups} do
		{
						_pos = [_basePos, _Placement, random 360] call BIS_fnc_relPos;
						_pos = [_pos,0,20,5,1,20,0] call BIS_fnc_findSafePos;
					if (surfaceiswater _basePos) exitwith {};
					_cGroup=[_pos,_PAgroupSize,_faction,_side] call EOS_Armour;
					_AV=_AV+[_cGroup];
					sleep 0.1;
				if (_debug) then {
								player sidechat format ["Armoured:%1 - r%2",(count _AV),_AVehGroups];
								0= [_mkr,(count _AV),"Armour",(getpos leader (_cGroup select 2))] call EOS_debug
								};
		};

	_n=0;
	_TR=[];

		while {_n < _CHGroups} do
		{

			if (_CHgroupSize select 1 == 0)then
			{ _CHType=true;
			_CHGroups=0;
						}else{
						_CHType=false;
						};

			0=[_mkr,_CHgroupSize,_faction,_CHType,_n,_bastActive,_side] execVM "eos\spawnUnits\Spawn_Aircraft.sqf";
			_TR=_TR+[_n];
				if (_debug) then {hint "Spawning HELI TRANSPORT";};
			_n=_n+1;
			sleep 0.1;
				if (_CHType)then{_CHGroups=0;};
			};
	{
		_getToMarker = _x addWaypoint [_basePos, 0];
		_getToMarker setWaypointType "MOVE";
		_getToMarker setWaypointSpeed "NORMAL";
		_getToMarker setWaypointBehaviour "AWARE";
		_getToMarker setWaypointFormation "NO CHANGE";
	}foreach _aGroup;

	{
		_getToMarker = (_x select 2) addWaypoint [_basePos, 0];
		_getToMarker setWaypointType "MOVE";
		_getToMarker setWaypointSpeed "NORMAL";
		_getToMarker setWaypointBehaviour "AWARE";
		_getToMarker setWaypointFormation "NO CHANGE";
	}foreach _AV;

	{
		_pos = [_basePos, (_mkrSizeX + 50), random 360] call BIS_fnc_relPos;
		_getToMarker = (_x select 2) addWaypoint [_pos, 0];
		_getToMarker setWaypointType "UNLOAD";
		_getToMarker setWaypointSpeed "NORMAL";
		_getToMarker setWaypointBehaviour "AWARE";
		_getToMarker setWaypointFormation "NO CHANGE";
			_wp = (_x select 2) addWaypoint [_basePos, 1];
					_wp setWaypointType "MOVE";
					_wp setWaypointSpeed "NORMAL";
					_wp setWaypointBehaviour "AWARE";
					_wp setWaypointFormation "NO CHANGE";
	}foreach _LV;


waituntil {triggeractivated _bastActive};
	_basActive=true;
_time=0;
	while {_basActive} do
	{
			if (!triggeractivated _bastActive || getmarkercolor _mkr == "colorblack") exitwith
			{
			//hint "Player left";

					{
					{deleteVehicle _x} foreach units _x;
					}foreach _aGroup;

					if (count _AV > 0) then
					{
						{				_vehicle = _x select 0;
										_crew = _x select 1;
										_grp = _x select 2;
									waituntil {!(isnil "_vehicle")};
																	{deleteVehicle _x} forEach (_crew);
																	if (!(vehicle player == _vehicle)) then
																		{{deleteVehicle _x} forEach[_vehicle];};
																			{deleteVehicle _x} foreach units _grp;
																			deleteGroup _grp;
																			}foreach _AV;
					};

					if (count _LV > 0) then
					{
						{				_vehicle = _x select 0;
										_crew = _x select 1;
										_grp = _x select 2;
									waituntil {!(isnil "_vehicle")};
																	{deleteVehicle _x} forEach (_crew);
																	if (!(vehicle player == _vehicle)) then
																		{{deleteVehicle _x} forEach[_vehicle];};
																			{deleteVehicle _x} foreach units _grp;
																			deleteGroup _grp;
																			}foreach _lv;
													};

						if (count _TR > 0) then
				{
				if (!_CHType) then{
								_CHGroups=0;
						{		_grpID=format ["TR%1",_x];
										_veh=_bastActive getvariable _grpID;
											_vehicle = _veh select 0;
											_crew = _veh select 1;
											_grp = _veh select 2;

														{deleteVehicle _x} forEach (_crew);
															if (!(vehicle player == _vehicle)) then {
																{deleteVehicle _x} forEach[_vehicle];};
																	{deleteVehicle _x} foreach units _grp;
																	deleteGroup _grp;}foreach _TR;};};
					_mkr setmarkeralpha _mkrAlpha;
					_basActive=false;
			};



		if (triggeractivated _bastActive and triggeractivated _bastClear and (_time > _timeout)) exitwith
			{
			//hint "Player survived bastion";
					_mkr setmarkercolor VictoryColor;
					_mkr setmarkeralpha _mkrAlpha;
			_basActive=false;
			};

	_time=_time+1;
	//hint format ["%1",_time];
	sleep 1;
	};

	deletevehicle _bastActive;deletevehicle _bastClear;deletevehicle _bastTaken;
if (getmarkercolor _mkr == "colorblack") then {_mkr setmarkeralpha 0;};