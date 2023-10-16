Lib.Require("comfort/IsLocalScript");
Lib.Register("module/uibuilding/UIBuilding_API");

--- Creates a building button at the menu position.
--- @param _X integer X position for button
--- @param _Y integer X position for button
--- @param _Action function Button action controller
--- @param _Tooltip function Button tooltip controller
--- @param _Update function Button update controller
--- @return integer ID ID of button
function AddBuildingButtonAtPosition(_X, _Y, _Action, _Tooltip, _Update)
    return Lib.UIBuilding.Local:AddButtonBinding(0, _X, _Y, _Action, _Tooltip, _Update);
end
API.AddBuildingButtonAtPosition = AddBuildingButtonAtPosition;

--- Creates a building button.
---
--- #### Examples
--- ```lua
--- -- Example #1: A simple button
--- SpecialButtonID = AddBuildingButton(
---     -- Aktion
---     function(_WidgetID, _BuildingID)
---         GUI.AddNote("Something happens!");
---     end,
---     -- Tooltip
---     function(_WidgetID, _BuildingID)
---         -- Es MUSS ein Kostentooltip verwendet werden.
---         SetTooltipCosts("Description", "This is the description!");
---     end,
---     -- Update
---     function(_WidgetID, _BuildingID)
---         -- Disable for when under construction
---         if Logic.IsConstructionComplete(_BuildingID) == 0 then
---             XGUIEng.ShowWidget(_WidgetID, 0);
---             return;
---         end
---         -- Disable for when being upgraded
---         if Logic.IsBuildingBeingUpgraded(_BuildingID) then
---             XGUIEng.DisableButton(_WidgetID, 1);
---         end
---         SetIcon(_WidgetID, {1, 1});
---     end
--- );
--- ```
---
--- @param _Action function Button action controller
--- @param _Tooltip function Button tooltip controller
--- @param _Update function Button update controller
--- @return integer ID ID of button
function AddBuildingButton(_Action, _Tooltip, _Update)
    ---@diagnostic disable-next-line: param-type-mismatch
    return AddBuildingButtonAtPosition(nil, nil, _Action, _Tooltip, _Update);
end
API.AddBuildingButton = AddBuildingButton;

--- Creates a building button at the menu position for a entity type.
--- @param _Type integer Type of entity
--- @param _X integer X position for button
--- @param _Y integer Y position for button
--- @param _Action function Button action controller
--- @param _Tooltip function Button tooltip controller
--- @param _Update function Button update controller
--- @return integer ID ID of button
function AddBuildingButtonByTypeAtPosition(_Type, _X, _Y, _Action, _Tooltip, _Update)
    return Lib.UIBuilding.Local:AddButtonBinding(_Type, _X, _Y, _Action, _Tooltip, _Update);
end
API.AddBuildingButtonByTypeAtPosition = AddBuildingButtonByTypeAtPosition;

--- Creates a building button for a entity type.
--- @param _Type integer Type of entity
--- @param _Action function Button action controller
--- @param _Tooltip function Button tooltip controller
--- @param _Update function Button update controller
--- @return integer ID ID of button
function AddBuildingButtonByType(_Type, _Action, _Tooltip, _Update)
    ---@diagnostic disable-next-line: param-type-mismatch
    return AddBuildingButtonByTypeAtPosition(_Type, nil, nil, _Action, _Tooltip, _Update);
end
API.AddBuildingButtonByType = AddBuildingButtonByType;

--- Creates a building button at the menu position for a specific entity.
--- @param _ScriptName string Script name of entity
--- @param _X integer X position for button
--- @param _Y integer X position for button
--- @param _Action function Button action controller
--- @param _Tooltip function Button tooltip controller
--- @param _Update function Button update controller
--- @return integer ID ID of button
function AddBuildingButtonByEntityAtPosition(_ScriptName, _X, _Y, _Action, _Tooltip, _Update)
    return Lib.UIBuilding.Local:AddButtonBinding(_ScriptName, _X, _Y, _Action, _Tooltip, _Update);
end
API.AddBuildingButtonByEntityAtPosition = AddBuildingButtonByEntityAtPosition;

--- Creates a building button for a specific entity.
--- @param _ScriptName string Script name of entity
--- @param _Action function Button action controller
--- @param _Tooltip function Button tooltip controller
--- @param _Update function Button update controller
--- @return integer ID ID of button
function AddBuildingButtonByEntity(_ScriptName, _Action, _Tooltip, _Update)
    ---@diagnostic disable-next-line: param-type-mismatch
    return AddBuildingButtonByEntityAtPosition(_ScriptName, nil, nil, _Action, _Tooltip, _Update);
end
API.AddBuildingButtonByEntity = AddBuildingButtonByEntity;

--- Removes a building button.
--- @param _ID integer ID of button
function DropBuildingButton(_ID)
    Lib.UIBuilding.Local:RemoveButtonBinding(0, _ID);
end
API.DropBuildingButton = DropBuildingButton;

--- Removes a building button for the entity type.
--- @param _Type integer Type of entity
--- @param _ID integer ID of button
function DropBuildingButtonFromType(_Type, _ID)
    Lib.UIBuilding.Local:RemoveButtonBinding(_Type, _ID);
end
API.DropBuildingButtonFromType = DropBuildingButtonFromType;

--- Removes a building button for a specific entity.
--- @param _ScriptName string Script name of entity
--- @param _ID integer ID of button
function DropBuildingButtonFromEntity(_ScriptName, _ID)
    Lib.UIBuilding.Local:RemoveButtonBinding(_ScriptName, _ID);
end
API.DropBuildingButtonFromEntity = DropBuildingButtonFromEntity;

