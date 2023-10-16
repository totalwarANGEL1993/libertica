-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
-- ||||                          GLOBALES SKRIPT                         |||| --
-- ||||                    --------------------------                    |||| --
-- ||||                            Testmap 01                            |||| --
-- ||||                           totalwarANGEL                          |||| --
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --

-- ========================================================================== --

Script.Load("maps/externalmap/" ..Framework.GetCurrentMapName().. "/liberty/liberator.lua");

Lib.Loader.PushPath("E:/Repositories/liberty/var/");

Lib.Require("comfort/global/ReplaceEntity");
Lib.Require("core/Core");
Lib.Require("module/quest/Quest");
Lib.Require("module/uitools/UITools");
Lib.Require("module/uieffects/UIEffects");
Lib.Require("module/promotion/Promotion");
Lib.Require("module/information/Requester");
Lib.Require("module/entity/Selection");

-- ========================================================================== --

function GameCallback_Lib_LoadingFinished()
    ActivateDebugMode(true, false, true, true);

    AddGood(Goods.G_Gold, 2500, 1);
    AddGood(Goods.G_Wood, 20, 1);
    AddGood(Goods.G_Stone, 25, 1);
    AddGood(Goods.G_Grain, 10, 1);
    AddGood(Goods.G_RawFish, 10, 1);
    AddGood(Goods.G_Milk, 10, 1);
    AddGood(Goods.G_Carcass, 10, 1);
end

-- ========================================================================== --

function Mission_FirstMapAction()
    Script.Load("maps/externalmap/" ..Framework.GetCurrentMapName().. "/questsystembehavior.lua");

    -- Mapeditor-Einstellungen werden geladen
    if Framework.IsNetworkGame() ~= true then
        Startup_Player();
        Startup_StartGoods();
        Startup_Diplomacy();
    end
    Liberate();
end

function Mission_InitPlayers()
end

function Mission_SetStartingMonth()
    Logic.SetMonthOffset(3);
end

function Mission_InitMerchants()
end

-- ========================================================================== --

function GameCallback_Lib_LoadingFinished()
    ActivateDebugMode(true, false, true, true);

    CreateReportReceiver(Report.CinematicConcluded, function(...)
        LuaDebugger.Break();
    end);
    CreateReportReceiver(Report.CinematicActivated, function(...)
        LuaDebugger.Break();
    end);
    CreateReportReceiver(Report.ImageScreenShown, function(...)
        LuaDebugger.Break();
    end);
    CreateReportReceiver(Report.ImageScreenHidden, function(...)
        LuaDebugger.Break();
    end);
    CreateReportReceiver(Report.GameInterfaceShown, function(...)
        LuaDebugger.Break();
    end);
    CreateReportReceiver(Report.GameInterfaceHidden, function(...)
        LuaDebugger.Break();
    end);
    CreateReportReceiver(Report.BorderScrollLocked, function(...)
        LuaDebugger.Break();
    end);
    CreateReportReceiver(Report.BorderScrollReset, function(...)
        LuaDebugger.Break();
    end);

    SetupQuest {
        Name        = "HelloWorld",
        Success     = "It just work's!",

        Goal_InstantSuccess(),
        Trigger_Time(10),
    }
end

function TestTypeWriter()
    local EventName = StartTypewriter {
        PlayerID = 1,
        Text     = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, "..
                   "sed diam nonumy eirmod tempor invidunt ut labore et dolore"..
                   "magna aliquyam erat, sed diam voluptua. At vero eos et"..
                   " accusam et justo duo dolores et ea rebum. Stet clita kasd"..
                   " gubergren, no sea takimata sanctus est Lorem ipsum dolor"..
                   " sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing"..
                   " elitr, sed diam nonumy eirmod tempor invidunt ut labore et"..
                   " dolore magna aliquyam erat, sed diam voluptua. At vero eos"..
                   " et accusam et justo duo dolores et ea rebum. Stet clita"..
                   " kasd gubergren, no sea takimata sanctus est Lorem ipsum"..
                   " dolor sit amet.",
        Callback = function(_Data)
        end
    };
end

