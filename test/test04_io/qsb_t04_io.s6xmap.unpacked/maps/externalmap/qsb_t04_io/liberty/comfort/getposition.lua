Lib.Register("comfort/GetPosition");

--- Returns the coordinates of the entity on the world.
--- @param _Entity any ID or scriptname
--- @return table Position Table of coordinates
function GetPosition(_Entity)
    if type(_Entity) == "table" and _Entity.X and _Entity.Y then
        _Entity.Z = _Entity.Z or 0;
        return _Entity;
    end
    assert(IsExisting(_Entity), "Entity does not exist.");
    local x, y, z = Logic.EntityGetPos(GetID(_Entity));
    return {X= x, Y= y, Z= z};
end

