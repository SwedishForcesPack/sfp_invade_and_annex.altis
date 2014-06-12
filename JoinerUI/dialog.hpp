
class GJoiner
{
    idd = 3000;
    movingenable = true;
    onLoad = "uiNamespace setVariable ['myDisplay', (_this select 0)]"; 

    class Controls
    {
      

      /* --------------------------------

            BackGround Image (IPod)

       ------------------------------- */
      class ICE_JoinerBG: IcePicture
      {
	idc = -1;
	text = "Pictures\joiner_bg.paa"; 
	x = 0.33 * safezoneW + safezoneX;
	y = 0.4 * safezoneH + safezoneY;
	w = 0.45 * safezoneW;
	h = 0.45 * safezoneH;
      };


      /* --------------------------------

          List Boxes (player names)

       ------------------------------- */
      class ICE_Joiner_LBA: IceLB
      {
	idc = 6100;
	text = ""; 
	x = 0.373 * safezoneW + safezoneX;
	y = 0.48 * safezoneH + safezoneY;
	w = 0.085 * safezoneW;
	h = 0.2 * safezoneH;
      };

      class ICE_Joiner_LBB: IceLB
      {
	idc = 6101;
	text = ""; 
	x = 0.465 * safezoneW + safezoneX;
	y = 0.48 * safezoneH + safezoneY;
	w = 0.085 * safezoneW;
	h = 0.2 * safezoneH;
      };

      class ICE_Joiner_LBC: IceLB
      {
	idc = 6102;
	text = ""; 
	x = 0.558 * safezoneW + safezoneX;
	y = 0.48 * safezoneH + safezoneY;
	w = 0.085 * safezoneW;
	h = 0.2 * safezoneH;
      };

      class ICE_Joiner_LBD: IceLB
      {
	idc = 6103;
	text = ""; 
	x = 0.648 * safezoneW + safezoneX;
	y = 0.48 * safezoneH + safezoneY;
	w = 0.085 * safezoneW;
	h = 0.2 * safezoneH;
      };


      /* ---------------------------------

                Invisible Buttons

      --------------------------------- */
      class ICE_Button_A: IceButtonInvis
      {
	idc = -1;
	text = ""; 
        action = "[] spawn GrpAlpha";
	x = 0.39 * safezoneW + safezoneX;
	y = 0.4550 * safezoneH + safezoneY;
	w = 0.055 * safezoneW;
	h = 0.02 * safezoneH;
      };

      class ICE_Button_B: IceButtonInvis
      {
	idc = -1;
	text = ""; 
        action = "[] spawn GrpBravo";
	x = 0.482 * safezoneW + safezoneX;
	y = 0.4550 * safezoneH + safezoneY;
	w = 0.055 * safezoneW;
	h = 0.02 * safezoneH;
      };

      class ICE_Button_C: IceButtonInvis
      {
	idc = -1;
	text = ""; 
        action = "[] spawn GrpCharlie";
	x = 0.575 * safezoneW + safezoneX;
	y = 0.4550 * safezoneH + safezoneY;
	w = 0.06 * safezoneW;
	h = 0.02 * safezoneH;
      };

      class ICE_Button_D: IceButtonInvis
      {
	idc = -1;
	text = ""; 
        action = "[] spawn GrpDelta";
	x = 0.67 * safezoneW + safezoneX;
	y = 0.4554 * safezoneH + safezoneY;
	w = 0.0542 * safezoneW;
	h = 0.02 * safezoneH;
      };

      class ICE_Button_LW: IceButtonInvis
      {
	idc = -1;
	text = ""; 
        action = "[] spawn GrpLoneWolf";
	x = 0.48 * safezoneW + safezoneX;
	y = 0.76 * safezoneH + safezoneY;
	w = 0.15 * safezoneW;
	h = 0.03 * safezoneH;
      };

      class ICE_Button_Exit: IceButtonInvis
      {
	idc = -1;
	text = ""; 
        action = "closeDialog 0";
        colorBackgroundActive[] = {1,1,1,0};
        colorFocused[] = {1,1,1,0};
	x = 0.75 * safezoneW + safezoneX;
	y = 0.614 * safezoneH + safezoneY;
	w = 0.02 * safezoneW;
	h = 0.025 * safezoneH;
        tooltip = "Exit The iPad";
      };


    };





};
