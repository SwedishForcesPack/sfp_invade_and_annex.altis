_timer = 300;

while { true } do
{
	mortarSupport removeMagazines "8Rnd_82mm_Mo_Shells";
	mortarSupport removeMagazines "8Rnd_82mm_Mo_Smoke_white";
	mortarSupport removeMagazines "8Rnd_82mm_Mo_Flare_white";
	mortarSupport vehicleChat "Mortar HE Magazines Removed.";
	sleep 1;
	mortarSupport addMagazines ["8Rnd_82mm_Mo_Smoke_white",2];
	mortarSupport addMagazines ["8Rnd_82mm_Mo_Flare_white",4];
	mortarSupport vehicleChat "Mortar HE Magazines Reloaded.";
	sleep _timer;
	mortarSupport vehicleChat "Mortar HE reload in 20 minutes.";
	sleep _timer;
	mortarSupport vehicleChat "Mortar HE reload in 15 minutes.";
	sleep _timer;
	mortarSupport vehicleChat "Mortar HE reload in 10 minutes.";
	sleep _timer;
	mortarSupport vehicleChat "Mortar HE reload in 5 minutes.";
	sleep _timer;
};