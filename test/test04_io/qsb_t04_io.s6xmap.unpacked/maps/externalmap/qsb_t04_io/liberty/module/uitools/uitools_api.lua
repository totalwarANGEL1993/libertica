Lib.Require("comfort/IsLocalScript");
Lib.Register("module/uitools/UITools_API");

--- Sets an icon from an icon matrix.
---
--- It is possible to use a custom icon matrix. Files must be copied to gui_768,
--- gui_920 and gui_1200 and scaled to the appropiate size. Files must be packed
--- to graphics/textures inside the map archive.
---
--- There are 3 different icon sizes. For each size the game enginge searches
--- for a different file:
--- * 44:  [filename].png
--- * 64:  [filename]big.png
--- * 128: [filename]verybig.png
---
--- @param _WidgetID any Path or ID of widget
--- @param _Coordinates table Table with coordinates
--- @param _Size? number Optional icon size
--- @param _Name? string Optional icon file
function ChangeIcon(_WidgetID, _Coordinates, _Size, _Name)
    assert(IsLocalScript(), "Can only be done in local script!");
    _Coordinates = _Coordinates or {10, 14};
    Lib.UITools.Widget:SetIcon(_WidgetID, _Coordinates, _Size, _Name);
end

--- Changes the description of a button or icon.
--- @param _Title any Title text or localized table
--- @param _Text any Text or localized table
--- @param _DisabledText any Text or localized table
function SetTooltipNormal(_Title, _Text, _DisabledText)
    assert(IsLocalScript(), "Can only be done in local script!");
    Lib.UITools.Widget:TooltipNormal(_Title, _Text, _DisabledText);
end

--- Changes the description of a button or icon with additional costs.
--- @param _Title any Title text or localized table
--- @param _Text any Text or localized table
--- @param _DisabledText any Text or localized table
--- @param _Costs table Table with costs
--- @param _InSettlement boolean Check all sources in settlement
function SetTooltipCosts(_Title, _Text, _DisabledText, _Costs, _InSettlement)
    assert(IsLocalScript(), "Can only be done in local script!");
    Lib.UITools.Widget:TooltipCosts(_Title,_Text,_DisabledText,_Costs,_InSettlement);
end

--- Changes the visibility of the minimap.
--- @param _Flag boolean Widget is hidden
function HideMinimap(_Flag)
    if not IsLocalScript() then
        ExecuteLocal("HideMinimap(%s)", tostring(_Flag));
        return;
    end
    Lib.UITools.Widget:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/MapFrame/Minimap/MinimapOverlay",_Flag);
    Lib.UITools.Widget:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/MapFrame/Minimap/MinimapTerrain",_Flag);
end

--- Changes the visibility of the minimap button.
--- @param _Flag boolean Widget is hidden
function HideToggleMinimap(_Flag)
    if not IsLocalScript() then
        ExecuteLocal("HideToggleMinimap(%s)", tostring(_Flag));
        return;
    end
    Lib.UITools.Widget:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/MapFrame/MinimapButton",_Flag);
end

--- Changes the visibility of the diplomacy menu button.
--- @param _Flag boolean Widget is hidden
function HideDiplomacyMenu(_Flag)
    if not IsLocalScript() then
        ExecuteLocal("HideDiplomacyMenu(%s)", tostring(_Flag));
        return;
    end
    Lib.UITools.Widget:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/MapFrame/DiplomacyMenuButton",_Flag);
end

--- Changes the visibility of the produktion menu button.
--- @param _Flag boolean Widget is hidden
function HideProductionMenu(_Flag)
    if not IsLocalScript() then
        ExecuteLocal("HideProductionMenu(%s)", tostring(_Flag));
        return;
    end
    Lib.UITools.Widget:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/MapFrame/ProductionMenuButton",_Flag);
end

--- Changes the visibility of the weather menu button.
--- @param _Flag boolean Widget is hidden
function HideWeatherMenu(_Flag)
    if not IsLocalScript() then
        ExecuteLocal("HideWeatherMenu(%s)", tostring(_Flag));
        return;
    end
    Lib.UITools.Widget:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/MapFrame/WeatherMenuButton",_Flag);
