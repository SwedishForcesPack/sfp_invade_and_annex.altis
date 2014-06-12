/*
 * Carry body action
 * 
 * Copyleft 2013 naong
 * 
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

private ["_injured", "_player", "_release_body_action","_playerMove","_wrong_moves","_dir","_trigger"];

// Remove action
(_this select 0) removeAction (_this select 2);

// Set variable
_injured = (_this select 3) select 0;
_release_body_action = (_this select 3) select 1;
_trigger = (_this select 3) select 2;
_player = player;
_wrong_moves = ["helper_switchtocarryrfl","acinpknlmstpsraswrfldnon_amovppnemstpsraswrfldnon","acinpknlmstpsraswrfldnon_acinpercmrunsraswrfldnon","acinpercmrunsraswrfldnon","acinpercmrunsraswrfldf"];
INS_REV_GVAR_do_release_body = false;
INS_REV_GVAR_is_carring = true;
INS_REV_GVAR_injured = _injured;

// Infrom player is taking care of injured
_injured setVariable ["INS_REV_PVAR_who_taking_care_of_injured", _player, true];

// Start carring move
[_injured, "AinjPpneMstpSnonWrflDnon"] call INS_REV_FNCT_switchMove;
waitUntil {animationState _injured == "AinjPpneMstpSnonWrflDnon"};
_injured switchMove "AinjPfalMstpSnonWnonDnon_carried_Up";
_injured attachto [player,[0.05, 1.1, 0]];
detach _injured;
_injured setPos [getPos _injured select 0,getPos _injured select 1,0.01];
[_injured, (getDir _player + 180)] call INS_REV_FNCT_setDir;
[_player, "AcinPknlMstpSrasWrflDnon_AcinPercMrunSrasWrflDnon"] call INS_REV_FNCT_playMoveNow;
while {animationState _injured == "ainjpfalmstpsnonwnondnon_carried_up" && alive _player && !INS_REV_GVAR_do_release_body && vehicle _player == _player} do {sleep 0.01};
_player playMove "manPosCarrying";
sleep 0.1;

// Create dir funciton
if (isNil "FNC_dir_func") then {
	FNC_dir_func = {
		private ["_veh","_unit","_v","_p","_c","_dir"];
		_veh = _this select 0;
		_unit = _this select 1;

		_v = getDir _veh;
		_p = getDir _unit;
		_c = 360;

		_dir = _c-((_c-_p)-(_c-_v));

		_dir
	};
};

// Attach injured to player
[_injured, "AinjPfalMstpSnonWnonDnon_carried_still"] call INS_REV_FNCT_switchMove;
sleep 0.1;
_injured attachto [_player,[0.1, 0.1, 0]];
_dir = [_player, _injured] call FNC_dir_func;
[_injured, _dir + 180] call INS_REV_FNCT_setDir;

if (isNil "FNC_is_finished_carring") then {
	FNC_is_finished_carring = {
		private ["_result","_player","_injured"];
		
		_player = _this select 0;
		_injured = _this select 1;
		_carring_moves = ["acinpercmstpsraswrfldnon","acinpercmrunsraswrfldf","acinpercmrunsraswrfldfr","acinpercmrunsraswrfldfl","acinpercmrunsraswrfldl","acinpercmrunsraswrfldr","acinpercmrunsraswrfldb","acinpercmrunsraswrfldbr","acinpercmrunsraswrfldbl"];
		_result = true;
		
		if (!INS_REV_GVAR_do_release_body) then {
			if (!isNull _player && alive _player && !isNull _injured && alive _injured && isPlayer _injured && vehicle _player == _player && _injured getVariable "INS_REV_PVAR_is_unconscious") then {
				if (animationState _player in _carring_moves) then {
					_result = false;
				};
			};
		};
		
		_result
	};
};

waitUntil {animationState _player == "acinpercmstpsraswrfldnon" || !alive _player || INS_REV_GVAR_do_release_body || vehicle _player != _player};

// Wait until dragging is finished
while {!([_player, _injured] call FNC_is_finished_carring)} do {
	sleep 0.5;
};

// If injured is not disconnected
if (!isNull _injured) then {
	// Detach injured
	detach _injured;
	
	// If injured is alive set move
	if (alive _player && _injured getVariable "INS_REV_PVAR_is_unconscious") then {
		[_injured, "AinjPpneMstpSnonWrflDb_release"] call INS_REV_FNCT_playMoveNow;
	} else {
		[_injured, "AinjPpneMstpSnonWrflDnon"] call INS_REV_FNCT_switchMove;
	};
	_injured setVariable ["INS_REV_PVAR_who_taking_care_of_injured", nil, true];
};

// Finish carring
if !(isNull _player) then {
	[_player, "AmovPknlMstpSrasWrflDnon"] call INS_REV_FNCT_switchMove;
};

// Remove  actions
_player removeAction _release_body_action;
if (INS_REV_CFG_medevac) then {
	if (!isNil "INS_REV_GVAR_loadActionID") then {
		_player removeAction INS_REV_GVAR_loadActionID;
		INS_REV_GVAR_loadActionID = nil;
	};
	
	// Remove trigger
	if (!isNil "_trigger" && {!isNull _trigger}) then {
		deleteVehicle _trigger;
		_trigger = nil;
	};
};

// Clear variable
INS_REV_GVAR_is_carring = false;
INS_REV_GVAR_do_release_body = true;