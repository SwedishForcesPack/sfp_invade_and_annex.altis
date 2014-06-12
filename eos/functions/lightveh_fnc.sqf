if (!isServer) exitWith {};
// SINGLE VEHICLE GROUP
private ["_cargo","_type","_unit","_grpSize","_pos","_vehicle","_grp","_newpos","_radveh"];

_pos=(_this select 0);
_grpSize=(_this select 1);
_faction=(_this select 2);
_side=(_this select 3);
_radveh = 50;


if (surfaceiswater _pos) then {_type=2;}else{_type=3;};

		_pool=[_faction,_type] call EOS_unit;
		_unit=_pool select 0;
		_cargo=_pool select 1;
		
		for "_counter" from 0 to 20 do {
	_newpos = [_pos,0,_radveh,5,1,20,0] call BIS_fnc_findSafePos;
	if ((_pos distance _newpos) < (_radveh + 5)) exitWith {_pos = _newpos;};
				};


					_veh= [_newpos, random 360, _unit, _side] call bis_fnc_spawnvehicle;
					_vehicle = _veh select 0;
					_grp = _veh select 2;		

// SPAWN WITH CARGO	
if ((_vehicle emptyPositions "cargo") > 0) then {
		0=[_vehicle,_grpSize,_grp,_cargo] call EOS_FILLCARGO;
						};

_skillset = server getvariable "LIGskill";
{
 
 _unit = _x;
 {
  _skillvalue = (_skillset select _forEachIndex) + (random 0.2) - (random 0.2);
  _unit setSkill [_x,_skillvalue];
 } forEach ['aimingAccuracy','aimingShake','aimingSpeed','spotDistance','spotTime','courage','reloadSpeed','commanding','general'];
if (EOS_DAMAGE_MULTIPLIER != 1) then {_unit removeAllEventHandlers "HandleDamage";_unit addEventHandler ["HandleDamage",{_damage = (_this select 2)*EOS_DAMAGE_MULTIPLIER;_damage}];};
if (EOS_KILLCOUNTER) then {_unit addEventHandler ["killed", "null=[] execVM ""eos\functions\EOS_KillCounter.sqf"""]};
} forEach (units _grp); 
_veh