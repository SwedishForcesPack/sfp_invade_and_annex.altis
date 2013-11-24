_timer = 300;

while { true } do
{

	mortarHE removeMagazines "8Rnd_82mm_Mo_Shells";
	mortarHE vehicleChat "Mortar HE Magazines Removed.";
	sleep 1;
	mortarHE addMagazines ["8Rnd_82mm_Mo_Shells", 5];
	mortarHE vehicleChat "Mortar HE Magazines Reloaded.";
	sleep _timer;
	mortarHE vehicleChat "Mortar HE reload in 20 minutes.";
	sleep _timer;
	mortarHE vehicleChat "Mortar HE reload in 15 minutes.";
	sleep _timer;
	mortarHE vehicleChat "Mortar HE reload in 10 minutes.";
	sleep _timer;
	mortarHE vehicleChat "Mortar HE reload in 5 minutes.";
	sleep _timer;
	
};