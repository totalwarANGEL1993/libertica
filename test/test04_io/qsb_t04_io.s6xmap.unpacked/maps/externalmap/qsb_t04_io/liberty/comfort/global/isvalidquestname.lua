Lib.Register("comfort/global/IsValidQuestName");

CONST_REGEX_QUEST_NAME = "^[A-Za-z0-9_ @ÄÖÜäöüß]+$";

--- Returns if the quest name is complaint to naming conventions.
--- @param _Name string Name to check
--- @return boolean Valid Name is valid
function IsValidQuestName(_Name)
    return string.find(_Name, CONST_REGEX_QUEST_NAME) ~= nil;
end

