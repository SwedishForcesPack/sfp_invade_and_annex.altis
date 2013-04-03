private["_type","_dialog","_list","_slist","_sel","_magarray","_name","_pic"];
disableSerialization;
_type = _this select 0;

if(_type == 0) then
{
	_dialog = findDisplay 2510;
	_list = _dialog displayCtrl 2511;
	_slist = _dialog displayctrl 2513;

	lbClear _slist;

	_sel = Lbselection _list select 0;
	if(isNil {_sel}) then {_sel = 0;};
	_num = _sel;
	_data = lbData[2511,_sel];

	_magarray = [];
	if(!isnil {profileNameSpace getVariable format["vas_gear_new_%1",_num]}) then
	{
		CtrlShow[2513,true];
		_loadout = profileNameSpace getVariable format["vas_gear_new_%1",_num];
		_primary = _loadout select 1;
		_launcher = _loadout select 2;
		_handgun = _loadout select 3;
		_magazines = _loadout select 4;
		_uniform = _loadout select 5;
		_vest = _loadout select 6;
		_backpack = _loadout select 7;
		_items = _loadout select 8;
		_primitems = _loadout select 9;
		_secitems = _loadout select 10;
		_handgunitems = _loadout select 11;
		_uitems = _loadout select 12;
		_vitems = _loadout select 13;
		_bitems = _loadout select 14;
		
		//hint format["%1", _loadout];
		
		if(_primary != "") then
		{
			_name = getText(configFile >> "CfgWeapons" >> _primary >> "displayName");
			_pic = getText(configFile >> "CfgWeapons" >> _primary >> "picture");
			_slist lbAdd _name;
			_slist lbSetPicture [(lbSize _slist)-1,_pic];
		};
		
		if(_launcher != "") then
		{
			_name = getText(configFile >> "CfgWeapons" >> _launcher >> "displayName");
			_pic = getText(configFile >> "CfgWeapons" >> _launcher >> "picture");
			_slist lbAdd _name;
			_slist lbSetPicture [(lbSize _slist)-1,_pic];
		};
		
		if(_handgun != "") then
		{
			_name = getText(configFile >> "CfgWeapons" >> _handgun >> "displayName");
			_pic = getText(configFile >> "CfgWeapons" >> _handgun >> "picture");
			_slist lbAdd _name;
			_slist lbSetPicture [(lbSize _slist)-1,_pic];
		};
		
		if(count _magazines > 0) then
		{

			_magarray = [];
			{
				_name = getText(configFile >> "CfgMagazines" >> _x >> "displayName");
				_pic = getText(configFile >> "CfgMagazines" >> _x >> "picture");
				if(!(_x in _magarray)) then
				{
					_mag = _x;
					_slist lbAdd format["x%1 %2",({_x == _mag} count _magazines),_name];
					_slist lbSetPicture [(lbSize _slist)-1,_pic];
					_magarray set[count _magarray,_x];
				};
			} foreach _magazines;
		};
		
		if(_uniform != "") then
		{
			_name = getText(configFile >> "CfgWeapons" >> _uniform >> "displayName");
			_pic = getText(configFile >> "CfgWeapons" >> _uniform >> "picture");
			_slist lbAdd _name;
			_slist lbSetPicture [(lbSize _slist)-1,_pic];
		};
		
		if(_vest != "") then
		{
			_name = getText(configFile >> "CfgWeapons" >> _vest >> "displayName");
			_pic = getText(configFile >> "CfgWeapons" >> _vest >> "picture");
			_slist lbAdd _name;
			_slist lbSetPicture [(lbSize _slist)-1,_pic];
		};
		
		if(_backpack != "") then
		{
				_name = getText(configFile >> "CfgVehicles" >> (backpack player) >> "displayname");
				_pic = getText(configFile >> "CfgVehicles" >> (backpack player) >> "picture");
				_slist lbAdd format["%1",_name];
				_slist lbSetPicture [(lbSize _slist)-1,_pic];
		};
		
		{
			if(_x != "") then
			{
				_name = getText(configFile >> "CfgWeapons" >> _x >> "displayName");
				_pic = getText(configFile >> "CfgWeapons" >> _x >> "picture");
				_slist lbAdd _name;
				_slist lbSetPicture [(lbSize _slist)-1,_pic];
			};
		} foreach _primitems;
		
		{
			if(_x != "") then
			{
				_name = getText(configFile >> "CfgWeapons" >> _x >> "displayName");
				_pic = getText(configFile >> "CfgWeapons" >> _x >> "picture");
				_slist lbAdd _name;
				_slist lbSetPicture [(lbSize _slist)-1,_pic];
			};
		} foreach _secitems;
		
		{
			if(_x != "") then
			{
				_name = getText(configFile >> "CfgWeapons" >> _x >> "displayName");
				_pic = getText(configFile >> "CfgWeapons" >> _x >> "picture");
				_slist lbAdd _name;
				_slist lbSetPicture [(lbSize _slist)-1,_pic];
			};
		} foreach _handgunitems;
		
		{
			if(_x != "") then
			{
				if(_x == "G_Diving" || _x == "G_Shades_Black" || _x == "G_Shades_Blue" || _x == "G_Sport_Blackred" || _x == "G_Tactical_Clear") then
				{
					_name = getText(configFile >> "CfgGlasses" >> _x >> "displayname");
					_pic = getText(configFile >> "CfgGlasses" >> _x >> "picture");
					_slist lbAdd format["%1",_name];
					_slist lbSetPicture [(lbSize _slist)-1,_pic];
				};
				
				if((getText(configFile >> "CfgWeapons" >> _x >> "picture")) != "") then
				{
					_name = getText(configFile >> "CfgWeapons" >> _x >> "displayname");
					_pic = getText(configFile >> "CfgWeapons" >> _x >> "picture");
					_slist lbAdd format["%1",_name];
					_slist lbSetPicture [(lbSize _slist)-1,_pic];
				};
			};
		} foreach _items;
		
		if(count _uitems != 0) then
		{
			{
				if(_x == "G_Diving" || _x == "G_Shades_Black" || _x == "G_Shades_Blue" || _x == "G_Sport_Blackred" || _x == "G_Tactical_Clear") then
				{
					_name = getText(configFile >> "CfgGlasses" >> _x >> "displayname");
					_pic = getText(configFile >> "CfgGlasses" >> _x >> "picture");
					_slist lbAdd format["%1",_name];
					_slist lbSetPicture [(lbSize _slist)-1,_pic];
				};
				
				if((getText(configFile >> "CfgWeapons" >> _x >> "picture")) != "") then
				{
					_name = getText(configFile >> "CfgWeapons" >> _x >> "displayname");
					_pic = getText(configFile >> "CfgWeapons" >> _x >> "picture");
					_slist lbAdd format["%1",_name];
					_slist lbSetPicture [(lbSize _slist)-1,_pic];
				};
			} foreach _uitems;
		};
		
		if(count _vitems != 0) then
		{
			{
				if(_x == "G_Diving" || _x == "G_Shades_Black" || _x == "G_Shades_Blue" || _x == "G_Sport_Blackred" || _x == "G_Tactical_Clear") then
				{
					_name = getText(configFile >> "CfgGlasses" >> _x >> "displayname");
					_pic = getText(configFile >> "CfgGlasses" >> _x >> "picture");
					_slist lbAdd format["%1",_name];
					_slist lbSetPicture [(lbSize _slist)-1,_pic];
				};
				
				if((getText(configFile >> "CfgWeapons" >> _x >> "picture")) != "") then
				{
					_name = getText(configFile >> "CfgWeapons" >> _x >> "displayname");
					_pic = getText(configFile >> "CfgWeapons" >> _x >> "picture");
					_slist lbAdd format["%1",_name];
					_slist lbSetPicture [(lbSize _slist)-1,_pic];
				};
			} foreach _vitems;
		};
		
		if(count _bitems != 0) then
		{
			{
				if(_x == "G_Diving" || _x == "G_Shades_Black" || _x == "G_Shades_Blue" || _x == "G_Sport_Blackred" || _x == "G_Tactical_Clear") then
				{
					_name = getText(configFile >> "CfgGlasses" >> _x >> "displayname");
					_pic = getText(configFile >> "CfgGlasses" >> _x >> "picture");
					_slist lbAdd format["%1",_name];
					_slist lbSetPicture [(lbSize _slist)-1,_pic];
				};
				
				if((getText(configFile >> "CfgWeapons" >> _x >> "picture")) != "") then
				{
					_name = getText(configFile >> "CfgWeapons" >> _x >> "displayname");
					_pic = getText(configFile >> "CfgWeapons" >> _x >> "picture");
					_slist lbAdd format["%1",_name];
					_slist lbSetPicture [(lbSize _slist)-1,_pic];
				};
			} foreach _bitems;
		};
		
	}
		else
	{
		CtrlShow[2513,false];
	};
}
	else
{
	_dialog = findDisplay 2520;
	_list = _dialog displayCtrl 2521;
	_slist = _dialog displayctrl 2522;

	lbClear _slist;

	_sel = Lbselection _list select 0;
	if(isNil {_sel}) then {_sel = 0;};
	_num = _sel;
	_data = lbData[2511,_sel];

	_magarray = [];
	if(!isnil {profileNameSpace getVariable format["vas_gear_new_%1",_num]}) then
	{
		CtrlShow[2522,true];
		_loadout = profileNameSpace getVariable format["vas_gear_new_%1",_num];
		_primary = _loadout select 1;
		_launcher = _loadout select 2;
		_handgun = _loadout select 3;
		_magazines = _loadout select 4;
		_uniform = _loadout select 5;
		_vest = _loadout select 6;
		_backpack = _loadout select 7;
		_items = _loadout select 8;
		_primitems = _loadout select 9;
		_secitems = _loadout select 10;
		_handgunitems = _loadout select 11;
		_uitems = _loadout select 12;
		_vitems = _loadout select 13;
		_bitems = _loadout select 14;
		
		//hint format["%1", _loadout];
		
		if(_primary != "") then
		{
			_name = getText(configFile >> "CfgWeapons" >> _primary >> "displayName");
			_pic = getText(configFile >> "CfgWeapons" >> _primary >> "picture");
			_slist lbAdd _name;
			_slist lbSetPicture [(lbSize _slist)-1,_pic];
		};
		
		if(_launcher != "") then
		{
			_name = getText(configFile >> "CfgWeapons" >> _launcher >> "displayName");
			_pic = getText(configFile >> "CfgWeapons" >> _launcher >> "picture");
			_slist lbAdd _name;
			_slist lbSetPicture [(lbSize _slist)-1,_pic];
		};
		
		if(_handgun != "") then
		{
			_name = getText(configFile >> "CfgWeapons" >> _handgun >> "displayName");
			_pic = getText(configFile >> "CfgWeapons" >> _handgun >> "picture");
			_slist lbAdd _name;
			_slist lbSetPicture [(lbSize _slist)-1,_pic];
		};
		
		if(count _magazines > 0) then
		{

			_magarray = [];
			{
				_name = getText(configFile >> "CfgMagazines" >> _x >> "displayName");
				_pic = getText(configFile >> "CfgMagazines" >> _x >> "picture");
				if(!(_x in _magarray)) then
				{
					_mag = _x;
					_slist lbAdd format["x%1 %2",({_x == _mag} count _magazines),_name];
					_slist lbSetPicture [(lbSize _slist)-1,_pic];
					_magarray set[count _magarray,_x];
				};
			} foreach _magazines;
		};
		
		if(_uniform != "") then
		{
			_name = getText(configFile >> "CfgWeapons" >> _uniform >> "displayName");
			_pic = getText(configFile >> "CfgWeapons" >> _uniform >> "picture");
			_slist lbAdd _name;
			_slist lbSetPicture [(lbSize _slist)-1,_pic];
		};
		
		if(_vest != "") then
		{
			_name = getText(configFile >> "CfgWeapons" >> _vest >> "displayName");
			_pic = getText(configFile >> "CfgWeapons" >> _vest >> "picture");
			_slist lbAdd _name;
			_slist lbSetPicture [(lbSize _slist)-1,_pic];
		};
		
		if(_backpack != "") then
		{
				_name = getText(configFile >> "CfgVehicles" >> (backpack player) >> "displayname");
				_pic = getText(configFile >> "CfgVehicles" >> (backpack player) >> "picture");
				_slist lbAdd format["%1",_name];
				_slist lbSetPicture [(lbSize _slist)-1,_pic];
		};
		
		{
			if(_x != "") then
			{
				_name = getText(configFile >> "CfgWeapons" >> _x >> "displayName");
				_pic = getText(configFile >> "CfgWeapons" >> _x >> "picture");
				_slist lbAdd _name;
				_slist lbSetPicture [(lbSize _slist)-1,_pic];
			};
		} foreach _primitems;
		
		{
			if(_x != "") then
			{
				_name = getText(configFile >> "CfgWeapons" >> _x >> "displayName");
				_pic = getText(configFile >> "CfgWeapons" >> _x >> "picture");
				_slist lbAdd _name;
				_slist lbSetPicture [(lbSize _slist)-1,_pic];
			};
		} foreach _secitems;
		
		{
			if(_x != "") then
			{
				_name = getText(configFile >> "CfgWeapons" >> _x >> "displayName");
				_pic = getText(configFile >> "CfgWeapons" >> _x >> "picture");
				_slist lbAdd _name;
				_slist lbSetPicture [(lbSize _slist)-1,_pic];
			};
		} foreach _handgunitems;
		
		{
			if(_x != "") then
			{
				if(_x == "G_Diving" || _x == "G_Shades_Black" || _x == "G_Shades_Blue" || _x == "G_Sport_Blackred" || _x == "G_Tactical_Clear") then
				{
					_name = getText(configFile >> "CfgGlasses" >> _x >> "displayname");
					_pic = getText(configFile >> "CfgGlasses" >> _x >> "picture");
					_slist lbAdd format["%1",_name];
					_slist lbSetPicture [(lbSize _slist)-1,_pic];
				};
				
				if((getText(configFile >> "CfgWeapons" >> _x >> "picture")) != "") then
				{
					_name = getText(configFile >> "CfgWeapons" >> _x >> "displayname");
					_pic = getText(configFile >> "CfgWeapons" >> _x >> "picture");
					_slist lbAdd format["%1",_name];
					_slist lbSetPicture [(lbSize _slist)-1,_pic];
				};
			};
		} foreach _items;
		
		if(count _uitems != 0) then
		{
			{
				if(_x == "G_Diving" || _x == "G_Shades_Black" || _x == "G_Shades_Blue" || _x == "G_Sport_Blackred" || _x == "G_Tactical_Clear") then
				{
					_name = getText(configFile >> "CfgGlasses" >> _x >> "displayname");
					_pic = getText(configFile >> "CfgGlasses" >> _x >> "picture");
					_slist lbAdd format["%1",_name];
					_slist lbSetPicture [(lbSize _slist)-1,_pic];
				};
				
				if((getText(configFile >> "CfgWeapons" >> _x >> "picture")) != "") then
				{
					_name = getText(configFile >> "CfgWeapons" >> _x >> "displayname");
					_pic = getText(configFile >> "CfgWeapons" >> _x >> "picture");
					_slist lbAdd format["%1",_name];
					_slist lbSetPicture [(lbSize _slist)-1,_pic];
				};
			} foreach _uitems;
		};
		
		if(count _vitems != 0) then
		{
			{
				if(_x == "G_Diving" || _x == "G_Shades_Black" || _x == "G_Shades_Blue" || _x == "G_Sport_Blackred" || _x == "G_Tactical_Clear") then
				{
					_name = getText(configFile >> "CfgGlasses" >> _x >> "displayname");
					_pic = getText(configFile >> "CfgGlasses" >> _x >> "picture");
					_slist lbAdd format["%1",_name];
					_slist lbSetPicture [(lbSize _slist)-1,_pic];
				};
				
				if((getText(configFile >> "CfgWeapons" >> _x >> "picture")) != "") then
				{
					_name = getText(configFile >> "CfgWeapons" >> _x >> "displayname");
					_pic = getText(configFile >> "CfgWeapons" >> _x >> "picture");
					_slist lbAdd format["%1",_name];
					_slist lbSetPicture [(lbSize _slist)-1,_pic];
				};
			} foreach _vitems;
		};
		
		if(count _bitems != 0) then
		{
			{
				if(_x == "G_Diving" || _x == "G_Shades_Black" || _x == "G_Shades_Blue" || _x == "G_Sport_Blackred" || _x == "G_Tactical_Clear") then
				{
					_name = getText(configFile >> "CfgGlasses" >> _x >> "displayname");
					_pic = getText(configFile >> "CfgGlasses" >> _x >> "picture");
					_slist lbAdd format["%1",_name];
					_slist lbSetPicture [(lbSize _slist)-1,_pic];
				};
				
				if((getText(configFile >> "CfgWeapons" >> _x >> "picture")) != "") then
				{
					_name = getText(configFile >> "CfgWeapons" >> _x >> "displayname");
					_pic = getText(configFile >> "CfgWeapons" >> _x >> "picture");
					_slist lbAdd format["%1",_name];
					_slist lbSetPicture [(lbSize _slist)-1,_pic];
				};
			} foreach _bitems;
		};
		
	}
		else
	{
		CtrlShow[2522,false];
	};
};