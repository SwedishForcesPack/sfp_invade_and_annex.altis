if (!isServer) exitwith {};

	private ["_mkr"];
		_mkr=(_this select 0);

		//hint format ["%1",_mkr];
		
	{
		_x setmarkercolor "colorblack";
		_x setmarkerAlpha 0;
	}foreach _mkr;

