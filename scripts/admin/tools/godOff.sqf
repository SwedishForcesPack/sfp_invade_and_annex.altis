cutText ["Godmode DE-activated.", "PLAIN"];
player removeAllEventHandlers "handleDamage";
player addEventHandler ["handleDamage", {true}];