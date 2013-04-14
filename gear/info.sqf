private["_dialog","_list","_dlist","_text","_name","_mags","_type"];
disableSerialization;

_dialog = findDisplay 2500;
_list = _dialog displayCtrl 2509;
_text = _dialog displayCtrl 2508;
_dlist = _dialog displayCtrl 2501;
_gun = LbSelection _dlist select 0;
if(isNil {_gun}) then {_gun = 0;};
_gun = lbData [2501,_gun];

lbClear _list;
if(_gun == "MineDetector" || _gun == "Binocular") exitWith {ctrlShow [2507,false]; ctrlShow [2508,false]; ctrlShow [2509,false];};
if(isClass (configFile >> "Cfgweapons" >> _gun)) then
{
	_type = getNumber(configFile >> "CfgWeapons" >> _gun >> "type");
	
	if(_type in [1,2,4,5]) then
	{
		_name = getText (configFile >> "CfgWeapons" >> _gun >> "displayName");
		_mags = getArray (configFile >> "CfgWeapons" >> _gun >> "magazines");
		
		_text ctrlSetStructuredText parseText format["<t align='center'>%1</t>", _name];
		
		{
			_name = getText (configFile >> "CfgMagazines" >> _x >> "displayName");
			_pic = getText (configFile >> "CfgMagazines" >> _x >> "picture");
			_list lbAdd format["%1", _name];
			_list lbSetPicture [(lbSize _list)-1,_pic];
		} foreach _mags;
		
		ctrlShow [2507,true];
		ctrlShow [2508,true];
		ctrlShow [2509,true];
	}
		else
	{
		if(ctrlShown _list) then
		{
			ctrlShow [2507,false];
			ctrlShow [2508,false];
			ctrlShow [2509,false];
		};
	};
}
	else
{
	if(ctrlShown _list) then
	{
		ctrlShow [2507,false];
		ctrlShow [2508,false];
		ctrlShow [2509,false];
	};
};