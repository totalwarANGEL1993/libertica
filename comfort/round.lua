Lib.Register("comfort/Round");

--- Rounds the given value.
--- @param _Value number      Any number to round
--- @param _Decimals? integer Amount of decimals
--- @return number? Value Rounded value
function Round(_Value, _Decimals)
    _Decimals = math.ceil(_Decimals or 0);
    if _Decimals <= 0 then
        return math.floor(_Value + 0.5);
    end
    return tonumber(string.format("%." .._Decimals.. "f", _Value));
end