end

--- Changes the visibility of the territory button.
--- @param _Flag boolean Widget is hidden
function HideBuyTerritory(_Flag)
    if not IsLocalScript() then
        ExecuteLocal("HideBuyTerritory(%s)", tostring(_Flag));
        return;
    end
    Lib.UITools.Widget:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/DialogButtons/Knight/ClaimTerritory",_Flag);
end

--- Changes the visibility of the knight ability button.
--- @param _Flag boolean Widget is hidden
function HideKnightAbility(_Flag)
    if not IsLocalScript() then
        ExecuteLocal("HideKnightAbility(%s)", tostring(_Flag));
        return;
    end
    Lib.UITools.Widget:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/DialogButtons/Knight/StartAbilityProgress",_Flag);
    Lib.UITools.Widget:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/DialogButtons/Knight/StartAbility",_Flag);
end

--- Changes the visibility of the knight selection button.
--- @param _Flag boolean Widget is hidden
function HideKnightButton(_Flag)
    if not IsLocalScript() then
        ExecuteLocal("HideKnightButton(%s)", tostring(_Flag));
        Logic.SetEntitySelectableFlag("..KnightID..", (_Flag and 0) or 1);
        return;
    end
    local KnightID = Logic.GetKnightID(GUI.GetPlayerID());
    if _Flag then
        GUI.DeselectEntity(KnightID);
    end
    Lib.UITools.Widget:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/MapFrame/KnightButtonProgress",_Flag);
    Lib.UITools.Widget:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/MapFrame/KnightButton",_Flag);
end

--- Changes the visibility of the select military button.
--- @param _Flag boolean Widget is hidden
function HideSelectionButton(_Flag)
    if not IsLocalScript() then
        ExecuteLocal("HideSelectionButton(%s)", tostring(_Flag));
        return;
    end
    HideKnightButton(_Flag);
    GUI.ClearSelection();
    Lib.UITools.Widget:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/MapFrame/BattalionButton",_Flag);
end

--- Changes the visibility of the build menu.
--- @param _Flag boolean Widget is hidden
function HideBuildMenu(_Flag)
    if not IsLocalScript() then
        ExecuteLocal("HideBuildMenu(%s)", tostring(_Flag));
        return;
    end
    Lib.UITools.Widget:DisplayInterfaceButton("/InGame/Root/Normal/AlignBottomRight/BuildMenu", _Flag);
end

--- Adds a new shortcut description.
--- @param _Key string Key of shortcut
--- @param _Description any Text or localized table
--- @return integer ID ID of description
function AddShortcutDescription(_Key, _Description)
    if not IsLocalScript() then
        return -1;
    end
    g_KeyBindingsOptions.Descriptions = nil;
    for i= 1, #Lib.UITools.Shortcut.HotkeyDescriptions do
        if Lib.UITools.Shortcut.HotkeyDescriptions[i][1] == _Key then
            return -1;
        end
    end
    local ID = #Lib.UITools.Shortcut.HotkeyDescriptions+1;
    table.insert(Lib.UITools.Shortcut.HotkeyDescriptions, {ID = ID, _Key, _Description});
    return #Lib.UITools.Shortcut.HotkeyDescriptions;
end

--- Removes the shortcut description with the ID.
--- @param _ID number ID of shortcut
function RemoveShortcutDescription(_ID)
    if not IsLocalScript() then
        return;
    end
    g_KeyBindingsOptions.Descriptions = nil;
    for k, v in pairs(Lib.UITools.Shortcut.HotkeyDescriptions) do
        if v.ID == _ID then
            Lib.UITools.Shortcut.HotkeyDescriptions[k] = nil;
        end
    end
end

--- Activates or deactivates the forced speed 1.
--- @param _Flag boolean Is active
function SpeedLimitActivate(_Flag)
    if IsLocalScript() or Framework.IsNetworkGame() then
        return;
    end
    return ExecuteLocal(
        "Lib.UITools.Speed:ActivateSpeedLimit(%s)",
        tostring(_Flag)
    );
end

