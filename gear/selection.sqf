private["_dialog","_acc","_list","_item","_type","_struct","_accs","_ctrlNum","_show"];
disableSerialization;

_ctrlNum = _this select 0;
_dialog = findDisplay 2500;
_acc = _dialog DisplayCtrl 2503;
_list = _dialog DisplayCtrl _ctrlNum;
_item = Lbselection _list select 0;
if(isNil {_item}) then {_item = 0;};
_item = lbData[_ctrlNum,_item];
_struct = [];
_show = false;

if(isClass (configFile >> "Cfgweapons" >> _item)) then
{
	_type = getNumber(ConfigFile >> "CfgWeapons" >> _item >> "type");
	
	switch(_type) do
	{
		case 1:
		{
				_accs = primaryWeaponItems player;
				{
					if(_x != "") then
					{
						_name = getText(configFile >> "CfgWeapons" >> _x >> "displayName");
						if(([_name,5] call KRON_StrLeft) == "Sound") then
						{
							_struct set[count _struct, "Sound Suppressor"];
						}
							else
						{
							_struct set[count _struct, _name];
						};
					}
						else
					{
						_struct set[count _struct,"None"];
					};
				} foreach _accs;
				
				_acc ctrlSetStructuredText parseText format["<t size='.5px'>Muzzle: %1<br/>Attachment: %2<br/>Optics: %3</t>",_struct select 0, _struct select 1, _struct select 2];
				_acc ctrlShow true;
				_show = true;
		};
		
		case 2:
		{
				_accs = handgunItems player;
				{
					if(_x != "") then
					{
						_name = getText(configFile >> "CfgWeapons" >> _x >> "displayName");
						if(([_name,5] call KRON_StrLeft) == "Sound") then
						{
							_struct set[count _struct, "Sound Suppressor"];
						}
							else
						{
							_struct set[count _struct, _name];
						};
					}
						else
					{
						_struct set[count _struct,"None"];
					};
				} foreach _accs;
				
				_acc ctrlSetStructuredText parseText format["<t size='.5px'>Muzzle: %1<br/>Attachment: %2<br/>Optics: %3</t>",_struct select 0, _struct select 1, _struct select 2];
				_acc ctrlShow true;
				_show = true;
		};
	};
};
if(!_show) then
{
		ctrlShow [2503,false];
};
			
			