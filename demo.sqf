// clientside
while {kINTmissionstart!=0} do {      // Adding start-up delay
        sleep 1;
        _kINTcountme = _kINTcountme + 1;
        if (_kINTcountme==5) then {   // Sync the countdown every 5 sec with all clients
                publicVariable "kINTmissionstart";
                _kINTcountme=0;
        };
        kINTmissionstart = kINTmissionstart -1;
};
publicVariable "kINTmissionstart";


// Serverside:
if (!isServer) then {       // CLIENT code
        if (isNil "kINTmissionstart") then       // if countdown is not set:
        {
                kINTmissionstart = 400;      // Set countdown to 400 to prevent early start
        };
        "kINTmissionstart" addPublicVariableEventHandler {       // Create publiceventhandle for the countdown
                hint format ["mission start in: %1",kINTmissionstart];   // display countdown when eventhander is tripped
                };
        while {kINTmissionstart!=0} do {     // while countdown is not 0:
                sleep 1;    // sleep 1 second
        };
};

hint "Cargo system loaded";