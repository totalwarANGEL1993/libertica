Lib.Require("comfort/IsLocalScript");
Lib.Register("module/io/IO_API");

--- Adds an interaction to a object.
---
--- (Almost) All entities can be used as interactive object not just those
--- that are supposed to. An object is described by a table and (almost) all
--- keys are optional.
---
--- #### Fields of table
--- * Name                   - Scriptname of object
--- * Texture                - (Optional) table with coordinates
---   - Game icons: {x, y, ExtraNumber}
---   - Custom icons: {x, y, FileNamePrefix}
--- * Title                  - (Optional) Title of tooltip
--- * Text                   - (Optional) Text of tooltip
--- * Distance               - (Optional) Activation distance
--- * Player                 - (optional) List of players
--- * Waittime               - (optional) Activation waittime
--- * Replacement            - (Optional) Type to replace with
--- * Costs                  - (Optional) Activation cost table
---   - Format: {Type, Amount, Type, Amount}
--- * Reward                 - (Optional) Activation reward table
---   - Format: {Type, Amount}
--- * State                  - (Optional) Actvation behavior
---   - 0: Hero only
---   - 1: Automatic
---   - 2: Never
--- * Condition              - (Optional) Activation condition function
--- * ConditionInfo          - (Optional) Condition failure text
--- * Action                 - (Optional) Activation callback function
--- * RewardResourceCartType - (Optional) Type of reward resource cart
--- * RewardGoldCartType     - (Optional) Type of reward gold cart
--- * CostResourceCartType   - (Optional) Type of cost resource cart
--- * CostGoldCartType       - (Optional) Type of cost gold cart
---
--- #### Examples
--- ```lua
--- -- Create a simple object
--- SetupObject {
---     Name     = "hut",
---     Distance = 1500,
---     Reward   = {Goods.G_Gold, 1000},
--- };
--- ```
---
--- @param _Description table Object description
--- @return table? Data Object description
function SetupObject(_Description)
    if GUI then
        return;
    end
    return Lib.IO.Global:CreateObject(_Description);
end
API.CreateObject = SetupObject;

--- Removes the interaction from the object.
--- @param _ScriptName string Script name of entity
function DisposeObject(_ScriptName)
    if GUI or not CONST_IO[_ScriptName] then
        return;
    end
    Lib.IO.Global:DestroyObject(_ScriptName);
end
API.DisposeObject = DisposeObject;

--- Resets the interactive object. Needs to be activated separately.
--- @param _ScriptName string Script name of entity
function ResetObject(_ScriptName)
    if GUI or not CONST_IO[_ScriptName] then
        return;
    end
    Lib.IO.Global:ResetObject(_ScriptName);
    InteractiveObjectDeactivate(_ScriptName);
end
API.ResetObject = ResetObject;

--- Changes the name of the object in the 2D interface.
--- 
--- #### Exsamples
--- ```lua
--- InteractiveObjectAddCustomName("D_X_HabourCrane", {
---     de = "Hafenkran",
---     en = "Habour Crane"
--- });
--- ```
---
--- @param _Key string        Key to add
--- @param _Text string|table Text or replacement text
function InteractiveObjectAddCustomName(_Key, _Text)
    local Prefix = (Entities[_Key] and "UI_Names/") or "Names/";
    if not IsLocalScript() then
        ExecuteLocal(
            [[InteractiveObjectSetQuestName("%s", %s)]],
            _Key,
            (type(_Text) == "table" and table.tostring(_Text))
            or ("\"" .. _Text .. "\"")
        );
        return;
    end
    AddStringText(Prefix .. _Key, _Text);
end
API.InteractiveObjectSetQuestName = InteractiveObjectAddCustomName;

--- Removes the changes to the object name.
--- 
--- #### Exsample
--- ```lua
--- InteractiveObjectDeleteCustomName("D_X_HabourCrane");
--- ```
---
--- @param _Key string Key to remove
function InteractiveObjectDeleteCustomName(_Key)
    local Prefix = (Entities[_Key] and "UI_Names/") or "Names/";
    if not IsLocalScript() then
        ExecuteLocal([[InteractiveObjectDeleteCustomName("%s")]], _Key);
        return;
    end
    DeleteStringText(Prefix .. _Key);
