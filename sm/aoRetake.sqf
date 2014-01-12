sleep 5;

	if(random 1 >= 0.2) then   //chance AI will re-attack
	{
	_defendMessages =
	[
		"OPFOR Forces incoming! Seek cover immediately and defend the target!"
	];

	_targetStartText = format
	[
		"<t align='center' size='2.2'>Defend Target</t><br/><t size='1.5' align='center' color='#0d4e8f'>%1</t><br/>____________________<br/>We got a problem. The enemy managed to call in land reinforcements. They are on the way to take back the last target. You need to defend it at all costs!<br/><br/>If the last man of BluFor dies in the target area the enemy have won.<br/><br/>Forces are expected to be there in a couple minutes, hurry up and dig in!",
		currentAO
	];

	GlobalHint = _targetStartText; publicVariable "GlobalHint"; hint parseText GlobalHint;
	showNotification = ["NewMainDefend", currentAO]; publicVariable "showNotification";

	{_x setMarkerPos (getMarkerPos currentAO);} forEach ["aoCircle_2","aoCircle_3","aoMarker_2"];
	"aoMarker_2" setMarkerText format["Defend %1",currentAO];

	sleep 10; // give ao complete hint some time to be read
	publicVariable "refreshMarkers";
	publicVariable "currentAO";
	currentAOUp = true;
	publicVariable "currentAOUp";
	radioTowerAlive = false;
	publicVariable "radioTowerAlive";

	//check for online players
	players_online = West countSide allunits;
	publicVariable "players_online";

	_playersOnline = format
	[
		"Target: %1! Get ready boys - They are almost there! - UAVs available.", currentAO
	];

	_playersOnlineHint = format
	[
		"<t size='1.5' align='left' color='#C92626'>Target:%1!</t><br/><br/>____________________<br/>Get ready boys they are almost there! - UAVs available.", currentAO
	];

	_defendTimer = (500 + (random 300));
	hqSideChat = _playersOnline; publicVariable "hqSideChat"; [WEST,"HQ"] sideChat hqSideChat;
	GlobalHint = _playersOnlineHint; publicVariable "GlobalHint"; hint parseText GlobalHint;

	sleep 10; // time before they spawn

	hqSideChat = _defendMessages call BIS_fnc_selectRandom; publicVariable "hqSideChat"; [WEST,"HQ"] sideChat hqSideChat;

	null = [["aoCircle_2"],[12,2],[0,0],[1,2],[2,3],[0,0,25,EAST]] call Bastion_Spawn;
	hint "Thermal images show enemy are at the perimeter of the AO!";

	sleep 20; //time before next wave
	hint "sleeping for 20 then spawning second wave";

	null = [["aoCircle_3"],[15,2],[0,0],[0,0],[0,0],[0,0,25,EAST]] call Bastion_Spawn;
	hint "There are more then we expected!";

			// countdown timer
			[[hint "Enemy Spotted. Standby..."],"BIS_fnc_spawn",nil,true] spawn BIS_fnc_MP;
			sleep 0.5;
			while {true} do {
			//hintsilent format ["Assualt will end in :%1", [((_defendTimer)/60)+.01,"HH:MM"] call bis_fnc_timetostring];
			_targetStartText2 = format ["Assualt will end in: %1", [((_defendTimer)/60)+.01,"HH:MM"] call bis_fnc_timetostring];
			GlobalHint = _targetStartText2; publicVariable "GlobalHint"; hint parseText GlobalHint;
			if (_defendTimer < 1) exitWith{};
			_defendTimer = _defendTimer -1;
			sleep 1;
			};

	[["aoCircle_2"]] call EOS_deactivate;
	sleep 1;
	[["aoCircle_3"]] call EOS_deactivate;
	};

