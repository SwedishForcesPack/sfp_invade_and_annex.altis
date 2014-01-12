EOS_Spawn = compile preprocessfilelinenumbers "eos\core\EOS_Launch.sqf";
Bastion_Spawn=compile preprocessfilelinenumbers "eos\core\b_launch.sqf";
callHouseScript = compile preprocessFileLineNumbers "eos\Functions\SHK_buildingpos.sqf";
EOS_unit= compile preprocessfilelinenumbers "eos\UnitPools.sqf";
null=[] execVM "eos\Functions\EOS_misc.sqf";
null=[] execVM "eos\AI_Skill.sqf";
null=[] execVM "eos\core\Spawn_fnc.sqf";
onplayerConnected {[] execVM "eos\Functions\EOS_Markers.sqf";};
IF (isnil "server")then{hint "YOU MUST PLACE A GAME LOGIC NAMED SERVER!";};
/* EOS 1.95 by BangaBob
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
 null = [["BAS_zone_1"],[8,2],[3,2],[1],[1,0],[0,0,25,EAST]] call Bastion_Spawn;
 null=[["M1","M2","M3"],[PATROL GROUPS,SIZE OF GROUPS],[LIGHT VEHICLES,SIZE OF CARGO],[ARMOURED VEHICLES],[HELICOPTERS,SIZE OF HELICOPTER CARGO],[FACTION,MARKERTYPE,DISTANCE,SIDE]] call Bastion_Spawn;
*/
VictoryColor="colorGreen";	// Colour of marker after completion
hostileColor="colorRed";	// Default colour when enemies active
bastionColor="colorOrange";	// Colour for bastion marker
EOS_DAMAGE_MULTIPLIER=1.5;	// 1 is default
EOS_KILLCOUNTER=true;		// Counts killed units

null = [["aoCircle_2"],[0,0],[0,0],[0,0],[0,0],[0,0,25,EAST]] call Bastion_Spawn;