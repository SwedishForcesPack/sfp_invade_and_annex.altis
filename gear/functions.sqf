if(!isNil {fnc_gear_weapons}) exitWith {};

[] execVM "gear\KRON_Strings.sqf";

fnc_ismagazine =
{
	private["_item"];
	_item = _this select 0;
	if((getText(configFile >> "CfgMagazines" >> _item >> "displayname")) != "") then
	{
		true;
	}
		else
	{
		false;
	};
};

fnc_save_gear = 
{
	private["_dialog","_list","_slist","_edit","_sel","_primary,_launcher","_handgun","_magazines","_uniform","_vest","_backpack","_items","_primitems","_secitems","_handgunitems","_uitems","_vitems","_bitems"];
	disableSerialization;

	_dialog = findDisplay 2510;
	_list = _dialog displayCtrl 2511;
	_slist = _dialog displayctrl 2513;
	_edit = ctrlText 2512;
	
	_sel = Lbselection _list select 0;
	if(isNil {_sel}) then {_sel = 0;};
	
	_primary = primaryWeapon player;
	_launcher = secondaryWeapon player;
	_handgun = handGunWeapon player;
	_magazines = magazines player;
	_uniform = uniform player;
	_vest = vest player;
	_backpack = backpack player;
	_items = assignedItems player;
	_primitems = primaryWeaponItems player;
	_secitems = secondaryWeaponItems player;
	_handgunitems = handGunItems player;
	_uitems = [];
	_vitems = [];
	_bitems = [];
	{if(!([_x] call fnc_ismagazine)) then { _uitems set[count _uitems,_x];};} foreach (uniformItems player);
	{if(!([_x] call fnc_ismagazine)) then { _vitems set[count _vitems,_x];};} foreach (vestItems player);
	{if(!([_x] call fnc_ismagazine)) then { _bitems set[count _bitems,_x];};} foreach (backPackItems player);
	
	if(primaryWeapon player != "") then
	{
		player selectWeapon (primaryWeapon player);
		if(currentMagazine player != "") then
		{
			_magazines set[count _magazines,currentMagazine player];
		};
	};
		
	if(secondaryWeapon player != "") then
	{
		player selectWeapon (secondaryWeapon player);
		if(currentMagazine player != "") then
		{
			_magazines set[count _magazines,currentMagazine player];
		};
	};
		
	if(handgunWeapon player != "") then
	{
		player selectWeapon (handgunWeapon player);
		if(currentMagazine player != "") then
		{
			_magazines set[count _magazines,currentMagazine player];
		};
	};
	player selectWeapon (primaryWeapon player);
	profileNameSpace setVariable[format["vas_gear_new_%1",_sel],[_edit,_primary,_launcher,_handgun,_magazines,_uniform,_vest,_backpack,_items,_primitems,_secitems,_handgunitems,_uitems,_vitems,_bitems]];
	
	[0] execVM "gear\refresh.sqf";
};

