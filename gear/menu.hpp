/*
	ArmA 3 VAS
	VAS_Rsc Source by Sa-Matra
	Use of the VAS system is permitted although modification and distribution must be approved by Tonic, use of the VAS_Rsc source files i.e common.hpp you must have permission from Sa-Matra himself
*/

class VAS_Diag {
	idd = 2500;
	name= "Virtual_Ammobox_Sys";
	movingEnable = false;
	enableSimulation = true;
	onLoad = "['guns'] execVM 'gear\switch.sqf'";
	
	class controlsBackground {
		class VAS_RscTitleBackground:VAS_RscText {
			colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.7])"};
			idc = -1;
			x = 0.1;
			y = 0.2;
			w = 0.8;
			h = (1 / 25);
		};
		
		class MainBackground:VAS_RscText {
			colorBackground[] = {0, 0, 0, 0.7};
			idc = -1;
			x = 0.1;
			y = 0.2 + (11 / 250);
			w = 0.8;
			h = 0.6 - (22 / 250);
		};
		
		class vasText : VAS_RscText
		{
			idc = -1;
			colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
			text = "Virtual Ammobox";
			sizeEx = 0.04;
			x = 0.12; y = 0.27;
			w = 0.275; h = 0.04;
		};
		
		class vasgText : VAS_RscText
		{
			idc = -1;
			colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
			text = "Your Current Gear";
			sizeEx = 0.04;
			
			x = 0.60; y = 0.27;
			w = 0.275; h = 0.04;
		};
		
		class accText : VAS_RscStructuredText
		{
			idc = 2503;
			colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
			text = "";
			sizeEx = 0.04;
			x = 0.38; y = 0.67;
			w = 0.23; h = 0.06;
		};
	};
	
	class controls {
	
		class gundetailsbg : VAS_RscText
		{
			colorBackground[] = {0, 0, 0, 0.7};
			idc = 2507;
			text = "";
			
			x = -0.205;
			y = 0.2 + (11 / 250);
			w = 0.3;
			h = 0.35 - (22 / 250);
		};
		
		class gundetails : VAS_RscStructuredText
		{
			idc = 2508;
			text = "";
			//text = "<t align='center'>EBR 21 7.62 mm Uses:</t>";
			x = -0.265;
			y = 0.21 + (11 / 250);
			w = 0.4; h = 0.15;
		};
		
		class gundetailslist : VAS_RscListBox
		{
			colorBackground[] = {0,0,0,0};
			idc = 2509;
			text = "";
			sizeEx = 0.030;
			
			x = -0.175; y = 0.3;
			w = 0.25; h = 0.16;
		};

		class vasGear : VAS_RscListBox 
		{
			idc = 2501;
			text = "";
			sizeEx = 0.030;
			onLBSelChanged = "[] execVM 'gear\info.sqf'";
			
			x = 0.12; y = 0.31;
			w = 0.275; h = 0.340;
		};
		
		class vasPGear : VAS_RscListBox 
		{
			idc = 2502;
			text = "";
			sizeEx = 0.030;
			onLBSelChanged = "[2502] execVM 'gear\selection.sqf'";
			
			x = 0.60; y = 0.31;
			w = 0.275; h = 0.340;
		};
		
		class WeaponsBtn : VAS_RscButtonMenu
		{
			idc = -1;
			text = "Weapons";
			colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
			onButtonClick = "['guns'] execVM 'gear\switch.sqf'";
			x = 0.42; y = 0.35;
			w = (6.25 / 40);
			h = (1 / 25);
		};
		
		class MagazinesBtn : VAS_RscButtonMenu
		{
			idc = -1;
			text = "Magazines";
			colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
			onButtonClick = "['mags'] execVM 'gear\switch.sqf'";
			x = 0.42; y = 0.40;
			w = (6.25 / 40);
			h = (1 / 25);
		};
		
		class ItemsBtn : VAS_RscButtonMenu
		{
			idc = -1;
			text = "Items";
			colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
			onButtonClick = "['items'] execVM 'gear\switch.sqf'";
			x = 0.42; y = 0.45;
			w = (6.25 / 40);
			h = (1 / 25);
		};
		
		class BackpacksBtn : VAS_RscButtonMenu
		{
			idc = -1;
			text = "Backpacks";
			colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
			onButtonClick = "['packs'] execVM 'gear\switch.sqf'";
			x = 0.42; y = 0.50;
			w = (6.25 / 40);
			h = (1 / 25);
		};
		
		class GogglesBtn : VAS_RscButtonMenu
		{
			idc = -1;
			text = "Goggles";
			colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
			onButtonClick = "['glass'] execVM 'gear\switch.sqf'";
			x = 0.42; y = 0.55;
			w = (6.25 / 40);
			h = (1 / 25);
		};
			
		class Title : VAS_RscTitle {
			colorBackground[] = {0, 0, 0, 0};
			idc = -1;
			text = "Virtual Ammobox System";
			x = 0.1;
			y = 0.2;
			w = 0.8;
			h = (1 / 25);
		};

		class PlayersName : Title {
			idc = 601;
			style = 1;
			text = "";
		};
	
		class ButtonAddG : VAS_RscButtonMenu
		{
			idc = -1;
			text = "Add Item";
			colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
			onButtonClick = "[] execVM 'gear\add.sqf'";
			
			x = 0.16;
			y = 0.67;
			w = (6.25 / 40);
			h = (1 / 25);
		};
		class ButtonRemoveG : VAS_RscButtonMenu
		{
			idc = -1;
			text = "Remove Item";
			colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
			onButtonClick = "[] execVM 'gear\remove.sqf'";
			
			x = 0.69;
			y = 0.67;
			w = (6.25 / 40);
			h = (1 / 25);
		};
		
		class ButtonClose : VAS_RscButtonMenu {
			idc = -1;
			//shortcuts[] = {0x00050000 + 2};
			text = "Close";
			onButtonClick = "closeDialog 0;";
			x = 0.1;
			y = 0.8 - (1 / 25);
			w = (6.25 / 40);
			h = (1 / 25);
		};

		class ButtonSaveGear : VAS_RscButtonMenu {
			idc = -1;
			text = "Save Gear";
			onButtonClick = "if(!vas_disableLoadSave) then {createDialog ""VAS_Save_Diag"";} else {hint ""The mission maker has disabled this feature!"";};";
			x = 0.1 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
			y = 0.8 - (1 / 25);
			w = (6.25 / 40);
			h = (1 / 25);
		};
		
		class ButtonLoadGear : VAS_RscButtonMenu {
			idc = -1;
			text = "Load Gear";
			onButtonClick = "if(!vas_disableLoadSave) then {createDialog ""VAS_Load_Diag"";} else {hint ""The mission maker has disabled this feature!"";};";
			x = 0.1 + (6.25 / 19.8) + (1 / 250 / (safezoneW / safezoneH));
			y = 0.8 - (1 / 25);
			w = (6.25 / 40);
			h = (1 / 25);
		};
	};
};

