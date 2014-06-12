_handle = CreateDialog "GJoiner";
Hint "Click on the name of the squad you would like to join";
sleep 1;

While {dialog} do {

[] spawn Group_LB_Refresh;
sleep 0.1;
};