while {true} do
{
	waitUntil {sleep 0.5; alive player};

	if (typeOf player == "B_medic_F") then
	{
		onEachFrame
		{
			{
				if (!isNil {_x getVariable "BTC_need_revive"}) then
				{
					if (_x getVariable "BTC_need_revive" == 1 && (player distance _x) < 500) then
					{
						drawIcon3D
						[
							"a3\ui_f\data\map\MapControl\hospital_ca.paa",
							[0,0.25,0.5,1],
							_x,
							1,
							1,
							0,
							format["%1 needs reviving (%2m)", name _x, ceil (player distance _x)],
							0
						];
					};
				};
			} forEach playableUnits;

			if (!alive player) then { onEachFrame {}; };
		};
	};
	waitUntil {sleep 0.5; !alive player};
};