// settings
_unit = _this select 1;
_id = _this select 2;
_heli = (_this select 3) select 0;

// close door
_unit removeAction _id;

_actionsToRemove = _heli getVariable "actionsToRemove";
		
{
	_unit removeAction _x;
} forEach _actionsToRemove;
		
_heli setVariable ["actionsToRemove", [], false];

// open
_action = "Open cargo ramp";
if (language == "French") then {_action = "Ouvrir la rampe";};
_action = format ["<t color='#ff1111'>%1</t>", _action];

_id = _unit addAction [_action, "scripts\usableCargoRamp\open.sqf", [_heli], 6.1, false];

_actionsToRemove = _heli getVariable "actionsToRemove";			//
[_actionsToRemove, _id] call BIS_fnc_arrayPush;					// add to actions to remove array
_heli setVariable ["actionsToRemove", _actionsToRemove, false];	//

// middle
_action = "Cargo ramp in middle position";
if (language == "French") then {_action = "Rampe en position milieu";};
_action = format ["<t color='#ff1111'>%1</t>", _action];

_id = _unit addAction [_action, "scripts\usableCargoRamp\middle.sqf", [_heli], 6.05, false];
			
_actionsToRemove = _heli getVariable "actionsToRemove";			//
[_actionsToRemove, _id] call BIS_fnc_arrayPush;					// add to actions to remove array
_heli setVariable ["actionsToRemove", _actionsToRemove, false];	//

// bordcast action to players in cargo
[[[_heli], "scripts\usableCargoRamp\removeCargoAction.sqf"], "BIS_fnc_execVM", true, false] spawn BIS_fnc_MP;

// door status
_heli setVariable ["doorStatus", "closed", true];

// animation
_heli animate ["CargoRamp_Open", 0];