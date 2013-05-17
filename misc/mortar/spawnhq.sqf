if (isServer) then {
		_mortarbuilding = createVehicle ["Land_Cargo_HQ_V1_F", [4088.2217,4591.668], [], 0, "NONE"];
		_mortarbuilding enableSimulation false;
		_mortarbuilding setDir 280;
		_mortarbuilding setpos [ getPos _mortarbuilding select 0, getPos _mortarbuilding select 1, -0.3]; 
					}