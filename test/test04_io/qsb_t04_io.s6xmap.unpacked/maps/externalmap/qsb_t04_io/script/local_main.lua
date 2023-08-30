-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
-- ||||                          LOKALES SKRIPT                          |||| --
-- ||||                    --------------------------                    |||| --
-- ||||                            Testmap 04                            |||| --
-- ||||                           totalwarANGEL                          |||| --
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --

-- ========================================================================== --

Script.Load("maps/externalmap/" ..Framework.GetCurrentMapName().. "/liberty/liberator.lua");

if CONST_IS_IN_DEV then
    Lib.Loader.PushPath("E:/Repositories/");
end
Lib.Require("core/Core");
Lib.Require("module/quest/Quest");
Lib.Require("module/npc/NPC");
Lib.Require("module/io/IO");
Lib.Require("module/iochest/IOChest");

-- ========================================================================== --



-- ========================================================================== --

function GameCallback_Lib_LoadingFinished()
end

