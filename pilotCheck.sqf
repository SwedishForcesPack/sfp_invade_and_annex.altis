/*
      ::: ::: :::             ::: :::             ::: 
     :+: :+:   :+:           :+:   :+:           :+:  
    +:+ +:+     +:+         +:+     +:+         +:+   
   +#+ +#+       +#+       +#+       +#+       +#+    
  +#+ +#+         +#+     +#+         +#+     +#+     
 #+# #+#           #+#   #+#           #+#   #+#      
### ###             ### ###             ### ###      

| AHOY WORLD | ARMA 3 ALPHA | STRATIS DOMI VER 2.7 |

Creating working missions of this complexity from
scratch is difficult and time consuming, please
credit http://www.ahoyworld.co.uk for creating and
distibuting this mission when hosting!

This version of Domination was lovingly crafted by
Jack Williams (Rarek) for Ahoy World!
*/

while {true} do
{
	waitUntil {sleep 0.5; alive player};
	if (typeOf player != "B_Helipilot_F") then
	{
		private "_v";

		while {alive player} do
		{
			waitUntil {sleep 0.5; vehicle player != player};

			_v = vehicle player;
			if (_v isKindOf "Helicopter" && !(_v isKindOf "ParachuteBase")) then
			{
				if (driver _v == player) then
				{
					player action ["eject", _v];
					waitUntil {sleep 0.5; vehicle player == player};
					player action ["engineOff", _v];
					hint "You must be a pilot to fly!";
				};
			};
		};
	} else {
		waitUntil {sleep 0.5; !alive player};
	};
};