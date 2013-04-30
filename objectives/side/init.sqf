/***********************************************
|
|	TITLE: Side Mission Template
|	LOCATION: objectives/side/init.sqf
|	AUTHOR: Rarek [AW]
|	
|	DESCRIPTION
|		|	Initialises a Side Mission using this
|		|	template coupled with a "content" file
|		|	which is randomly selected from a folder.
|		└---------------------------------------
|
***********************************************/

private ["_sideObjs", "_sideMissions", "_missionDetails", "_spawnedObjects", "_title", "_briefObj", "_posConditions"];

/***********************************************
|
|	You should only edit this part of the template
|	to include more Side Missions in I&A.
|
|	Editing any other part of this file may result
|	in your mission breaking.
*/
	_sideMissions = 
	[
		"land_destroyChopper",
		"land_destroyRadar",
		"land_destroyAntannae",
		"land_destroySmuggledExplosives",
		"land_disarmMines",
		"sea_disarmMines",
		"sea_recoverIntel"
	];
/*
|
|	It should be of note that you can name these
|	missions anything you like, so long as files
|	with identical names are placed in the relative
|	missions/ folder.
|
***********************************************/

_sideObjs = []; publicVariable "sideObjs";
call compile preProcessFileLineNumbers format["objectives/side/missions/%1.sqf", _sideMissions select (random ((count _sideMissions) - 1))];

