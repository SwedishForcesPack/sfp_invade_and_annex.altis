if (isServer) then {
private ["_CHgroupArray","_LVgroupArray","_HPgroupArray","_PAgroupArray","_CHgroupSize","_CHGroups","_SVehGroups","_AVgroupSize","_AVehGroups","_LVehGroups","_LVgroupSize","_PAgroupSize","_PApatrols","_HPpatrols","_HPgroupSize"];

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

	if (_PAgroupSize==0) then {_PAgroupArray=[1,1]};
	if (_PAgroupSize==1) then {_PAgroupArray=[2,4]};
	if (_PAgroupSize==2) then {_PAgroupArray=[4,8]};
	if (_PAgroupSize==3) then {_PAgroupArray=[8,12]};
	if (_PAgroupSize==4) then {_PAgroupArray=[12,16]};
	if (_PAgroupSize==5) then {_PAgroupArray=[16,20]};

	if (_HPgroupSize==0) then {_HPgroupArray=[1,1]};
	if (_HPgroupSize==1) then {_HPgroupArray=[2,4]};
	if (_HPgroupSize==2) then {_HPgroupArray=[4,8]};
	if (_HPgroupSize==3) then {_HPgroupArray=[8,12]};
	if (_HPgroupSize==4) then {_HPgroupArray=[12,16]};
	if (_HPgroupSize==5) then {_HPgroupArray=[16,20]};

	if (_LVgroupSize==0) then {_LVgroupArray=[1,1]};
	if (_LVgroupSize==1) then {_LVgroupArray=[2,4]};
	if (_LVgroupSize==2) then {_LVgroupArray=[4,8]};
	if (_LVgroupSize==3) then {_LVgroupArray=[8,12]};
	if (_LVgroupSize==4) then {_LVgroupArray=[12,16]};
	if (_LVgroupSize==5) then {_LVgroupArray=[16,20]};

	if (_CHgroupSize==0) then {_CHgroupArray=[0,0]};
	if (_CHgroupSize==1) then {_CHgroupArray=[2,4]};
	if (_CHgroupSize==2) then {_CHgroupArray=[4,8]};
	if (_CHgroupSize==3) then {_CHgroupArray=[8,12]};
	if (_CHgroupSize==4) then {_CHgroupArray=[12,16]};
	if (_CHgroupSize==5) then {_CHgroupArray=[16,20]};

{
	_eosMarkers=server getvariable "EOSmarkers";
	if (isnil "_eosMarkers") then {_eosMarkers=[];};
		_eosMarkers set [count _eosMarkers,_x];
		server setvariable ["EOSmarkers",_eosMarkers,true];
		null = [_x,[_HPpatrols,_HPgroupArray],[_PApatrols,_PAgroupArray],[_LVehGroups,_LVgroupArray],[_AVehGroups,_SVehGroups,_CHGroups,_CHgroupArray],_settings] execVM "eos\core\EOS_Core.sqf";
}foreach _JIPmkr;
};