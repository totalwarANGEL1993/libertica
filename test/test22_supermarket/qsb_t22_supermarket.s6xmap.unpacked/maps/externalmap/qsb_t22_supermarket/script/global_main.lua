-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
-- ||||                          GLOBALES SKRIPT                         |||| --
-- ||||                    --------------------------                    |||| --
-- ||||                            Testmap 22                            |||| --
-- ||||                           totalwarANGEL                          |||| --
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --

-- ========================================================================== --

Script.Load("maps/externalmap/qsb_t22_supermarket/libertica/librarian.lua");

if CONST_IS_IN_DEV then
    Lib.Loader.PushPath("E:/Repositories/libertica/release/");
end
Lib.Require("comfort/KeyOf");
Lib.Require("core/Core");
Lib.Require("module/entity/EntitySelection");
Lib.Require("module/mode/SettlementSurvival");

-- ========================================================================== --

function GameCallback_Lib_LoadingFinished()
    ActivateDebugMode(true, true, true, true, false);
end

