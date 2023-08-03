Lib.Register("comfort/global/GetQuestID");

--- Returns the ID of the quest with the name.
--- @param _Name string Name of quest
--- @return integer ID ID of quest
function GetQuestID(_Name)
    if type(_Name) == "number" then
        return _Name;
    end
    for k, v in pairs(Quests) do
        if v and k > 0 then
            if v.Identifier == _Name then
                return k;
            end
        end
    end
    return -1;
end

