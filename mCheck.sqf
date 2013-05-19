_man = _this select 2;
_V = vehicle _man
if(_man == mortarMan) then {TRUE} else { _V vehicleChat "You need to be the Mortar Gunner to fire the mortars."; _man action ["eject", _V]; };