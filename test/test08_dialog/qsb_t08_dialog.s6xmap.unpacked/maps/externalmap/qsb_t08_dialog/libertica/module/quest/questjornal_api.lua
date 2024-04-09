Lib.Require("comfort/IsLocalScript");
Lib.Register("module/quest/QuestJornal_API");

--- Activates or deactivates the jornal or a spezific quest.
--- @param _Quest string Name of quest
--- @param _Flag boolean Activate/deactivate
function ShowJournalForQuest(_Quest, _Flag)
    assert(not IsLocalScript(), "Can not be used in local script!");
    local Quest = Quests[GetQuestID(_Quest)];
    if Quest then
        Quest.QuestNotes = _Flag == true;
    end
end

--- Allows the player to make notes in the jornal.
--- @param _Quest string Name of quest
--- @param _Flag boolean Activate/deactivate
function AllowNotesForQuest(_Quest, _Flag)
    assert(not IsLocalScript(), "Can not be used in local script!");
    local Quest = Quests[GetQuestID(_Quest)];
    if Quest then
        Lib.QuestJornal.Global.CustomInputAllowed[_Quest] = _Flag == true;
    end
end

--- Creates a new journal entry and returns the ID.
---
--- The entry can be added to any jornal of any quest.
--- @param _Text string Text of entry
--- @return integer ID ID of entry
function CreateJournalEntry(_Text)
    assert(not IsLocalScript(), "Can not be used in local script!");
    _Text = _Text:gsub("{@[A-Za-z0-9:,]+}", "");
    _Text = _Text:gsub("{[A-Za-z0-9_]+}", "");
    return Lib.QuestJornal.Global:CreateJournalEntry(_Text, 0, false);
end

--- Updates the journal entry with the ID.
--- @param _ID integer ID of entry
--- @param _Text string Text of entry
function AlterJournalEntry(_ID, _Text)
    assert(not IsLocalScript(), "Can not be used in local script!");
    _Text = _Text:gsub("{@[A-Za-z0-9:,]+}", "");
    _Text = _Text:gsub("{[A-Za-z0-9_]+}", "");
    local Entry = Lib.QuestJornal.Global:GetJournalEntry(_ID);
    if Entry then
        Lib.QuestJornal.Global:UpdateJournalEntry(
            _ID,
            _Text,
            Entry.Rank,
            Entry.AlwaysVisible,
            Entry.Deleted
        );
    end
end

--- Marks an journal entry as important and highlights it.
--- @param _ID integer ID of entry
--- @param _Important boolean Highlight entry
function HighlightJournalEntry(_ID, _Important)
    assert(not IsLocalScript(), "Can not be used in local script!");
    local Entry = Lib.QuestJornal.Global:GetJournalEntry(_ID);
    if Entry then
        Lib.QuestJornal.Global:UpdateJournalEntry(
            _ID,
            Entry[1],
            (_Important == true and 1) or 0,
            Entry.AlwaysVisible,
            Entry.Deleted
        );
    end
end

--- Deletes an entry. The entry will be deleted from all journals it is
--- attached to.
--- @param _ID integer ID of entry
function DeleteJournalEntry(_ID)
    assert(not IsLocalScript(), "Can not be used in local script!");
    local Entry = Lib.QuestJornal.Global:GetJournalEntry(_ID);
    if Entry then
        Lib.QuestJornal.Global:UpdateJournalEntry(
            _ID,
            Entry[1],
            Entry.Rank,
            Entry.AlwaysVisible,
            true
        );
    end
end

--- Restores an deleted entry. The entry will reappear in all journals it
--- is attached to.
--- @param _ID integer ID of entry
function RestoreJournalEntry(_ID)
    assert(not IsLocalScript(), "Can not be used in local script!");
    local Entry = Lib.QuestJornal.Global:GetJournalEntry(_ID);
    if Entry then
        Lib.QuestJornal.Global:UpdateJournalEntry(
            _ID,
            Entry[1],
            Entry.Rank,
            Entry.AlwaysVisible,
            false
        );
    end
end

--- Adds a entry to the jornal of the quest.
--- @param _ID integer ID of entry
--- @param _Quest string Name of quest
function AddJournalEntryToQuest(_ID, _Quest)
    assert(not IsLocalScript(), "Can not be used in local script!");
    local Entry = Lib.QuestJornal.Global:GetJournalEntry(_ID);
    if Entry then
        Lib.QuestJornal.Global:AssociateJournalEntryWithQuest(_ID, _Quest, true);
    end
end

--- Removes a entry from the journal of the quest.
--- @param _ID integer ID of entry
--- @param _Quest string Name of quest
function RemoveJournalEntryFromQuest(_ID, _Quest)
    assert(not IsLocalScript(), "Can not be used in local script!");
    local Entry = Lib.QuestJornal.Global:GetJournalEntry(_ID);
    if Entry then
        Lib.QuestJornal.Global:AssociateJournalEntryWithQuest(_ID, _Quest, false);
    end
end

