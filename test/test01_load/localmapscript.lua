-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
-- ||||                          LOKALES SKRIPT                          |||| --
-- ||||                    --------------------------                    |||| --
-- ||||                            Testmap 01                            |||| --
-- ||||                           totalwarANGEL                          |||| --
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --

-- ========================================================================== --

Script.Load("maps/externalmap/" ..Framework.GetCurrentMapName().. "/liberty/liberator.lua");

Lib.Require("core/core");
Lib.Require("module/quest/questmodule");

function Mission_LocalOnMapStart()
end

function Mission_LocalVictory()
end

-- ========================================================================== --

function GameCallback_Lib_LoadingFinished()
end