end
API.InteractiveObjectUnsetQuestName = InteractiveObjectDeleteCustomName;

--- Allows or forbids to refill iron mines.
--- 
--- #### Requires Addon!
--- @param _PlayerID integer ID of player
--- @param _Allowed boolean  Activation is allowed
function AllowActivateIronMines(_PlayerID, _Allowed)
    assert(not IsLocalScript(), "Can not be used in local script!");
    Logic.TechnologySetState(_PlayerID, Technologies.R_RefillIronMine, (_Allowed and 3 or 1));
end
API.AllowActivateIronMines = AllowActivateIronMines;

--- Sets the required title to refill iron mines.
--- 
--- #### Requires Addon!
--- @param _Title integer  Knight title
function RequireTitleToRefilIronMines(_Title)
    assert(not IsLocalScript(), "Can not be used in local script!");
    ExecuteLocal([[
        table.insert(NeedsAndRightsByKnightTitle[%d][4], Technologies.R_RefillIronMine)
        CreateTechnologyKnightTitleTable()
    ]], _Title);
    table.insert(NeedsAndRightsByKnightTitle[_Title][4], Technologies.R_RefillIronMine);
    CreateTechnologyKnightTitleTable()
    for i= 1, 8 do
        Logic.TechnologySetState(i, Technologies.R_RefillIronMine, 0);
    end
end
API.RequireTitleToRefilIronMines = RequireTitleToRefilIronMines;

--- Allows or forbids to refill stone mines.
--- 
--- #### Requires Addon!
--- @param _PlayerID integer ID of player
--- @param _Allowed boolean  Activation is allowed
function AllowActivateStoneMines(_PlayerID, _Allowed)
    assert(not IsLocalScript(), "Can not be used in local script!");
    Logic.TechnologySetState(_PlayerID, Technologies.R_RefillStoneMine, (_Allowed and 3 or 1));
end
API.AllowActivateStoneMines = AllowActivateStoneMines;

--- Sets the required title to refill stone quarries.
--- 
--- #### Requires Addon!
--- @param _Title integer  Knight title
function RequireTitleToRefilStoneMines(_Title)
    assert(not IsLocalScript(), "Can not be used in local script!");
    ExecuteLocal([[
        table.insert(NeedsAndRightsByKnightTitle[%d][4], Technologies.R_RefillStoneMine)
        CreateTechnologyKnightTitleTable()
    ]], _Title);
    table.insert(NeedsAndRightsByKnightTitle[_Title][4], Technologies.R_RefillStoneMine);
    CreateTechnologyKnightTitleTable()
    for i= 1, 8 do
        Logic.TechnologySetState(i, Technologies.R_RefillStoneMine, 0);
    end
end
API.RequireTitleToRefilStoneMines = RequireTitleToRefilStoneMines;

--- Allows or forbids to refill cisterns.
--- 
--- #### Requires Addon!
--- @param _PlayerID integer ID of player
--- @param _Allowed boolean  Activation is allowed
function AllowActivateCisterns(_PlayerID, _Allowed)
    assert(not IsLocalScript(), "Can not be used in local script!");
    Logic.TechnologySetState(_PlayerID, Technologies.R_RefillCistern, (_Allowed and 3 or 1));
end
API.AllowActivateCisterns = AllowActivateCisterns;

--- Sets the required title to refill cisterns.
--- 
--- #### Requires Addon!
--- @param _Title integer  Knight title
function RequireTitleToRefilCisterns(_Title)
    assert(not IsLocalScript(), "Can not be used in local script!");
    ExecuteLocal([[
        table.insert(NeedsAndRightsByKnightTitle[%d][4], Technologies.R_RefillCisternMine)
        CreateTechnologyKnightTitleTable()
    ]], _Title);
    table.insert(NeedsAndRightsByKnightTitle[_Title][4], Technologies.R_RefillCisternMine);
    CreateTechnologyKnightTitleTable()
    for i= 1, 8 do
        Logic.TechnologySetState(i, Technologies.R_RefillCisternMine, 0);
    end
