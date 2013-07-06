private["_type","_dialog","_item","_list","_wep_type","_temp"];
_type = taw_g_sel;
disableSerialization;

_dialog = findDisplay 2500;
_list = _dialog displayctrl 2501;
_item = Lbselection _list select 0;
if(isNil {_item}) then {_item = 0;};
_item = lbData[2501,_item];

switch (_type) do
{
	case "guns":
	{
		_wep_type = getNumber(configFile >> "CfgWeapons" >> _item >> "type");
		//hint format["%1", _wep_type];
		switch (_wep_type) do
		{
			case 1:
			{
				if(primaryWeapon player != "") then
				{
					player removeWeapon (primaryWeapon player);
				};
				player addweapon _item;
			};
			
			case 2:
			{
				if(handgunWeapon player != "") then
				{
					player removeWeapon (handgunWeapon player);
				};
					player addweapon _item;
			};
			
			case 5:
			{
				if(primaryWeapon player != "") then
				{
					player removeWeapon (primaryWeapon player);
				};
				player addweapon _item;
			};
			
			case 4:
			{
				if(_item == "MineDetector") then
				{
					player addItem _item;
				}
					else
				{
					if(secondaryWeapon player != "") then
					{
						player removeWeapon (secondaryWeapon player);
					};
						player addweapon _item;
				};
			};
			
			case 4096:
			{
				player removeWeapon _item;
				player addWeapon _item;
			};
		};
	};
	
	case "mags":
	{
		player addMagazine _item;
		//player assignItem _item;
	};
	
	case "items":
	{
		_item_type = [_item] call fnc_isgear;
		
		if(_item_type != "") then
		{
			switch (_item_type) do
			{
				case "uni":
				{
					_temp = [];
					if(uniform player != "") then {_temp = uniformItems player; removeUniform player;};
					player addUniform _item;
					{player addItem _x} foreach _temp;
				};
				
				case "vest":
				{
					_temp = [];
					if(vest player != "") then {_temp = vestItems player; removeVest player;};
					player addVest _item;
					{player addItem _x} foreach _temp;
				};
				
				case "head":
				{
					if(headGear player != "") then {removeHeadgear player;};
					player addHeadGear _item;
				};
				
				case "optic":
				{
					createDialog "VAS_prompt";
					waitUntil {!isNil {vas_prompt_choice}};
					if(vas_prompt_choice) then
					{
						if((primaryWeaponItems player) select 2 != "") then
						{
							player removeItemFromPrimaryWeapon ((primaryWeaponItems player) select 2);
							player addPrimaryWeaponItem _item;
						}
							else
						{
							player addPrimaryWeaponItem _item;
						};
					}
						else
					{
						player addItem _item;
					};
					vas_prompt_choice = nil;
				};
				
				case "acc":
				{
					createDialog "VAS_prompt";
					waitUntil {!isNil {vas_prompt_choice}};
					if(vas_prompt_choice) then
					{
						if((primaryWeaponItems player) select 1 != "") then
						{
							player removeItemFromPrimaryWeapon ((primaryWeaponItems player) select 1);
							player addPrimaryWeaponItem _item;
						}
							else
						{
							player addPrimaryWeaponItem _item;
						};
					}
						else
					{
						player addItem _item;
					};
					vas_prompt_choice = nil;
				};
				
				case "muzzle":
				{
					createDialog "VAS_prompt";
					waitUntil {!isNil {vas_prompt_choice}};
					if(vas_prompt_choice) then
					{
						if(_item == "muzzle_snds_L") then
						{
							if((handgunItems player) select 0 != "") then
							{
								player removeItemFromPrimaryWeapon ((handgunitems player) select 0);
								player addHandgunItem _item;
							}
								else
							{
								player addHandgunItem _item;
							};
						}
							else
						{
							if((primaryWeaponItems player) select 0 != "") then
							{
								player removeItemFromPrimaryWeapon ((primaryWeaponItems player) select 0);
								player addPrimaryWeaponItem _item;
							}
								else
							{
								player addPrimaryWeaponItem _item;
							};
						};
					}
						else
					{
						player addItem _item;
					};
					vas_prompt_choice = nil;
				};
			};
		}
			else
		{
			if([_item] call fnc_item_type) then
			{
				if(_item in (assignedItems player)) then
				{
					player addItem _item;
				}
					else
				{
					player addItem _item;
					player assignItem _item;
				};
			}
				else
			{
				player addItem _item;
			};
		};
	};
	
	case "packs":
	{
		if(backpack player != "") then
		{
			removeBackpack player;
			player addBackpack _item;
		}
			else
		{
			player addBackpack _item;
		};
	};
	
	case "glass":
	{
		if(goggles player != "") then
		{
			removeGoggles player;
			player addGoggles _item;
		}
			else
		{
			player addGoggles _item;
		};
	};
};

[_type] execVM "gear\pswitch.sqf";