fnc_load_gear =
{
	private["_dialog","_list","_edit","_sel","_primary,_launcher","_handgun","_magazines","_uniform","_vest","_backpack","_items","_primitems","_secitems","_handgunitems","_item_type","_uitems","_vitems","_bitems"];
	disableSerialization;

	_tmp = false;
	_dialog = findDisplay 2520;
	_list = _dialog displayCtrl 2521;
	_sel = Lbselection _list select 0;
	if(isNil {_sel}) then {_sel = 0;};
	//hint format["%1", _sel];
	if(!isnil {profileNameSpace getVariable format["vas_gear_new_%1",_sel]}) then
	{
		_loadout = profileNameSpace getVariable format["vas_gear_new_%1",_sel];
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
		
		{player removeMagazine _x;} foreach (magazines player);
		
		{
			if(_x == "G_Diving" || _x == "G_Shades_Black" || _x == "G_Shades_Blue" || _x == "G_Sport_Blackred" || _x == "G_Tactical_Clear") then
			{
				removeGoggles player;
			};
			
			if(_x == "Binocular") then
			{
				player removeWeapon _x;
			}
				else
			{
				player unassignItem _x;
				player removeItem _x;
			};
		} foreach (assignedItems player);
		
		if(primaryWeapon player != "") then	{player removeWeapon (primaryWeapon player);};
		if(secondaryWeapon player != "") then {player removeWeapon (secondaryWeapon player);};
		if(handGunWeapon player != "") then {player removeWeapon (handGunWeapon player);};
		if(uniform player != "") then {removeUniform player;};
		if(vest player != "") then {removeVest player;};
		if(backpack player != "") then {removebackpack player;};

		player addUniform _uniform;
		player addVest _vest;
		player addbackpack _backpack;
		{player addMagazine _x} foreach _magazines;
		player addWeapon _primary;
		player addWeapon _launcher;
		player addWeapon _handgun;
		_tmp = false;
		
		{
			if(_x == "MineDetector") then
			{
				(unitBackpack player) addWeaponCargo [_x,1];
			};
			
			if(_x in ["ItemMap","ItemWatch","NVGoggles","ItemGPS","ItemRadio","ItemCompass"]) then
			{
				player addItem _x;
				player assignItem _x;
			};
			
			if(_x == "G_Diving" || _x == "G_Shades_Black" || _x == "G_Shades_Blue" || _x == "G_Sport_Blackred" || _x == "G_Tactical_Clear") then
			{
				player addGoggles _x;
			};
			
			if(_x == "Binocular") then
			{
				player addWeapon _x;
			};
			
			_item_type = [_x,2] call KRON_StrLeft;
		
			if(_item_type == "H_") then
			{
				player addHeadGear _x;
			};
			
		} foreach _items;
		
		if(count _uitems != 0) then 
		{
			{
				player addItem _x;
			} foreach _uitems;
		};
		
		if(count _vitems != 0) then
		{
			{
				player addItem _x;
			} foreach _vitems;
		};
		
		if(count _bitems != 0) then
		{
			{
				player addItem _x;
			} foreach _bitems;
		};
		
		if(count _primitems != 0) then
		{
			for "_i" from 0 to 2 do
			{
				if((primaryWeaponItems player select _i) != _primitems select _i) then
				{
					player addPrimaryWeaponItem (_primitems select _i);
				};
			};
		};
		
		if(count _secitems != 0) then
		{
			for "_i" from 0 to 2 do
			{
				if((primaryWeaponItems player select _i) != _secitems select _i) then
				{
					player addSecondaryWeaponItem (_secitems select _i);
				};
			};
		};
		
		if(count _handgunitems != 0) then
		{
			for "_i" from 0 to 2 do
			{
				if((handgunItems player select _i) != _handgunitems select _i) then
				{
					player addHandgunItem (_handgunitems select _i);
				};
			};
		};
	};
};