end
API.RequireTitleToRefilCisterns = RequireTitleToRefilCisterns;

--- Allows or forbids to build tradeposts.
--- 
--- #### Requires Addon!
--- @param _PlayerID integer ID of player
--- @param _Allowed boolean  Activation is allowed
function AllowActivateTradepost(_PlayerID, _Allowed)
    assert(not IsLocalScript(), "Can not be used in local script!");
    Logic.TechnologySetState(_PlayerID, Technologies.R_Tradepost, (_Allowed and 3 or 1));
end
API.AllowActivateTradepost = AllowActivateTradepost;

--- Sets the required title to build tradeposts.
--- 
--- #### Requires Addon!
--- @param _Title integer  Knight title
function RequireTitleToBuildTradeposts(_Title)
    assert(not IsLocalScript(), "Can not be used in local script!");
    ExecuteLocal([[
        table.insert(NeedsAndRightsByKnightTitle[%d][4], Technologies.R_Tradepost)
        CreateTechnologyKnightTitleTable()
    ]], _Title);
    table.insert(NeedsAndRightsByKnightTitle[_Title][4], Technologies.R_Tradepost);
    CreateTechnologyKnightTitleTable();
    for i= 1, 8 do
        Logic.TechnologySetState(i, Technologies.R_Tradepost, 0);
    end
end
API.RequireTitleToBuildTradeposts = RequireTitleToBuildTradeposts;

--- Activates an interactive object.
--- @param _ScriptName string Script name of entity
--- @param _State integer     Interactable state
--- @param ... integer        List of player IDs
InteractiveObjectActivate = function(_ScriptName, _State, ...)
    arg = arg or {1};
    if not IsLocalScript() then
        if CONST_IO[_ScriptName] then
            local SlaveName = (CONST_IO[_ScriptName].Slave or _ScriptName);
            if CONST_IO[_ScriptName].Slave then
                CONST_IO_SLAVE_STATE[SlaveName] = 1;
                Logic.ExecuteInLuaLocalState(string.format(
                    [[CONST_IO_SLAVE_STATE["%s"] = 1]],
                    SlaveName
                ));
            end
            Lib.IO.Global:SetObjectState(SlaveName, _State, unpack(arg));
            CONST_IO[_ScriptName].IsActive = true;
            ExecuteLocal([[CONST_IO["%s"].IsActive = true]], _ScriptName);
        else
            Lib.IO.Global:SetObjectState(_ScriptName, _State, unpack(arg));
        end
    end
end
API.InteractiveObjectActivate = InteractiveObjectActivate;

--- Deactivates an interactive object.
--- @param _ScriptName string Script name of entity
--- @param ... integer        List of player IDs
InteractiveObjectDeactivate = function(_ScriptName, ...)
    arg = arg or {1};
    if not IsLocalScript() then
        if CONST_IO[_ScriptName] then
            local SlaveName = (CONST_IO[_ScriptName].Slave or _ScriptName);
            if CONST_IO[_ScriptName].Slave then
                CONST_IO_SLAVE_STATE[SlaveName] = 0;
                Logic.ExecuteInLuaLocalState(string.format(
                    [[CONST_IO_SLAVE_STATE["%s"] = 0]],
                    SlaveName
                ));
            end
            Lib.IO.Global:SetObjectState(SlaveName, 2, unpack(arg));
            CONST_IO[_ScriptName].IsActive = false;
            ExecuteLocal([[CONST_IO["%s"].IsActive = false]], _ScriptName);
        else
            Lib.IO.Global:SetObjectState(_ScriptName, 2, unpack(arg));
        end
    end
end
API.InteractiveObjectDeactivate = InteractiveObjectDeactivate;
