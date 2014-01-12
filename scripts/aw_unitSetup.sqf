_unit = _this select 0;

if(isNull _unit) exitWith {};

if((_unit isKindOf "Helicopter") AND !(_unit isKindOf "B_Heli_Attack_01_F")) then {[_unit] execVM "scripts\aw_sling\aw_sling_setupUnit.sqf"};

if(_unit isKindOf "B_Heli_Transport_01_camo_F") then {_unit addAction ["<t color='#0000f6'>Ammo Drop</t>", "scripts\aw_drop.sqf",[1],0,false,true,""," driver  _target == _this"]};

if((_unit isKindOf "B_Heli_Light_01_armed_F") OR (_unit isKindOf "Heli_Light_01_base_F")) then {_unit setObjectTexture [0,"a3\air_f\Heli_Light_01\Data\heli_light_01_ext_ion_co.paa"]};

/* if((_unit isKindOf "I_Heli_Transport_02_F")) then
{
	_unit setObjectTexture [0,"#(argb,8,8,3)color(1,1,1,1)"];
	_unit setObjectTexture [1,"#(argb,8,8,3)color(1,0,0,1)"];
	_unit setObjectTexture [2,"#(argb,8,8,3)color(1,1,1,1)"];
}; */

if((_unit isKindOf "Ship") OR (_unit isKindOf "Wheeled_APC_F")) then {[_unit] execVM "scripts\aw_boatPush\aw_boatPush_setupUnit.sqf"};

if((_unit isKindOf "B_MRAP_01_F") OR (_unit isKindOf "B_MRAP_01_hmg_F")) then {clearitemcargo _unit; clearWeaponCargoGlobal _unit; clearMagazineCargoGlobal _unit;};

