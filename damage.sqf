{_x setVariable ["selections", []];
_x setVariable ["gethit", []];
_x addEventHandler
[
    "HandleDamage",
    {
        _x = _this select 0;
        _selections = _x getVariable ["selections", []];
        _gethit = _x getVariable ["gethit", []];
        _selection = _this select 1;
        if !(_selection in _selections) then
        {
            _selections set [count _selections, _selection];
            _gethit set [count _gethit, 0];
        };
        _i = _selections find _selection;
        _olddamage = _gethit select _i;
        _damage = _olddamage + ((_this select 2) - _olddamage) * 0.33;
        _gethit set [_i, _damage];
        _damage;
    }
];


} forEach playableUnits;