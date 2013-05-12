/* 
	Custom radio channels to come...

	Add the following to the description.ext
	to remove certain channels:

		disableChannels[] = {0, 1, 2};

	This removes the Global, Side and
	Command channels. Players still have
	Group, Vehicle and Direct channels.
*/

/*
	Add the following when we can restict the
	channels to only admins talking i.e.
	everyone can listen, but only admins
	can talk.

		_adminIndex = radioChannelCreate [
			[0.81, 0.13, 0.14],
			"Admin Channel",
			"%UNIT_NAME",
			[]
		];
*/

if (!isServer) then
{
	{ _x radioChannelAdd [player]; } forEach radioChannels;
} else {
	_mainIndex = radioChannelCreate [
		[1.0, 0.81, 0.06],
		"Main AO Channel",
		"%UNIT_NAME",
		[player]
	];

	_sideIndex = radioChannelCreate [
		[0, 0.7, 0.93],
		"Side Mission Channel",
		"%UNIT_NAME",
		[player]
	];

	_transportIndex = radioChannelCreate [
		[0.38, 0.81, 0.16],
		"Transport Channel",
		"%UNIT_NAME",
		[player]
	];

	radioChannels = [_mainIndex, _sideIndex, _transportIndex];
	publicVariable "radioChannels";
};

/*
	Make sure players are added to this
	channel upon entering the game.

	TODO:
		-	Figure out if channels must be
			re-added after a unit's death
		-	Find a good way to be able to
			subscribe/unsubscribe to/from
			channels. Dialog would be perfect.
*/
