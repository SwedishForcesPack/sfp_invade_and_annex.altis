if (!isServer) exitWith {};
private ["_pos","_newpos","_radveh"];

_pos=(_this select 0);
_faction=(_this select 1);
_side=(_this select 2);
_radveh = 50;

		_pool=[_faction,7] call EOS_unit;
			for "_counter" from 0 to 20 do {
	_newpos = [_pos,0,_radveh,5,1,20,0] call BIS_fnc_findSafePos;
	if ((_pos distance _newpos) < (50 + 5)) exitWith {_pos = _newpos;};
				};
				
					_veh=[_newpos, random 360,_pool,_side] call bis_fnc_spawnvehicle;
					_grp = _veh select 2;

_skillset = server getvariable "STAskill";
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