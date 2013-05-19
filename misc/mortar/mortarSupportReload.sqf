While {true} do
{		_ms = mortarSupport;
		_ms removemagazines "8Rnd_82mm_Mo_Shells";
		_ms removemagazines "8Rnd_82mm_Mo_Smoke_white";
		_ms removemagazines "8Rnd_82mm_Mo_Flare_white";
		_ms addmagazines ["8Rnd_82mm_Mo_Smoke_white",2];
		_ms addmagazines ["8Rnd_82mm_Mo_Flare_white",4];
		sleep 300;
		_ms vehicleChat "10 minutes untill reload";
		sleep 300;
		_ms vehicleChat "5 minutes untill reload";
		sleep 300;
}