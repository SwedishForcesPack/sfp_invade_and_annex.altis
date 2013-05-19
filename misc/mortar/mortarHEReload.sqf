While {true} do
{
		_MHE = mortarHE;
		_MHE removemagazines "8Rnd_82mm_Mo_Shells";
		_MHE addmagazines ["8Rnd_82mm_Mo_shells",5];
		sleep 300;
		_MHE vehicleChat "reloading HE in 20 minutes";
		sleep 300;
		_MHE vehicleChat "reloading HE in 15 minutes";
		sleep 300;
		_MHE vehicleChat "reloading HE in 10 minutes";
		sleep 300;
		_MHE vehicleChat "reloading HE in 5 minutes";
		sleep 300;
}