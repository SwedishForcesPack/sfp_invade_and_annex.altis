_pathtotools = "scripts\admin\tools\";
_pathtovehicles = "scripts\admin\veh\";
_EXECscript1 = 'player execVM "'+_pathtotools+'%1"';
_EXECscript5 = 'player execVM "'+_pathtovehicles+'%1"';
_adminList =
[
"76561198022163272",  //david
"76561198093488202",  //elcour
"76561198043867265",  //jester
"76561198054120913",  //zissou
"76561198086257618",  //kama
"76561198043550034",  //danne
"76561198061765216",  //berezon
"76561197984319908",  //jeff
"76561198019189559",  //brooksie
"76561197983658369",  //hoax
"76561198033324720",  //McClane
"76561198003953068",  //ferg
"76561197979546789",  //jack
"76561198001522951",  //raz
"76561197998355936",  //cain
"76561198022267525",  //edward
"76561198004408914",  //repeatz
"76561198085765221",  //mykey
"76561198049323414",  //pach
"76561198029008449"   //danny
];

if ((getPlayerUID player) in _adminList) then { //all admins
	if ((getPlayerUID player) in _adminList) then { //Admins Go Here aswell
		adminmenu =
		[
			["Admin Menu",true],
				["Tools", [2], "#USER:ToolsMenu", -5, [["expression", ""]], "1", "1"],
				["Cars", [3], "#USER:VehicleMenu", -5, [["expression", ""]], "1", "1"],
				["", [-1], "", -5, [["expression", ""]], "1", "0"],
			["Exit", [13], "", -3, [["expression", ""]], "1", "1"]
		];};
} else {
adminmenu =
[
	["",true],
		//["Toggle Debug", [2], "", -5, [["expression", format[_execdebug,"playerstats.sqf"]]], "1", "1"],
		["", [-1], "", -5, [["expression", ""]], "1", "0"],
	["Exit", [13], "", -3, [["expression", ""]], "1", "1"]
];};
ToolsMenu =
[
	["Tools",true],
    ["Teleport", [2],  "", -5, [["expression", format[_EXECscript1,"teleport.sqf"]]], "1", "1"],
    ["Spectate", [3],  "", -5, [["expression", format[_EXECscript1,"spectate.sqf"]]], "1", "1"],
    ["AI Paradrop - DO NOT ABUSE", [4],  "", -5, [["expression", format[_EXECscript1,"aiDrop.sqf"]]], "1", "1"],
    ["AoE Nuke 200m - USE W/ CAUTION!", [5],  "", -5, [["expression", format[_EXECscript1,"boom.sqf"]]], "1", "1"],
    ["God Mode On", [6],  "", -5, [["expression", format[_EXECscript1,"god.sqf"]]], "1", "1"],
    ["God Mode Off", [7],  "", -5, [["expression", format[_EXECscript1,"godOff.sqf"]]], "1", "1"],
		["", [-1], "", -5, [["expression", ""]], "1", "0"],
			["Exit", [13], "", -3, [["expression", ""]], "1", "1"]
];

VehicleMenu =
[
	["Vehicles",true],
		["ATV", [2],  "", -5, [["expression", format[_EXECscript5,"ATV.sqf"]]], "1", "1"],
		["Hunter Armed", [3],  "", -5, [["expression", format[_EXECscript5,"hunter.sqf"]]], "1", "1"],
		["Offroad Truck HMG .50", [4],  "", -5, [["expression", format[_EXECscript5,"offroad.sqf"]]], "1", "1"],
		["", [-1], "", -5, [["expression", ""]], "1", "0"],
		["Exit", [13], "", -3, [["expression", ""]], "1", "1"]
];

showCommandingMenu "#USER:adminmenu";