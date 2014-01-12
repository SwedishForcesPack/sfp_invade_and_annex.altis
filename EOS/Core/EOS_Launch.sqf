if (!isServer) exitwith {};
private ["_side","_bastion","_CHgroupSize","_CHGroups","_SVehGroups","_AVgroupSize","_AVehGroups","_LVehGroups","_LVgroupSize","_PAgroupSize","_PApatrols","_JIPmkr","_HPpatrols","_HPgroupSize"];
VictoryColor="colorGreen";
hostileColor="colorRed";
bastionColor="colorOrange";
_JIPmkr=(_this select 0);
_HouseInfantry=(_this select 1);
_HPpatrols=_HouseInfantry select 0;
_HPgroupSize=_HouseInfantry select 1;
_infantry=(_this select 2);
_PApatrols=_infantry select 0;
_PAgroupSize=_infantry select 1;
_LVeh=(_this select 3);
_LVehGroups=_LVeh select 0;
_LVgroupSize=_LVeh select 1;
_SVeh=(_this select 4);
_AVehGroups=_SVeh select 0;
_SVehGroups=_SVeh select 1;
_CHGroups=_SVeh select 2;
_CHgroupSize=_SVeh select 3;
_settings=(_this select 5);
_faction=_settings select 0;
_alpha=_settings select 1;
_distance=_settings select 2;
_side=_settings select 3;

switch (_PAgroupSize) do
{
	case 0:{_PAgroupSize=[1,1]};
	case 1:{_PAgroupSize=[2,4]};
	case 2:{_PAgroupSize=[4,8];};
	case 3:{_PAgroupSize=[8,12];};
	case 4:{_PAgroupSize=[12,16];};
	case 5:{_PAgroupSize=[16,20];};
};
switch (_HPgroupSize) do
{
	case 0:{_HPgroupSize=[1,1]};
	case 1:{_HPgroupSize=[2,4]};
	case 2:{_HPgroupSize=[4,8];};
	case 3:{_HPgroupSize=[8,12];};
	case 4:{_HPgroupSize=[12,16];};
	case 5:{_HPgroupSize=[16,20];};
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
		null = [_x,[_HPpatrols,_HPgroupSize],[_PApatrols,_PAgroupSize],[_LVehGroups,_LVgroupSize],[_AVehGroups,_SVehGroups,_CHGroups,_CHgroupSize],_settings] execVM "eos\core\EOS_Core.sqf";
}foreach _JIPmkr;