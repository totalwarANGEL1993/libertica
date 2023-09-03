Lib.Require("comfort/IsValidPosition");
Lib.Register("comfort/GetCirclePosition");

--- Returns a position at a circle around the target.
--- @param _Target any Position or Entity
--- @param _Distance integer Radius of circle
--- @param _Angle number Angle relative to Target
--- @return table Position Position at circle
function GetCirclePosition(_Target, _Distance, _Angle)
    if not IsValidPosition(_Target) and not IsExisting(_Target) then
        error(false, "Target does not exist or is invalid position!");
    end

    local Position = _Target;
    local Orientation = 0+ (_Angle or 0);
    if type(_Target) ~= "table" then
        local EntityID = GetID(_Target);
        Orientation = Logic.GetEntityOrientation(EntityID)+(_Angle or 0);
        Position = GetPosition(EntityID);
    end

    local Result = {
        X= Position.X+_Distance * math.cos(math.rad(Orientation)),
        Y= Position.Y+_Distance * math.sin(math.rad(Orientation)),
        Z= Position.Z
    };
    return Result;
end
API.GetRelatiePos = GetCirclePosition;

