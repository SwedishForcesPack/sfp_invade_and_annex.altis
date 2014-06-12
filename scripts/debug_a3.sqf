FHQ_DebugConsole_InitHint = {
	FHQ_DebugConsole_Dynamic = [];
	FHQ_DebugConsole_Header = ""; 
	FHQ_DebugConsole_Text = "";
};

FHQ_DebugConsole_ShowHint = {
    FHQ_DebugConsole_HintHandle = [] spawn {
    	
        while {true} do {
        	waitUntil {
                _params = [];
                {
                    _params = _params + [call _x];
                } foreach FHQ_DebugConsole_Dynamic;
                _text = parseText format (["<t align=""left"">" + FHQ_DebugConsole_Text + "<t>"] + _params);
                
                hintSilent _text;
                true;
            };
        };
    };
};

FHQ_DebugConsole_TerminateHint = {
    hintSilent "";
    terminate FHQ_DebugConsole_HintHandle;
};

FHQ_DebugConsole_TypeForGroup = {
    private ["_type", "_grp", "_vehicle", "_list", "_cars", "_apcs", "_tanks", "_helos", "_uavs", "_planes", "_arties", "_mortars", "_supports"];

	_grp = _this;
	_list = [];
	_cars = 0;
    _apcs = 0;
    _tanks = 0;
    _helos = 0;
    _uavs = 0;
    _planes = 0;
    _arties = 0;
    _mortars = 0;
    _supports_fuel = 0;
    _supports_repair = 0;
    _supports_meds = 0;
    
    {
     	if (alive vehicle _x && !(vehicle _x in _list)) then {
            _vehicle = vehicle _x;
            _list = _list + [_vehicle];
            
            if (_vehicle isKindOf "car" || _vehicle isKindOf "wheeled_apc") then { _cars = _cars + 1; };
            if (_vehicle isKindOf "tracked_apc") then { _apcs = _apcs + 1; };
            if (_vehicle isKindOf "tank") then { _tanks = _tanks + 1; };
            if (_vehicle isKindOf "helicopter") then { _helos = _helos + 1; };
            if (_vehicle isKindOf "UAV") then { _uavs = _uavs + 1; };
            if (_vehicle isKindOf "plane") then { _planes = _planes + 1; };
            if (_vehicle isKindOf "staticcanon") then { _arties = _arties + 1; };
            if (_vehicle isKindOf "staticmortar") then { _mortars = _mortars + 1; };
            if (getNumber (configFile >> "cfgVehicles" >> typeof _vehicle >> "transportAmmo") > 0)
            			then { _supports_fuel = _supports_fuel + 1; };
            if (getNumber (configFile >> "cfgVehicles" >> typeof _vehicle >> "transportFuel") > 0)
             			then { _supports_fuel = _supports_fuel + 1; };
            if (getNumber (configFile >> "cfgVehicles" >> typeof _vehicle >> "transportRepair") > 0)
            			then { _supports_repair = _supports_repair + 1; };
            if (getnumber (configfile >> "cfgvehicles" >> typeof _vehicle >> "attendant") > 0)
            			then {_supports_meds = _supports_meds + 1; };
		};
            
    } forEach (units _grp);
    
    _type = "_inf";
    if (_cars > 0) then { _type = "_motor_inf"; };
    if (_tanks > 0) then { _type = "_armor"; };
    if (_apcs > 0) then { _type = "_mech_inf"; };
    if (_helos > 0) then { _type = "_air"; };
    if (_uavs > 0) then { _type = "_uav"; };
    if (_planes > 0) then { _type = "_plane"; };
    if (_arties > 0) then { _type = "_art"; };
    if (_mortars > 0) then { _type = "_mortar"; };
    if (_supports_repair > 0) then { _type = "_maint"; };
    if (_supports_meds > 0) then { _type = "_med"; };
    if (_supports_fuel > 0) then { _type = "_support"; };
    if ((_supports_repair + _supports_meds + _supports_fuel) > 1) then { _type = "_support"; };
    
    _type;
};

