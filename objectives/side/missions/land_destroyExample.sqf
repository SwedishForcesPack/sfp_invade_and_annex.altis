/***********************************************
|
|	TITLE: Destroy the Example
|	LOCATION: objectives/side/missions/land_destroyExample.sqf
|	AUTHOR: Rarek [AW]
|	
|
|	DESCRIPTION
|		|
|		|	These files give the SM template the vars
|		|	it needs to successfully create a Side
|		|	Mission.
|		|
|		└---------------------------------------
|
|
|	GUIDELINES
|		|
|		|	Side Missions are designed to be
|		|	non-critical targets often protected by
|		|	the same types of units as normal AOs
|		|	but requiring certain skillsets /
|		| 	classes.
|		|
|		|	They are encouraged to provide players
|		|	with a different approach to the 
|		|	normal "travel to > kill > win" gametype
|		|	and instead give a challenge that must
|		|	be dealt with carefully and strategically.
|		|	It is for this reason that players are
|		|	given rewards upon the completion of
|		|	a Side Mission.
|		|
|		|	Side Missions should not be based on
|		|	timers in any way. They should be able
|		|	to be left for an indefinite amount
|		|	of time and still completed.
|		|
|		└---------------------------------------
|
|
|	ENEMY GROUP CLASSNAMES
|		|
|		|	- x
|		|	- y
|		|	- z
|		|
|		└---------------------------------------
|
***********************************************/

_title = "Destroy Chopper";
_briefObj = "Destroy the enemy's prototype chopper";

/* Explain ALL vars in this */
_posConditions = [[[getMarkerPos currentAO, 20],_dt],["water","out"]] call BIS_fnc_randomPos;

_enemies =
[
	/*
		In here, you can give a list of enemies
		you'd like to spawn at the Side Mission.

		Currently, we're only going to allow
		the spawning of groups to simplify
		the process.

		Each entry is an array in the following
		format:

			[
				"GroupClassNameInCfgGroups",
				2, //how many groups to spawn
				[
					"patrol", //what should the group do? Either "patrol" or "defend"
					[
						200, //radius from SM group can spawn
						50 //distance between patrolling waypoints; not needed if set to "defend"
					]
				]
			]

			Example:
				["GroupClassNameInCfgGroups", 2, ["patrol", [200, 50]]],
				["ADifferentGroupHere", 1, ["defend", [100]]]

		There are already some examples placed
		below. Feel free to replace them with whatever
		you would like.
	*/	

	["GroupClassNameInCfgGroups", 2, ["patrol", [200, 50]]],
	["ADifferentGroupHere", 1, ["defend", [100]]]
];

_SM_Create =
{
	/*
		Here we give you more-or-less free reign
		over what's spawned in the Side Mission.
		
		As a matter of necessity, however, it is
		OF GREAT IMPORTANCE that you add ANY
		object/group/entity spawned to the
		and return it at the end of this function.

		An example is below. Failure to do this will
		result in your Side Mission being rejected.
	*/
		private ["_pos"];
		_pos = _this select 0;
	/*
		The above line is what this script is passed;
		a position found based on the conditions
		you supplied above.

		Use this to place units.
	*/

	_hangar = "O_hangar_F" createVehicle _pos;
	_objectsArray = _objectsArray + [_hangar];

	_objectsArray
}

_SM_Success =
{
	/*
		This is quite simply a list of IF statements
		that return whether or not the Side Mission
		has been successfully completed.
	*/
		private ["sideObjs"];
		_sideObjs = _this select 0;
	/*
		The above line is what this script is passed;
		the _sideObjs array that you added all crucial
		objects to earlier.

		Remember, we return TRUE if we've completed the
		mission and FALSE if we haven't.
	*/

	_hasSucceeded = true;
	{
		if (alive _x) then { _hasSucceeded = false; };
	} forEach _sideObjs;

	_hasSucceeded

	/* OR AN ALTERNATIVE EXAMPLE FOR A MINE FIELD */

	_hasSucceeded = true;
	{
		if (mineActive _x) then { _hasSucceeded = true; };
	} forEach _sideObjs;

	_hasSucceeded
}

_SM_Failure
{
	/*
		This, as you've probably guessed, are the conditions
		for failing a Side Mission. If you'd like to make it
		impossible to fail the Side Mission, just put the
		following in this function:

			false

		For now, let's use our mine field example.
		Remember, we return TRUE if we've failed the mission
		and FALSE if we haven't.
	*/

	/* If more than 5 mines have blown up, fail the mission */
	_counter = 0;
	if (!alive _x) then { _counter++; };
	if (_counter > 5) then { true } else { false };
}