if (!isServer) exitWith {};
// SINGLE INFANTRY GROUP
private ["_grp","_unit","_pool","_pos","_faction"];

_pos=(_this select 0);
_grpSize=(_this select 1);
_faction=(_this select 2);
_side=(_this select 3);

_grpMin=_grpSize select 0;
_grpMax=_grpSize select 1;
_d=_grpMax-_grpMin;				
_r=floor(random _d);							
_grpSize=_r+_grpMin;
				
	if (surfaceiswater _pos) then {_pool=[_faction,1] call EOS_unit;}else{_pool=[_faction,0] call EOS_unit;};
	
	_grp=createGroup _side;
			
for "_x" from 1 to _grpSize do {					
		_unitType=_pool select (floor(random(count _pool)));
		_unit = _grp createUnit [_unitType, _pos, [], 6, "FORM"];  
	};


_skillset = server getvariable "INFskill";
{
 _unit = _x;
 {
  _skillvalue = (_skillset select _forEachIndex) + (random 0.2) - (random 0.2);
  _unit setSkill [_x,_skillvalue];
 } forEach ['aimingAccuracy','aimingShake','aimingSpeed','spotDistance','spotTime','courage','reloadSpeed','commanding','general'];
if (EOS_DAMAGE_MULTIPLIER != 1) then {_unit removeAllEventHandlers "HandleDamage";_unit addEventHandler ["HandleDamage",{_damage = (_this select 2)*EOS_DAMAGE_MULTIPLIER;_damage}];};
if (EOS_KILLCOUNTER) then {_unit addEventHandler ["killed", "null=[] execVM ""eos\functions\EOS_KillCounter.sqf"""]};
} forEach (units _grp); 

_grp