FHQ_DebugConsole_IconForGroup = {
   	private ["_type", "_grp", "_vehicle", "_side"];
    
    _grp = _this;
    _side = "n";
    _type = _grp call FHQ_DebugConsole_TypeForGroup;
    
	if (side _grp == west) then { _side = "b"; };
    if (side _grp == east) then { _side = "o"; };
    
    
    _ret = [_side + _type, [0, 0]];

    _ret;
};

FHQ_DebugConsole_ParamsForGroup = {
    private ["_color", "_grp"];
 
    _grp = _this;  
     
    _color = [1, 1, 0, 1];
    switch (side _grp) do {
        case west: {_color = [0, 0, 1, 1]; };
        case east: {_color = [1, 0, 0, 1]; };
        case resistance: {_color = [0, 1, 0, 1]; };
    };
    
    _ret = [_color, str _x, 1, true];
    
	_ret;    
};

FHQ_DebugConsole_ParamsForSize = {
    private ["_size", "_grp", "_offy", "_id"];
    
    _grp = _this select 0;
    _id = _this select 1;
    _size = 0;
    _offy = 0.1;    
    _type = _grp call FHQ_DebugConsole_TypeForGroup;
    
    
    if (_type in ["_inf", "_motor_inf", "_mech_inf", "_mortar"]) then {
        private ["_count"];
        
        _count = {alive _x} count (units _grp);
        
        if (_count >= 4) then {_size = 1;};
		if (_count >= 12) then {_size = 2;};
        if (_count >= 25) then {_size = 3;};
        if (_count >= 60) then {_size = 4;};
        if (_count >= 300) then {_size = 5;};
        if (_count >= 1000) then {_size = 6;};        
	};
    
    if (_type in ["_armor", "_art", "_support", "_maint", "_med"]) then {
        private ["_count"];
        
        _count = {_x == effectiveCommander (vehicle _x) && alive _x} count (units _grp);
        
        _size = 1;
        if (_count >= 2) then {_size = 2;};
        if (_count >= 4) then {_size = 3;};
        if (_count >= 12) then {_size = 4;};
        if (_count >= 100) then {_size = 5;};
    };
    
    if (_type in ["_air", "_plane", "_uav"]) then {
        private ["_count"];
        
        _count = {_x == effectiveCommander (vehicle _x) && alive _x} count (units _grp);
        
        _size = 2;
        if (_count >= 4) then {_size = 3;};
        if (_count >= 5) then {_size = 4;};
    };
  
	if (side _grp == east) then {_offy = 0.2;};
    if (side _grp == west) then {_offy = 0;};   

    _ret = [_id, format ["Group_%1", _size], [0, _offy]];
    
    _ret;
};
    

FHQ_DebugConsole_UpdateGroupIcons = {
    private "_x";
    
    {
        if (_x getVariable ["FHQ_DebugConsole_GrpIconID", -1] == -1) then {
            private ["_id", "_id2"];
            
            _id = _x addGroupIcon (_x call FHQ_DebugConsole_IconForGroup);
            _x setGroupIconParams (_x call FHQ_DebugConsole_ParamsForGroup);
			_id2 = _x addGroupIcon ["flag"];
			_x setGroupIcon ([_x, _id2] call FHQ_DebugConsole_ParamsForSize);
            
            _x setVariable ["FHQ_DebugConsole_GrpIconID", _id];
        };
    } forEach allGroups;
};

FHQ_DebugConsole_GetColor = {
	_red 	= (profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843]) * 255;
	_green 	= (profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019]) * 255;
	_blue 	= (profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862]) * 255;

	_hex = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'];

	_colortag = format ["<t color='#%1%2%3%4%5%6'>", _hex select (_red / 16), _hex select (_red % 16),
									 _hex select (_green / 16), _hex select (_green % 16),
									 _hex select (_blue / 16), _hex select (_blue % 16)];

	_colortag;
};

FHQ_DebugConsole_ProgressBar = {
    _level = _this * 30;
    _max = 30;
    
    _bar = "|";
    _res = call FHQ_DebugConsole_GetColor;
    
    
    for "_i" from 1 to _level do {
        _res = _res + _bar;
    };
    _res = _res + "</t>";
    
    if (_level <= _max) then {
        _res = _res + "<t color='#000000'>";
	   	for "_i" from _level+1 to _max do {
        	_res = _res + _bar;
    	};
        _res = _res + "</t>";
    };
    
    _res;
};

