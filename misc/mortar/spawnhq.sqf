if (isServer) then {
		_mortarbuilding = createVehicle ["Land_Cargo_HQ_V1_F", [1,1], [], 0, "NONE"];
		_mortarbuilding enableSimulation false;
		_mortarPos = getMarkerPos "MortarHQ";
		_mortarbuilding setpos [_mortarPos select 0, _mortarPos select 1, -0.3 ]; 
		_mortarbuilding allowDamage false;
		_mortarbuilding setDir 100;
					}