class VAS_Load_Diag {
	idd = 2520;
	name= "Virtual_Ammobox_Sys Load";
	movingEnable = false;
	enableSimulation = true;
	onLoad = "[1] execVM 'gear\refresh.sqf'";
	
	class controlsBackground {
		class VAS_RscTitleBackground:VAS_RscText {
			colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.7])"};
			idc = -1;
			x = 0.1;
			y = 0.2;
			w = 0.6;
			h = (1 / 25);
		};
		
		class MainBackground:VAS_RscText {
			colorBackground[] = {0, 0, 0, 0.7};
			idc = -1;
			x = 0.1;
			y = 0.2 + (11 / 250);
			w = 0.6;
			h = 0.6 - (22 / 250);
		};
	};
	
	class controls {

		
		class Title : VAS_RscTitle {
			colorBackground[] = {0, 0, 0, 0};
			idc = -1;
			text = "Virtual Ammobox System - Load Gear";
			x = 0.1;
			y = 0.2;
			w = 0.6;
			h = (1 / 25);
		};
		
		class LoadLoadoutList : VAS_RscListBox 
		{
			idc = 2521;
			text = "";
			sizeEx = 0.035;
			onLBSelChanged = "[1] execVM 'gear\csel.sqf'";
			
			x = 0.12; y = 0.26;
			w = 0.230; h = 0.360;
		};
		
		class LoadFetchList : VAS_RscListBox 
		{
			idc = 2522;
			colorBackground[] = {0,0,0,0};
			text = "";
			sizeEx = 0.030;
			
			x = 0.35; y = 0.26;
			w = 0.330; h = 0.360;
		};

		
		class CloseLoadMenu : VAS_RscButtonMenu {
			idc = -1;
			text = "Close";
			onButtonClick = "closeDialog 0;";
			x = -0.06 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
			y = 0.8 - (1 / 25);
			w = (6.25 / 40);
			h = (1 / 25);
		};
		
		class LoadOnRespawnMenu : VAS_RscButtonMenu {
			idc = -1;
			text = "Load On Respawn";
			onButtonClick = "[] call vas_loadonrespawn;";
			x = 0.10 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
			y = 0.8 - (1 / 25);
			w = (9 / 40);
			h = (1 / 25);
		};
		
		class GearLoadMenu : VAS_RscButtonMenu {
			idc = -1;
			text = "Load";
			colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
			onButtonClick = "[] call fnc_load_gear";
			x = 0.05 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
			y = 0.73 - (1 / 25);
			w = (6.25 / 40);
			h = (1 / 25);
		};
		
		class GearDeleteMenu : VAS_RscButtonMenu 
		{
			idc = -1;
			text = "Delete";
			colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
			onButtonClick = "[] call fnc_delete_gear";
			x = 0.25 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
			y = 0.73 - (1 / 25);
			w = (6.25 / 40);
			h = (1 / 25);
		};
	};
};
	
