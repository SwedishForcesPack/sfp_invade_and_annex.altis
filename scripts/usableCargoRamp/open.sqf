// settings
_unit = _this select 1;
_id = _this select 2;
_heli = (_this select 3) select 0;

// open door
_unit removeAction _id;

_actionsToRemove = _heli getVariable "actionsToRemove";
		
{
	_unit removeAction _x;
} forEach _actionsToRemove;
		
_heli setVariable ["actionsToRemove", [], false];

// close
_action = "Close cargo ramp";
if (language == "French") then {_action = "Fermer la rampe";};
_action = format ["<t color='#ff1111'>%1</t>", _action];

_id = _unit addAction [_action, "scripts\usableCargoRamp\close.sqf", [_heli], 1.5, false];

_actionsToRemove = _heli getVariable "actionsToRemove";			//
[_actionsToRemove, _id] call BIS_fnc_arrayPush;					// add to actions to remove array
_heli setVariable ["actionsToRemove", _actionsToRemove, false];	//

// middle
_action = "Cargo ramp in middle position";
if (language == "French") then {_action = "Rampe en position mi-ouverte";};
_action = format ["<t color='#ff1111'>%1</t>", _action];

_id = _unit addAction [_action, "scripts\usableCargoRamp\middle.sqf", [_heli], 1.5, false];
			
_actionsToRemove = _heli getVariable "actionsToRemove";			//
[_actionsToRemove, _id] call BIS_fnc_arrayPush;					// add to actions to remove array
_heli setVariable ["actionsToRemove", _actionsToRemove, false];	//

// animation
_heli animate ["CargoRamp_Open", 1];

_sleep = 5 - ((_heli animationPhase "CargoRamp_Open") * 5);
sleep _sleep;

// door status
_heli setVariable ["doorStatus", "open", true];

// bordcast action to players in cargo
if ((_heli getVariable "doorStatus") == "open") then {
	[[[_heli], "scripts\usableCargoRamp\addCargoAction.sqf"], "BIS_fnc_execVM", true, false] spawn BIS_fnc_MP;
};