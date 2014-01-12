EOS_Patrol = compile preprocessfilelinenumbers "eos\Functions\shk_patrol.sqf";
EOS_LightVeh = compile preprocessfilelinenumbers "eos\spawnUnits\Spawn_Vehicle.sqf";
EOS_spawnPatrol = compile preprocessfilelinenumbers "eos\spawnUnits\Spawn_Infantry.sqf";
EOS_spawnStatic = compile preprocessfilelinenumbers "eos\spawnUnits\Spawn_Static.sqf";
callHouseScript = compile preprocessFileLineNumbers "eos\Functions\SHK_buildingpos.sqf";
EOS_FILLCARGO = compile preprocessFileLineNumbers "eos\Functions\EOS_Fill_Cargo.sqf";
Bastion_Spawn = compile preprocessfilelinenumbers "eos\bastion\b_launch.sqf";
EOS_Armour = compile preprocessfilelinenumbers "eos\spawnUnits\Spawn_Armour.sqf";
EOS_unit = compile preprocessfilelinenumbers "eos\EOS_UnitPools.sqf";
EOS_debug = compile preprocessfilelinenumbers "eos\functions\EOS_debugMarker.sqf";
EOS_Deactivate = compile preprocessfilelinenumbers "eos\Functions\EOS_deactivate.sqf";
onplayerConnected {[] execVM "eos\Functions\EOS_Markers.sqf";};
IF (isnil "server")then{hint "YOU MUST PLACE A GAME LOGIC NAMED SERVER!";};
// EOS 1.9 by BangaBob
//
// GROUP SIZES
// 0 = 0
// 1 = 2,4
// 2 = 4,8
// 3 = 8,12
// 4 = 12,16
// 5 = 16,20
//
// EXAMPLE CALL - EOS
// null = [["m1"],[1,2],[2,1],[1,4],[2,0],[0,1,1],[0,0,300]] call EOS_Spawn;
// null=[["M1","M2","M3"],[HOUSE GROUPS,SIZE OF GROUPS],[PATROL GROUPS,SIZE OF GROUPS],[LIGHT VEHICLES,SIZE OF CARGO],[ARMOURED VEHICLES,SIZE OF GROUPS],[STATIC VEHICLES,HELICOPTERS,SIZE OF HELICOPTER CARGO],[FACTION,MARKERTYPE,DISTANCE,SIDE]] call EOS_Spawn;
//
// EXAMPLE CALL - BASTION
// null=[["m1"],[1,1],[1,1],[1,1],[1,1],[2,0,25]] call Bastion_Spawn;
// null=[["M1","M2","M3"],[PATROL GROUPS,SIZE OF GROUPS],[LIGHT VEHICLES,SIZE OF CARGO],[ARMOURED VEHICLES,SIZE OF GROUPS],[HELICOPTERS,SIZE OF HELICOPTER CARGO],[FACTION,MARKERTYPE,DISTANCE,SIDE]] call Bastion_Spawn;
////////////////////////////////////////////////////////////////////////////////////////////

null = [["aoCircle_2"],[10,2],[0,0],[1,2],[1,3],[0,0,25,EAST]] call Bastion_Spawn;