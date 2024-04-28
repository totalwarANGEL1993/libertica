-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
-- ||||                          LOKALES SKRIPT                          |||| --
-- ||||                    --------------------------                    |||| --
-- ||||                            Testmap 21                            |||| --
-- ||||                           totalwarANGEL                          |||| --
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --

-- ========================================================================== --

Script.Load("maps/externalmap/" ..Framework.GetCurrentMapName().. "/libertica/librarian.lua");

if CONST_IS_IN_DEV then
    Lib.Loader.PushPath("E:/Repositories/libertica/var/");
end
Lib.Require("core/Core");
Lib.Require("module/quest/Quest");
Lib.Require("module/quest/QuestJornal");
Lib.Require("module/entity/NPC");
Lib.Require("module/information/BriefingSystem");
Lib.Require("module/information/CutsceneSystem");
Lib.Require("module/information/DialogSystem");

-- ========================================================================== --



-- ========================================================================== --

function GameCallback_Lib_LoadingFinished()
end

