// SINGLE EOS MANAGER
if (!isServer) exitwith {};
private ["_pos","_r","_side","_AVGrp","_bGroup","_bastion","_eType","_civZone","_heightLimit","_AT","_ATCHGroups","_eGrpB","_eSize","_eGrpsB","_eGrp","_eGrps","_e","_dSize","_dGrps","_d","_aMin","_aSize","_aGrps","_a","_aGrp","_bMin","_units","_bSize","_bGrps","_b","_bGrp","_trig","_cache","_grp","_crew","_vehicle","_actCond","_mAN","_mAH","_distance","_mA","_settings","_cGrp","_grpID","_LVvehGrpCache","_cSize","_cGrps","_taken","_clear","_strFac","_faction","_veh","_n","_c","_eosAct","_eosActivated","_debug","_mkr","_mPos","_mkrX","_mkrY"];

_mkr=(_this select 0);_mPos=markerpos(_this select 0);_mkrX=getMarkerSize _mkr select 0;_mkrY=getMarkerSize _mkr select 1;
_a=(_this select 1);_aGrps=_a select 0;_aSize=_a select 1;_aMin=_aSize select 0;
_b=(_this select 2);_bGrps=_b select 0;_bSize=_b select 1;_bMin=_bSize select 0;
_c=(_this select 3);_cGrps=_c select 0;_cSize=_c select 1;
_d=(_this select 4);_dGrps=_d select 0;_dSize=_d select 1;
_e=(_this select 5);_eGrps=_e select 0;_eGrpsB=_e select 1;_eSize=_e select 2;
_settings=(_this select 6);_faction=_settings select 0;_mA=_settings select 1;_distance=_settings select 2;_side=_settings select 3;
_cache= if (count _this > 7) then {_this select 7} else {false};

_debug=false;
_heightLimit=false;
_r=_mkrX * 0.8;

switch (_side) do{case EAST:{_strFac="east";_civZone=false;};case WEST:{_strFac="west";_civZone=false;};case INDEPENDENT:{_strFac="GUER";_civZone=false;};case CIVILIAN:{_strFac="civ";_civZone=true;};};
switch (_mA) do {case 0:{_mAH = 1;_mAN = 0.5;};case 1:{_mAH = 0;_mAN = 0;};case 2:{_mAH = 0.5;_mAN = 0.5;};};

// INITIATE ZONE
_trig=format ["EOSTrigger%1",_mkr];

if (!_cache) then {
	if ismultiplayer then {
			if (_heightLimit) then 
			{_actCond="{vehicle _x in thisList && isplayer _x && ((getPosATL _x) select 2) < 5} count playableunits > 0";
							}else 
							{_actCond="{vehicle _x in thisList && isplayer _x} count playableunits > 0";
		};}else{
			if (_heightLimit) then 
						{_actCond="{vehicle _x in thisList && isplayer _x && ((getPosATL _x) select 2) < 5} count allUnits > 0";
								}else
									{_actCond="{vehicle _x in thisList && isplayer _x} count allUnits > 0";};};
	
		_eosActivated = createTrigger ["EmptyDetector",_mPos]; 
		_eosActivated setTriggerArea [(_distance+_mkrX),(_distance+_mkrY),0,true]; 
		_eosActivated setTriggerActivation ["ANY","PRESENT",true];
		_eosActivated setTriggerTimeout [1, 1, 1, true];
		_eosActivated setTriggerStatements [_actCond,"",""];
		
			server setvariable [_trig,_eosActivated];	
					}else{
				_eosActivated=server getvariable _trig;	
					};
		
					_mkr setmarkerAlpha _mAN;
						if (!(getmarkercolor _mkr == VictoryColor)) then 	//IF MARKER IS GREEN DO NOT CHANGE COLOUR
							{
						_mkr setmarkercolor hostileColor;
							};
					
