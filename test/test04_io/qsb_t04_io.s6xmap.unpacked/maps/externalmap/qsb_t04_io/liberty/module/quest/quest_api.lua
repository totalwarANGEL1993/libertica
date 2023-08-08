-- ...................../´¯¯/)
-- ...................,/¯.../
-- .................../..../
-- .............../´¯/'..'/´¯¯`·¸
-- .........../'/.../..../....../¨¯\
-- ..........('(....´...´... ¯~/'..')
-- ...........\..............'...../
-- ............\....\.........._.·´
-- .............\..............(
-- ..............\..............\

---@diagnostic disable: missing-return-value
---@diagnostic disable: return-type-mismatch

Lib.Register("module/quest/Quest_API");

--- Creates a normal quest.
---
--- A quest can have several fields:
--- * Name:        A unique name for the quest
--- * Sender:      Quest giver player ID
--- * Receiver:    Quest receiver player ID
--- * Suggestion:  Proposal quest of the text
--- * Success:     Success text of the quest
--- * Failure:     Failure text of the quest
--- * Description: Custom quest description
--- * Time:        Time until automatic failure
--- * Loop:        Loop function
--- * Callback:    Callback function
--- 
--- @param _Data table Quest data
--- @return string Name Name of quest
--- @return number Amount Quest amount
function SetupQuest(_Data)
    if GUI then
        return;
    end
    if _Data.Name and Quests[GetQuestID(_Data.Name)] then
        error("SetupQuest: A quest named " ..tostring(_Data.Name).. " already exists!");
        return;
    end
    return Lib.Quest.Global:CreateSimpleQuest(_Data);
end

--- Creates a nested quest.
---
--- Nested quest simplifying the notation of quests connected to each other. The
--- "main quest" is always invisible and contains segments as "sub quests". Each
--- segment of the quest is itself a quest that can contain more segments.
---
--- The name of a segment can be defined. If left empty a name is automatically
--- asigned. This name is build from the name of the main quest separated with
--- an @ followed by the segment name (e.g. "ExampleName@Segment1"). 
---
--- Segments have a expected result. Usually success. The expected result can
--- be changed to failure or completly ignored. A nested quest is finished when
--- all segments concluded with their expected result (success) or at least one
--- segment concluded with another result (failure).
---
--- Segments do not need a trigger because they are all automatically started.
--- Additional triggers can be added (e.g. triggering on other segment).
---
--- @param _Data table Quest data
--- @return string Name Name of quest
function SetupNestedQuest(_Data)
    if GUI or type(_Data) ~= "table" then
        return;
    end
    if _Data.Segments == nil or #_Data.Segments == 0 then
        error(string.format("SetupNestedQuest: Segmented quest '%s' is missing it's segments!", tostring(_Data.Name)));
        return;
    end
    return Lib.Quest.Global:CreateNestedQuest(_Data);
end

--- Adds a function to control if trigger are evaluated.
--- @param _Function function Condition
function AddDisableTriggerCondition(_Function)
    if GUI then
        return;
    end
    table.insert(Lib.Quest.Global.ExternalTriggerConditions, _Function);
end

--- Adds a function to control if timer are evaluated.
--- @param _Function function Condition
function AddDisableTimerCondition(_Function)
    if GUI then
        return;
    end
    table.insert(Lib.Quest.Global.ExternalTimerConditions, _Function);
end

--- Adds a function to control if objectives are evaluated.
--- @param _Function function Condition
function AddDisableDecisionCondition(_Function)
    if GUI then
        return;
    end
    table.insert(Lib.Quest.Global.ExternalDecisionConditions, _Function);
end

