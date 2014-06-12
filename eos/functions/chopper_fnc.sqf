if (!isServer) exitWith {};
//SINGLE CHOPPER GROUP
private ["_cargo","_unit","_grpSize","_vehicle","_cargoGrp","_cargoAllow"];

_pos=(_this select 0);
_grpSize=(_this select 1);
_faction=(_this select 2);
_side=(_this select 3);

if ((_grpSize select 0) > 0) then {
		_cargoAllow=true;
		_pool=[_faction,6] call EOS_unit;
				_unit=_pool select 0;
				_cargo=_pool select 1;
						}else{
						_cargoAllow=false;
						_pool=[_faction,5] call EOS_unit;
						_unit=_pool;
						};
		
	_newpos = [_pos, 1500, random 360] call BIS_fnc_relPos;	

					_veh= [_newpos, random 360, _unit, _side] call bis_fnc_spawnvehicle;
					_vehicle = _veh select 0;
					_grp = _veh select 2;		

// SPAWN WITH CARGO	
if (_cargoAllow) then {
		_cargoGrp = createGroup _side;
		0=[_vehicle,_grpSize,_cargoGrp,_cargo] call EOS_FILLCARGO;
		_veh set [count _veh,_cargoGrp];	
						};		
						
_skillset = server getvariable "AIRskill";
{
 
 _unit = _x;
 {
  _skillvalue = (_skillset select _forEachIndex) + (random 0.2) - (random 0.2);
  _unit setSkill [_x,_skillvalue];
 } forEach ['aimingAccuracy','aimingShake','aimingSpeed','spotDistance','spotTime','courage','reloadSpeed','commanding','general'];
if (EOS_DAMAGE_MULTIPLIER != 1) then {_unit removeAllEventHandlers "HandleDamage";_unit addEventHandler ["HandleDamage",{_damage = (_this select 2)*EOS_DAMAGE_MULTIPLIER;_damage}];};
if (EOS_KILLCOUNTER) then {_unit addEventHandler ["killed", "null=[] execVM ""eos\functions\EOS_KillCounter.sqf"""]};
}forEach (units _grp); 

_veh