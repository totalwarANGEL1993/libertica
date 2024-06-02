-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
-- ||||                          GLOBALES SKRIPT                         |||| --
-- ||||                    --------------------------                    |||| --
-- ||||                            Testmap 22                            |||| --
-- ||||                           totalwarANGEL                          |||| --
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --

-- ========================================================================== --

CONST_IS_IN_DEV = true;
local Path = "maps/externalmap/qsb_t23_diplomacy/script/global_main.lua";
if CONST_IS_IN_DEV then
    Path = "E:/Repositories/libertica/test/test23_diplomacy/qsb_t23_diplomacy.s6xmap.unpacked/" ..Path;
end
Script.Load(Path);

function Mission_FirstMapAction()
    Script.Load("maps/externalmap/qsb_t23_diplomacy/questsystembehavior.lua");

    -- Mapeditor-Einstellungen werden geladen
    if Framework.IsNetworkGame() ~= true then
        Startup_Player();
        Startup_StartGoods();
        Startup_Diplomacy();
    end
    PrepareLibrary();
end

function Mission_InitPlayers()
end

function Mission_SetStartingMonth()
    Logic.SetMonthOffset(3);
end

function Mission_InitMerchants()
end