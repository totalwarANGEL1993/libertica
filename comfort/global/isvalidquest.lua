Lib.Require("comfort/global/GetQuestID");
Lib.Register("comfort/global/IsValidQuest");

--- Returns if the quest is valid.
--- @param _QuestID any ID or name of quest
--- @return boolean Valid Quest is valid
function IsValidQuest(_QuestID)
    return Quests[_QuestID] ~= nil or Quests[GetQuestID(_QuestID)] ~= nil;
end

