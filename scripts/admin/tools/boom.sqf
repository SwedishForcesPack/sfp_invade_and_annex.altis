titleText ["Admin Nuke Initiated","PLAIN DOWN"]; titleFadeOut 4;
_x = _this;
{if(_x != player) then { _x setdamage 1};} foreach nearestobjects [getPosATL player,["allvehicles"],600]; sleep 5; {if(_x != player) then { _x setdamage 1};} foreach nearestobjects [getPosATL player,["man"],1000];
deleteVehicle radioTower;
radioTowerAlive = false;
publicVariable "radioTowerAlive";

