-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
-- ||||                          LOKALES SKRIPT                          |||| --
-- ||||                    --------------------------                    |||| --
-- ||||                            Testmap 21                            |||| --
-- ||||                           totalwarANGEL                          |||| --
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --

-- ========================================================================== --

if CONST_IS_IN_DEV then
    Script.Load("E:/Repositories/libertica/var/libertica/librarian.lua");
    Lib.Loader.PushPath("E:/Repositories/libertica/var/");
else
    Script.Load("maps/externalmap/qsb_t08_dialog/libertica/librarian.lua");
end
Lib.Require("core/Core");
Lib.Require("module/quest/Quest");
Lib.Require("module/quest/QuestJornal");
Lib.Require("module/entity/NPC");
Lib.Require("module/information/BriefingSystem");
Lib.Require("module/information/CutsceneSystem");
Lib.Require("module/information/DialogSystem");
Lib.Require("module/settings/Sound");

-- ========================================================================== --



-- ========================================================================== --

function GameCallback_Lib_LoadingFinished()
end

