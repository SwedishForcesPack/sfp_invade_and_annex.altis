/*
Hint & Tips

obj setvariable ["BTC_cannot_lift",1,true]; // Make an object not liftable
obj setVariable ["BTC_cannot_drag",1,true]; // Make an object not draggable
obj setVariable ["BTC_cannot_load",1,true]; // Make an object not loadable
BTC_lift_min_h   = 7;  // Min height required to lift an object
BTC_lift_max_h   = 12; // Max height required to lift an object
BTC_lift_radius  = 2;  // You have to stay in this radius to lift an object
BTC_lift_pilot   = []; // Leave empty if all soldiers can use choppers to lift. If only pilot can -> BTC_lift_pilot = ["US_Soldier_Pilot_EP1","USMC_Soldier_Pilot", ...etc etc];

BTC_Get_liftable_array =
{
	_chopper = _this select 0;
	_array   = [];
	switch (typeOf _chopper) do
	{
		case "MH6J_EP1" : {_array = ["Motorcycle","ReammoBox","B_Truck_01_transport_F","B_Truck_01_covered_F","I_Truck_02_covered_F","O_Truck_02_covered_F","I_Truck_02_transport_F","O_Truck_02_transport_F","I_MRAP_03_gmg_F","I_MRAP_03_F","I_MRAP_03_hmg_F","B_MRAP_01_hmg_F","B_MRAP_01_gmg_F","B_MRAP_01_F","C_Hatchback_01_sport_F","C_Hatchback_01_F","O_MRAP_02_F","O_MRAP_02_gmg_F","O_MRAP_02_hmg_F","B_Quadbike_01_F","B_G_Quadbike_01_F","O_Quadbike_01_F","I_Quadbike_01_F","C_Quadbike_01_F","B_G_Offroad_01_armed_F","B_G_Offroad_01_F","C_Offroad_01_F"];};	
		case "O_Heli_Light_02_F" : {_array = ["Motorcycle","ReammoBox","B_Truck_01_transport_F","B_Truck_01_covered_F","I_Truck_02_covered_F","O_Truck_02_covered_F","I_Truck_02_transport_F","O_Truck_02_transport_F","I_MRAP_03_gmg_F","I_MRAP_03_F","I_MRAP_03_hmg_F","B_MRAP_01_hmg_F","B_MRAP_01_gmg_F","B_MRAP_01_F","C_Hatchback_01_sport_F","C_Hatchback_01_F","O_MRAP_02_F","O_MRAP_02_gmg_F","O_MRAP_02_hmg_F","B_Quadbike_01_F","B_G_Quadbike_01_F","O_Quadbike_01_F","I_Quadbike_01_F","C_Quadbike_01_F","B_G_Offroad_01_armed_F","B_G_Offroad_01_F","C_Offroad_01_F"];};
		case "O_Heli_Light_02_unarmed_F" : {_array = ["Motorcycle","ReammoBox","B_Truck_01_transport_F","B_Truck_01_covered_F","I_Truck_02_covered_F","O_Truck_02_covered_F","I_Truck_02_transport_F","O_Truck_02_transport_F","I_MRAP_03_gmg_F","I_MRAP_03_F","I_MRAP_03_hmg_F","B_MRAP_01_hmg_F","B_MRAP_01_gmg_F","B_MRAP_01_F","C_Hatchback_01_sport_F","C_Hatchback_01_F","O_MRAP_02_F","O_MRAP_02_gmg_F","O_MRAP_02_hmg_F","B_Quadbike_01_F","B_G_Quadbike_01_F","O_Quadbike_01_F","I_Quadbike_01_F","C_Quadbike_01_F","B_G_Offroad_01_armed_F","B_G_Offroad_01_F","C_Offroad_01_F"];};
		case "B_Heli_Transport_01_F" : {_array = ["Motorcycle","ReammoBox","B_Truck_01_transport_F","B_Truck_01_covered_F","I_Truck_02_covered_F","O_Truck_02_covered_F","I_Truck_02_transport_F","O_Truck_02_transport_F","I_MRAP_03_gmg_F","I_MRAP_03_F","I_MRAP_03_hmg_F","B_MRAP_01_hmg_F","B_MRAP_01_gmg_F","B_MRAP_01_F","C_Hatchback_01_sport_F","C_Hatchback_01_F","O_MRAP_02_F","O_MRAP_02_gmg_F","O_MRAP_02_hmg_F","B_Quadbike_01_F","B_G_Quadbike_01_F","O_Quadbike_01_F","I_Quadbike_01_F","C_Quadbike_01_F","B_G_Offroad_01_armed_F","B_G_Offroad_01_F","C_Offroad_01_F"];};
		case "B_Heli_Transport_01_camo_F" : {_array = ["Motorcycle","ReammoBox","B_Truck_01_transport_F","B_Truck_01_covered_F","I_Truck_02_covered_F","O_Truck_02_covered_F","I_Truck_02_transport_F","O_Truck_02_transport_F","I_MRAP_03_gmg_F","I_MRAP_03_F","I_MRAP_03_hmg_F","B_MRAP_01_hmg_F","B_MRAP_01_gmg_F","B_MRAP_01_F","C_Hatchback_01_sport_F","C_Hatchback_01_F","O_MRAP_02_F","O_MRAP_02_gmg_F","O_MRAP_02_hmg_F","B_Quadbike_01_F","B_G_Quadbike_01_F","O_Quadbike_01_F","I_Quadbike_01_F","C_Quadbike_01_F","B_G_Offroad_01_armed_F","B_G_Offroad_01_F","C_Offroad_01_F"];};
		case "B_Heli_Attack_01_F" : {_array = ["Motorcycle","ReammoBox","B_Truck_01_transport_F","B_Truck_01_covered_F","I_Truck_02_covered_F","O_Truck_02_covered_F","I_Truck_02_transport_F","O_Truck_02_transport_F","I_MRAP_03_gmg_F","I_MRAP_03_F","I_MRAP_03_hmg_F","B_MRAP_01_hmg_F","B_MRAP_01_gmg_F","B_MRAP_01_F","C_Hatchback_01_sport_F","C_Hatchback_01_F","O_MRAP_02_F","O_MRAP_02_gmg_F","O_MRAP_02_hmg_F","B_Quadbike_01_F","B_G_Quadbike_01_F","O_Quadbike_01_F","I_Quadbike_01_F","C_Quadbike_01_F","B_G_Offroad_01_armed_F","B_G_Offroad_01_F","C_Offroad_01_F"];};
		case "O_Heli_Attack_02_F" : {_array = ["Motorcycle","ReammoBox","B_Truck_01_transport_F","B_Truck_01_covered_F","I_Truck_02_covered_F","O_Truck_02_covered_F","I_Truck_02_transport_F","O_Truck_02_transport_F","I_MRAP_03_gmg_F","I_MRAP_03_F","I_MRAP_03_hmg_F","B_MRAP_01_hmg_F","B_MRAP_01_gmg_F","B_MRAP_01_F","C_Hatchback_01_sport_F","C_Hatchback_01_F","O_MRAP_02_F","O_MRAP_02_gmg_F","O_MRAP_02_hmg_F","B_Quadbike_01_F","B_G_Quadbike_01_F","O_Quadbike_01_F","I_Quadbike_01_F","C_Quadbike_01_F","B_G_Offroad_01_armed_F","B_G_Offroad_01_F","C_Offroad_01_F"];};
		// To add a new chopper class: copy the previous line:
		// case "MH6J_EP1" : {_array = ["Motorcycle","ReammoBox"];};
		// modify the class in the "" -> "Mi17_Ins"
		// case "Mi17_Ins" : {_array = ["Motorcycle","ReammoBox"];};
		// modify the _array as u want like above
	};
	_array
};
*/