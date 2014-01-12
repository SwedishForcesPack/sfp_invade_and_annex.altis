if (isServer) then {     // Server countdown
        missionNamespace setVariable ["kINTmissionstart",60];      // Set counter duration
        publicVariable "kINTmissionstart";         // Transmit counter duration over the network
        _kINTcountme = 0;    // Set initial loopcount to zero

        while {kINTmissionstart!=0} do {     // Run the following while is not zero
                sleep 1;    // wait 1 second
                _kINTcountme = _kINTcountme + 1;   // Add 1 second to the loopcounter
                kINTmissionstart = kINTmissionstart -1;   // Deduct 1 second from the countdown
                if (_kINTcountme==10) then {  // When the countdown has reached 10sec do:
                        publicVariable "kINTmissionstart";  // Transmit the current countdown status over the network
                        _kINTcountme=0;     // reset the loopcounter to zero
                };
        };
};    // So after the countdown reaches zero, the loop will break and the code will continue

if (!isServer) then { // CLIENT code
        if (isNil "kINTmissionstart") then    // if countdown is not set to anything (meaning client still JIP or not synced yet)
        {
                kINTmissionstart = 60;   // Assume the full 600 seconds to prevent early start
        };
        "kINTmissionstart" addPublicVariableEventHandler {   // Create publiceventhandler for the countdown
                _timeLeftHint = format
                [
                "Enemy attack will end in: %1",kINTmissionstart
                ];
                TimerHint = _timeLeftHint; publicVariable "TimerHint"; hint parseText TimerHint;
                //hint format ["Enemy attack will end in: %1",kINTmissionstart];     // display countdown when eventhander is tripped (so once every 10 seconds
                //hint "Enemy attack will end in: %1",kINTmissionstart;
                };
        while {kINTmissionstart!=0} do {   // while countdown is not zero do:
                sleep 1;      // sleep 1 second
        };          // client will loop here and show hint every 10sec according to the eventhandler
};  // after the 600 seconds the client will break out of the loop and the code will continue
