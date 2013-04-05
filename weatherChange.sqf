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

This is a very basic dynamic weather script made by
Rarek for Ahoy World.

As a bug in the alpha, setOvercast currently does not
work and we can therefore have no dynamic cloud
coverage / rain (yet).

Quick check to see if DEV builds are working...
*/


private ["_random"];
while {true} do
{
	sleep (3600 + (random 3600));
	_random = random 1;
	if (_random <= 0.8) then
	{
		60 setOvercast 0;
	} else {
		60 setOvercast (0.7 + random 0.3);
	};
	60 setGusts random 1;
	60 setLightnings random 1;
	60 setWaves random 1;
	60 setWindForce random 1;
	60 setWindDir random 360;
	60 setRain random 1;
};