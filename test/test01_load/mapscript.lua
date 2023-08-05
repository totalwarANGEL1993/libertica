-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
-- ||||                          GLOBALES SKRIPT                         |||| --
-- ||||                    --------------------------                    |||| --
-- ||||                            Testmap 01                            |||| --
-- ||||                           totalwarANGEL                          |||| --
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --

-- ========================================================================== --

Script.Load("maps/externalmap/" ..Framework.GetCurrentMapName().. "/liberty/liberator.lua");

Lib.Require("core/core");
Lib.Require("module/quest/questmodule");

function Mission_FirstMapAction()
    Script.Load("maps/externalmap/" ..Framework.GetCurrentMapName().. "/questsystembehavior.lua");

    -- Mapeditor-Einstellungen werden geladen
    if Framework.IsNetworkGame() ~= true then
        Startup_Player();
        Startup_StartGoods();
        Startup_Diplomacy();
    end
    Liberate();
end

function Mission_InitPlayers()
end

function Mission_SetStartingMonth()
    Logic.SetMonthOffset(3);
end

function Mission_InitMerchants()
end

-- ========================================================================== --

function GameCallback_Lib_LoadingFinished()
    -- Logic.DEBUG_AddNote("Global: Listener initialized");
    -- CreateReportReceiver(Report.EscapePressed, function(...)
    --     Logic.DEBUG_AddNote("Global: It just works!");
    -- end);

    LuaDebugger.Break()
    SetupQuest {
        Name        = "HelloWorld",
        Success     = "It just work's!",

        Goal_InstantSuccess(),
        Trigger_Time(10),
    }
end

