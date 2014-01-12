/*
Created by =BTC= Giallustio
Version: 0.14 rc 1
Date: 20/03/2013
Visit us at: http://www.blacktemplars.altervista.org/
*/
if (isServer) then 
{
	BTC_id_repo = 10;publicVariable "BTC_id_repo";
	BTC_cargo_repo = "Land_HBarrierBig_F" createVehicle [- 5000,- 5000,0];publicVariable "BTC_cargo_repo";
};
if (isDedicated) exitwith {};
BTC_active_lift      = 0;
BTC_active_fast_rope = 1;
BTC_active_cargo     = 0;
//Common
BTC_dir_action = "=BTC=_logistic\=BTC=_addAction.sqf";
BTC_l_placement_area = 20;
if (BTC_active_lift == 0) then
{
	//Lift
	BTC_lift_pilot    = ["I_medic_F","B_medic_F","O_medic_F"];
	BTC_lift          = 0;
	BTC_lifted        = 0;
	BTC_lift_min_h    = 0;
	BTC_lift_max_h    = 0;
	BTC_lift_radius   = 0;
	BTC_def_hud       = 0;
	BTC_def_pip       = 0;
	BTC_l_def_veh_pip = ["B_Heli_Light_01_F","O_Heli_Light_02_F","B_Heli_Transport_01_F","I_Heli_Transport_02_F"];
	BTC_l_pip_cond    = false;
	BTC_cargo_lifted  = objNull;
	BTC_Hud_Cond      = false;
	BTC_HUD_x         = 0;
	BTC_HUD_y         = 0;
	/* _lift = [] execVM "=BTC=_logistic\=BTC=_lift\=BTC=_lift_init.sqf"; */
	BTC_get_liftable_array =
	{
		_chopper = _this select 0;
		_array   = [];
		switch (typeOf _chopper) do
		{
	
	    //MI 48
		case "O_Heli_Attack_02_F" : {_array = ["B_APC_Tracked_01_CRV_F","Tank","I_supplyCrate_F","Box_IND_AmmoVeh_F","Land_CargoBox_V1_F","Tank","Car","Truck","Wheeled_APC","Tracked_APC","Air","B_APC_Tracked_01_rcws_F","B_Truck_01_transport_F","O_APC_Tracked_02_cannon_F"];};
		
		//MI 48
		case "O_Heli_Attack_02_black_F" : {_array = ["B_APC_Tracked_01_CRV_F","Tank","I_supplyCrate_F","Box_IND_AmmoVeh_F","Land_CargoBox_V1_F","Tank","Car","Truck","Wheeled_APC","Tracked_APC","Air","B_APC_Tracked_01_rcws_F","B_Truck_01_transport_F","O_APC_Tracked_02_cannon_F"];};

		//AH9
		case "B_Heli_Light_01_armed_F"     : {_array = ["I_supplyCrate_F","Box_IND_AmmoVeh_F","Land_CargoBox_V1_F"];};
		
		//MH9
		case "B_Heli_Light_01_F"     : {_array = ["I_supplyCrate_F","Box_IND_AmmoVeh_F","Land_CargoBox_V1_F"];};
		
		//UH80
		case "B_Heli_Transport_01_F" : {_array = ["B_APC_Tracked_01_CRV_F","I_supplyCrate_F","Box_IND_AmmoVeh_F","Land_CargoBox_V1_F","Car","Tank","Truck","Wheeled_APC","Air","B_APC_Tracked_01_rcws_F","B_Truck_01_transport_F","O_APC_Tracked_02_cannon_F"];};
		
		//UH80 Green
		case "B_Heli_Transport_01_camo_F"     : {_array = ["B_APC_Tracked_01_CRV_F","I_supplyCrate_F","Box_IND_AmmoVeh_F","Land_CargoBox_V1_F","Tank","Car","Truck","Wheeled_APC","Tracked_APC","Air","Quadbike_01_base_F","B_APC_Tracked_01_rcws_F","B_Truck_01_transport_F","B_APC_Tracked_01_rcws_F","B_Truck_01_transport_F","O_APC_Tracked_02_cannon_F"];};
		
		//PO-30 Orca
		case "O_Heli_Light_02_unarmed_F"     : {_array = ["B_APC_Tracked_01_CRV_F","I_supplyCrate_F","Box_IND_AmmoVeh_F","Land_CargoBox_V1_F","Tank","Car","Truck","Wheeled_APC","Air","Quadbike_01_base_F","B_APC_Tracked_01_rcws_F","B_Truck_01_transport_F","B_APC_Tracked_01_rcws_F","B_Truck_01_transport_F","O_APC_Tracked_02_cannon_F"];};
		
		//PO-30
		case "O_Heli_Light_02_F"     : {_array = ["B_APC_Tracked_01_CRV_F","I_supplyCrate_F","Box_IND_AmmoVeh_F","Land_CargoBox_V1_F","Tank","Car"];};		
		
		//CH49
		case "I_Heli_Transport_02_F" : {_array = ["B_APC_Tracked_01_CRV_F","I_supplyCrate_F","Box_IND_AmmoVeh_F","Land_CargoBox_V1_F","Tank","Car","Truck","Wheeled_APC","Tracked_APC","Air","B_APC_Tracked_01_rcws_F","B_Truck_01_transport_F","B_APC_Tracked_01_rcws_F","B_Truck_01_transport_F","O_APC_Tracked_02_cannon_F"];};

		};
		_array
	};
};
if (BTC_active_fast_rope == 1) then
{
	//Fast roping
	BTC_fast_rope_h = 50;
	BTC_fast_rope_h_min = 2;
	BTC_roping_chopper = ["B_Heli_Light_01_F","O_Heli_Light_02_F","B_Heli_Transport_01_F","I_Heli_Transport_02_F","B_Heli_Transport_01_camo_F","O_Heli_Light_02_unarmed_F","O_Heli_Light_02_unarmed_F","O_Heli_Attack_02_black_F","B_Heli_Attack_01_F","O_Heli_Attack_02_F","O_Heli_Attack_02_F"];
	_rope = [] execVM "=BTC=_logistic\=BTC=_fast_roping\=BTC=_fast_roping_init.sqf";
};
if (BTC_active_cargo == 0) then
{
	//Cargo System
	/*
	_cargo = [] execVM "=BTC=_logistic\=BTC=_cargo_system\=BTC=_cargo_system_init.sqf";
	*/
	BTC_def_vehicles     = ["Tank","Wheeled_APC","Truck","Car","Helicopter"];
	BTC_def_cargo        = ["Land_BagBunker_Large_F","CamoNet_OPFOR_big_F","B_UGV_01_rcws_F","B_MBT_01_cannon_F","B_MBT_01_mlrs_F","B_MBT_01_arty_F","I_G_Offroad_01_armed_F","B_APC_Tracked_01_AA_F","B_APC_Wheeled_01_cannon_F","O_MBT_02_cannon_F","I_MRAP_03_gmg_F","I_static_AT_F","B_GMG_01_A_F","B_HMG_01_A_F","I_static_AA_F","B_GMG_01_high_F","I_static_AT_F","B_Quadbike_01_F","I_supplyCrate_F","Land_Razorwire_F","Land_BagFence_Long_F","Land_HBarrierBig_F","Box_IND_AmmoVeh_F","Land_CargoBox_V1_F","Land_BagBunker_Small_F"];
	BTC_def_drag         = ["I_static_AT_F","B_GMG_01_A_F","B_HMG_01_A_F","I_static_AA_F","B_GMG_01_high_F","I_static_AT_F","I_supplyCrate_F","Box_IND_AmmoVeh_F","Land_CargoBox_V1_F","Land_BagBunker_Small_F"];
	BTC_def_placement    = ["Land_BagBunker_Large_F","CamoNet_OPFOR_big_F","I_static_AT_F","B_GMG_01_A_F","B_HMG_01_A_F","I_static_AA_F","B_GMG_01_high_F","I_static_AT_F","I_supplyCrate_F","Land_Razorwire_F","Land_BagFence_Long_F","Land_HBarrierBig_F","Land_BagBunker_Small_F"];
	BTC_cargo_selected   = objNull;
	BTC_def_cc =
	[
		//Trucks
		"B_Truck_01_transport_F",10,
		"B_Truck_01_covered_F",105,
		"B_APC_Tracked_01_CRV_F",105,
		"I_Truck_02_covered_F",10,
		"O_Truck_02_covered_F",10,
		"I_Truck_02_transport_F",10,
		"O_Truck_02_transport_F",10,
		"O_Truck_02_transport_F",10,
		"B_Truck_01_Repair_F",105,
		"B_Truck_01_medical_F",105,
		"I_Heli_Transport_02_F",105
	];
	BTC_def_rc =
	[
		"Land_BagBunker_Small_F",4
	];
};
//Functions
BTC_l_paradrop =
{
	_veh          = _this select 0;
	_dropped      = _this select 1;
	_chute_type   = _this select 2;
	private ["_chute"];
	_dropped_type = typeOf _dropped;
	_dropped attachTo [_veh,[0,2,-5]];
	sleep 0.1;
	detach _dropped;
	_dropped setvariable ["BTC_cannot_lift",1,false];
	waitUntil {_dropped distance _veh > 50};
	_dropped setvariable ["BTC_cannot_lift",0,false];
	_chute = createVehicle [_chute_type, getposatl _dropped, [], 0, "FLY"];
	_smoke        = "SmokeshellGreen" createVehicle position _dropped;
	_chem         = "Chemlight_green" createVehicle position _dropped;
    _smoke attachto [_dropped,[0,0,0]];
	_chem attachto [_dropped,[0,0,0]]; 
	_dropped attachTo [_chute,[0,0,0]];
	_heigh = 0;
	while {((getPos _chute) select 2) > 0.3} do {sleep 1;_heigh = (getPos _chute) select 2;};
	detach _dropped;

};
BTC_l_obj_fall =
{
	_obj    = _this select 0;
	_height = (getPos _obj) select 2;
	_fall   = 0.09;
	while {((getPos _obj) select 2) > 0.1} do 
	{

		_fall = (_fall * 1.1);
		_obj setPos [getPos _obj select 0, getPos _obj select 1, _height];
		_height = _height - _fall;
		//hint format ["%1 - %2", (getPos _obj) select 2,_height];
		sleep 0.01;
	};
	//if (((getPos _obj) select 2) < 0.3) then {_obj setPos [getPos _obj select 0, getPos _obj select 1, 0.2];};
};