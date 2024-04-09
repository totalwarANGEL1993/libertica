-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
-- ||||                          LOKALES SKRIPT                          |||| --
-- ||||                    --------------------------                    |||| --
-- ||||                            Testmap 01                            |||| --
-- ||||                           totalwarANGEL                          |||| --
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --

-- ========================================================================== --

Script.Load("maps/externalmap/" ..Framework.GetCurrentMapName().. "/libertica/librarian.lua");

Lib.Loader.PushPath("E:/Repositories/libertica/var/");

Lib.Require("core/Core");
Lib.Require("module/quest/Quest");
Lib.Require("module/ui/UITools");
Lib.Require("module/ui/UIEffects");
Lib.Require("module/promotion/Promotion");
Lib.Require("module/information/Requester");
Lib.Require("module/entity/Selection");
Lib.Require("module/city/SettlementSurvival");

function Mission_LocalOnMapStart()
end

function Mission_LocalVictory()
end

-- ========================================================================== --

function GameCallback_Lib_LoadingFinished()
    -- Logic.DEBUG_AddNote("Local: Listener initialized");
    -- CreateReportReceiver(Report.EscapePressed, function(...)
    --     GUI.AddNote("Local: It just works!");
    -- end);
end

