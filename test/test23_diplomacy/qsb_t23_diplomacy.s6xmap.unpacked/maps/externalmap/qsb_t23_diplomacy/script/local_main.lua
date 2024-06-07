-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
-- ||||                          LOKALES SKRIPT                          |||| --
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
Lib.Require("module/information/Requester");

-- ========================================================================== --

function GameCallback_Lib_LoadingFinished()
end

