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

Lib.Core = Lib.Core or {
    ModuleList = {},
    Global = {
        IsInstalled = false,
    },
    Local = {
        IsInstalled = false;
    }
}

Lib.Require("comfort/IsHistoryEdition");
Lib.Require("comfort/IsMultiplayer");
Lib.Require("comfort/IsLocalScript");

Lib.Require("core/feature/Core_Logging");
Lib.Require("core/feature/Core_Debug");
Lib.Require("core/feature/Core_LuaExtension");
Lib.Require("core/feature/Core_Report");
Lib.Require("core/feature/Core_ScriptingValue");
Lib.Require("core/feature/Core_Text");
Lib.Require("core/feature/Core_Job");
Lib.Require("core/feature/Core_Save");
Lib.Require("core/feature/Core_Quest");
Lib.Require("core/feature/Core_Chat");
Lib.Require("core/feature/Core_Debug");

Lib.Register("core/Core");

-- -------------------------------------------------------------------------- --

function Lib.Core.Global:Initialize()
    if not self.IsInstalled then
        self:OverrideOnSaveGameLoaded();

        -- Init base features
        Lib.Core.Logging:Initialize();
        Lib.Core.LuaExtension:Initialize();
        Lib.Core.Report:Initialize();
        Lib.Core.Text:Initialize();
        Lib.Core.Job:Initialize();
        Lib.Core.ScriptingValue:Initialize();
        Lib.Core.Save:Initialize();
        Lib.Core.Quest:Initialize();
        Lib.Core.Chat:Initialize();
        Lib.Core.Debug:Initialize();

        -- Load user files
        if GameCallback_Lib_GetExternFilesToLoad then
            local Files = GameCallback_Lib_GetExternFilesToLoad();
            for i= 1, #Files do
                Script.Load(Files);
            end
        end

        -- Initialize modules
        for i= 1, #Lib.Core.ModuleList do
            local Module = Lib[Lib.Core.ModuleList[i]];
            if Module.Global and Module.Global.Initialize then
                Module.Global:Initialize();
            end
        end

        -- Loading finished callback
        if GameCallback_Lib_LoadingFinished then
            GameCallback_Lib_LoadingFinished();
        end

        -- Cleanup (garbage collection)
        Lib.Core.Local = nil;
    end
    self.IsInstalled = true;
end

function Lib.Core.Global:OnSaveGameLoaded()
    Lib.Core.Logging:OnSaveGameLoaded();
    Lib.Core.LuaExtension:OnSaveGameLoaded();
    Lib.Core.Report:OnSaveGameLoaded();
    Lib.Core.Text:OnSaveGameLoaded();
    Lib.Core.Job:OnSaveGameLoaded();
    Lib.Core.ScriptingValue:OnSaveGameLoaded();
    Lib.Core.Save:OnSaveGameLoaded();
    Lib.Core.Quest:OnSaveGameLoaded();
    Lib.Core.Chat:OnSaveGameLoaded();
    Lib.Core.Debug:OnSaveGameLoaded();

    -- Restore modules
    for i= 1, #Lib.Core.ModuleList do
        local Module = Lib[Lib.Core.ModuleList[i]];
        if Module.Global and Module.Global.OnSaveGameLoaded then
            Module.Global:OnSaveGameLoaded();
        end
    end
end

function Lib.Core.Global:OverrideOnSaveGameLoaded()
    Mission_OnSaveGameLoaded_Orig_Liberty = Mission_OnSaveGameLoaded;
    Mission_OnSaveGameLoaded = function()
        Lib.Core.Global:ExecuteLocal("Lib.Core.Local:OnSaveGameLoaded()");
        Lib.Core.Global:OnSaveGameLoaded();
    end
end

function Lib.Core.Global:ExecuteLocal(_Command, ...)
    local Command = _Command;
    if #arg > 0 then
        Command = Command:format(unpack(arg));
    end
    Logic.ExecuteInLuaLocalState(Command);
end

-- -------------------------------------------------------------------------- --

function Lib.Core.Local:Initialize()
    if not self.IsInstalled then
        -- Init base features
        Lib.Core.Logging:Initialize();
        Lib.Core.LuaExtension:Initialize();
        Lib.Core.Report:Initialize();
        Lib.Core.Text:Initialize();
        Lib.Core.Job:Initialize();
        Lib.Core.ScriptingValue:Initialize();
        Lib.Core.Save:Initialize();
        Lib.Core.Quest:Initialize();
        Lib.Core.Chat:Initialize();
        Lib.Core.Debug:Initialize();

        -- Load user files
        if GameCallback_Lib_GetExternFilesToLoad then
            local Files = GameCallback_Lib_GetExternFilesToLoad();
            for i= 1, #Files do
                Script.Load(Files);
            end
        end

        -- Initialize modules
        for i= 1, #Lib.Core.ModuleList do
            local Module = Lib[Lib.Core.ModuleList[i]];
            if Module.Local and Module.Local.Initialize then
                Module.Local:Initialize();
            end
        end

        -- Loading finished callback
        if GameCallback_Lib_LoadingFinished then
            GameCallback_Lib_LoadingFinished();
        end

        -- Cleanup (garbage collection)
        Lib.Core.Global = nil;
    end
    self.IsInstalled = true;
end

function Lib.Core.Local:OnSaveGameLoaded()
    Lib.Core.Logging:OnSaveGameLoaded();
    Lib.Core.LuaExtension:OnSaveGameLoaded();
    Lib.Core.Report:OnSaveGameLoaded();
    Lib.Core.Text:OnSaveGameLoaded();
    Lib.Core.Job:OnSaveGameLoaded();
    Lib.Core.ScriptingValue:OnSaveGameLoaded();
    Lib.Core.Save:OnSaveGameLoaded();
    Lib.Core.Quest:OnSaveGameLoaded();
    Lib.Core.Chat:OnSaveGameLoaded();
    Lib.Core.Debug:OnSaveGameLoaded();

    -- Restore modules
    for i= 1, #Lib.Core.ModuleList do
        local Module = Lib[Lib.Core.ModuleList[i]];
        if Module.Local and Module.Local.OnSaveGameLoaded then
            Module.Local:OnSaveGameLoaded();
        end
    end

    SendReport(Report.SaveGameLoaded);
end

function Lib.Core.Local:ExecuteGlobal(_Command, ...)
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

--- Initializes the whole library.
function Liberate()
    assert(not IsLocalScript(), "Must be called from global script!");
    Lib.Core.Global:Initialize();
    ExecuteLocal("Lib.Core.Local:Initialize()");
end

--- Register a module in the module list.
--- @param _Name string Name of module
function RegisterModule(_Name)
    assert(Lib[_Name], "Module '" .._Name.. "' does not exist!");
    table.insert(Lib.Core.ModuleList, _Name);
end

--- Executes dynamic lua in the local script.
--- @param _Command string Lua string
--- @param ... unknown Replacement values
function ExecuteLocal(_Command, ...)
    Lib.Core.Global:ExecuteLocal(_Command, unpack(arg));
end

--- Executes dynamic lua in the global script.
--- @param _Command string Lua string
--- @param ... unknown Replacement values
function ExecuteGlobal(_Command, ...)
    assert(IsLocalScript(), "Can not be used in global script.");
    Lib.Core.Local:ExecuteGlobal(_Command, unpack(arg));
end

