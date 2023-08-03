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

LibertyCore = {
    Global = {
        ScriptCommandRegister = {},
        ScriptCommandSequence = 0,
        IsInstalled = false;
    },
    Local = {
        IsInstalled = false;
    },
}

Report = {};
Command = {};
QSB = {};

Lib.Require("comfort/IsHistoryEdition");
Lib.Require("comfort/IsMultiplayer");
Lib.Require("comfort/IsLocalScript");

Lib.Require("core/feature/Logging");
Lib.Require("core/feature/Debug");
Lib.Require("core/feature/LuaExtension");
Lib.Require("core/feature/Report");
Lib.Require("core/feature/Text");
Lib.Require("core/feature/Job");
Lib.Require("core/feature/Save");
Lib.Require("core/feature/Quest");
Lib.Require("core/feature/Chat");
Lib.Require("core/feature/Debug");

Lib.Register("core/LibertyCore");

-- -------------------------------------------------------------------------- --

function LibertyCore.Global:Initialize()
    if not self.IsInstalled then
        self:OverrideOnSaveGameLoaded();

        -- Init base features
        LibertyCore.Logging:Initialize();
        LibertyCore.LuaExtension:Initialize();
        LibertyCore.Report:Initialize();
        LibertyCore.Text:Initialize();
        LibertyCore.Job:Initialize();
        LibertyCore.ScriptingValue:Initialize();
        LibertyCore.Save:Initialize();
        LibertyCore.Quest:Initialize();
        LibertyCore.Chat:Initialize();
        LibertyCore.Debug:Initialize();
        -- Cleanup (garbage collection)
        LibertyCore.Local = nil;
    end
    self.IsInstalled = true;
end

function LibertyCore.Global:OnSaveGameLoaded()
    LibertyCore.Logging:OnSaveGameLoaded();
    LibertyCore.LuaExtension:OnSaveGameLoaded();
    LibertyCore.Report:OnSaveGameLoaded();
    LibertyCore.Text:OnSaveGameLoaded();
    LibertyCore.Job:OnSaveGameLoaded();
    LibertyCore.ScriptingValue:OnSaveGameLoaded();
    LibertyCore.Save:OnSaveGameLoaded();
    LibertyCore.Quest:OnSaveGameLoaded();
    LibertyCore.Chat:OnSaveGameLoaded();
    LibertyCore.Debug:OnSaveGameLoaded();
end

function LibertyCore.Global:OverrideOnSaveGameLoaded()
    Mission_OnSaveGameLoaded_Orig_Liberty = Mission_OnSaveGameLoaded;
    Mission_OnSaveGameLoaded = function()
        LibertyCore.Global:ExecuteLocal("LibertyCore.Local:OnSaveGameLoaded()");
        LibertyCore.Global:OnSaveGameLoaded();
    end
end

function LibertyCore.Global:ExecuteLocal(_Command, ...)
    local Command = _Command;
    if #arg > 0 then
        Command = Command:format(unpack(arg));
    end
    Logic.ExecuteInLuaLocalState(_Command);
end

-- -------------------------------------------------------------------------- --

function LibertyCore.Local:Initialize()
    if not self.IsInstalled then
        -- Init base features
        LibertyCore.Logging:Initialize();
        LibertyCore.LuaExtension:Initialize();
        LibertyCore.Report:Initialize();
        LibertyCore.Text:Initialize();
        LibertyCore.Job:Initialize();
        LibertyCore.ScriptingValue:Initialize();
        LibertyCore.Save:Initialize();
        LibertyCore.Quest:Initialize();
        LibertyCore.Chat:Initialize();
        LibertyCore.Debug:Initialize();
        -- Cleanup (garbage collection)
        LibertyCore.Global = nil;
    end
    self.IsInstalled = true;
end

function LibertyCore.Local:OnSaveGameLoaded()
    LibertyCore.Logging:OnSaveGameLoaded();
    LibertyCore.LuaExtension:OnSaveGameLoaded();
    LibertyCore.Report:OnSaveGameLoaded();
    LibertyCore.Text:OnSaveGameLoaded();
    LibertyCore.Job:OnSaveGameLoaded();
    LibertyCore.ScriptingValue:OnSaveGameLoaded();
    LibertyCore.Save:OnSaveGameLoaded();
    LibertyCore.Quest:OnSaveGameLoaded();
    LibertyCore.Chat:OnSaveGameLoaded();
    LibertyCore.Debug:OnSaveGameLoaded();

    SendReport(Report.SaveGameLoaded);
end

function LibertyCore.Local:ExecuteGlobal(_Command, ...)
    local Command = _Command;
    assert(
        not (IsHistoryEdition() and IsMultiplayer()),
        "Script command is not allowed in history edition multiplayer."
    );
    if #arg > 0 then
        Command = Command:format(unpack(arg));
    end
    GUI.SendScriptCommand(Command);
end

-- -------------------------------------------------------------------------- --

--- Executes dynamic lua in the local script.
--- @param _Command string Lua string
--- @param ... unknown Replacement values
function ExecuteLocal(_Command, ...)
    LibertyCore.Global:ExecuteLocal(_Command, unpack(arg));
end

--- Executes dynamic lua in the global script.
--- @param _Command string Lua string
--- @param ... unknown Replacement values
function ExecuteGlobal(_Command, ...)
    assert(IsLocalScript(), "Can not be used in global script.");
    LibertyCore.Local:ExecuteGlobal(_Command, unpack(arg));
end

