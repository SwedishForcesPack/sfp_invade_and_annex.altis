private["_type","_dialog","_list","_weps","_name","_wep","_pic"];
_type = _this select 0;
taw_g_sel = _type;

disableSerialization;

_dialog = findDisplay 2500;
_list = _dialog displayCtrl 2501;

lbClear _list;  //Flush the list.

switch (_type) do
{
	case "guns":
	{
		_weps = [] call fnc_gear_weapons;
		{
			_name = _x select 0;
			_wep = _x select 1;
			_pic = _x select 2;
			
			_list lbAdd format["%1",_name];
			_list lbSetPicture [(lbSize _list)-1,_pic];
			_list lbSetData [(lbSize _list)-1,_wep];
		
		} foreach _weps;
		["guns"] execVM "gear\pswitch.sqf";
	};
	
	case "mags":
	{
		_weps = [] call fnc_gear_mags;
		{
			_name = _x select 0;
			_wep = _x select 1;
			_pic = _x select 2;
			
			_list lbAdd format["%1",_name];
			_list lbSetPicture [(lbSize _list)-1,_pic];
			_list lbSetData [(lbSize _list)-1,_wep];
		
		} foreach _weps;
		["mags"] execVM "gear\pswitch.sqf";
	};
	
	case "items":
	{
		_weps = [] call fnc_gear_items;
		{
			_name = _x select 0;
			if(_name != "") then
			{
				_wep = _x select 1;
				_pic = _x select 2;
			
				_list lbAdd format["%1",_name];
				_list lbSetPicture [(lbSize _list)-1,_pic];
				_list lbSetData [(lbSize _list)-1,_wep];
			};
		
		} foreach _weps;
		["items"] execVM "gear\pswitch.sqf";
	};
	
	case "packs":
	{
		_weps = [] call fnc_gear_packs;
		{
			_name = _x select 0;
			_wep = _x select 1;
			_pic = _x select 2;
			
			_list lbAdd format["%1",_name];
			_list lbSetPicture [(lbSize _list)-1,_pic];
			_list lbSetData [(lbSize _list)-1,_wep];
		
		} foreach _weps;
		["packs"] execVM "gear\pswitch.sqf";
	};
	
	case "glass":
	{
		_weps = [] call fnc_gear_goggles;
		{
			_name = _x select 0;
			_wep = _x select 1;
			_pic = _x select 2;
			
			_list lbAdd format["%1",_name];
			_list lbSetPicture [(lbSize _list)-1,_pic];
			_list lbSetData [(lbSize _list)-1,_wep];
		
		} foreach _weps;
		["glass"] execVM "gear\pswitch.sqf";
	};
};