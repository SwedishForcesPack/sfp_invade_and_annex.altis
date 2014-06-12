
private ["_obj","_id"];
_obj = _this select 0;
_id = _this select 2;

talkedToContact = true;
publicVariable "talkedToContact";

aw_removeAction = [_obj,_id];
publicVariable "aw_removeAction";
_obj removeAction _id;