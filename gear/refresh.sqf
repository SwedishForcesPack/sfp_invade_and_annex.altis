private["_type","_dialog","_list","_loadout"];
_type = _this select 0;
disableSerialization;
if(_type == 0) then
{
	_dialog = findDisplay 2510;
	_list = _dialog displayCtrl 2511;
	CtrlShow[2513,false];

	lbClear _list;

	for "_i" from 0 to 9 do
	{
		if(!isnil {profileNameSpace getVariable format["vas_gear_new_%1",_i]}) then
		{
			_loadout = profileNameSpace getVariable format["vas_gear_new_%1",_i];
			_loadout = _loadout select 0;
			_list lbAdd format["%1", _loadout];
		}
			else
		{
			_list lbAdd format["Custom Loadout %1", _i+1];
			_list lbSetData [(lbSize _list)-1,format["Custom Loadout %1", _i+1]];
		};
	};
}
	else
{
	_dialog = findDisplay 2520;
	_list = _dialog displayCtrl 2521;
	CtrlShow[2522,false];

	lbClear _list;

	for "_i" from 0 to 9 do
	{
		if(!isnil {profileNameSpace getVariable format["vas_gear_new_%1",_i]}) then
		{
			_loadout = profileNameSpace getVariable format["vas_gear_new_%1",_i];
			_loadout = _loadout select 0;
			_list lbAdd format["%1", _loadout];
		}
			else
		{
			_list lbAdd format["Custom Loadout %1", _i+1];
			_list lbSetData [(lbSize _list)-1,format["Custom Loadout %1", _i+1]];
		};
	};
};