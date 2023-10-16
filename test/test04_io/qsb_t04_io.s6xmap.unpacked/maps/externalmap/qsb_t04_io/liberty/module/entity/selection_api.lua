Lib.Require("comfort/IsLocalScript");
Lib.Register("module/entity/Selection_API");

--- Deacivates (and reactivates) firing thieves.
--- @param _Flag boolean Deactivate release thieves
function DisableReleaseThieves(_Flag)
    if not GUI then
        ExecuteLocal([[DisableReleaseThieves(%s)]], tostring(_Flag));
        return;
    end
    Lib.Selection.Local.ThiefRelease = not _Flag;
end
API.DisableReleaseThieves = DisableReleaseThieves;

--- Deacivates (and reactivates) firing war machines.
--- @param _Flag boolean Deactivate release war machines
function DisableReleaseSiegeEngines(_Flag)
    if not GUI then
        ExecuteLocal([[DisableReleaseSiegeEngines(%s)]], tostring(_Flag));
        return;
    end
    Lib.Selection.Local.SiegeEngineRelease = not _Flag;
end
API.DisableReleaseSiegeEngines = DisableReleaseSiegeEngines;

--- Deacivates (and reactivates) firing soldiers.
--- @param _Flag boolean Deactivate release soldiers
function DisableReleaseSoldiers(_Flag)
    if not GUI then
        ExecuteLocal([[DisableReleaseSoldiers(%s)]], tostring(_Flag));
        return;
    end
    Lib.Selection.Local.MilitaryRelease = not _Flag;
end
API.DisableReleaseSoldiers = DisableReleaseSoldiers;

--- Returns true if the entity is currently selected.
--- @param _Entity any        Entity to check
--- @param _PlayerID integer? PlayerID to check
--- @return boolean Selected Entity is selectec
function IsEntitySelected(_Entity, _PlayerID)
    if IsExisting(_Entity) then
        local EntityID = GetID(_Entity);
        local PlayerID = _PlayerID or Logic.EntityGetPlayer(EntityID);
        local SelectedEntities;
        if not GUI then
            SelectedEntities = Lib.Selection.Global.SelectedEntities[PlayerID];
        else
            SelectedEntities = {GUI.GetSelectedEntities()};
        end
        for i= 1, #SelectedEntities, 1 do
            if SelectedEntities[i] == EntityID then
                return true;
            end
        end
    end
    return false;
end
API.IsEntityInSelection = IsEntitySelected;

--- Returns the first selected entity.
--- @param _PlayerID integer ID of player
--- @return integer Entity First selected entity
function GetSelectedEntity(_PlayerID)
    local SelectedEntity;
    if not GUI then
        SelectedEntity = Lib.Selection.Global.SelectedEntities[_PlayerID][1];
    else
        SelectedEntity = Lib.Selection.Local.SelectedEntities[_PlayerID][1];
    end
    return SelectedEntity or 0;
end
API.GetSelectedEntity = GetSelectedEntity;

--- Returns all selected entities of the player.
--- @param _PlayerID integer ID of player
--- @return table List Entities selected by the player
function GetSelectedEntities(_PlayerID)
    local SelectedEntities;
    if not GUI then
        SelectedEntities = Lib.Selection.Global.SelectedEntities[_PlayerID];
    else
        SelectedEntities = Lib.Selection.Local.SelectedEntities[_PlayerID];
    end
    return SelectedEntities;
end
API.GetSelectedEntities = GetSelectedEntities;

