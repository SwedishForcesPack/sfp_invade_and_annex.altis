/* 

Author: wildw1ng
Contributor: Quiksilver 
Editor: Your name here

Quiksilver notes: 

	The more restrictions, the more performance-costly, as it is monitoring constantly whether players have weapons they shouldn't have.
	Item restrictions (explosives, rangefinders, uav terminals, etc.) have to be considered in a different manner. As of ArmA 1.16, don't bother trying to restrict 
	items using the below setup, it doesn't work.
	
_________________________________________________*/

#define AT_MSG "Only AT Soldiers may use this weapon system. Launcher removed."
#define SNIPER_MSG "Only Snipers may use this weapon system. Sniper rifle removed."

[] spawn {
	while { true } do {
	
		//------------------------------------- Launchers
		
		if ((player hasWeapon "launch_NLAW_F") || (player hasWeapon "launch_B_Titan_F") || (player hasWeapon "launch_O_Titan_F") || (player hasWeapon "launch_I_Titan_F") || (player hasWeapon "launch_B_Titan_short_F") || (player hasWeapon "launch_O_Titan_short_F") || (player hasWeapon "launch_I_Titan_short_F")) then
		{
			if ((playerSide == west && typeOf player != "B_soldier_LAT_F") || (playerside == east && typeOf player != "O_soldier_LAT_F") || (playerside == resistance && typeOf player != "I_soldier_LAT_F")) then
			{
				player removeWeapon "launch_NLAW_F";
				player removeWeapon "launch_B_Titan_F";
				player removeWeapon "launch_O_Titan_F";
				player removeWeapon "launch_I_Titan_F";
				player removeWeapon "launch_B_Titan_short_F";
				player removeWeapon "launch_O_Titan_short_F";
				player removeWeapon "launch_I_Titan_short_F";
				titleText [AT_MSG, "PLAIN", 3];
			};
		};
		
		//------------------------------------- Sniper Rifles
		
		if ((player hasWeapon "srifle_GM6_F") || (player hasWeapon "srifle_GM6_LRPS_F") || (player hasWeapon "srifle_LRR_F") || (player hasWeapon "srifle_GM6_SOS_F") || (player hasWeapon "srifle_LRR_LRPS_F") || (player hasWeapon "srifle_LRR_SOS_F")) then
		{
			if ((playerSide == west && typeOf player != "B_sniper_F") || (playerside == east && typeOf player != "O_sniper_F")) then
			{
				player removeWeapon "srifle_GM6_F";
				player removeWeapon "srifle_GM6_LRPS_F";
				player removeWeapon "srifle_GM6_SOS_F";
				player removeWeapon "srifle_LRR_F";
				player removeWeapon "srifle_LRR_LRPS_F";
				player removeWeapon "srifle_LRR_SOS_F";
				titleText [SNIPER_MSG, "PLAIN", 3];
			};
		};
		sleep 5;
	} forEach playableUnits;	// original: foreach allUnits;
};