vas_loadonrespawn =
{
	if(!vas_onRespawn) exitWith {};
	disableSerialization;
	
	_dialog = findDisplay 2520;
	_list = _dialog displayCtrl 2521;
	_sel = Lbselection _list select 0;
	if(isNil {_sel}) then {_sel = 0;};
	vas_loadout = _sel;
	player addEventHandler["respawn",
	{
		if(!isnil {profileNameSpace getVariable format["vas_gear_new_%1",vas_loadout]}) then
		{
			_loadout = profileNameSpace getVariable format["vas_gear_new_%1",vas_loadout];
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
			
			{player removeMagazine _x;} foreach (magazines player);
			
			{
				if(_x == "G_Diving" || _x == "G_Shades_Black" || _x == "G_Shades_Blue" || _x == "G_Sport_Blackred" || _x == "G_Tactical_Clear") then
				{
					removeGoggles player;
				};
				
				if(_x == "Binocular") then
				{
					player removeWeapon _x;
				}
					else
				{
					player unassignItem _x;
					player removeItem _x;
				};
			} foreach (assignedItems player);
			
			if(primaryWeapon player != "") then	{player removeWeapon (primaryWeapon player);};
			if(secondaryWeapon player != "") then {player removeWeapon (secondaryWeapon player);};
			if(handGunWeapon player != "") then {player removeWeapon (handGunWeapon player);};
			if(uniform player != "") then {removeUniform player;};
			if(vest player != "") then {removeVest player;};
			if(backpack player != "") then {removebackpack player;};

			player addUniform _uniform;
			player addVest _vest;
			player addbackpack _backpack;
			{player addMagazine _x} foreach _magazines;
			player addWeapon _primary;
			player addWeapon _launcher;
			player addWeapon _handgun;
			
			{
				if(_item == "MineDetector") then
				{
				if(!(_item in (backpackItems player))) then
				{
					(unitBackpack player) addWeaponCargo [_item,1];
				};
				};
				if(_x in ["ItemMap","ItemWatch","NVGoggles","ItemGPS","ItemRadio","ItemCompass"]) then
				{
					player addItem _x;
					player assignItem _x;
				};
				
				if(_x == "G_Diving" || _x == "G_Shades_Black" || _x == "G_Shades_Blue" || _x == "G_Sport_Blackred" || _x == "G_Tactical_Clear") then
				{
					player addGoggles _x;
				};
				
				if(_x == "Binocular") then
				{
					player addWeapon _x;
				};
				
				_item_type = [_x,2] call KRON_StrLeft;
			
				if(_item_type == "H_") then
				{
					player addHeadGear _x;
				};
				
				if(_x in ["FirstAidKit","ToolKit","Medikit"]) then
				{
					player addItem _x;
				};
		
			} foreach _items;
			
			if(count _primitems != 0) then
			{
				for "_i" from 0 to 2 do
				{
					if((primaryWeaponItems player select _i) != _primitems select _i) then
					{
						player addPrimaryWeaponItem (_primitems select _i);
					};
				};
			};
			
			if(count _secitems != 0) then
			{
				for "_i" from 0 to 2 do
				{
					if((primaryWeaponItems player select _i) != _secitems select _i) then
					{
						player addSecondaryWeaponItem (_secitems select _i);
					};
				};
			};
			
			if(count _handgunitems != 0) then
			{
				for "_i" from 0 to 2 do
				{
					if((handgunItems player select _i) != _handgunitems select _i) then
					{
						player addHandgunItem (_handgunitems select _i);
					};
				};
			};
			
			if(count _uitems != 0) then 
			{
				{
					player addItem _x;
				} foreach _uitems;
			};
			
			if(count _vitems != 0) then
			{
				{
					player addItem _x;
				} foreach _vitems;
			};
			
			if(count _bitems != 0) then
			{
				{
					player addItem _x;
				} foreach _bitems;
			};
		};
	}];
};
fnc_gear_weapons = 
{
	private["_cfgweapons","_weapons","_cur_wep","_classname","_scope","_picture","_wep_type","_name","_match","_compare"];
	_weapons = [];
	if(count vas_weapons > 0) then
	{
		{
			_classname = _x;
			_wep_type = getNumber(configFile >> "CfgWeapons" >> _classname >> "type");
			_name = getText(configFile >> "CfgWeapons" >> _classname >> "displayname");
			_scope = getNumber(configFile >> "Cfgweapons" >> _classname >> "scope");
			_picture = getText(configFile >> "CfgWeapons" >> _classname >> "picture");
			if(_scope >= 2 && _wep_type in [1,2,4,4096] && _picture != "" && !(_classname in _weapons) && _classname != "NVGoggles") then
			{
				//diag_log format["Class: %1 - Type: %2 - Scope: %3 - Pic: %4 - WEP: %5",_classname,_wep_type,_scope,_picture,_cur_wep];
				_weapons set[count _weapons, [_name,_classname,_picture]];
			};
		} foreach vas_weapons;
	}
		else
	{
		_cfgweapons = configFile >> "CfgWeapons";
		
		for "_i" from 0 to (count _cfgWeapons)-1 do
		{
			_cur_wep = _cfgweapons select _i;
			if(isClass _cur_wep) then
			{
				_classname = configName _cur_wep;
				_wep_type = getNumber(_cur_wep >> "type");
				_name = getText (_cur_wep >> "DisplayName");
				_scope = getNumber(_cur_wep >> "scope");
				_picture = getText(_cur_wep >> "picture");
				if(_scope >= 2 && _wep_type in [1,2,4,4096] && _picture != "" && !(_classname in _weapons) && _classname != "NVGoggles") then
				{
					//diag_log format["Class: %1 - Type: %2 - Scope: %3 - Pic: %4 - WEP: %5",_classname,_wep_type,_scope,_picture,_cur_wep];
					_match = false;
					_compare = [_classname,5] call KRON_StrLeft;
					{
						if(_picture ==  (_x select 2)) then
						{
							_match = true;
						};
					} foreach _weapons;
					
					if(!_match) then
					{
						_weapons set[count _weapons, [_name,_classname,_picture]];
					};
				};
			};
		};
	};
_weapons;
};

