/*
You may not remove any entries from Credits without first removing the author's contributions, or asking permission.
*/

if (!hasInterface) exitWith {};

waitUntil {!isNull player};

player createDiarySubject ["rules", "Server Rules"];
player createDiarySubject ["mods", "Mods"];
player createDiarySubject ["teamspeak", "Teamspeak"];
player createDiarySubject ["faq", "FAQ"];
player createDiarySubject ["changelog", "Change Log"];
player createDiarySubject ["credits", "Credits"];


player createDiaryRecord ["rules",
[
"I & A",
"
<br />1. Hacking and mission exploitation will not be tolerated.
<br />2. Intentional team-killing will not be tolerated.
<br />3. Excessive, unintentional team-killing may result in a Kick/Temp ban.
<br />4. Unnecessary destruction of BLUFOR vehicles will not be tolerated.
<br />5. Verbal abuse and bullying will not be tolerated. 
<br />6. It is reccomended  you be on Teamspeak to fly.
<br />7. Firing a weapon on base--unless at an enemy--may result in a Kick/Temp ban.
<br />8. Disruptive play will not be tolerated.
<br />9. Excessive mic spamming, especially of Side and Global channels, will not be tolerated.
<br />10. A server moderator or admin's word is final.
<br />
<br />If you see a player in violation of the above, contact a moderator or admin (teamspeak).
"
]];

player createDiaryRecord ["mods",
[
"Mods Allowed",
"
<br /> Mods currently allowed (subject to change without notice):<br /><br />

<br />- CBA - Required to run the below mods.
		http://www.armaholic.com/page.php?id=18768<br /><br />
		
<br />- JSRS (2.1) - Enhanced sounds and audio.
		http://www.armaholic.com/page.php?id=22150<br /><br />
		
<br />- Blastcore R3 - Enhanced visuals, including explosions.
		http://www.armaholic.com/page.php?id=23899<br /><br />
		
<br />- ShackTac Fireteam HUD - Situational awareness HUD
		http://www.armaholic.com/page.php?id=9936<br /><br />

<br />- VTS Weapon resting (v04) - Simulates 'bipod' and weapon resting.
		http://www.armaholic.com/page.php?id=20817
"
]];

player createDiaryRecord ["mods",
[
"Serverside",
"
<br /> Mods currently running on server (subject to change without notice):<br /><br />

<br />- Coming soon!
"
]];

player createDiaryRecord ["teamspeak",
[
"Ahoy World",
"
<br /> Address: ts3.ahoyworld.co.uk
<br />
<br /> Visitors and guests welcome!
"
]];

player createDiaryRecord ["teamspeak",
[
"TS3",
"
<br /> Teamspeak:<br /><br />
<br /> http://www.teamspeak.com/?page=downloads
"
]];

player createDiaryRecord ["faq",
[
"UAV",
"
<br /><font size='16'>Q:</font> Can I use the UAVs?<br />
<br /><font size='16'>A:</font> Yes, however you must be in the UAV Operator role and you must have a UAV Terminal.
<br />
<br /> --------------------------------------------- 
<br />
<br /><font size='16'>Q:</font> Why do the UAVs keep exploding?<br />
<br /><font size='16'>A:</font> UAVs are bugged and do not handle respawning very well. Until it's fixed, here is a guide for you.<br />
<br /> To safely connect to the MQ4A Greyhawk UAV:<br />
<br /> 1. Enter action menu (mouse scroll), click 'Open UAV Terminal'.
<br /> 2. Right-click on the UAV you wish to control, on the terminal map.
<br /> 3. Click 'Connect Terminal to UAV'.
<br /><br /> [IMPORTANT] Do NOT click 'Take Control' button in UAV Terminal.<br />
<br /> 4. Esc out of the UAV terminal.
<br /> 5. Enter action menu (mouse scroll) again.
<br /> 6. [IMPORTANT] Select 'Take UAV TURRET controls'.<br />
<br /> It is now safe to 'Take Control' of the UAV.
<br />
<br /> --------------------------------------------- 
<br />
<br /><font size='16'>Q:</font> Why can't I connect to the UAV?<br />
<br /><font size='16'>A:</font> The UAVs are bugged and do not handle respawning very well. Ensure you have a UAV Terminal. If the UAV does not appear on the UAV Terminal map, there is no way to connect to it, and your only recourse is to destroy it and wait for respawn.
"
]];

