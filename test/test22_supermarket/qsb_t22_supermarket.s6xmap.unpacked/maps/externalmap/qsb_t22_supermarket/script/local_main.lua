-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
-- ||||                          LOKALES SKRIPT                          |||| --
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
Lib.Require("module/entity/Selection");
Lib.Require("module/city/SettlementSurvival");

-- ========================================================================== --

function GameCallback_Lib_LoadingFinished()
end

