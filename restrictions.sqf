/* by wildw1ng */
[] spawn
{
	while {true} do
	{		
		// Launchers
		if ((player hasWeapon "launch_NLAW_F") || (player hasWeapon "launch_B_Titan_F") || (player hasWeapon "launch_O_Titan_F") || (player hasWeapon "launch_I_Titan_F") || (player hasWeapon "launch_B_Titan_short_F") || (player hasWeapon "launch_O_Titan_short_F") || (player hasWeapon "launch_I_Titan_short_F")) then
		{
			if ((playerSide == west && typeOf player != "B_soldier_LAT_F" && typeOf player != "B_officer_F") || (playerside == east && typeOf player != "O_soldier_LAT_F") || (playerside == resistance && typeOf player != "I_soldier_LAT_F")) then
			{
				player removeWeapon "launch_NLAW_F";
				player removeWeapon "launch_B_Titan_F";
				player removeWeapon "launch_O_Titan_F";
				player removeWeapon "launch_I_Titan_F";
				player removeWeapon "launch_B_Titan_short_F";
				player removeWeapon "launch_O_Titan_short_F";
				player removeWeapon "launch_I_Titan_short_F";
				player globalChat "Only AT Soldiers may use this weapon system. Launcher removed.";
			};
		};
		
		// Sniper Rifles
		if ((player hasWeapon "srifle_GM6_F") || (player hasWeapon "srifle_GM6_LRPS_F") || (player hasWeapon "srifle_LRR_F") || (player hasWeapon "srifle_GM6_SOS_F") || (player hasWeapon "srifle_LRR_LRPS_F") || (player hasWeapon "srifle_LRR_SOS_F")) then
		{
			if ((playerSide == west && typeOf player != "B_sniper_F" && typeOf player != "B_officer_F") || (playerside == east && typeOf player != "O_sniper_F")) then
			{
				player removeWeapon "srifle_GM6_F";
				player removeWeapon "srifle_GM6_LRPS_F";
				player removeWeapon "srifle_GM6_SOS_F";
				player removeWeapon "srifle_LRR_F";
				player removeWeapon "srifle_LRR_LRPS_F";
				player removeWeapon "srifle_LRR_SOS_F";
				player globalChat "Only Snipers may use this weapon system. Sniper rifle removed.";
			};
		};
		
		// Marksman
		if ((player hasWeapon "srifle_EBR_F") || (player hasWeapon "srifle_DMR_01_F")) then
		{
			if ((playerSide == west && typeOf player != "B_soldier_M_F" && typeOf player != "B_officer_F" && typeOf player != "B_recon_M_F")) then
			{
				player removeWeapon "srifle_EBR_F";
				player removeWeapon "srifle_DMR_01_F";
				player globalChat "Only Marksman may use this weapon system. Marksman Rifle removed.";
			};
		};
		
		// Autorifleman
		if ((player hasWeapon "LMG_Zafir_F")) then
		{
			if ((playerSide == west && typeOf player != "B_soldier_AR_F" && typeOf player != "B_officer_F")) then
			{
				player removeWeapon "LMG_Zafir_F";
				player globalChat "Only Autorifleman may use this weapon system. Zafir removed.";
			};
		};
		sleep 5;
	} foreach playableUnits;
};