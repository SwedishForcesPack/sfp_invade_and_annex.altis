if (!isServer) exitwith {};

private ["_ID","_smHint","_smMkr","_smPos","_object","_disname","_objectListArray","_objectType","_taskTitle","_SideMissionComplete","_taskDescription"];

	_smMkr=(_this select 0);
	_smPos=markerpos _smMkr;
	_object=(_this select 1);
// SET MISSION	
	_object setPosATL _smPos;
	"SM_Marker" setMarkerPos markerpos _smMkr;

	_objectType=typeof _object;
	_disname= _objectType call ISSE_Cfg_Vehicle_GetName;	
	
// SET HINT
	_taskTitle="Destroy the " + _disname;
	_smHint=floor (random 3);
	
SWITCH(_smHint)do 
{
case 0:{
_taskDescription = format ["OPFOR are using shipping containers to establish an underwater listening post off the coast of Altis. Stop them!",_disname];
};
case 1:{
_taskDescription = format ["The enemy is trying to jam our communications with the mainland. Destroy their communications container.",_disname];
};
case 2:{
_taskDescription = format ["Local fishermen have reported suspicious activity near the coast. Confirm it is the enemy comms container and destroy it",_disname];
};
};

_ID=format ["%1%2",_disname,_smHint];
				
		_SideMissionComplete = format ["<t color='#2159D1' size='1.6' shadow='1' shadowColor='#000000' align='center'>Side Mission</t><br/><br/><t color='#FFF700' size='1.6' shadow='1' shadowColor='#000000' align='center'>%1</t><br/><br/><t color='#EEEEEE' size='1.3' shadow='1' shadowColor='#000000' align='center'>%2</t><br/><br/><t color='#EEEEEE' size='1.3' shadow='1' shadowColor='#000000' align='center'>Get your scuba gear on!</t><br/><br/>",_taskTitle,_taskDescription];
GlobalHint = _SideMissionComplete; publicVariable "GlobalHint"; hintsilent parseText _SideMissionComplete;
		[_ID,_taskTitle,_taskDescription] call SHK_Taskmaster_add;
