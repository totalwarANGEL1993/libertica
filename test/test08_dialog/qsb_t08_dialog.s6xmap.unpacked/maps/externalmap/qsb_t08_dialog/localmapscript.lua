-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
-- ||||                          LOKALES SKRIPT                          |||| --
-- ||||                    --------------------------                    |||| --
-- ||||                            Testmap 08                            |||| --
-- ||||                           totalwarANGEL                          |||| --
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --

-- ========================================================================== --

CONST_IS_IN_DEV = true;
local Path = "maps/externalmap/" ..Framework.GetCurrentMapName().. "/script/local_main.lua";
if CONST_IS_IN_DEV then
    Path = "E:/Repositories/liberty/test/test08_dialog/qsb_t08_dialog.s6xmap.unpacked/" ..Path;
end
Script.Load(Path);

function Mission_LocalOnMapStart()
end

function Mission_LocalVictory()
end

