waitUntil {sleep 0.5; !(isNil "currentAOUp")};
waitUntil {sleep 0.5; !(isNil "currentAO")};
private ["_priorityMessageHelo"];

while {true} do {
	sleep 3;
    if ((!radioTowerAlive) && (currentAOUp)) then {
			_dropPos=getMarkerPos "PD_Drop";
			aoDropObject1 setPos _dropPos;
	    } else {aoDropObject1 setPos [0,0,0]};
	    sleep 10;
};
