-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
-- ||||                          LOKALES SKRIPT                          |||| --
-- ||||                    --------------------------                    |||| --
-- ||||                            Testmap 04                            |||| --
-- ||||                           totalwarANGEL                          |||| --
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --

-- ========================================================================== --

CONST_IS_IN_DEV = true;
local Path = "maps/externalmap/" ..Framework.GetCurrentMapName().. "/script/local_main.lua";
if CONST_IS_IN_DEV then
    Path = "E:/Repositories/libertica/test/test04_io/qsb_t04_io.s6xmap.unpacked/" ..Path;
end
Script.Load(Path);

function Mission_LocalOnMapStart()
end

function Mission_LocalVictory()
end

