/*
      ::: ::: :::             ::: :::             :::
     :+: :+:   :+:           :+:   :+:           :+:
    +:+ +:+     +:+         +:+     +:+         +:+
   +#+ +#+       +#+       +#+       +#+       +#+
  +#+ +#+         +#+     +#+         +#+     +#+
 #+# #+#           #+#   #+#           #+#   #+#
### ###             ### ###             ### ###

| AHOY WORLD |

PilotCheck.sqf was created by Kamaradski [AW]
You may alter, use or change this code as you wish as long as you keep the original authors name in it.

*/

kARRdisallowed = ["B_Heli_Transport_01_F","I_Heli_Transport_02_F","B_Heli_Transport_01_camo_F","B_Heli_Light_01_armed_F","B_Heli_Light_01_F"];

while {true} do {
	waitUntil {sleep 0.5; alive player};									// wait till player is alive
	if (typeOf player != "B_Helipilot_F") then {								// if player is type of pilot
		private "_v";														// set _v for this client only (private)
		while {alive player} do	{											// as long as player is alive
			waitUntil {sleep 0.5; vehicle player != player};				// wait till player enters a vehicle
			kSTRvehname = typeOf vehicle player;							// Get vehicle classname of current vehicle
			_v = vehicle player;											// SET _v as the vehicle the player is in
			if ( kSTRvehname in kARRdisallowed ) then {						// if the vehicle is in the dis-allowed list
				if (driver _v == player) then {								// if player is driver of that vehicle
					player action ["eject", _v];							// eject player
					waitUntil {sleep 0.5; vehicle player == player};		// wait till player is booted out of the vehicle
					player action ["engineOff", _v];						// turn off the engine of the vehicle
					hint "You must be a pilot to fly!";						// message on screen
				};
			};
		};
	} else {																// if player is not pilot
		waitUntil {sleep 0.5; !alive player};								// Wait till player is alive
	};
};