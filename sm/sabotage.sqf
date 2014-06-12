private ["_obj","_caller","_id","_params","_FerDelay","_OtherObj","_PubVar"];

_obj = _this select 0;               // E.g. ActionBarrel
_caller = _this select 1;            // E.g. Player
_id = _this select 2;                // ID of action
_params = _this select 3;            // Params passed to this script.

_OtherObj = sideObj;        // Dummy object to replace this object (object)

_OtherObj setPos (getPos _obj);                                    //Replace object with dummy (so if player JIPs, they don't get to fire the event again; also prevents action from being called mulitple times whilst the wait is running)
sideObj setVectorUp [0,0,1];
_obj setPos [-200,-200];                                           //Move object to nether regions
sleep 1;
_timeleft = 45;

[[hint "Charge placed on Objective. Standby..."],"BIS_fnc_spawn",nil,true] spawn BIS_fnc_MP;
sleep 0.5;
while {true} do {
hintsilent format ["Charge Explode in :%1", [((_timeleft)/60)+.01,"HH:MM"] call bis_fnc_timetostring];
if (_timeleft < 1) exitWith{};
  _timeleft = _timeleft -1;
sleep 1;
};
"Bo_GBU12_LGB" createvehicle getpos _OtherObj;
{_x setdamage 1} foreach crew _OtherObj + [_OtherObj];