fnc_gear_mags =
{
	private["_cfgweapons","_magazines","_cur_wep","_classname","_scope","_picture","_name"];
	_magazines = [];
	if(count vas_magazines > 0) then
	{
		{
			_classname = _x;
			_name = getText(configFile >> "CfgMagazines" >> _classname >> "displayname");
			_scope = getNumber(configFile >> "CfgMagazines" >> _classname >> "scope");
			_picture = getText(configFile >> "CfgMagazines" >> _classname >> "picture");
			if(_scope >= 2 && _picture != "" && !(_classname in _magazines)) then
			{
				_magazines set[count _magazines,[_name,_classname,_picture]];
			};
		} foreach vas_magazines;
	}
		else
	{
		_cfgweapons = configFile >> "CfgMagazines";		
			for "_i" from 0 to (count _cfgWeapons)-1 do
			{
				_cur_wep = _cfgweapons select _i;
				
				if(isClass _cur_wep) then
				{
					_classname = configName _cur_wep;
					//_wep_type = getNumber(_cur_wep >> "type");
					_scope = getNumber(_cur_wep >> "scope");
					_name = getText (_cur_wep >> "displayname");
					_picture = getText(_cur_wep >> "picture");
					
					//diag_log format["%1 - %2 - %3 - %4",_cur_wep,_classname,_scope,_name];
					if(_scope >= 1 && _picture != "" && !(_classname in _magazines)) then
					{
						_magazines set[count _magazines,[_name,_classname,_picture]];
					};
				};
			};
		};
	_magazines;
};

fnc_gear_items =
{
	private["_cfgweapons","_items","_cur_wep","_classname","_scope","_picture","_wep_type","_name"];
	_items = [];
	if(count vas_items > 0) then
	{
		{
			_classname = _x;
			_wep_type = getNumber(configFile >> "CfgWeapons" >> _classname >> "type");
			_name = getText(configFile >> "CfgWeapons" >> _classname >> "displayname");
			_scope = getNumber(configFile >> "Cfgweapons" >> _classname >> "scope");
			_picture = getText(configFile >> "CfgWeapons" >> _classname >> "picture");
			if(_scope >= 2 && _wep_type in [131072,4096] && _picture != "" && !(_classname in _items) && _classname != "Binocular") then
			{
				_items set[count _items, [_name,_classname,_picture]];
			};
		} foreach vas_items;
	}
		else
	{
		_cfgweapons = configFile >> "CfgWeapons";
			
			for "_i" from 0 to (count _cfgWeapons)-1 do
			{
				_cur_wep = _cfgweapons select _i;
				
				if(isClass _cur_wep) then
				{
					_classname = configName _cur_wep;
					_name = getText (_cur_wep >> "DisplayName");
					_wep_type = getNumber(_cur_wep >> "type");
					_scope = getNumber(_cur_wep >> "scope");
					_picture = getText(_cur_wep >> "picture");
					if(_scope >= 2 && _wep_type in [131072,4096] && _picture != "" && !(_classname in _items) && _classname != "Binocular") then
					{
						//diag_log format["Class: %1 - Type: %2 - Scope: %3 - Pic: %4 - WEP: %5",_classname,_wep_type,_scope,_picture,_cur_wep];
						_items set[count _items, [_name,_classname,_picture]];
					};
				};
			};
		};
	_items;
};