FHQ_DebugConsole_OnGroupIconEnter = {
    private ["_grp", "_text", "_res"];

    _grp = _this select 1;
    _type = _grp call FHQ_DebugConsole_TypeForGroup;
    FHQ_DebugConsole_Group = str _grp;
    FHQ_DebugConsole_Side = "";
    FHQ_DebugConsole_Faction = "Civilian";
    FHQ_DebugConsole_CombatMode = "";
    FHQ_DebugConsole_Behaviour = "";
    
    _damage = 0;
    {_damage = _damage + (1-0 - damage _x)} forEach (units _grp);
    FHQ_DebugConsole_Strength = _damage / (count (units _grp));
   
   	_units = 0;
    _vehicles = [];
    {
        if (_x isKindOf "Man") then {_units = _units + 1;};
        if (!((vehicle _x) in _vehicles) && ((vehicle _x) != _x)) then {_vehicles = _vehicles + [vehicle _x];};
    } forEach units _grp;
    
    FHQ_DebugConsole_Units = _units;
    FHQ_DebugConsole_Vehicles = count _vehicles;
    
    switch (side _grp) do
    {
        case west: { FHQ_DebugConsole_Side = "West"; };
        case east: { FHQ_DebugConsole_Side ="East"; };
        case resistance: { FHQ_DebugConsole_Side = "Independant"; };
        default { FHQ_DebugConsole_Side = "Civilian"; };
    };
    
    switch (toUpper (faction (leader _grp))) do
    {
        case "BLU_F": { FHQ_DebugConsole_Faction = "NATO"; };
        case "BLU_G_F": { FHQ_DebugConsole_Faction = "FIA"; };
        case "IND_F": { FHQ_DebugConsole_Faction = "AAF"; };
        case "CIV_F": { FHQ_DebugConsole_Faction = "Civilian (Altis)"; };
        case "OPF_F": { FHQ_DebugConsole_Faction = "CSAT"; };
        case "USMC": { FHQ_DebugConsole_Faction = "United States Marine Corps"; };
        case "CDF": { FHQ_DebugConsole_Faction =  "Chernarussian Defense Force"; };
        case "RU": { FHQ_DebugConsole_Faction = "Army of the Russian Federation"; };
        case "INS": { FHQ_DebugConsole_Faction = "Chernarus Red Star Movement"; };
        case "GUE": { FHQ_DebugConsole_Faction = "National Party (NAPA)"; };
        case "BIS_US": { FHQ_DebugConsole_Faction = "United States Army"; };
        case "BIS_CZ": { FHQ_DebugConsole_Faction = "Army of the Czech Republic"; };
        case "BIS_GER": { FHQ_DebugConsole_Faction = "German Army"; };
        case "BIS_TK": { FHQ_DebugConsole_Faction = "Takistani Army"; };
        case "BIS_TK_INS": { FHQ_DebugConsole_Faction = "Takistani Republican Militia";};
        case "BIS_TK_GUE": { FHQ_DebugConsole_Faction = "Takistani Guerillias"; };
        case "BIS_UN": { FHQ_DebugConsole_Faction = "United Nations Peacekpeeer"; };
        case "BIS_BAF": { FHQ_DebugConsole_Faction = "British Armed Forces"; };
        case "PMC_BAF": { FHQ_DebugConsole_Faction = "Private Military Contractors"; };
        case "CIV": { FHQ_DebugConsole_Faction = "Civilian (Chernarus)"; };
        case "CIV_RU": { FHQ_DebugConsole_Faction = "Civilian (Russia)"; };
        case "BIS_TK_CIV": { FHQ_DebugConsole_Faction = "Civilian (Takistan)"; };
        case "BIS_CIV_SPECIAL": { FHQ_DebugConsole_Faction =" Civilian"; };
        /* ACE */
        case "ACE_USNAVY": { FHQ_DebugConsole_Faction = "United States Navy"; };
        case "ACE_USAF": { FHQ_DebugConsole_Faction = "United States Air Force"; };
        case "ACE_VDV": {  FHQ_DebugConsole_Faction = "Russian Airborne Troops"; };
        /* CWR2 */
        case "CWR2_US": { FHQ_DebugConsole_Faction = "United States Army"; };
        case "CWR2_RU": { FHQ_DebugConsole_Faction = "Army of the Soviet Union"; };
        case "CWR2_NL": { FHQ_DebugConsole_Faction = "Dutch Army"; };
        case "CWR2_UK": { FHQ_DebugConsole_Faction = "British Armed Forces"; };
        case "CWR2_FIA": { FHQ_DebugConsole_Faction = "Resistance;" };
        case "CWR2_CIV": { FHQ_DebugConsole_Faction = "Civilian"; };
        /* I44 */
        case "I44_A_AAF": { FHQ_DebugConsole_Faction = "United States Air Force"; };
        case "I44_A_ARMY": { FHQ_DebugConsole_Faction = "United States Army"; };
        case "I44_A_ARMY_WINTER": { FHQ_DebugConsole_Faction = "United States Army"; };
        case "I44_B_ARMY": {  FHQ_DebugConsole_Faction = "British Army"; };
        case "I44_B_ARMY_WINTER": {  FHQ_DebugConsole_Faction = "British Army"; };
        case "I44_B_RAF": { FHQ_DebugConsole_Faction = "Royal Air Force"; };
        case "I44_B_RN" : { FHQ_DebugConsole_Faction = "Royal Navy"; };
        case "I44_C_F": { FHQ_DebugConsole_Faction = "Civilian (French)"; };
        case "I44_G_SS": { FHQ_DebugConsole_Faction = "Deutsche Waffen SS"; };
        case "I44_G_SS_WINTER": { FHQ_DebugConsole_Faction = "Deutsche Waffen SS"; };
        case "I44_G_WH": { FHQ_DebugConsole_Faction = "Deutsches Heer"; };
        case "I44_G_WH_WINTER": { FHQ_DebugConsole_Faction = "Deutsches Heer"; };
        case "I44_G_WL": { FHQ_DebugConsole_Faction = "Deutsche Luftwaffe"; };
        case "I44_G_WH": { FHQ_DebugConsole_Faction = "Deutsche Kriegsmarine"; };
        case "I44_LUFTWAFFE": { FHQ_DebugConsole_Faction = "Deutsche Luftwaffe"; };
        case "I44_R_F": { FHQ_DebugConsole_Faction = "Resistance (France)"; };
        /* Icebreaker */
        case "CIV_AFR": { FHQ_DebugConsole_Faction = "Civilian (Duala)"; };
        case "CIV_LGR": { FHQ_DebugConsole_Faction = "Civilian (Republic of Lingor)"; };
        case "IBR_ARL_FACTION": { FHQ_DebugConsole_Faction = "Rebels (Lingor)"; };
        case "IBR_DRG_FACTION": { FHQ_DebugConsole_Faction = "Drug Lord's Army"; };
        case "IBR_POLICE_UNIT": { FHQ_DebugConsole_Faction = "Lingor Police"; };
        case "IBR_REBEL_FACTION": { FHQ_DebugConsole_Faction = "Rebels (African)"; };
        case "IBR_UNISOL_FACTION": { FHQ_DebugConsole_Faction = "UniSol Corporation"; };
        case "IBR_VENERATOR_FACTION": { FHQ_DebugConsole_Faction = "Venerator PMC"; };
        case "IBR_ZETABORN_FACTION": { FHQ_DebugConsole_Faction = "Zetaborn Aliens"; };
        case "LIN_army": { FHQ_DebugConsole_Faction = "Lingor Army"; };
        /* Other */
        case "PRACS": { FHQ_DebugConsole_Faction = "Royal Army Corps of Sahrani"; };
        case "VME_PLA": { FHQ_DebugConsole_Faction = "People's Liberation Army"; };
        case "VME_PLA_China": { FHQ_DebugConsole_Faction = "People's Liberation Army"; };    
        
        default {FHQ_DebugConsole_Faction = faction (leader _grp); };
    }; 
	
    switch (combatMode _grp) do
    {
        case "BLUE": { FHQ_DebugConsole_CombatMode = "Never fire"; };
        case "GREEN": { FHQ_DebugConsole_CombatMode = "Return fire only"; };
        case "WHITE":  { FHQ_DebugConsole_CombatMode = "Hold, engage at will"; };
        case "YELLOW": { FHQ_DebugConsole_CombatMode = "Fire at will"; };
        case "RED":  { FHQ_DebugConsole_CombatMode = "Engage at will"; };
    };
    
    switch (behaviour  leader _grp) do
    {
        case "CARELESS": { FHQ_DebugConsole_Behaviour = "Careless"; };
        case "SAFE": { FHQ_DebugConsole_Behaviour = "Safe"; };
        case "AWARE": { FHQ_DebugConsole_Behaviour = "Aware"; };
        case "COMBAT": { FHQ_DebugConsole_Behaviour = "Danger/Combat"; };
        case "STEALTH": { FHQ_DebugConsole_Behaviour = "Stealth"; };
    };
    
    FHQ_DebugConsole_Dynamic = [{FHQ_DebugConsole_Group}, {FHQ_DebugConsole_Side}, {FHQ_DebugConsole_Faction}, {FHQ_DebugConsole_Strength call FHQ_DebugConsole_ProgressBar},
    	{FHQ_DebugConsole_Units}, {FHQ_DebugConsole_Vehicles}, {FHQ_DebugConsole_CombatMode}, {FHQ_DebugConsole_Behaviour}];
    
    if (!FHQ_DebugConsole_HintShown) then {
    	FHQ_DebugConsole_HintShown = true;
        
        FHQ_DebugConsole_Header = "Group Info"; 
		FHQ_DebugConsole_Text = "<t color='#66ab47' shadow='1' shadowColor='#312100'>Group:</t> %1<br/>" + "---------------------" + "<br/>"
        				  + "<t color='#66ab47' shadow='1' shadowColor='#312100'>Side:</t> %2<br/><t size='0.85'>%3</t><br/>"
                          + "<t color='#66ab47' shadow='1' shadowColor='#312100'>Strength:</t> %4<br/>" 
                          + "<t color='#66ab47' shadow='1' shadowColor='#312100'>Units:</t> <br/>%5 infantry <br/>%6 vehicles<br/>"
                          + "<t color='#66ab47' shadow='1' shadowColor='#312100'>Combat Mode:</t> %7<br/>"
                          + "<t color='#66ab47' shadow='1' shadowColor='#312100'>Behavior:</t> %8<br/>"
                          ;

		[] spawn FHQ_DebugConsole_ShowHint;
    };    
};

