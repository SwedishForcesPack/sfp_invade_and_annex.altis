/*
Modified by [LB] chucky to temporarily disable copilot on transport choppers whilst bug 11987 is outstanding
http://feedback.arma3.com/view.php?id=11987

Adapted SaMatra's code published on:
http://forums.bistudio.com/showthread.php?157481-crewmen
*/

//Script by Sa-Matra
true spawn {
    //List of pilot classes, crewman classes, affected aircraft classes and affected vehicle classes
    _AWSubscriber = ["B_officer_F"];
    _armor = ["C_Kart_01_Fuel_F","C_Kart_01_F","C_Kart_01_Blu_F","C_Kart_01_Red_F","C_Hatchback_01_sport_F","C_SUV_01_F"];

    //Wait until player is fully loaded
    waitUntil {player == player};

    //Check if player is pilot or crewman, you can add more classes into arrays
    _iamAWSubscriber = ({typeOf player == _x} count _AWSubscriber) > 0;

    //Never ending cycle
    while{true} do {
        //Wait until player's vehicle changed
        _oldvehicle = vehicle player;
        waitUntil {vehicle player != _oldvehicle};

        //If player is inside vehicle and not on foot
        if(vehicle player != player) then {
            _veh = vehicle player;

            //Check if vehicle is armor and player is not crewman
            if(({typeOf _veh == _x} count _armor) > 0 && !_iamAWSubscriber) then {
                //Forbidden seats: gunner, driver
                _forbidden = [gunner _veh] + [driver _veh];
                if(player in _forbidden) then {
                    systemChat "You are not an Ahoy World Subscriber and are not allowed to drive this vehicle!";
                    player action ["eject", _veh];
                };
            };
        };
    };
};