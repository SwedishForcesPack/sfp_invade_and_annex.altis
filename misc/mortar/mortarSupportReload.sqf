_mortar = mortarSupport;
_mortarPos = getPos _mortar;
_gunner = gunner _mortar;
_reloadTime = 30;			// 1800 = 30 minutes
sleep 10;
while { true } do
{
	if (name _gunner == name player) then {hint format ["Removing Magazines"];};
	_mortar removemagazines "8Rnd_82mm_Mo_Shells";
	_mortar removemagazines "8Rnd_82mm_Mo_Smoke_white";
	_mortar removemagazines "8Rnd_82mm_Mo_Flare_white";
	sleep 5;
	if (name _gunner == name player) then {hint format ["Adding Magazines"];};
	_mortar addmagazines ["8Rnd_82mm_Mo_Smoke_white",2];
	_mortar addmagazines ["8Rnd_82mm_Mo_Flare_white",4];
	sleep 5;
	if (name _gunner == name player) then {hint format ["Support Mortar Reloaded!"];};
	sleep _reloadTime / 5;
	if (name _gunner == name player) then {hint format ["reloading Support in 20 minutes"];};
	sleep _reloadTime / 5;
	if (name _gunner == name player) then {hint format ["reloading Support in 15 minutes"];};
	sleep _reloadTime / 5;
	if (name _gunner == name player) then {hint format ["reloading Support in 10 minutes"];};
	sleep _reloadTime / 5;
	if (name _gunner == name player) then {hint format ["reloading Support in 5 minutes"];};
	sleep _reloadTime / 5;
};
