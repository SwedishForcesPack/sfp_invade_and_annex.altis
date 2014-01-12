===================================================================================================================================================
Instructions on how to add more vehicles to the list.
===================================================================================================================================================

Okay so first lets get what kind of vehicle you want, Go here to get them

http://forums.bistudio.com/showthread.php?169226-Arma-3-Assets-Objects-Weapons-Magazines-and-much-more
===================================================================================================================================================
Okay so to make the vehicle come up in the acutal menu, go into the tools.sqf and find the other vehicles.
Put the following there (Fill IN with the vehicle names etc)

["Vehicle Name", [Number of the next (Only Up TO 10)],  "", -5, [["expression", format[_EXECscript5,"vehiclename.sqf"]]], "1", "1"],

NOW TO MAKE THE ACTUAL VEHICLE

_spawn = "REPLACE ME WITH CAR CLASS NAME";
_posplr = [((getPos player) select 0) + 2, ((getPos player) select 1) + 2, 0];
_dirplr = getDir player;
_spwnveh = _spawn createVehicle (_posplr);
_spwnveh setVariable ["Sarge",1,true];


I will be continually updating this to make a better menu <3

===================================================================================================================================================
===================================================================================================================================================