--- Returns the name of the territory.
--- @param _TerritoryID number ID of territory
--- @return string Name Name of territory
function GetTerritoryName(_TerritoryID)
    local Name = Logic.GetTerritoryName(_TerritoryID);
    local MapType = Framework.GetCurrentMapTypeAndCampaignName();
    if MapType == 1 or MapType == 3 then
        return Name;
    end

    local MapName = Framework.GetCurrentMapName();
    local StringTable = "Map_" .. MapName;
    local TerritoryName = string.gsub(Name, " ","");
    TerritoryName = XGUIEng.GetStringTableText(StringTable .. "/Territory_" .. TerritoryName);
    if TerritoryName == "" then
        TerritoryName = Name .. "(key?)";
    end
    return TerritoryName;
end

--- Returns the name of the player.
--- @param _PlayerID number ID of player
--- @return string Name Name of player
function GetPlayerName(_PlayerID)
    local PlayerName = Logic.GetPlayerName(_PlayerID);
    local name = CONST_PLAYER_NAMES[_PlayerID];
    if name ~= nil and name ~= "" then
        PlayerName = name;
    end

    local MapType = Framework.GetCurrentMapTypeAndCampaignName();
    local MutliplayerMode = Framework.GetMultiplayerMapMode(Framework.GetCurrentMapName(), MapType);

    if MutliplayerMode > 0 then
        return PlayerName;
    end
    if MapType == 1 or MapType == 3 then
        local PlayerNameTmp, PlayerHeadTmp, PlayerAITmp = Framework.GetPlayerInfo(_PlayerID);
        if PlayerName ~= "" then
            return PlayerName;
        end
        return PlayerNameTmp;
    end
    return PlayerName;
end

---Changes the name of a player.
---@param _PlayerID number ID of player
---@param _Name string Player name
function SetPlayerName(_PlayerID, _Name)
    assert(type(_PlayerID) == "number");
    assert(type(_Name) == "string");
    if not IsLocalScript() then
        ExecuteLocal([[SetPlayerName(%d, "%s")]], _PlayerID, _Name);
        return;
    end
    GUI_MissionStatistic.PlayerNames[_PlayerID] = _Name
    CONST_PLAYER_NAMES[_PlayerID] = _Name;
end

--- Changes the color of a player.
--- @param _PlayerID number ID of player
--- @param _Color any Name or ID of color
--- @param _Logo? number ID of logo
--- @param _Pattern? number ID of pattern
function SetPlayerColor(_PlayerID, _Color, _Logo, _Pattern)
    assert(not IsLocalScript(), "Player color must be set from logic!");
    g_ColorIndex["ExtraColor1"] = g_ColorIndex["ExtraColor1"] or 16;
    g_ColorIndex["ExtraColor2"] = g_ColorIndex["ExtraColor2"] or 17;

    local Col     = (type(_Color) == "string" and g_ColorIndex[_Color]) or _Color;
    local Logo    = _Logo or -1;
    local Pattern = _Pattern or -1;
    Logic.PlayerSetPlayerColor(_PlayerID, Col, Logo, Pattern);
    ExecuteLocal([[
        Display.UpdatePlayerColors()
        GUI.RebuildMinimapTerrain()
        GUI.RebuildMinimapTerritory()
    ]]);
end

--- Changes the portrait of a player.
--- @param _PlayerID number  ID of player
--- @param _Portrait? string Name of model
function SetPlayerPortrait(_PlayerID, _Portrait)
    assert(_PlayerID < 1 or _PlayerID > 8, "Invalid player ID!");
    if not IsLocalScript then
        local Portrait = (_Portrait ~= nil and "'" .._Portrait.. "'") or "nil";
        ExecuteLocal("SetPlayerPortrait(%d, %s)", _PlayerID, Portrait)
        return;
    end
    if _Portrait == nil then
        Lib.UITools.Player:SetPlayerPortraitByPrimaryKnight(_PlayerID);
    elseif _Portrait ~= nil and IsExisting(_Portrait) then
        Lib.UITools.Player:SetPlayerPortraitBySettler(_PlayerID, _Portrait);
    else
        Lib.UITools.Player:SetPlayerPortraitByModelName(_PlayerID, _Portrait);
    end
end