FHQ_DebugConsole_OnGroupIconLeave = {
    [] call FHQ_DebugConsole_TerminateHint;
    FHQ_DebugConsole_HintShown = false;
};

[] call FHQ_DebugConsole_InitHint;
FHQ_DebugConsole_HintShown = false;



if (isNil "FHQ_DebugConsole_ShowingGroupIcons") then {
    FHQ_DebugConsole_ShowingGroupIcons = false;
};

if (!FHQ_DebugConsole_ShowingGroupIcons) then {
    hintSilent "Showing Group Icons";
    FHQ_DebugConsole_ShowingGroupIcons = true;
    
    [] spawn {
    	setGroupIconsVisible [true, true];
        setGroupIconsSelectable true;

        onGroupIconOverEnter {_this call FHQ_DebugConsole_OnGroupIconEnter; };
        onGroupIconOverLeave {_this call FHQ_DebugConsole_OnGroupIconLeave; };
        
    	while {FHQ_DebugConsole_ShowingGroupIcons} do {
            sleep 1.0;
            call FHQ_DebugConsole_UpdateGroupIcons;
       	};
    };
} else {
    hintSilent "Hiding Group Icons";
    setGroupIconsVisible [false, false];
    setGroupIconsSelectable false;
    onGroupIconOverEnter {};
    onGroupIconOverLeave {};
    
    [] call FHQ_DebugConsole_TerminateHint;
    FHQ_DebugConsole_ShowingGroupIcons = false;
};
  
