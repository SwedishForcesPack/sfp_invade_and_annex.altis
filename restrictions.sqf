/* by wildw1ng */
[] spawn
{
	while {true} do
	{
/* 		if ((!(primaryWeapon player == "") && (typeOf player == "B_Helipilot_F")) || (!(primaryWeapon player == "") && (typeOf player == "O_helipilot_F")) || (!(primaryWeapon player == "") && (typeOf player == "I_helipilot_F"))) then
		{
			player removeWeapon (primaryWeapon player);
			{player removeMagazine _x} forEach magazines player;
			{player addMagazine "16Rnd_9x21_Mag"} forEach [1,2,3,4];
			player addweapon "hgun_P07_F";
			player addHandgunItem "muzzle_snds_L";
			Server globalChat "Pilots may use side arms only. Primary weapon removed.";		
		}; */
		if ((player hasWeapon "launch_NLAW_F") || (player hasWeapon "launch_B_Titan_F") || (player hasWeapon "launch_B_Titan_short_F")) then
		{
			if ((playerSide == west && typeOf player != "B_soldier_LAT_F") || (playerside == east && typeOf player != "O_soldier_LAT_F") || (playerside == resistance && typeOf player != "I_soldier_LAT_F")) then
			{
				player removeWeapon "launch_NLAW_F";
				player removeWeapon "launch_B_Titan_F";
				player removeWeapon "launch_B_Titan_short_F";
				player globalChat "Only AT Soldiers are trained in missile launcher operations. Launcher removed.";
			};
		};
		if ((player hasWeapon "srifle_GM6_F") || (player hasWeapon "srifle_LRR_F") || (player hasWeapon "srifle_GM6_SOS_F") || (player hasWeapon "srifle_LRR_SOS_F")) then
		{
			if ((playerSide == west && typeOf player != "B_sniper_F") || (playerside == east && typeOf player != "O_sniper_F")) then
			{
				player removeWeapon "srifle_GM6_F";
				player removeWeapon "srifle_LRR_F";
				player removeWeapon "srifle_GM6_SOS_F";
				player removeWeapon "srifle_LRR_SOS_F";
				player globalChat "Only Snipers are trained with this caliber weapon. Sniper rifle removed.";
			};
		};
/* 		 if ((player hasItem "B_UavTerminal") || (player hasItem "O_UavTerminal") || (player hasItem "I_UavTerminal")) then
		{
			if ((playerSide == west && typeOf player != "B_soldier_UAV_F") || (playerside == east && typeOf player != "O_soldier_UAV_F")) then
			{
				player removeItem "B_UavTerminal";
				player removeItem "O_UavTerminal";
				player removeItem "I_UavTerminal";
				player globalChat "Only UAV are trained with this caliber weapon. Sniper rifle removed.";
			};
		}; */	 
		/* if ((surfaceIsWater getPos player) && !(vehicle player isKindOf "Air") && !(vehicle player isKindOf "LandVehicle") && !(vehicle player isKindOf "Ship") && !(vehicle player isKindOf "ParachuteBase")) then
		{
			if ((vest player != "V_RebreatherB") && (uniform player != "U_B_Wetsuit")) then
			{
				_magazines = magazines player;
				_items = items player;
				_uniform = uniform player;
				_vest = vest player;
				if (goggles player != "") then {removeGoggles player;};
				player addGoggles "G_Diving";
				if (typeOf unitBackpack player == "") then {player addBackpack "B_FieldPack_blk";};
				removeVest player;
				player addVest "V_RebreatherB";
				removeUniform player;
				player addUniform "U_B_Wetsuit";
				{player addMagazine _x} foreach _magazines;
				{player addItem _x } forEach _items;
				player addItem _uniform;
				player addItem _vest;
				Server globalChat "Diving Equipment.";
			};
		}; */
		sleep 1.0;
	} foreach allUnits;
};