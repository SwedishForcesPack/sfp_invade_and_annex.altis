// VAS-enabled vehicles
_VASable = ["B_Truck_01_ammo_F","B_Truck_01_covered_F"];
_unit = _this select 0;
_type = typeOf _unit;

if(isNull _unit) exitWith {};

[_unit] execVM "scripts\aw_markerFollow.sqf";

if((_unit isKindOf "Helicopter") AND !(_unit isKindOf "B_Heli_Attack_01_F")) then {[_unit] execVM "scripts\aw_sling\aw_sling_setupUnit.sqf"};

if(_unit isKindOf "B_Heli_Light_01_F") then {_unit addAction ["<t color='#0000f6'>Ammo Drop</t>", "scripts\aw_drop.sqf",[1],0,false,true,""," driver  _target == _this"]};

if((_unit isKindOf "B_Heli_Light_01_armed_F") OR (_unit isKindOf "Heli_Light_01_F")) then {_unit setObjectTexture [0,"a3\air_f\Heli_Light_01\Data\heli_light_01_ext_ion_co.paa"]};

if((_unit isKindOf "Ship") OR (_unit isKindOf "Wheeled_APC_F")) then {[_unit] execVM "scripts\aw_boatPush\aw_boatPush_setupUnit.sqf"};

if ( _unit isKindOf "Helicopter" ) then {
	_unit execVM "scripts\a3rc_PilotsPoints.sqf";
};

if(_type in _VASable) then { _unit addAction["<t color='#ff1111'>Mobile Ammo Box</t>", "VAS\open.sqf"]; };

_unit addAction ["<t color='#3f3fff'>Clear Inventory</t>","misc\clear.sqf",[],-97,false];