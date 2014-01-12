wildcat = _this select 0;
wildcat addEventHandler ["dammaged", {hint "fired"; wildcat setHit ["main rotor", 0.2];}];};