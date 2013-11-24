Hello! Thank you for using my Virtual Ammobox System (VAS). This was created for a specific mission to cut back on network lag & ammo box usage and well decided to release for public!

System is very easy to use, to add this to your mission copy the gear folder from the scripts folder to your mission folder, edit description.ext and put:

#include "VAS\menu.hpp"

class CfgFunctions
{
	#include "VAS\cfgfunctions.hpp"
};

Somewhere in description.ext
This shouldn't conflict with any other dialogs unless you are trying to use this in Wasteland (as the class names for the dialogs are the same as wasteland).
It is best to attach the action to a pre-existing ammo box so place a ammo box on the map via editor and in the initialization field put:

this addAction["<t color='#ff1111'>Virtual Ammobox</t>", "VAS\open.sqf"];

And your done! Just look at the ammo box, scroll and click Virtual Ammobox. The interface is easy to use so have fun!

v1.1 Notes:
If you don't change your description.ext when updating VAS for your mission to what I have now or that is in the example Description.ext your game will crash due to missing files in a non-existent file path.
Also a check was put in place to check if a saved loadout being loaded had a weapon in the uniform/vest, if it did it will exit so it doesn't overwrite your current weapons in your hand, if you want to store addition weapons on you then do it in your backpack.

V1.0 Notes:
VAS's backend has completely changed, VAS 1.0 marks the future progress of VAS, all previous change logs are considered legacy and obsolete. This version was aimed to fix all issues with the previous versions and introduce a few new
features and also prepare it for the BETA / Final version of ARMA 3. I want to thank everyone for their feedback! The functions: VAS_fnc_handleItem and VAS_fnc_fetchCfgDetails are encouraged to use outside of VAS, I found them to be quite
handy in just VAS and will prove to be handy outside of VAS!

Known Issue(s)/Bug(s):
Entire Backend changed, not aware of any bugs in the system yet (please report).

Changelog:
v1.4:
Changed: 'forced' was changed to 'preInit' in CfgFunctions.
Fixed: Fixed issue with gear on loadouts sometimes missing.
Changed: Some changes to the initialization process it try and fix 'VAS hasn't finished loading yet.'.
Added: If restricted items are listed in the config.sqf upon loading a loadout that item will not be added.

v1.3:
Fixed: Broken Commands that were changed to something else from Alpha->Beta transition
Changed: Backend stuff that was used to fetch magazines from the gun, changed to new commands added in.
Changed: Some functions changed to the call method instead of spawn.
Added: Full support of adding attachments to the all weapon types (Weapons on you that support the item).

v1.2:
Changed: Tweaks to VAS_fnc_handleItem for better handling in future.
Changed: Tweaks to VAS_fnc_fetchCfgDetails (Should display Ghillie suits till BIS fixes the config entries).
Changed: Tweaks to VAS_fnc_buildConfig for future use, Range finder and other binocs should show as a weapon.
Changed: Tweaks to UI Experience, should no longer flash when adding/removing items.
Added: Ability to remove all magazines of a type or items of a type.
Added: Double clicking on a weapon/item/whatever adds it.
Added: Double clicking on a weapon/item/whatever removes it.
Changed: Tweaks to the save/load display, items are now grouped and show in quantity thanks to naong.
Changed: Tweaks to load option to prevent excessive magazines being added when spamming Load.

v1.1:
Fixed: VAS couldn't add the range finder or any other 'binocular' based item besides the actual binoculars.
Changed: Converted VAS's function initialization to CfgFunctions (VAS now initializes when mission is started, thanks to Tyrghen on Armaholic for the tip).
Changed: VAS's file path changed from gear to VAS to make it stand out more (Read notes about the new Description.ext when adding VAS 1.1 to your mission).
Changed: Highlighted selections should no longer flash between black and white (now less annoying and easier to read).
Changed: When setting disableLoadSave to true VAS now changes over to missionNamespace so saves are only persistent in the missionNamespace.
Changed: Tweaks to VAS_fnc_handleItem for loading of saved loadouts (enabling it to save gps's,uniforms/vests within the uniform/vest).
Added: New configuration parameter vas_customslots allowing mission maker to enable the amount of saved slots (was actually in 1.0).

v1.0:
Changed: Recoded the entire backend
Fixed: When saving a loadout with a weapon in the backend, it wouldn't be loaded.
Fixed: When saving a loadout with a gun that had a GL it would load in with a missing magazine.
Added: Confirmation to deleting a saved loadout.
Added: When selecting a loadout through the save menu the saved loadouts name is now loaded in the text field.
Added: When selecting a weapon you can now double click on the magazine on the left information window to quickly add the magazine.


Credits & thanks:
Kronzky - For his string functions library
SaMatra - For helping with the UI Conversion from OA->A3
Dslyecxi - For his Paper doll giving insight on how to detech item types.
Tyrghen on Armaholic - For giving me the tip about CfgFunctions