private ["_uid", "_name", "_coinsQuery", "_tempString", "_tempArray", "_memberData", "_memberID", "_ahoycoins", "_groupQuery", "_memberGroupID", "_memberOtherIDs", "_groupTitle", "_player", "_isConnected", "_lastScore", "_currentScore", "_coinsToAdd", "_newTotal", "_coinsUpdate", "_handle", "_iteration", "_iterations", "_timeout"];

_uid = _this select 0;
_name = _this select 1;

_coinsQuery = format["SELECT member_id, eco_points FROM ipbpfields_content WHERE field_16='%1'", _uid];
_tempString = "Arma2Net.Unmanaged" callExtension format["Arma2NETMySQLCommand ['mxegnxzt_ipb', '%1']", _coinsQuery];
_tempArray = call compile _tempString;

if (count (_tempArray select 0) > 0 && ((_tempArray select 0) select 0) select 0 != "Error") then
{
	_memberData = (_tempArray select 0) select 0;
	_memberID = parseNumber (_memberData select 0);
	_ahoycoins = parseNumber (_memberData select 1);
	_groupQuery = format["SELECT member_group_id, mgroup_others FROM ipbmembers WHERE member_id='%1'", _memberID];
	_tempString = "Arma2Net.Unmanaged" callExtension format["Arma2NETMySQLCommand ['mxegnxzt_ipb', '%1']", _groupQuery];
	_tempArray = call compile _tempString;

	_memberData = (_tempArray select 0) select 0;
	_memberGroupID = parseNumber (_memberData select 0);
	_memberOtherIDs = toArray((_memberData select 1));
	_groupTitle = "AW Community Member";

	switch (_memberGroupID) do
	{
		case 8: { _groupTitle = "AW Member"; };
		case 4: { _groupTitle = "AW Core Staff Member"; };
		case 9: { _groupTitle = "AW Developer"; };
		case 6: { _groupTitle = "AW Administrator"; };
	};

	if (55 in _memberOtherIDs) then { _groupTitle = _groupTitle + " and Ahoy+ Subscriber"; };

	GlobalHint = format["<t align='center'><t size='2.2' color='#CE2123'>Ahoy World</t><br/>%1...<br/><t size='1.4'>%2</t><br/>...has joined the server</t><br/>_____________________<br/>To track stats and start earning Ahoy Coins, simply register an account at www.AhoyWorld.co.uk and get playing!", _groupTitle, _name]; publicVariable "GlobalHint";

	_player = objNull; _iterations = 0;
	while {isNull _player && _iterations < 50} do
	{
		sleep 6;
		{ if (getPlayerUID _x == _uid) then { _player = _x; }; } forEach playableUnits;
	};

	if !(isNull _player) then
	{
		_player setVariable ["lastScore", score _player, false];
		_isConnected = true;
		_iteration = 0;
		debugMessage = format["Player <t color='#FF8000'>%1</t> is confirmed member; starting while loop.<br/><t color='#FF8000'>lastScore:</t> %2", _name, score _player]; publicVariable "debugMessage";
		while {_isConnected} do
		{
			sleep (60 + (random 240));
			_iteration = _iteration + 1;
			_player = objNull; _iterations = 0;
			while {isNull _player && _iterations < 10} do
			{
				sleep 6;
				{ if (getPlayerUID _x == _uid) then { _player = _x; }; } forEach playableUnits;
				_iterations = _iterations + 1;
			};

			if !(isNull _player) then
			{
				_lastScore = _player getVariable ["lastScore", false];
				if ((typeName _lastScore) == "SCALAR") then
				{
					_currentScore = score _player;
					if (_currentScore > _lastScore) then
					{
						_coinsToAdd = (_currentScore - _lastScore);
						_coinsQuery = format["SELECT eco_points FROM ipbpfields_content WHERE field_16='%1'", _uid];
						_tempString = "Arma2Net.Unmanaged" callExtension format["Arma2NETMySQLCommand ['mxegnxzt_ipb', '%1']", _coinsQuery];
						_tempArray = call compile _tempString;

						if (count (_tempArray select 0) > 0 && ((_tempArray select 0) select 0) select 0 != "Error") then
						{
							_memberData = (_tempArray select 0) select 0;
							_ahoycoins = parseNumber (_memberData select 0);
							_newTotal = _ahoycoins + _coinsToAdd;

							_coinsUpdate = format ["UPDATE ipbpfields_content SET eco_points=%1 WHERE field_16 = '%2'", _newTotal, _uid];
							_handle = "Arma2Net.Unmanaged" callExtension format ["Arma2NETMySQLCommand ['mxegnxzt_ipb', '%1']", _coinsUpdate];
							_player setVariable ["lastScore", _currentScore, false];
							debugMessage = format["Player <t color='#FF8000'>%1</t> has been given <t color='#FF8000'>%2</t> more Ahoy Coins.", _name, _coinsToAdd]; publicVariable "debugMessage";
						};
					} else {
						debugMessage = format["Score hasn't changed for player <t color='#FF8000'>%1</t>; will not update Ahoy Coins.", _name]; publicVariable "debugMessage";
					};
				} else {
					debugMessage = format["No longer tracking player <t color='#FF8000'>%1</t> for Ahoy Coin integration; couldn't find <t color='#FF8000'>lastScore</t> variable.", _name]; publicVariable "debugMessage";
					_isConnected = false;
				};
			} else {
				debugMessage = format["No longer tracking player <t color='#FF8000'>%1</t> for Ahoy Coin integration; couldn't find <t color='#FF8000'>player object</t>.", _name]; publicVariable "debugMessage";
				_isConnected = false;
			};
		};
		sleep 10;
		debugMessage = format["End of loop for player <t color='#FF8000'>%1</t>.", _name]; publicVariable "debugMessage";
	} else {
		debugMessage = format["Could not find <t color='#FF8000'>player object</t> for player <t color='#FF8000'>%1</t>.<br/><t color='#FF8000'>UID:</t> %2", _name, _uid]; publicVariable "debugMessage";
	};
} else {
	debugMessage = format["Player <t color='#FF8000'>%1</t> was not found to be a registered member.", _name]; publicVariable "debugMessage";
};