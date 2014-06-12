private ["_obj", "_caller", "_id", "_loadout"];

_obj = _this select 0; //the object that had the action
_caller = _this select 1; //unit that called the action
_id = _this select 2; //id of the action

// Saves loadout of player into var loadout
_loadout = [_caller] call INS_REV_FNCT_get_loadout;

INS_REV_GVAR_player_loadout = _loadout;
