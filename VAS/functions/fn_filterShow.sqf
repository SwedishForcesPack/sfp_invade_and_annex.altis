#include "macro.sqf"
/*
	@version: 1.0
	@file_name: filter_show.sqf
	@file_author: TAW_Tonic
	@file_edit: 5/9/2013
	@file_description: Checks if we need to hide/show filters.
	
*/
private["_req"];
_req = _this select 0;
_cur_filter = uiNamespace getVariable "VAS_UI_FILTER";

switch(_req) do
{
	case "guns":
	{
		ctrlSetText[VAS_filter_1,"Rifles"];
		ctrlSetText[VAS_filter_2,"Scoped"];
		ctrlSetText[VAS_filter_3,"Heavy"];
		ctrlSetText[VAS_filter_4,"Launcher"];
		ctrlSetText[VAS_filter_5,"Pistol"];
		
		ctrlShow[VAS_filter_1,true];
		ctrlShow[VAS_filter_2,true];
		ctrlShow[VAS_filter_3,true];
		ctrlShow[VAS_filter_4,true];
		ctrlShow[VAS_filter_5,true];
	};
	
	case "items":
	{
		ctrlSetText[VAS_filter_1,"Uniforms"];
		ctrlSetText[VAS_filter_2,"Vests"];
		ctrlSetText[VAS_filter_3,"Headgear"];
		ctrlSetText[VAS_filter_4,"Attachments"];
		ctrlSetText[VAS_filter_5,"Misc"];
		
		ctrlShow[VAS_filter_1,true];
		ctrlShow[VAS_filter_2,true];
		ctrlShow[VAS_filter_3,true];
		ctrlShow[VAS_filter_4,true];
		ctrlShow[VAS_filter_5,true];
	};
	
	default 
	{
		ctrlShow[VAS_filter_1,false];
		ctrlShow[VAS_filter_2,false];
		ctrlShow[VAS_filter_3,false];
		ctrlShow[VAS_filter_4,false];
		ctrlShow[VAS_filter_5,false];
	};
};
		