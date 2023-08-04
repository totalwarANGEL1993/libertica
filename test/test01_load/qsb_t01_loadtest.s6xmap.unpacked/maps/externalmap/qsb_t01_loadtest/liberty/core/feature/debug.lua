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

Lib.Core.Debug = {
    CheckAtRun       = false;
    TraceQuests      = false;
    DevelopingCheats = false;
    DevelopingShell  = false;
}

Lib.Require("comfort/IsLocalScript");
Lib.Require("core/feature/Report");
Lib.Require("core/feature/Chat");
Lib.Register("core/feature/Debug");

function Lib.Core.Debug:Initialize()
    Report.DebugChatConfirmed = CreateReport("Event_DebugChatConfirmed");
    Report.DebugConfigChanged = CreateReport("Event_DebugConfigChanged");

    if IsLocalScript() then
        self:InitializeQsbDebugHotkeys();

        CreateReportReceiver(
            Report.ChatClosed,
            function(...)
                Lib.Core.Debug:ProcessDebugInput(unpack(arg));
            end
        );
    end
end

function Lib.Core.Debug:OnSaveGameLoaded()
    if IsLocalScript() then
        self:InitializeDebugWidgets();
        self:InitializeQsbDebugHotkeys();
    end
end

function Lib.Core.Debug:ActivateDebugMode(_CheckAtRun, _TraceQuests, _DevelopingCheats, _DevelopingShell)
    if IsLocalScript() then
        return;
    end

    self.CheckAtRun       = _CheckAtRun == true;
    self.TraceQuests      = _TraceQuests == true;
    self.DevelopingCheats = _DevelopingCheats == true;
    self.DevelopingShell  = _DevelopingShell == true;

    SendReport(
        Report.DebugConfigChanged,
        self.CheckAtRun,
        self.TraceQuests,
        self.DevelopingCheats,
        self.DevelopingShell
    );

    ExecuteLocal(
        [[
            Swift.Debug.CheckAtRun       = %s;
            Swift.Debug.TraceQuests      = %s;
            Swift.Debug.DevelopingCheats = %s;
            Swift.Debug.DevelopingShell  = %s;

            Swift.Event:DispatchScriptEvent(
                QSB.ScriptEvents.DebugConfigChanged,
                Swift.Debug.CheckAtRun,
                Swift.Debug.TraceQuests,
                Swift.Debug.DevelopingCheats,
                Swift.Debug.DevelopingShell
            );
            Swift.Debug:InitializeDebugWidgets();
        ]],
        tostring(self.CheckAtRun),
        tostring(self.TraceQuests),
        tostring(self.DevelopingCheats),
        tostring(self.DevelopingShell)
    );
end

function Lib.Core.Debug:InitializeDebugWidgets()
    if Network.IsNATReady ~= nil and Framework.IsNetworkGame() then
        return;
    end
    if self.DevelopingCheats then
        KeyBindings_EnableDebugMode(1);
        KeyBindings_EnableDebugMode(2);
        KeyBindings_EnableDebugMode(3);
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopLeft/GameClock", 1);
        self.GameClock = true;
    else
        KeyBindings_EnableDebugMode(0);
        XGUIEng.ShowWidget("/InGame/Root/Normal/AlignTopLeft/GameClock", 0);
        self.GameClock = false;
    end
end

function Lib.Core.Debug:InitializeQsbDebugHotkeys()
    if Framework.IsNetworkGame() then
        return;
    end
    -- Restart map
    Input.KeyBindDown(
        Keys.ModifierControl + Keys.ModifierShift + Keys.ModifierAlt + Keys.R,
        "Lib.Core.Debug:ProcessDebugShortcut('RestartMap')",
        30,
        false
    );
    -- Open chat
    Input.KeyBindDown(
        Keys.ModifierShift + Keys.OemPipe,
        "Lib.Core.Debug:ProcessDebugShortcut('Terminal')",
        30,
        false
    );
end

function Lib.Core.Debug:ProcessDebugShortcut(_Type, _Params)
    if self.DevelopingCheats then
        if _Type == "RestartMap" then
            Framework.RestartMap();
        elseif _Type == "Terminal" then
            ShowTextInput(GUI.GetPlayerID(), true);
        end
    end
end

function Lib.Core.Debug:ProcessDebugInput(_Input, _PlayerID, _DebugAllowed)
    if _DebugAllowed then
        if _Input:lower():find("^restartmap") then
            self:ProcessDebugShortcut("RestartMap");
        elseif _Input:lower():find("^clear") then
            GUI.ClearNotes();
        elseif _Input:lower():find("^version") then
            -- FIXME
        elseif _Input:find("^> ") then
            GUI.SendScriptCommand(_Input:sub(3), true);
        elseif _Input:find("^>> ") then
            GUI.SendScriptCommand(string.format(
                "Logic.ExecuteInLuaLocalState(\"%s\")",
                _Input:sub(4)
            ), true);
        elseif _Input:find("^< ") then
            GUI.SendScriptCommand(string.format(
                [[Script.Load("%s")]],
                _Input:sub(3)
            ));
        elseif _Input:find("^<< ") then
            Script.Load(_Input:sub(4));
        end
    end
end

-- -------------------------------------------------------------------------- --

--- Activates the debug mode of the game.
--- @param _CheckAtRun boolean       Check custom behavior on/off
--- @param _TraceQuests boolean      Trace quests on/off
--- @param _DevelopingCheats boolean Cheats on/off
--- @param _DevelopingShell boolean  Input commands on/off
function ActivateDebugMode(_CheckAtRun, _TraceQuests, _DevelopingCheats, _DevelopingShell)
    Lib.Core.Debug:ActivateDebugMode(_CheckAtRun, _TraceQuests, _DevelopingCheats, _DevelopingShell);
end

