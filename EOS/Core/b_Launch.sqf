if (!isServer) exitwith {};
private ["_bastion","_CHgroupSize","_CHGroups","_SVehGroups","_AVehGroups","_LVehGroups","_LVgroupSize","_PAgroupSize","_PApatrols","_JIPmkr","_HPpatrols","_HPgroupSize"];
_JIPmkr=(_this select 0);

_infantry=(_this select 1);
_PApatrols=_infantry select 0;
_PAgroupSize=_infantry select 1;
_LVeh=(_this select 2);
_LVehGroups=_LVeh select 0;
_LVgroupSize=_LVeh select 1;
_AVeh=(_this select 3);
_AVehGroups=_AVeh select 0;
_SVeh=(_this select 4);
_CHGroups=_SVeh select 0;
_CHgroupSize=_SVeh select 1;
_settings=(_this select 5);
_faction=_settings select 0;
_alpha=_settings select 1;
_distance=_settings select 2;
_side=_settings select 3;
_bastion=if (count _settings > 3) then {_settings select 3} else {false};

switch (_PAgroupSize) do
{
	case 0:{_PAgroupSize=[1,1]};
	case 1:{_PAgroupSize=[2,4]};
	case 2:{_PAgroupSize=[4,8];};
	case 3:{_PAgroupSize=[8,12];};
	case 4:{_PAgroupSize=[12,16];};
	case 5:{_PAgroupSize=[16,20];};
};
switch (_LVgroupSize) do
{
	case 0:{_LVgroupSize=[1,1]};
	case 1:{_LVgroupSize=[2,4]};
	case 2:{_LVgroupSize=[4,8];};
	case 3:{_LVgroupSize=[8,12];};
	case 4:{_LVgroupSize=[12,16];};
	case 5:{_LVgroupSize=[16,20];};
};

switch (_CHgroupSize) do
{
	case 0:{_CHgroupSize=[1,1]};
	case 1:{_CHgroupSize=[2,4]};
	case 2:{_CHgroupSize=[4,8];};
	case 3:{_CHgroupSize=[8,12];};
	case 4:{_CHgroupSize=[12,16];};
	case 5:{_CHgroupSize=[16,20];};
};
{
	_eosMarkers=server getvariable "EOSmarkers";
	
	if (isnil "_eosMarkers") then {_eosMarkers=[];};
	
		_eosMarkers=_eosMarkers + [_x];
		server setvariable ["EOSmarkers",_eosMarkers];
		null = [_x,[_PApatrols,_PAgroupSize],[_LVehGroups,_LVgroupSize],[_AVehGroups],[_CHGroups,_CHgroupSize],_settings] execVM "eos\core\b_core.sqf";;
}foreach _JIPmkr;