player createDiaryRecord ["changelog",
[
"2.70.2",
"
<br />- [UPDATED]=BTC= Revive.
<br />- [UPDATED] Realistic airlift system.
<br />- [ADDED] SCUBA missions.
<br />- [ADDED] Defend AO.
<br />- [ADDED] AO Air Reinforcements.
<br />- [ADDED] Greater variety of enemy soldiers and vehicles at the AO and side missions.
<br />- [ADDED] FFIS mod.
<br />- [ADDED] Easter eggs!
<br />- [ADDED] A-143 Buzzard spawn at base (CAS).
<br />- [ADDED] UH-80 Ghost Hawk door animation added.
<br />- [ADDED] Recon Team added to role assignments.
<br />- [ADDED] Clear Inventory script added to vehicles, for easy clearing of stock inventory to facilitate custom loading.
<br />- [CHANGED] Spawn area and base layout adjusted to increase frame rate performance and mitigate griefing.
<br />- [CHANGED] HEMTT Mobile Ammo Box (VAS) Truck now respawns.
<br />- [CHANGED] Lots of subtle adjustments to AI strengths, weaknesses, and actions.
<br />- [CHANGED] UAVs adjusted to mitigate spontaneous explosion.
<br />- [FIXED] Fire-related frame-drop and crash-to-desktop bug fixed.
<br />- [FIXED] Plenty of behind-the-scenes scripts and code adjustments for performance, realism and fun!
"
]];

player createDiaryRecord ["changelog",
[
"2.70.3",
"
<br />- [UPDATED] EOS v1.95
<br />- [ADDED] New Side Missions.
<br />- [ADDED] OPFOR Static weapons.
<br />- [ADDED] UAV Connection instructions added to map Diary entry.
<br />- [CHANGED] Improved AI garrison scripts.
<br />- [CHANGED] Modified FFIS.
<br />- [CHANGED] OPFOR Artillery range reduced.
<br />- [CHANGED] AI vehicle crew behavior.
<br />- [CHANGED] Refined AO locations.
<br />- [CHANGED] Refined OPFOR behavior and waypoints.
"
]];

player createDiaryRecord ["changelog",
[
"2.70.4",
"
<br />- [UPDATED] EOS v1.96.
<br />- [UPDATED] FFIS v1.25.
<br />- [ADDED] Urban missions.
<br />- [ADDED] Medic markers and Revive tweaks.
<br />- [ADDED] UGV Stomper added.
<br />- [REMOVED] AH-9 Pawnee removed from CAS spawn.
<br />- [FIXED] Behind-the-scenes bug fixes, code adjustments and performance-related tweaks.
"
]];

player createDiaryRecord ["changelog",
[
"2.71.0",
"
<br />- [UPDATED] EOS v1.97.
<br />- [UPDATED] TAW View Distance v1.2
<br />- [UPDATED] VAS v2.3
<br />- [CHANGED] Refined urban missions and AO counterattack.
<br />- [REMOVED] Old code.
<br />- [REMOVED] Skip Time parameter.
<br />- [FIXED] De-sync associated with Skip Time.
<br />- [FIXED] Bug fixes and code adjustments aimed at improving performance and frame rate.
"
]];

player createDiaryRecord ["changelog",
[
"2.71.1",
"
<br />- [UPDATED] Map Markers.
<br />- [UPDATED] Admin tools.
<br />- [ADDED] MBT-52 Kuma to vehicle spawn.
<br />- [ADDED] VAS to unarmed UGV Stomper.
<br />- [CHANGED] Fast-Rope.
<br />- [CHANGED] Map marker color to grey, to improve clarity.
<br />- [REMOVED] Duplicate group manager (assigned to 'T' key).
<br />- [REMOVED] Global chat.
<br />- [FIXED] UI errors associated with last patch.
<br />- [FIXED] UAV spawn. Maybe. Ok, not quite.
<br />- [FIXED] Players couldn't be dragged or revived.
"
]];