waituntil {triggeractivated _eosActivated};	//WAIT UNTIL PLAYERS IN ZONE
if (!(getmarkercolor _mkr == "colorblack"))then {
	if (!(getmarkercolor _mkr == VictoryColor)) then {_mkr setmarkerAlpha _mAH;};

// SPAWN HOUSE PATROLS
	_n=0;
	_aGrp=[];
		while {_n < _aGrps} do 
		{	
		_n=_n+1;
		if (_cache) then {
				_cacheGrp=format ["HP%1",_n];
				_units=_eosActivated getvariable _cacheGrp;	
						_aSize=[_units,_units];
						_aMin=_aSize select 0;
							if (_debug)then{player sidechat format ["ID:%1,restore - %2",_cacheGrp,_units];};
							};
								if (_aMin > 0) then {
									_pos = [_mPos, _r, random 360] call BIS_fnc_relPos;
									_pos = [_pos,0,20,5,1,20,0] call BIS_fnc_findSafePos;
								
										_aGroup=[_pos,_aSize,_faction,_side] call EOS_spawnPatrol;
										
											0=[_mPos,units _aGroup,_r,0,[0,4],true] call callHouseScript;
												_aGrp=_aGrp+[_aGroup];sleep 0.1;
												//[(units _aGroup)] call aw_setGroupSkill;
						if (_debug) then {hint "Spawning House patrol";0= [_mkr,_n,"House Patrol",getpos (leader _aGroup)] call EOS_debug};
												};
		};
		
// SPAWN PATROLS
	_n=0;
	_bGrp=[];
		while {_n < _bGrps} do 
		{	
		_n=_n+1;
		if (_cache) then {
				_cacheGrp=format ["PA%1",_n];
				_units=_eosActivated getvariable _cacheGrp;	
					_bSize=[_units,_units];_bMin=_bSize select 0;
					if (_debug)then{player sidechat format ["ID:%1,restore - %2",_cacheGrp,_units];};
						};
							if (_bMin > 0) then {	
								_pos = [_mPos, _r, random 360] call BIS_fnc_relPos;
								_pos = [_pos,0,20,5,1,20,0] call BIS_fnc_findSafePos;
									_bGroup=[_pos,_bSize,_faction,_side] call EOS_spawnPatrol;
										0 = [_bGroup,_r] call EOS_Patrol;
										_bGrp=_bGrp+[_bGroup];sleep 0.1;
										//[(units _bGroup)] call aw_setGroupSkill;
							if (_debug) then {PLAYER SIDECHAT "Spawning patrol";0= [_mkr,_n,"patrol",getpos (leader _bGroup)] call EOS_debug};
												};
		};	
		
//SPAWN LIGHT VEHICLES
	_cGrp=[];
		while {(count _cGrp) < _cGrps} do 
		{		
				_pos = [_mPos, _r, random 360] call BIS_fnc_relPos;
				_pos = [_pos,0,20,5,1,20,0] call BIS_fnc_findSafePos;	
					_cGroup=[_pos,_cSize,_faction,_side] call EOS_LightVeh;			
					_cGrp=_cGrp+[_cGroup];				
						0 = [(_cGroup select 2),_r] call EOS_Patrol;
						sleep 0.1;
						
				if (_debug) then {player sidechat format ["Light Vehicle:%1 - r%2",(count _cGrp),_cGrps];0= [_mkr,(count _cGrp),"Light Veh",(getpos leader (_cGroup select 2))] call EOS_debug};
		};			
//SPAWN ARMOURED VEHICLES
	_dGrp=[];
		while {(count _dGrp) < _dGrps} do 
		{
			_pos = [_mPos, _r, random 360] call BIS_fnc_relPos;
			_pos = [_pos,0,20,5,1,20,0] call BIS_fnc_findSafePos;
				if (surfaceiswater _mPos) exitwith {};
					_dGroup=[_pos,_dSize,_faction,_side] call EOS_Armour;
					0 = [(_dGroup select 2),_r] call EOS_Patrol;
					_dGrp=_dGrp+[_dGroup];sleep 0.1;
					
						if (_debug) then {player sidechat format ["Armoured:%1 - r%2",(count _dGrp),_dGrps];0= [_mkr,(count _dGrp),"Armour",(getpos leader (_dGroup select 2))] call EOS_debug};
		};				
//SPAWN STATIC PLACEMENTS
	_eGrp=[];
		while {(count _eGrp) < _eGrps} do 
		{	
		if (surfaceiswater _mPos) exitwith {};
			_pos = [_mPos, _r, random 360] call BIS_fnc_relPos;
			_pos = [_pos,0,20,5,1,20,0] call BIS_fnc_findSafePos;
				_eGroup=[_pos,_eSize,_faction,_side] call EOS_spawnStatic;
					_eGrp=_eGrp+[_eGroup];sleep 0.1;
					
							if (_debug) then {hint "Spawning static Vehicles";0= [_mkr,(count _eGrp),"Static",(getpos leader (_eGroup select 2))] call EOS_debug};
		};	
		
//SPAWN HELI TRANSPORT
	_n=0;
	_eGrpB=[];
		while {_n < _eGrpsB} do 
		{	

			if (_eSize select 1 == 0)then
			{ 
			_eType=true;_eGrpsB=0;
						}else{
						_eType=false;
						};						
						0=[_mkr,_eSize,_faction,_eType,_n,_eosActivated,_side] execVM "eos\spawnUnits\Spawn_Aircraft.sqf";
						_eGrpB=_eGrpB+[_n];
							if (_debug) then {hint "Spawning HELI TRANSPORT";};
							_n=_n+1;sleep 0.1;
							if (_eType)then{_eGrpsB=0;};
			};	
//SPAWN ALT TRIGGERS	
			_clear = createTrigger ["EmptyDetector",_mPos]; 
			_clear setTriggerArea [_mkrX,_mkrY,0,true]; 
			_clear setTriggerActivation [_strFac,"NOT PRESENT",true]; 
			_clear setTriggerStatements ["this","",""]; 
				_taken = createTrigger ["EmptyDetector",_mPos]; 
				_taken setTriggerArea [_mkrX,_mkrY,0,true];
				_taken setTriggerActivation ["ANY","PRESENT",true]; 
				_taken setTriggerStatements ["{vehicle _x in thisList && isplayer _x && ((getPosATL _x) select 2) < 5} count allUnits > 0","",""]; 
_eosAct=true;	
while {_eosAct} do
	{
	// IF PLAYER LEAVES THE AREA OR ZONE DEACTIVATED
	if (!triggeractivated _eosActivated || getmarkercolor _mkr == "colorblack") exitwith 
		{
		if (_debug) then {if (!(getmarkercolor _mkr == "colorblack")) then {hint "Restarting Zone AND deleting units";}else{hint "EOS zone deactivated";};};		
//CACHE LIGHT VEHICLES
	if (count _cGrp > 0) then 
				{				
						{	_vehicle = _x select 0;_crew = _x select 1;_grp = _x select 2;
									waituntil {!(isnil "_vehicle")};
									if (!alive _vehicle || {!alive _x} foreach _crew) then { _cGrps= _cGrps - 1;};	
												{deleteVehicle _x} forEach (_crew);		
														if (!(vehicle player == _vehicle)) then {{deleteVehicle _x} forEach[_vehicle];};												
																			{deleteVehicle _x} foreach units _grp;deleteGroup _grp;
						}foreach _cGrp;
if (_debug) then {player sidechat format ["ID:c%1",_cGrps];};};
											
// CACHE ARMOURED VEHICLES
		if (count _dGrp > 0) then 
				{				
						{	_vehicle = _x select 0;_crew = _x select 1;_grp = _x select 2;
									waituntil {!(isnil "_vehicle")};
									if (!alive _vehicle || {!alive _x} foreach _crew) then {_dGrps= _dGrps - 1;};	
												{deleteVehicle _x} forEach (_crew);		
														if (!(vehicle player == _vehicle)) then {{deleteVehicle _x} forEach[_vehicle];};												
																			{deleteVehicle _x} foreach units _grp;deleteGroup _grp;
						}foreach _dGrp;
if (_debug) then {player sidechat format ["ID:c%1",_dGrps];};};

// CACHE PATROL INFANTRY					
	if (count _bGrp > 0) then 
				{		_n=0;					
						{	_n=_n+1;_units={alive _x} count units _x;_cacheGrp=format ["PA%1",_n];
	if (_debug) then{player sidechat format ["ID:%1,cache - %2",_cacheGrp,_units];};
						_eosActivated setvariable [_cacheGrp,_units];		
						{deleteVehicle _x} foreach units _x;deleteGroup _x;
						}foreach _bGrp;};
						
// CACHE HOUSE INFANTRY
	if (count _aGrp > 0) then 
				{		_n=0;					
						{	_n=_n+1;_units={alive _x} count units _x;_cacheGrp=format ["HP%1",_n];
	if (_debug) then{player sidechat format ["ID:%1,cache - %2",_cacheGrp,_units];};
						_eosActivated setvariable [_cacheGrp,_units];		
						{deleteVehicle _x} foreach units _x;deleteGroup _x;
						}foreach _aGrp;};
					
// CACHE MORTARS			
	if (count _eGrp > 0) then 
				{			
						{	_vehicle = _x select 0;_crew = _x select 1;_grp = _x select 2;
									if (!alive _vehicle || {!alive _x} foreach _crew) then {_eGrps= _eGrps - 1;};			
														{deleteVehicle _x} forEach (_crew);
															if (!(vehicle player == _vehicle)) then {{deleteVehicle _x} forEach[_vehicle];};													
																	{deleteVehicle _x} foreach units _grp;deleteGroup _grp;
						}foreach _eGrp;};			
// CACHE HELICOPTER TRANSPORT
	if (count _eGrpB > 0) then 
				{if (!_eType) then{				
						{		_grpID=format ["TR%1",_x];	
										_veh=_eosActivated getvariable _grpID;
											_vehicle = _veh select 0;_crew = _veh select 1;_grp = _veh select 2;
									if (!alive _vehicle || {!alive _x} foreach _crew) then {_eGrpsB= _eGrpsB - 1;};			
														{deleteVehicle _x} forEach (_crew);
															if (!(vehicle player == _vehicle)) then {{deleteVehicle _x} forEach[_vehicle];};													
																	{deleteVehicle _x} foreach units _grp;deleteGroup _grp;
						}foreach _eGrpB;};};	
_eosAct=false;
//if (_debug) then {hint "Zone Cached";};
};
	if (triggeractivated _clear and triggeractivated _taken and !_civZone)exitwith 
			{// IF ZONE CAPTURED BEGIN CHECKING FOR ENEMIES
				_cGrps=0;_aGrps=0;_bGrps=0;_dGrps=0;_eGrps=0;_eGrpsB=0;_ATCHGroups=0;			
				while {triggeractivated _eosActivated AND !(getmarkercolor _mkr == "colorblack")} do 
						{
							if (!triggeractivated _clear) then
							{
								_mkr setmarkercolor hostileColor;
								_mkr setmarkerAlpha _mAH;
								if (_debug) then {hint "Zone Lost";};
										}else{
											_mkr setmarkercolor VictoryColor;
											_mkr setmarkerAlpha _mAN;
											if (_debug) then {hint "Zone Captured";};
											};
				sleep 1;};
// PLAYER LEFT ZONE				
_eosAct=false;		
			};sleep 0.5;};

deletevehicle _clear;deletevehicle _taken;	
	
if (!(getmarkercolor _mkr == "colorblack")) then {	
	null = [_mkr,[_aGrps,_aSize],[_bGrps,_bSize],[_cGrps,_cSize],[_dGrps,_dSize],[_eGrps,_eGrpsB,_eSize],_settings,true] execVM "eos\EOS\EOS_Core.sqf";
	}else{_Mkr setmarkeralpha 0;};};