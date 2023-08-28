Lib.Require("comfort/IsLocalScript");
Lib.Register("module/npc/NPC_API");

--- Adds an NPC to an entity.
---
--- An NPC might have the following fields:
--- * Name              Script name of entity (mandatory)
--- * Callback          Function called at activation
--- * Condition         Condition checked before activation
--- * Type              Type of NPC (1, 2, 3, 4)
--- * Player            Players allowed to talk
--- * WrongPlayerAction Message for wrong players
--- * Hero              Name of specific hero
--- * WrongHeroAction   Message for wrong heroes
--- * Active            NPC is active
---
--- @param _Data table NPC data
--- @return table NPC NPC data
function NpcCompose(_Data)
    assert(not IsLocalScript(), "NPC manipulated in local script.");
    assert(type(_Data) == "table", "NPC must be a table.");
    assert(_Data.Name ~= nil, "NPC needs a script name.");
    assert(IsExisting(_Data.Name), "Entity does not exist.");

    local Npc = Lib.NPC.Global:GetNpc(_Data.Name);
    assert(Npc == nil or not Npc.Active, "NPC already active.");
    assert(not _Data.Type or (_Data.Type >= 1 or _Data.Type <= 4), "NPC type is invalid.");
    return Lib.NPC.Global:CreateNpc(_Data);
end

--- Removes the NPC but does not delete the entity.
--- @param _Data table NPC data
function NpcDispose(_Data)
    assert(not IsLocalScript(), "NPC manipulated in local script.");
    assert(IsExisting(_Data.Name), "Entity does not exist.");
    assert(Lib.NPC.Global:GetNpc(_Data.Name) == nil, "NPC must first be composed.");
    Lib.NPC.Global:DestroyNpc(_Data);
end

--- Updates the NPC with the data table.
---
--- An NPC might have the following fields:
--- * Name              Script name of entity (mandatory)
--- * Callback          Function called at activation
--- * Condition         Condition checked before activation
--- * Type              Type of NPC (1, 2, 3, 4)
--- * Player            Players allowed to talk
--- * WrongPlayerAction Message for wrong players
--- * Hero              Name of specific hero
--- * WrongHeroAction   Message for wrong heroes
--- * Active            NPC is active
---
--- @param _Data table NPC data
function NpcUpdate(_Data)
    assert(not IsLocalScript(), "NPC manipulated in local script.");
    assert(IsExisting(_Data.Name), "Entity does not exist.");
    assert(Lib.NPC.Global:GetNpc(_Data.Name) ~= nil, "NPC must first be composed.");
    Lib.NPC.Global:UpdateNpc(_Data);
end

--- Checks if the NPC is active.
--- @param _Data table NPC data
--- @return boolean Active NPC is active
function NpcIsActive(_Data)
    assert(not IsLocalScript(), "NPC manipulated in local script.");
    assert(IsExisting(_Data.Name), "Entity does not exist.");
    local NPC = Lib.NPC.Global:GetNpc(_Data.Name);
    assert(NPC ~= nil, "NPC was not found.");
    if NPC.Active == true then
        return GetInteger(_Data.Name, CONST_SCRIPTING_VALUES.NPC) == 6;
    end
    return false;
end

--- Returns if an NPC has talked.
--- @param _Data table NPC data
--- @param _Hero string Scriptname of hero
--- @param _PlayerID integer ID of player
--- @return boolean HasTalked NPC has talked
function NpcTalkedTo(_Data, _Hero, _PlayerID)
    assert(not IsLocalScript(), "NPC manipulated in local script.");
    assert(IsExisting(_Data.Name), "Entity does not exist.");

    local NPC = Lib.NPC.Global:GetNpc(_Data.Name);
    assert(NPC ~= nil, "NPC was not found.");
    local TalkedTo = NPC.TalkedTo ~= nil and NPC.TalkedTo ~= 0;
    if _Hero and TalkedTo then
        TalkedTo = NPC.TalkedTo == GetID(_Hero);
    end
    if _PlayerID and TalkedTo then
        TalkedTo = Logic.EntityGetPlayer(NPC.TalkedTo) == _PlayerID;
    end
    return TalkedTo;
end

