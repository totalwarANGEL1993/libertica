-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
-- ||||                          GLOBALES SKRIPT                         |||| --
-- ||||                    --------------------------                    |||| --
-- ||||                            Testmap 01                            |||| --
-- ||||                           totalwarANGEL                          |||| --
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --

-- ========================================================================== --

Script.Load("maps/externalmap/" ..Framework.GetCurrentMapName().. "/liberty/liberator.lua");

Lib.Require("core/Core");
Lib.Require("module/quest/Quest");
Lib.Require("module/npc/NPC");

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
    SetupQuest {
        Name        = "NpcTest",
        Suggestion  = "Talk to me!",
        Success     = "It just work's!",
        Sender      = 2,

        Goal_NPC("npc1"),
        Trigger_Time(5),
    }
end

