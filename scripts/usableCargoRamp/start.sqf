/*  
	usableCargoRamp - v1.1 // Open and close the cargo ramp, get in and get out using cargo ramp. // Zigomarvin - www.easy-team.fr
	
	----------------------------------------------------------
	_null = [this] execVM "scripts\usableCargoRamp\start.sqf";
	----------------------------------------------------------
*/

// settings
_heli = _this select 0;

if (typeOf _heli != "I_Heli_Transport_02_F") exitWith {};

if !(isServer) then {
	_heli setVariable ["actionsToRemove", [], false]; // actions to remove
	_heli setVariable ["getInActionExist", 0, false]; // does "get in using cargo ramp" action exist
	_heli setVariable ["getOutActionExist", 0, false]; // does "get out using cargo ramp" action exist
	_heli setVariable ["getOutId", 0, false]; // id of the "get out using cargo ramp" action
	_heli setVariable ["getInId", 0, false]; // id of the "get in using cargo ramp" action
	_heli setVariable ["box", "", false]; // box
};

// define the box
_box = "";

if (isServer) then {
	sleep 1;
	_box = "Box_NATO_AmmoVeh_F" createVehicle getPos _heli;
	_box attachTo [_heli, [0, -3.8, -1.9]];
	_heli setVariable ["doorStatus", "closed", true];
} else {
	waitUntil {!isNull player};
	waitUntil {count (nearestObjects [_heli, ["Box_NATO_AmmoVeh_F"], 8]) != 0};
	_box = nearestObjects [_heli, ["Box_NATO_AmmoVeh_F"], 8];
	_box = _box select 0;
	
	_heli setVariable ["box", _box, false];
	
	_box setObjectTexture [0,""]; // hide box
	_box setObjectTexture [1,""]; // hide box
};

// actions
if !(isServer) then {
	// on get in
	_heli addEventHandler ["GetIn", {
		_heli = _this select 0;
		_pos = _this select 1;
		_unit = _this select 2;
		
		if (local _unit) then {
			_doorStatus = _heli getVariable "doorStatus";
			_box = _heli getVariable "box";
			
			// if get is as driver, else
			if (_pos == "Driver") then {
				_id = 0;
				
				// open
				if (_doorStatus != "open") then {
					_action = "Open cargo ramp";
					if (language == "French") then {_action = "Ouvrir la rampe";};
					_action = format ["<t color='#ff1111'>%1</t>", _action];
				
					_id = _unit addAction [_action, "scripts\usableCargoRamp\open.sqf", [_heli], 6.1, false];
					
					_actionsToRemove = _heli getVariable "actionsToRemove";			//
					[_actionsToRemove, _id] call BIS_fnc_arrayPush;					// add to actions to remove array
					_heli setVariable ["actionsToRemove", _actionsToRemove, false];	//
				};
				
				// close
				if (_doorStatus != "closed") then {
					_action = "Close cargo ramp";
					if (language == "French") then {_action = "Fermer la rampe";};
					_action = format ["<t color='#ff1111'>%1</t>", _action];
		
					_id = _unit addAction [_action, "scripts\usableCargoRamp\close.sqf", [_heli], 6.1, false];
					
					_actionsToRemove = _heli getVariable "actionsToRemove";			//
					[_actionsToRemove, _id] call BIS_fnc_arrayPush;					// add to actions to remove array
					_heli setVariable ["actionsToRemove", _actionsToRemove, false];	//
				};
				
				// middle
				if (_doorStatus != "middle") then {
					_action = "Cargo ramp in middle position";
					if (language == "French") then {_action = "Rampe en position mi-ouverte";};
					_action = format ["<t color='#ff1111'>%1</t>", _action];
				
					_id = _unit addAction [_action, "scripts\usableCargoRamp\middle.sqf", [_heli], 6.05, false];
					
					_actionsToRemove = _heli getVariable "actionsToRemove";			//
					[_actionsToRemove, _id] call BIS_fnc_arrayPush;					// add to actions to remove array
					_heli setVariable ["actionsToRemove", _actionsToRemove, false];	//
				};
			} else {
				// add "get out using cargo ramp" action
				if ((_pos != "Gunner") && (_doorStatus == "open")) then {
					_action = "Get out using cargo ramp";
					if (language == "French") then {_action = "Sortir par la rampe";};
					_action = format ["<t color='#ff1111'>%1</t>", _action];
						
					_id = _unit addAction [_action, "scripts\usableCargoRamp\getOut.sqf", [_heli], 6.15, false];
					_heli setVariable ["getOutId", _id, false];
					_heli setVariable ["getOutActionExist", 1, false];
					_box removeAction (_heli getVariable "getInId");
					_heli setVariable ["getInActionExist", 0, false];
	
					if  ((_heli emptyPositions "Cargo") == 0) then {
						[[[_heli], "scripts\usableCargoRamp\removeGetInActionOnly.sqf"], "BIS_fnc_execVM", true, false] spawn BIS_fnc_MP;
					};
					
				};
			};
		};	
	}];
	
	// on get out
	_heli addEventHandler ["GetOut", {
		_heli = _this select 0;
		_pos = _this select 1;
		_unit = _this select 2;
		
		if (local _unit) then {
			_box = _heli getVariable "box";
			
			// on get out, remove actions
			if (_pos == "Driver") then {
				_actionsToRemove = _heli getVariable "actionsToRemove";
				
				{
					_unit removeAction _x;
				} forEach _actionsToRemove;
				
				_heli setVariable ["actionsToRemove", [], false];
			} else {
				if (_pos != "Gunner") then {
					_unit removeAction (_heli getVariable "getOutId");
				};
			};
			
			// add actions to get in
			if (((_heli getVariable "doorStatus") == "open") && ((_heli emptyPositions "Cargo") != 0)) then {
				if ((_heli getVariable "getInActionExist") == 0) then {
					_action = "Get in CH-49 Mohawk - cargo ramp";
					if (language == "French") then {_action = "Grimper dans CH-49 Mohawk - par la rampe";};
					_action = format ["<t color='#ff1111'>%1</t>", _action];
					
					_id = _box addAction [_action, "scripts\usableCargoRamp\getIn.sqf", [_heli], 6, false, true, "", "_target distance _this < 4"];
					_heli setVariable ["getInId", _id, false];
					_heli setVariable ["getInActionExist", 1, false];
				
					if  ((_heli emptyPositions "Cargo") == 1) then {
						[[[_heli], "scripts\usableCargoRamp\addCargoAction.sqf"], "BIS_fnc_execVM", true, false] spawn BIS_fnc_MP;
					};
				};
			};
		};
	}];
	
	// on join, create action if door is open
	if (((_heli getVariable "doorStatus") == "open") && ((_heli emptyPositions "Cargo") != 0)) then {  // && vehicle player == player
		_action = "Get in CH-49 Mohawk - cargo ramp";
		if (language == "French") then {_action = "Grimper dans CH-49 Mohawk - par la rampe";};
		_action = format ["<t color='#ff1111'>%1</t>", _action];
		
		_id = _box addAction [_action, "scripts\usableCargoRamp\getIn.sqf", [_heli], 6, true, true, "", "_target distance _this < 4"];
		_heli setVariable ["getInId", _id, false];
		_heli setVariable ["getInActionExist", 1, false];
	};
};

waitUntil{sleep 60; !(alive _heli)};

deleteVehicle _box;