private["_type","_dialog","_item","_list"];
_type = taw_g_sel;
disableSerialization;

_dialog = findDisplay 2500;
_list = _dialog displayctrl 2502;
_item = Lbselection _list select 0;
if(isNil {_item}) then {_item = 0;};
_item = lbData[2502,_item];


switch(_type) do
{
	case "guns":
	{
		player removeWeapon _item;
	};
	
	case "mags":
	{
		player removeMagazine _item;
	};
	
	case "items":
	{
	
		switch (true) do
		{
			case ([_item] call fnc_isgoggle) :
			{
				removeGoggles player;
			};
			
			case ([_item] call fnc_isweapon) :
			{
				player removeWeapon _item;
			};
			
			case (!([_item] call fnc_isweapon)) :
			{
				_item_type = [_item] call fnc_isgear;
				
				if(_item_type != "") then
				{
					switch (_item_type) do
					{
						case "uni":
						{
							if(uniform player == _item) then {removeUniform player} else {player removeItem _item;};
						};
						
						case "vest":
						{
							if(vest player == _item) then {removeVest player;} else {player removeItem _item;};
						};
						
						case "head":
						{
							if(headGear player == _item) then {removeHeadGear player;} else {player removeItem _item;};
						};
						
						case "optic":
						{
							if((primaryWeaponItems player) select 2 == _item) then
							{
								player removeItemFromPrimaryWeapon ((primaryWeaponItems player) select 2);
							}
								else
							{
								player removeItem _item;
							};
						};
						
						case "acc":
						{
							if((primaryWeaponItems player) select 1 == _item) then
							{
								player removeItemFromPrimaryWeapon ((primaryWeaponItems player) select 1);
							}
								else
							{
								player removeItem _item;
							};
						};
						
						case "muzzle":
						{
							if(_item == "muzzle_snds_L") then
							{
								if((handGunItems player) select 0 == _item) then
								{
									//No command to remove it... WHY BIS!!!
								}
									else
								{
									player removeItem _item;
								};
							}
								else
							{
								if((primaryWeaponItems player) select 0 == _item) then
								{
									player removeItemFromPrimaryWeapon ((primaryWeaponItems player) select 0);
								}
									else
								{
									player removeItem _item;
								};
							};
						};
					};
				}
					else
				{
					if([_item] call fnc_item_type) then
					{
						player unassignItem _item;
					};
					
					player removeItem _item;
				};
			};
		};
	};
	case "packs":
	{
		removeBackPack player;
	};
	
	case "glass":
	{
		//player unassignItem _item;
		removeGoggles player;
		//player removeItem _item;
	};
};

[_type] execVM "gear\pswitch.sqf";