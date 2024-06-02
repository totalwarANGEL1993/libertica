-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
-- ||||                          GLOBALES SKRIPT                         |||| --
-- ||||                    --------------------------                    |||| --
-- ||||                            Testmap 23                            |||| --
-- ||||                           totalwarANGEL                          |||| --
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --

-- ========================================================================== --

if CONST_IS_IN_DEV then
    Script.Load("E:/Repositories/libertica/var/libertica/librarian.lua");
    Lib.Loader.PushPath("E:/Repositories/libertica/var/");
else
    Script.Load("maps/externalmap/qsb_t23_diplomacy/libertica/librarian.lua");
end
Lib.Require("comfort/KeyOf");
Lib.Require("core/Core");
Lib.Require("module/entity/EntitySelection");
Lib.Require("module/mode/SettlementSurvival");
Lib.Require("module/quest/QuestBehavior");

-- ========================================================================== --

function GameCallback_Lib_LoadingFinished()
    ActivateDebugMode(true, true, true, true, false);
end

function DiscoverTerritoriesQuest()
    SetupQuest {
        Name        = "DiscoverTerritories1",
        Suggestion  = "Find your neighbors!",
        Receiver    = 1,

        Goal_DiscoverTerritories(4, 2, 3, 4, 5),
        Trigger_Time(0),
    }
end

function DiscoverPlayersQuest()
    SetupQuest {
        Name        = "DiscoverPlayers1",
        Suggestion  = "Find your neighbors!",
        Receiver    = 1,

        Goal_DiscoverPlayers(4, 2, 3, 4, 5),
        Trigger_Time(0),
    }
end

