// Allow Revive
// values ={ 0,1,2 };
// texts  ={ "Everyone","Medic only","Pre-Defined"};
#define INS_REV_DEF_allow_revive 1

// Player Respawn Delay
// values[]={5,30,60,120,240};
// texts[]={"Dynamic","30 Sec","1 Min","2 Min","4 Min"};
#define INS_REV_DEF_respawn_delay 5

// Life Time for Revive
// values[]={-1,30,60,120,180,300,600};
// texts[]={"Unlimited","30 Sec","1 Min","2 Min","3 Min","5 Min","10 Min"};
#define INS_REV_DEF_life_time 180

// How long takes time to revive
// values[]={10,15,20,25,30,40,50,60,120};
// texts[]={"10 sec","15 sec","20 Sec","25 Sec","30 Sec","40 Sec","50 Sec","1 Min","2 Min"};
#define INS_REV_DEF_revive_take_time 15

// Require Medkit for Rivive
// values[]={ 1,0 };
// texts[]={ "Enabled","Disabled"};
#define INS_REV_DEF_require_medkit 1

// Respawn Faction
// values[]={ 0,1,2 };
// texts[]={ "ALL (Co-Op Only)","SIDE (Co-Op, PvP)","GROUP (Co-Op, PvP)"};
#define INS_REV_DEF_respawn_type 2

// Respawn Location
// values[]={ 0,1,2 };
// texts[]={ "Base + Alive friendly unit","Base","Alive friendly unit"};
#define INS_REV_DEF_respawn_location 1

// Display Respawn Locations Marker
// values[]={ 1,0 };
// texts[]={ "Enabled","Disabled"};
#define INS_REV_DEF_displayRespawnLocationMarker 1

//  - Marker Color
// values[]={ 0,1,2,3,4,5,6,7,8,9 };
// texts[]={ "ColorOrange","ColorYellow","ColorGreen","ColorPink","ColorBrown","ColorKhaki","ColorBlue","ColorRed","ColorBlack","ColorWhite" };
#define INS_REV_DEF_respawnLocationMarkerColor 0

//  - Marker Type
// values[]={ 0,1,2,3,4,5,6 };
// texts[]={ "mil_flag","mil_dot","mil_box","mil_triangle","mil_marker","mil_destroy","mil_circle" };
#define INS_REV_DEF_respawnLocationMarkerType 3

// Destroy when base vehicle can't move. (Mobile Respawn)
// values[]={ 1,0 };
// texts[]={ "Enabled","Disabled"};
#define INS_REV_DEF_destroyDamagedVehicle 0

//  - Delay Time
// values[]={10,15,20,25,30,40,50,60,120,300,600};
// texts[]={"10 sec","15 sec","20 Sec","25 Sec","30 Sec","40 Sec","50 Sec","1 Min","2 Min","5 Min", "10 Min"};
#define INS_REV_DEF_destroyDamagedVehicleDelay 30

// On JIP Action
// values[]={ 0,1,2 };
// texts[]={ "None","Teleport Action","Dispalay respawn camera"};
#define INS_REV_DEF_jip_action 0

// Allow to Drag Body
// values[]={ 1,0 };
// texts[]={ "Enabled","Disabled"};
#define INS_REV_DEF_can_drag_body 1

// Allow to Carry Body
// values[]={ 1,0 };
// texts[]={ "Enabled","Disabled"};
#define INS_REV_DEF_can_carry_body 1

//  - Allow to load Body (MEDEVAC)
// values[]={ 1,0 };
// texts[]={ "Enabled","Disabled"};
#define INS_REV_DEF_medevac 1

// Player can respawn player's own body
// values[]={ 1,0 };
// texts[]={ "Enabled","Disabled"};
#define INS_REV_DEF_can_respawn_player_body 0

// Player can respawn player's own body, If half of players are dead.
// values[]={ 1,0 };
// texts[]={ "Enabled","Disabled"};
#define INS_REV_DEF_half_dead_repsawn_player_body 0

// Player can respawn immediately, if there is not exist friendly unit near player
// values[]={ 1,0 };
// texts[]={ "Enabled","Disabled"};
#define INS_REV_DEF_near_friendly 1

// - Friendly unit search distance
// values[]={ 10,30,50,100,300,500 };
// texts[]={ "10m","30m","50m","100m","300m","500m"};
#define INS_REV_DEF_near_friendly_distance 300

// Player cannot respawn, if exist enemy unit near player
// values[]={ 1,0 };
// texts[]={ "Enabled","Disabled"};
#define INS_REV_DEF_near_enemy 0

// - Enemy unit search distance
// values[]={ 10,30,50,100,300,500 };
// texts[]={ "10m","30m","50m","100m","300m","500m"};
#define INS_REV_DEF_near_enemy_distance 50

// Player can respawn immediately, if all players are dead.
// values[]={ 1,0 };
// texts[]={ "Enabled","Disabled"};
#define INS_REV_DEF_all_dead_respawn 1

// Restore loadout on respawn
// values[]={ 1,0 };
// texts[]={ "Enabled","Disabled"};
#define INS_REV_DEF_loadout_on_respawn 0