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
-- Steal my IP and I'll sue you!

Lib.Require("core/feature/Report");
Lib.Require("core/feature/Job");
Lib.Register("core/feature/Save");

LibertyCore.Save = {
    HistoryEditionQuickSave = false,
    SavingDisabled = false,
    LoadingDisabled = false,
};

-- -------------------------------------------------------------------------- --

--- Deactivates the autosave of the History Edition.
--- @param _Flag boolean Auto save is disabled
function DisableAutoSave(_Flag)
    if not IsLocalScript() then
        LibertyCore.Save.HistoryEditionQuickSave = _Flag == true;
        ExecuteLocal([[LibertyCore.Save.HistoryEditionQuickSave = %s]], tostring(_Flag == true))
    end
end

--- Deactivates saving the game.
--- @param _Flag boolean Saving is disabled
function DisableSaving(_Flag)
    LibertyCore.Save:DisableSaving(_Flag);
end

--- Deactivates loading of savegames.
--- @param _Flag boolean Loading is disabled
function DisableLoading(_Flag)
    LibertyCore.Save:DisableLoading(_Flag);
end

-- -------------------------------------------------------------------------- --

function LibertyCore.Save:Initalize()
    Report.SaveGameLoaded = CreateReport("Event_SaveGameLoaded");

    self:SetupQuicksaveKeyCallback();
    self:SetupQuicksaveKeyTrigger();
end

function LibertyCore.Save:OnSaveGameLoaded()
    self:SetupQuicksaveKeyTrigger();
    self:UpdateLoadButtons();
    self:UpdateSaveButtons();

    SendReport(Report.SaveGameLoaded);
end

-- -------------------------------------------------------------------------- --

function LibertyCore.Save:SetupQuicksaveKeyTrigger()
    if IsLocalScript() then
        RequestHiResJob(
            function()
                Input.KeyBindDown(
                    Keys.ModifierControl + Keys.S,
                    "KeyBindings_SaveGame(true)",
                    2,
                    false
                );
                return true;
            end
        );
    end
end

function LibertyCore.Save:SetupQuicksaveKeyCallback()
    if IsLocalScript() then
        KeyBindings_SaveGame_Orig_Swift = KeyBindings_SaveGame;
        KeyBindings_SaveGame = function(...)
            -- No quicksave if saving disabled
            if LibertyCore.Save.SavingDisabled then
                return;
            end
            -- No quicksave if forced by History Edition
            if not LibertyCore.Save.HistoryEditionQuickSave and not arg[1] then
                return;
            end
            -- Do quicksave
            KeyBindings_SaveGame_Orig_Swift();
        end
    end
end

function LibertyCore.Save:DisableSaving(_Flag)
    self.SavingDisabled = _Flag == true;
    if not IsLocalScript() then
        ExecuteLocal([[LibertyCore.Save:DisableSaving(%s)]],tostring(_Flag));
    else
        self:UpdateSaveButtons();
    end
end

function LibertyCore.Save:UpdateSaveButtons()
    if IsLocalScript() then
        local VisibleFlag = (self.SavingDisabled and 0) or 1;
        XGUIEng.ShowWidget("/InGame/InGame/MainMenu/Container/QuickSave", VisibleFlag);
        XGUIEng.ShowWidget("/InGame/InGame/MainMenu/Container/SaveGame", VisibleFlag);
    end
end

function LibertyCore.Save:DisableLoading(_Flag)
    self.LoadingDisabled = _Flag == true;
    if not IsLocalScript() then
        ExecuteLocal([[LibertyCore.Save:DisableLoading(%s)]],tostring(_Flag));
    else
        self:UpdateLoadButtons();
    end
end

function LibertyCore.Save:UpdateLoadButtons()
    if IsLocalScript() then
        local VisibleFlag = (self.LoadingDisabled and 0) or 1;
        XGUIEng.ShowWidget("/InGame/InGame/MainMenu/Container/LoadGame", VisibleFlag);
        XGUIEng.ShowWidget("/InGame/InGame/MainMenu/Container/QuickLoad", VisibleFlag);
    end
end

