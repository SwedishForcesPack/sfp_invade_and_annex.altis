private ["_listedVeh"];

//if (vehicle player isKindOf "helicopter" ) then {	
//ammo7 say3d "arrival";}

_listedVeh = _this select 0;
_vehType = getText(configFile>>"CfgVehicles">>typeOf _listedveh>>"DisplayName");


if ((_listedveh isKindOf "helicopter" ) or (_listedveh isKindOf "plane")) exitWith {terminal1 say3D "arrival"};