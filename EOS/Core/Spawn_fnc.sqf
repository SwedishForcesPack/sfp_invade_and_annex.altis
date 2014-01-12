EOS_spawnPatrol = {
// SINGLE INFANTRY GROUP
private ["_type","_grp","_unit","_pool","_grpSize","_pos","_faction","_newPos"];

_pos=(_this select 0);
_grpSize=(_this select 1);
_faction=(_this select 2);
_side=(_this select 3);

_grpMin=_grpSize select 0;
_grpMax=_grpSize select 1;
_d=_grpMax-_grpMin;
_r=floor(random _d);
_grpSize=_r+_grpMin;


				_newPos = _pos findEmptyPosition [0,50];
				if (count _newPos > 0) then { _pos = _newPos};

				if (surfaceiswater _newPos) then {_type=1;}else{_type=0;};
					_pool=[_faction,_type] call EOS_unit;


	_grp=createGroup _side;

for "_x" from 1 to _grpSize do {
		_unitType=_pool select (floor(random(count _pool)));
		_unit = _grp createUnit [_unitType, _newPos, [], 6, "FORM"];
	};


_skillset = server getvariable "INFskill";
{
 _unit = _x;
 {
  _skillvalue = (_skillset select _forEachIndex) + (random 0.2) - (random 0.2);
  _unit setSkill [_x,_skillvalue];
 } forEach ['aimingAccuracy','aimingShake','aimingSpeed','endurance','spotDistance','spotTime','courage','reloadSpeed','commanding','general'];
if (EOS_DAMAGE_MULTIPLIER == 1) then {_unit removeAllEventHandlers "HandleDamage";_unit addEventHandler ["HandleDamage",{_damage = (_this select 2)*EOS_DAMAGE_MULTIPLIER;_damage}];};
if (EOS_KILLCOUNTER) then {_unit addEventHandler ["killed", "null=[] execVM ""eos\functions\EOS_KillCounter.sqf"""]};
} forEach (units _grp);

_grp
};

EOS_LightVeh = {
// SINGLE VEHICLE GROUP
if (!isServer) exitwith {};
private ["_cargo","_side","_type","_unit","_grpSize","_debug","_pos","_faction","_veh","_vehicle","_grp","_newpos","_radveh"];

_pos=(_this select 0);
_grpSize=(_this select 1);
_faction=(_this select 2);
_side=(_this select 3);
_radveh = 50;
_debug=DEBUG2;

if (surfaceiswater _pos) then {_type=2;}else{_type=3;};

		_pool=[_faction,_type] call EOS_unit;
		_unit=_pool select 0;
		_unit=_unit select 0;
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
 } forEach ['aimingAccuracy','aimingShake','aimingSpeed','endurance','spotDistance','spotTime','courage','reloadSpeed','commanding','general'];
if (EOS_DAMAGE_MULTIPLIER == 1) then {_unit removeAllEventHandlers "HandleDamage";_unit addEventHandler ["HandleDamage",{_damage = (_this select 2)*EOS_DAMAGE_MULTIPLIER;_damage}];};
if (EOS_KILLCOUNTER) then {_unit addEventHandler ["killed", "null=[] execVM ""eos\functions\EOS_KillCounter.sqf"""]};
} forEach (units _grp);
_veh
};

EOS_Armour = {
// SINGLE ARMOUR GROUP
private ["_side","_type","_debug","_pos","_faction","_radveh","_newpos","_grp"];

_pos=(_this select 0);
_faction=(_this select 1);
_side=(_this select 2);
_radveh = 50;
_debug=DEBUG2;

if (surfaceiswater _pos) then {_type=2;}else{_type=4;};
		_pool=[_faction,_type] call EOS_unit;

	for "_counter" from 0 to 20 do {
	_newpos = [_pos,0,_radveh,5,1,20,0] call BIS_fnc_findSafePos;
	if ((_pos distance _newpos) < (_radveh + 5)) exitWith {_pos = _newpos;};
				};

					_veh = [_newpos, random 360, _pool, _side] call bis_fnc_spawnvehicle;
					_grp = _veh select 2;

_skillset = server getvariable "ARMskill";
{
 _unit = _x;
 {
  _skillvalue = (_skillset select _forEachIndex) + (random 0.2) - (random 0.2);
  _unit setSkill [_x,_skillvalue];
 } forEach ['aimingAccuracy','aimingShake','aimingSpeed','endurance','spotDistance','spotTime','courage','reloadSpeed','commanding','general'];
if (EOS_DAMAGE_MULTIPLIER == 1) then {_unit removeAllEventHandlers "HandleDamage";_unit addEventHandler ["HandleDamage",{_damage = (_this select 2)*EOS_DAMAGE_MULTIPLIER;_damage}];};
if (EOS_KILLCOUNTER) then {_unit addEventHandler ["killed", "null=[] execVM ""eos\functions\EOS_KillCounter.sqf"""]};
} forEach (units _grp);
_veh
};

EOS_spawnStatic = {
private ["_side","_debug","_pos","_faction","_veh","_newpos","_radveh","_grp"];

_pos=(_this select 0);
_grpSize=(_this select 1);
_faction=(_this select 2);
_side=(_this select 3);
_radveh = 50;
_debug=DEBUG2;

		_type=7;


		_pool=[_faction,_type] call EOS_unit;

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
 } forEach ['aimingAccuracy','aimingShake','aimingSpeed','endurance','spotDistance','spotTime','courage','reloadSpeed','commanding','general'];
if (EOS_DAMAGE_MULTIPLIER == 1) then {_unit removeAllEventHandlers "HandleDamage";_unit addEventHandler ["HandleDamage",{_damage = (_this select 2)*EOS_DAMAGE_MULTIPLIER;_damage}];};
if (EOS_KILLCOUNTER) then {_unit addEventHandler ["killed", "null=[] execVM ""eos\functions\EOS_KillCounter.sqf"""]};
} forEach (units _grp);
_veh

};