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
		if(_item == "G_Diving" || _item == "G_Shades_Black" || _item == "G_Shades_Blue" || _item == "G_Sport_Blackred" || _item == "G_Tactical_Clear") then
		{
			removeGoggles player;
		}
			else
		{
			player unassignItem _item;
			player removeItem _item;
		};
		
		if(_item == "Binocular") then
		{
			player removeWeapon _item;
		};
		
		if(([_item,6] call KRON_StrLeft) == "optic_") then
			{
				if((primaryWeaponItems player) select 2 != "") then
				{
					player removeItemFromPrimaryWeapon ((primaryWeaponItems player) select 2);
				};
			};
			
			if(([_item,7] call KRON_StrLeft) == "muzzle_") then
			{
				if(_item == "muzzle_snds_L") then
				{
					if((handgunItems player) select 0 != "") then
					{
						player removeItemFromPrimaryWeapon ((handgunitems player) select 0);
					};
				}
					else
				{
					if((primaryWeaponItems player) select 0 != "") then
					{
						player removeItemFromPrimaryWeapon ((primaryWeaponItems player) select 0);
					};
				};
			};
			
			if(([_item,4] call KRON_StrLeft) == "acc_") then
			{
				if((primaryWeaponItems player) select 1 != "") then
				{
					player removeItemFromPrimaryWeapon ((primaryWeaponItems player) select 1);
				};
			}
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