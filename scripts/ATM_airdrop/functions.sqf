///////////////////////////////////////////////////////////
//                =ATM= Airdrop       	 				    //
//         		 =ATM=Pokertour        		       		    //
//				version : 5.5							        //
//				date : 08/01/2014						   //
//                   visit us : atmarma.fr                 //
/////////////////////////////////////////////////////////

fnc_alt_onsliderchange =
{
	private["_dialog","_text","_value"];
	disableSerialization;

	_dialog = findDisplay 2900;
	_text = _dialog displayCtrl 2902;
	_value = _this select 0;

	Altitude = round(_value);
	_text ctrlSetText format["%1", round(_value)];
};

/*pkChangeKey = {
		_index = lbCurSel 2903;
		switch _index do {
			case 0 : {
				//Fr Keyboard
			};
			case 1 : {
				Keys = 46; //C
			};
			case 2 : {
				//US Keyboard
			};
			case 3 : {
				Keys = 46; //C
			};
		};
	};*/

dokeyDown={
     private ["_r","_key_delay","_cutawaysound"] ;
     _key_delay  = 0.3;
	player setvariable ["key",false];
   _r = false ;

   if (player getvariable["key",true] and (_this select 1)  == Keys) exitwith {player setvariable["key",false]; [_key_delay] spawn {sleep (_this select 0);player setvariable["key",true]; }; _r};
     if ((_this select 1)  == Keys) then {
       if  (player != vehicle player and player getvariable ["cutaway",true]) then  {
		_cut = nearestObjects [player, ["Steerable_Parachute_F"], 5];
	   {
			deletevehicle _x;
	   } foreach _cut;
	player addBackpack "B_Parachute";
	deletevehicle (player getvariable "frontpack"); player setvariable ["frontpack",nil,true];
    player setvariable["key",true];
    player setvariable ["cutaway",false];
    (findDisplay 46) displayRemoveEventHandler ["KeyDown", Cut_Rope];
   };
    _r=true;
      };
     _r;
} ;

Getloadout={
_gear = [];
	_headgear = headgear player;
	_back_pack = backpack player;
	_back_pack_items = getItemCargo (unitBackpack player);
	_back_pack_weap = getWeaponCargo (unitBackpack player);
	_back_pack_maga = getMagazineCargo (unitBackpack player);


	_gear =
	[
		_headgear,
		_back_pack,
		_back_pack_items,
		_back_pack_weap,
		_back_pack_maga
	];
	_gear

};

Setloadout={
_unit = _this select 0;
	_gear = _this select 1;
	removeheadgear _unit;
	removeBackPack _unit;
	_unit addBackpack "B_AssaultPack_blk";
	removeBackPack _unit;
	if ((_gear select 1) != "") then {_unit addBackPack (_gear select 1);clearAllItemsFromBackpack _unit;};
	if ((_gear select 0) != "") then {_unit addHeadgear (_gear select 0);};
	if (count ((_gear select 3) select 0) > 0) then
	{
		for "_i" from 0 to (count ((_gear select 3) select 0) - 1) do
		{
			(unitBackpack _unit) addweaponCargoGlobal [((_gear select 3) select 0) select _i,((_gear select 3) select 1) select _i];
		};
	};
	if (count ((_gear select 4) select 0) > 0) then
	{
		for "_i" from 0 to (count ((_gear select 4) select 0) - 1) do
		{
			(unitBackpack _unit) addMagazineCargoGlobal [((_gear select 4) select 0) select _i,((_gear select 4) select 1) select _i];
		};
	};
	if (count ((_gear select 2) select 0) > 0) then
	{
		for "_i" from 0 to (count ((_gear select 2) select 0) - 1) do
		{
			(unitBackpack _unit) addItemCargoGlobal [((_gear select 2) select 0) select _i,((_gear select 2) select 1) select _i];
		};
	};
};

Frontpack={
	_pack = unitBackpack _target;
	_class = typeOf _pack;

	[_target,_class] spawn {
		private ["_target","_class","_packHolder"];
		_target	= _this select 0;
		_class 	= _this select 1;

		_packHolder = createVehicle ["groundWeaponHolder", [0,0,0], [], 0, "can_collide"];
		_packHolder addBackpackCargo [_class, 1];
		_packHolder attachTo [_target,[0.1,0.56,-.72],"pelvis"];
		_target setvariable ["frontpack", _packHolder,true];
		_packHolder setVectorDirAndUp [[0,1,0],[0,0,-1]];

		waitUntil {animationState _target == "para_pilot"};
		_packHolder attachTo [vehicle _target,[0.1,0.72,0.52],"pelvis"];
		_packHolder setVectorDirAndUp [[0,0.1,1],[0,1,0.1]];
		};
};