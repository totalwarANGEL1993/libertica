-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
-- ||||                          GLOBALES SKRIPT                         |||| --
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

-- ========================================================================== --

function TestSetupChests()
end

function TestSetupTradeposts()
    InteractiveObjectDeactivate("TP2");
    InteractiveObjectDeactivate("TP3");
end

function TestSetupRuins()
    SetupObject {
        Name        = "io1",
        Costs       = {Goods.G_Wood, 10},
        Replacement = Entities.D_X_BigFire_Fire,
    };

    SetupObject {
        Name        = "io2",
        Reward      = {Goods.G_Gold, 250},
    };
end

-- ========================================================================== --

function GameCallback_Lib_LoadingFinished()
    ActivateDebugMode(true, false, true, true);
    TestSetupChests();
    TestSetupTradeposts();
    TestSetupRuins();
end

