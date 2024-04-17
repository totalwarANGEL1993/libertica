-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
-- ||||                          LOKALES SKRIPT                          |||| --
-- ||||                    --------------------------                    |||| --
-- ||||                            Testmap 21                            |||| --
-- ||||                           totalwarANGEL                          |||| --
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --

-- ========================================================================== --

CONST_IS_IN_DEV = true;
local Path = "maps/externalmap/qsb_t21_city/script/local_main.lua";
if CONST_IS_IN_DEV then
    Path = "E:/Repositories/libertica/test/test21_city/qsb_t21_city.s6xmap.unpacked/" ..Path;
end
Script.Load(Path);

function Mission_LocalOnMapStart()
end

function Mission_LocalVictory()
end

