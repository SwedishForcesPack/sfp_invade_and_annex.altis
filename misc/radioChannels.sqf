if (!isServer) then
{
	while {true} do
	{
		waitUntil {alive player};
		{ _x radioChannelAdd [player]; } forEach radioChannels;
		waitUntil {!alive player};
	};
} else {
	_mainIndex = radioChannelCreate [
		[1.0, 0.81, 0.06, 1],
		"Main AO Channel",
		"[MAIN] %UNIT_GRP_NAME %UNIT_NAME [%UNIT_VEH_NAME]",
		[player]
	];

	_sideIndex = radioChannelCreate [
		[0, 0.7, 0.93, 1],
		"Side Mission Channel",
		"[SIDE] %UNIT_GRP_NAME %UNIT_NAME [%UNIT_VEH_NAME]",
		[player]
	];

	_transportIndex = radioChannelCreate [
		[0.38, 0.81, 0.16, 1],
		"Transport Channel",
		"[TRANSPORT] %UNIT_GRP_NAME %UNIT_NAME [%UNIT_VEH_NAME]",
		[player]
	];

	_generalIndex = radioChannelCreate [
		[0.8, 0.8, 0.8, 1],
		"General Conversation",
		"%UNIT_NAME",
		[player]
	];

	radioChannels = [_mainIndex, _sideIndex, _transportIndex, _generalIndex];
	publicVariable "radioChannels";
};

/*
	Make sure players are added to this
	channel upon entering the game.

	TODO:
		-	Find a good way to be able to
			subscribe/unsubscribe to/from
			channels. Dialog would be perfect.
*/
