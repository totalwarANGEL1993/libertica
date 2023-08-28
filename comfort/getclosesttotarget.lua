Lib.Require("comfort/GetDistance");
Lib.Register("comfort/GetClosestToTarget");

--- Returns the closest entity from the list to the reference point.
--- @param _Target any Reference position or entity
--- @param _List table List of entities
--- @return integer ID ID of entity
function GetClosestToTarget(_Target, _List)
    local ClosestToTarget = 0;
    local ClosestToTargetDistance = Logic.WorldGetSize() ^ 2;
    for i= 1, #_List, 1 do
        assert(type(_List[i]) ~= "table", "Invalid entity.");
        local DistanceBetween = GetDistance(_List[i], _Target, true);
        if DistanceBetween < ClosestToTargetDistance then
            ClosestToTargetDistance = DistanceBetween;
            ClosestToTarget = _List[i];
        end
    end
    return ClosestToTarget;
end
API.GetClosestToTarget = GetClosestToTarget;

