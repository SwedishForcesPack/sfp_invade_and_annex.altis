//Alex Wise Marker Script;
if(!isServer) exitWith{};
_unit = _this select 0;

_name = format ["aw_marker_%1%2%3%4",typeOf _unit,getPos _unit select 0,getPos _unit select 1,getPos _unit select 2];
deleteMarker _name;
createMarker [_name,[0,0,0]];
_markType = "";
_markerText = "";
//if(_unit isKindOf "MRAP_01_base_F") then {_markType = "b_motor_inf";_markerText = "Cr";};
if((_unit isKindOf "Wheeled_APC_F") OR (_unit isKindOf "Tank")) then {_markType = "b_armor";_markerText;};
//if(_unit isKindOf "Quadbike_01_base_F") then {_markType = "b_motor_inf";_markerText = "Qd";};
//if(_unit isKindOf "Truck_F") then {_markType = "b_motor_inf";_markerText = "Tr";};
//if(_unit isKindOf "Ship") then {_markType = "b_motor_inf";_markerText = "Bt";};
if(_unit isKindOf "Air") then {_markType = "b_air";_markerText;};
_name setMarkerType _markType;


while{(alive _unit) AND !(isNull _unit)} do
{
	_name setMarkerPos (getPos _unit);
	_name setMarkerText _markerText;
	if(count (crew _unit) < 1) then {_name setMarkerColor "ColorWhite"} else {_name setMarkerColor "ColorOrange"};
	sleep 0.1;
};

deleteMarker _name;
