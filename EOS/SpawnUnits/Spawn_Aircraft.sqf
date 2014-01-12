// SINGLE VEHICLE GROUP
if (!isServer) exitwith {};
private ["_side","_type","_pad","_alt","_eosActivated","_Placement","_grpID","_grpSize","_debug","_mkr","_pos","_MkrSizeX","_MkrSizeY","_faction","_veh","_vehicle","_crew","_grp"];

_mkr=(_this select 0);
_pos=markerpos(_this select 0);
_MkrSizeX=getMarkerSize _mkr select 0;
_MkrSizeY=getMarkerSize _mkr select 1;

_grpSize=(_this select 1);
_grpMin=_grpSize select 0;
_faction=(_this select 2);
_alt=(_this select 3);
_n=(_this select 4);
_eosActivated=(_this select 5);
_side=(_this select 6);

_debug=false;
_Placement=_MkrSizeX + 1500;

		
			
		_pos = [_pos, _Placement, random 360] call BIS_fnc_relPos;		
			
	if (!_alt) then {
		_type=6;
			}else{
			_type=5;
				};	
	_pool=[_faction,_type] call EOS_unit;
	_unit=_pool select 0;_unit=_unit select 0;
		
	_cargo=_pool select 1;
						
					_veh=[_pos, random 360,_unit,_side] call bis_fnc_spawnvehicle;
					_vehicle = _veh select 0;
					_crew = _veh select 1;
					_grp = _veh select 2;

if (!_alt) then {_grpID=format ["TR%1",_n];
	_pos=[markerpos _mkr,0,_MkrSizeX,5,1,20,0] call BIS_fnc_findSafePos;
	_pad = createVehicle ["Land_HelipadEmpty_F", _pos, [], 0, "NONE"]; 
		
					}else{				
			_grpID=format ["AT%1",_n];
			};	
		
			_eosActivated setvariable [_grpID,_veh];		
					
if (_debug) then {
if (!_alt)then {
		0= [_mkr,_n,"Transport CH",getpos (leader _grp)] call EOS_debug
		
		}else{
			0= [_mkr,_n,"Attack CH",getpos (leader _grp)] call EOS_debug
			};};

// SPAWN WITH CARGO	
if ((_vehicle emptyPositions "cargo") > 0 and !_alt) then {	
		0=[_vehicle,_grpSize,_grp,_cargo] call EOS_FILLCARGO;
						

					_getToMarker = _grp addWaypoint [getpos _pad, 0];
					_getToMarker setWaypointType "MOVE";
					_getToMarker setWaypointSpeed "FULL";
					_getToMarker setWaypointBehaviour "AWARE";
						_loiter = _grp addWaypoint [getpos _pad, 1];
						_loiter setWaypointType "UNLOAD";
						_loiter setWaypointBehaviour "CARELESS";
waitUntil {sleep 0.2; isTouchingGround _vehicle};
						
						
						if (_debug) then {hint "Transport unloaded";};	
						0 = [_grp,(_MkrSizeX * 0.8)] call EOS_Patrol;

deletevehicle _pad;
				}else{
				_getToMarker = _grp addWaypoint [markerpos _mkr, 0];
					_getToMarker setWaypointType "MOVE";
					_getToMarker setWaypointSpeed "NORMAL";
					_getToMarker setWaypointBehaviour "AWARE";
						_loiter = _grp addWaypoint [markerpos _mkr, 1];
						_loiter setWaypointType "LOITER";
						_loiter setWaypointLoiterType "CIRCLE";
						};