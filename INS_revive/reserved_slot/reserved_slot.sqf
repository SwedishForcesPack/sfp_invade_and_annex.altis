private ["_isAdmin","_admin"];

_isAdmin = false;
sleep 1;

if (isServer) exitWith {};

{
	if (str(player) == _x) exitWith {
		_isAdmin = true;
	};
} forEach INS_REV_CFG_reserved_slot_units;

if (!_isAdmin) exitWith {};

if (serverCommandAvailable "#kick") exitWith {
	hint format ["Welcome %1!\nYou logged in as admin", name player];
	titleText [format["Welcome %1! You logged in as admin", name player],"PLAIN"];
};

for "_i" from 1 to 600 do {
	player execVM "scripts\lockplayer.sqf";
	hint "Attention!\nThis is a reserved admin slot.\nIf you are an admin on this server log in now, otherwise you'll just stare at this black screen!";
	titleText ["Attention! This is a reserved admin slot.\n\nIf you are an admin on this server log in now, otherwise you'll just stare at this black screen!","BLACK FADED"];
	sleep 10;
if (serverCommandAvailable "#kick") exitWith {
	hint format ["Welcome %1!\nYou logged in as admin, no kick", name player];
	titleText [format["Welcome %1! You logged in as admin, no kick", name player],"PLAIN"];
};
};


