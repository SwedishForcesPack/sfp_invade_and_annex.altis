private["_type","_dialog","_item","_list","_wep_type"];
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
					player addWeapon _item;
				}
					else
				{
					player removeWeapon (primaryWeapon player);
					player addweapon _item;
				};
			};
			
			case 2:
			{
				if(handgunWeapon player != "") then
				{
					player addWeapon _item;
				}
					else
				{
					player removeWeapon (handgunWeapon player);
					player addweapon _item;
				};
			};
			
			case 4:
			{
				if(_item == "MineDetector") then
				{
					if(isNull (unitBackpack player)) then
					{
						hint "You need a backpack to use the Mine Detector";
					}
						else
					{
						if(!(_item in (backpackItems player))) then
						{
							(unitBackpack player) addWeaponCargo [_item,1];
						};
					};
				}
					else
				{
					if(secondaryWeapon player != "") then
					{
						player addWeapon _item;
					}
						else
					{
						player removeWeapon (secondaryWeapon player);
						player addweapon _item;
					};
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
		_item_type = [_item,2] call KRON_StrLeft;
		
		if(_item_type == "H_") then
		{
			if(headgear player != "") then
			{
				removeHeadgear player;
				player addHeadGear _item;
			}
				else
			{
				player addHeadGear _item;
			};
		};
			
		if(_item_type == "V_") then 
		{
			if(vest player != "") then
			{
				removeVest player;
				player addVest _item;
			}
				else
			{
				player addVest _item;
			};
		};
		
		if(_item_type == "U_") then
		{
			if(uniform player != "") then
			{
				removeUniform player;
				player addUniform _item;
			}
				else
			{
				player addUniform _item;
			};
		}
			else
		{
			if(([_item,6] call KRON_StrLeft) == "optic_") then
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
			};
			
			if(([_item,7] call KRON_StrLeft) == "muzzle_") then
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
			};
			
			if(([_item,4] call KRON_StrLeft) == "acc_") then
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
				
				if(_item in ["FirstAidKit","ToolKit","Medikit"]) then
				{
					player addItem _item;
				}
					else
				{
					player addItem _item;
					player assignItem _item;
				};
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