class VAS_Save_Diag {
	idd = 2510;
	name= "Virtual_Ammobox_Sys Save";
	movingEnable = false;
	enableSimulation = true;
	onLoad = "[0] execVM 'gear\refresh.sqf'";
	
	class controlsBackground {
		class VAS_RscTitleBackground:VAS_RscText {
			colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.7])"};
			idc = -1;
			x = 0.1;
			y = 0.2;
			w = 0.6;
			h = (1 / 25);
		};
		
		class MainBackground:VAS_RscText {
			colorBackground[] = {0, 0, 0, 0.7};
			idc = -1;
			x = 0.1;
			y = 0.2 + (11 / 250);
			w = 0.6;
			h = 0.6 - (22 / 250);
		};
	};
	
	class controls {

		
		class Title : VAS_RscTitle {
			colorBackground[] = {0, 0, 0, 0};
			idc = -1;
			text = "Virtual Ammobox System - Save Gear";
			x = 0.1;
			y = 0.2;
			w = 0.6;
			h = (1 / 25);
		};
		
		class SaveLoadoutList : VAS_RscListBox 
		{
			idc = 2511;
			text = "";
			sizeEx = 0.035;
			onLBSelChanged = "[0] execVM 'gear\csel.sqf'";
			
			x = 0.12; y = 0.26;
			w = 0.230; h = 0.360;
		};
		
		class SaveFetchList : VAS_RscListBox 
		{
			idc = 2513;
			colorBackground[] = {0,0,0,0};
			text = "";
			sizeEx = 0.030;
			
			x = 0.35; y = 0.26;
			w = 0.330; h = 0.360;
		};
		
		class SaveLoadEdit : VAS_RscEdit
		{
			idc = 2512;
			text = "Custom Loadout Name";
			
			x = -0.05 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
			y = 0.73 - (1 / 25);
			w = (13 / 40);
			h = (1 / 25);
		};
		
		class CloseSaveMenu : VAS_RscButtonMenu {
			idc = -1;
			text = "Close";
			onButtonClick = "closeDialog 0;";
			x = -0.06 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
			y = 0.8 - (1 / 25);
			w = (6.25 / 40);
			h = (1 / 25);
		};
		
		class GearSaveMenu : VAS_RscButtonMenu {
			idc = -1;
			text = "Save";
			colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
			onButtonClick = "[] call fnc_save_gear";
			x = 0.35 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
			y = 0.73 - (1 / 25);
			w = (6.25 / 40);
			h = (1 / 25);
		};
	};
};

class VAS_prompt 
{
	idd = 2550;
	name = "Virtual_Ammobox_sys_prompt";
	movingEnabled = false;
	enableSimulation = true;
	
	class controlsBackground {
		class VAS_RscTitleBackground:VAS_RscText {
			colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.7])"};
			idc = -1;
			x = 0.3;
			y = 0.2;
			w = 0.47;
			h = (1 / 25);
		};
		
		class MainBackground:VAS_RscText {
			colorBackground[] = {0, 0, 0, 0.7};
			idc = -1;
			x = 0.3;
			y = 0.2 + (11 / 250);
			w = 0.47;
			h = 0.3 - (22 / 250);
		};
	};
	
	class controls 
	{
		class InfoMsg : VAS_RscStructuredText
		{
			idc = -1;
			sizeEx = 0.020;
			text = "<t align='center'><t size='.8px'>What do you want to do with that attachment?</t></t><br/><t align='center'><t size='0.6'>Please know that if you choose to add it to your weapon your current existing attachment in that slot will be lost.</t></t>";
			x = 0.287;
			y = 0.2 + (11 / 250);
			w = 0.5; h = 0.12;
		};

		class addtogun : VAS_RscButtonMenu {
			idc = -1;
			text = "Add to gun";
			colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
			onButtonClick = "vas_prompt_choice = true; closeDialog 0;";
			x = 0.2 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
			y = 0.42 - (1 / 25);
			w = (6.25 / 40);
			h = (1 / 25);
		};
		
		class addtogear : VAS_RscButtonMenu {
			idc = -1;
			text = "Add to INV";
			colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])", 0.5};
			onButtonClick = "vas_prompt_choice = false; closeDialog 0;";
			x = 0.4 + (6.25 / 40) + (1 / 250 / (safezoneW / safezoneH));
			y = 0.42 - (1 / 25);
			w = (6.25 / 40);
			h = (1 / 25);
		};
	};
};