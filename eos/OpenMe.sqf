EOS_Spawn = compile preprocessfilelinenumbers "eos\core\eos_launch.sqf";Bastion_Spawn=compile preprocessfilelinenumbers "eos\core\b_launch.sqf";null=[] execVM "eos\core\spawn_fnc.sqf";onplayerConnected {[] execVM "eos\Functions\EOS_Markers.sqf";};
/* EOS 1.97 by BangaBob 
GROUP SIZES
 0 = 1
 1 = 2,4
 2 = 4,8
 3 = 8,12
 4 = 12,16
 5 = 16,20

EXAMPLE CALL - EOS
 null = [["MARKERNAME","MARKERNAME2"],[0,1],[0,1],[1,2],[2,1,0,0],[1,0,250,WEST]] call EOS_Spawn;
 null=[["M1","M2","M3"],[HOUSE GROUPS,SIZE OF GROUPS],[PATROL GROUPS,SIZE OF GROUPS],[LIGHT VEHICLES,SIZE OF CARGO],[ARMOURED VEHICLES, STATIC VEHICLES,HELICOPTERS,SIZE OF HELICOPTER CARGO],[FACTION,MARKERTYPE,DISTANCE,SIDE]] call EOS_Spawn;

EXAMPLE CALL - BASTION
 null = [["BAS_zone_1"],[3,1],[2,1],[2],[0,0],[0,0,EAST],[10,2,120,TRUE,TRUE]] call Bastion_Spawn;
 null=[["M1","M2","M3"],[PATROL GROUPS,SIZE OF GROUPS],[LIGHT VEHICLES,SIZE OF CARGO],[ARMOURED VEHICLES],[HELICOPTERS,SIZE OF HELICOPTER CARGO],[FACTION,MARKERTYPE,SIDE],[INITIAL PAUSE, NUMBER OF WAVES, DELAY BETWEEN WAVES, INTEGRATE EOS, SHOW HINTS]] call Bastion_Spawn;
*/
VictoryColor="colorGreen";	// Colour of marker after completion
hostileColor="colorRed";	// Default colour when enemies active
bastionColor="colorOrange";	// Colour for bastion marker
EOS_DAMAGE_MULTIPLIER=1;	// 1 is default
EOS_KILLCOUNTER=true;		// Counts killed units

null = [["EOSinf_1","EOSinf_2"],[2,1],[0,0],[0,0],[0,0,0,0],[0,0,350,EAST]] call EOS_Spawn;
null = [["EOSmot_1","EOSmot_2"],[0,1],[0,1],[0,3],[0,0,2,0],[1,0,350,WEST]] call EOS_Spawn;
null = [["BAS_zone_1"],[3,1],[2,1],[2],[1,2],[0,0,EAST],[10,2,120,TRUE,TRUE]] call Bastion_Spawn;