fnc_gear_packs =
{
	private["_cfgweapons","_backpacks","_cur_wep","_classname","_scope","_picture","_wep_type","_name"];
	_backpacks = [];
	if(count vas_backpacks > 0) then
	{
		{
			_classname = _x;
			_wep_type = getText(configFile >> "CfgVehicles" >> _classname >> "Vehicleclass");
			_name = getText(configFile >> "CfgVehicles" >> _classname >> "displayname");
			_scope = getNumber(configFile >> "CfgVehicles" >> _classname >> "scope");
			_picture = getText(configFile >> "CfgVehicles" >> _classname >> "picture");
			if(_scope >= 2 && _wep_type == "Backpacks" && _picture != "" && !(_classname in _backpacks)) then
			{
				//diag_log format["Class: %1 - Type: %2 - Scope: %3 - Pic: %4 - WEP: %5",_classname,_wep_type,_scope,_picture,_cur_wep];
				_backpacks set[count _backpacks, [_name,_classname,_picture]];
			};
		} foreach vas_backpacks;
	}
		else
	{
		_cfgweapons = configFile >> "CfgVehicles";
		
			for "_i" from 0 to (count _cfgWeapons)-1 do
			{
				_cur_wep = _cfgweapons select _i;
				
				if(isClass _cur_wep) then
				{
					_classname = configName _cur_wep;
					_name = getText (_cur_wep >> "DisplayName");
					_wep_type = getText(_cur_wep >> "vehicleClass");
					_scope = getNumber(_cur_wep >> "scope");
					_picture = getText(_cur_wep >> "picture");
					if(_scope >= 2 && _wep_type == "Backpacks" && _picture != "" && !(_classname in _backpacks)) then
					{
						//diag_log format["Class: %1 - Type: %2 - Scope: %3 - Pic: %4 - WEP: %5",_classname,_wep_type,_scope,_picture,_cur_wep];
						_backpacks set[count _backpacks, [_name,_classname,_picture]];
					};
				};
			};
		};
	_backpacks;
};

fnc_gear_goggles =
{
	private["_cfgweapons","_glasses","_cur_wep","_classname","_picture","_name"];
	_glasses = [];
	if(count vas_goggles > 0) then
	{
		{
			_classname = _x;
			_name = getText(configFile >> "CfgGlasses" >> _classname >> "displayname");
			_picture = getText(configFile >> "CfgGlasses" >> _classname >> "picture");
			if(_picture != "" && _name != "None") then
			{
				_glasses set[count _glasses, [_name,_classname,_picture]];
			};
		} foreach vas_goggles;
	}
		else
	{
		_cfgweapons = configFile >> "CfgGlasses";
			
			for "_i" from 0 to (count _cfgWeapons)-1 do
			{
				_cur_wep = _cfgweapons select _i;
				
				if(isClass _cur_wep) then
				{
					_classname = configName _cur_wep;
					_name = getText (_cur_wep >> "DisplayName");
					_picture = getText(_cur_wep >> "picture");
					if(_picture != "" && _name != "None") then
					{
						_glasses set[count _glasses, [_name,_classname,_picture]];
					};
				};
			};
		};
	_glasses;
};