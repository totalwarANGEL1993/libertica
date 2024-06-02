-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
-- ||||                          LOKALES SKRIPT                          |||| --
-- ||||                    --------------------------                    |||| --
-- ||||                            Testmap 22                            |||| --
-- ||||                           totalwarANGEL                          |||| --
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --

-- ========================================================================== --

CONST_IS_IN_DEV = true;
local Path = "maps/externalmap/qsb_t23_diplomacy/script/local_main.lua";
if CONST_IS_IN_DEV then
    Path = "E:/Repositories/libertica/test/test23_diplomacy/qsb_t23_diplomacy.s6xmap.unpacked/" ..Path;
end
Script.Load(Path);

function Mission_LocalOnMapStart()
end

function Mission_LocalVictory()
end