player createDiaryRecord ["changelog",
[
"2.71.2",
"
<br />- [UPDATED] EOS v1.97.2. (Defend sequence).
<br />- [UPDATED] Vehicle hud (tweaked by QS).
<br />- [ADDED] 
<br />- [CHANGED] AO Defend sequence, slightly. Attempt at increasing enemy aggression.
<br />- [REMOVED] Most easter eggs.
<br />- [REMOVED] Some aircraft service locations.
<br />- [REMOVED] A couple vehicles from base. Outsourced to under-construction FOBs.
<br />- [REMOVED] Personal UAV.
<br />- [FIXED] All UI errors.
<br />- [FIXED] 
"
]];

player createDiaryRecord ["changelog",
[
"2.71.3",
"
<br />- [UPDATED] 
<br />- [ADDED] T-100 to side mission rewards.
<br />- [ADDED] Radio tower minefield.
<br />- [ADDED] AA Buzzard instead of CAS (reduced respawn time!).
<br />- [CHANGED] OPFOR patrol logic, to increase performance and realism. 
<br />- [CHANGED] OPFOR skill refined, based on unit type and location.
<br />- [REMOVED] More old and inefficient code.
<br />- [FIXED] Some side mission errors.
<br />- [FIXED] AO unit spawn problems.
<br />- [FIXED] Enemy snipers smarter.
"
]];

player createDiaryRecord ["changelog",
[
"2.71.35",
"
<br />- [UPDATED]
<br />- [ADDED] Enemy UAV [disabled].
<br />- [ADDED] Airbase AA.
<br />- [ADDED] Weather script test.
<br />- [CHANGED] OPFOR patrol logic. They like the high ground too!
<br />- [REMOVED] More old code.
<br />- [FIXED] Enemy CAS spawn limit.
<br />- [FIXED]
"
]];

player createDiaryRecord ["changelog",
[
"2.74",
"
<br />- [UPDATED]
<br />- [ADDED] Class restrictions.
<br />- [ADDED] New medic system. A3 Wounding System.
<br />- [TWEAKED] Locations of vehicle repairs.
<br />- [REMOVED] Sling loading.
<br />- [REMOVED] Several Side Mission variants.
<br />- [FIXED] Pilot Check.
<br />- [ADDED] Ahoy+ Pavilion.
<br />- [FIXED] Ahoy+/Website Integration.
<br />- [READDED] Temporary Personal UAV's.
"
]];

player createDiaryRecord ["changelog",
[
"2.74b",
"
<br />- [UPDATED]
<br />- [TWEAKED] Class restrictions wording.
<br />- [TWEAKED] Tweaked settings in Medic system. Should no longer spam side chat.
<br />- [TWEAKED] Vehicle and Aircraft service spots.
<br />- [REMOVED] 3D Icons should no longer display on wounded soldiers
<br />- [REMOVED] Personal UAV's.
<br />- [REMOVED] Some unused scripts.
<br />- [REMOVED] Splash screen.
<br />- [FIXED] Aircraft service to repair planes.
<br />- [FIXED] Ahoy+/Website Integration some more.
<br />- [FIXED] UAV'S should now respawn.
"
]];

player createDiaryRecord ["credits",
[
"I & A",
"
<br />Mission authors: Ahoy World (ahoyworld.co.uk)<br /><br />
		- <font size='16'>Rarek</font><br /><br />
		- Jester<br />
		- Razgriz33<br />
		- Kamaradski<br /><br />
		
<br />Contributors: All FPS (allfps.com.au)<br /><br />
		- Quiksilver<br />
		- chucky<br /><br />
		
<br />Other:<br /><br />
		VAS<br />
		- Kronzky<br />
		- Sa-Matra<br />
		- Dslyecxi<br /><br />
		=BTC= Revive<br />
		- Giallustio<br /><br />
		EOS<br />
		- BangaBob<br /><br />
		Squad Management<br />
		- Xeno<br /> <br />
		TAW View Distance<br />
		- Tonic<br /> <br />
		aw_fnc<br />
		- Alex Wise<br /><br />
		Vehicle Respawn<br />
		- Tophe<br /><br />
		SHK Taskmaster<br />
		- Shuko<br /><br />
		Fast rope<br />
		- Zealot<br /><br />
		Map markers<br />
		- aeroson
"
]];