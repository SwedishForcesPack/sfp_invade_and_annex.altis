_fastRopable = [];

// ghosthawk
_ghosthawk = ["B_Heli_Transport_01_camo_F","B_Heli_Transport_01_F"];

// all Helicopters are slingable with the following exceptions
_slingable = [];
_notSlingable = ["B_Heli_Light_01_armed_F", "B_Heli_Attack_01_F"];

// all Ships are pushable with the following execeptions
_pushable = ["Wheeled_APC_F"];
_notPushable = [];

// VAS-enabled vehicles
_VASable = ["B_Truck_01_ammo_F"];

// texture
_lightHeliTexture = "a3\air_f\Heli_Light_01\Data\heli_light_01_ext_ion_co.paa";
_lightHeliTexturable = ["B_Heli_Light_01_armed_F", "Heli_Light_01_base_F"];

// parameters and variables
_unit = _this select 0;
_type = typeOf _unit;

// initialize vehicle

if(isNull _unit) exitWith {};
[_unit] execVM "scripts\aw_markerFollow.sqf";

if(((_unit isKindOf "Helicopter") OR (_type in _slingable)) AND !(_type in _notSlingable)) then {[_unit] execVM "vehicle\sling\sling_setupUnit.sqf"};

if(((_unit isKindOf "Ship") OR (_type in _pushable)) AND !(_type in _notPushable)) then {[_unit] execVM "vehicle\push\push_setupUnit.sqf"};

if(_type in _ghosthawk) then {
	[_unit] execVM "vehicle\ghosthawk\heliDoor.sqf";
	_unit addAction ["<t color='#0000f6'>Ammo Drop</t>", "vehicle\drop\drop.sqf",[1],0,false,true,"","driver _target == _this"];
};

if(_type in _lightHeliTexturable) then {_unit setObjectTexture [0,_lightHeliTexture]};

if(_type in _VASable) then { _unit addAction["<t color='#ff1111'>Mobile Ammo Box</t>", "VAS\open.sqf"]; };

_unit addAction ["<t color='#3f3fff'>Clear Inventory</t>","vehicle\clear\clear.sqf",[],-97,false];

