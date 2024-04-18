-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
-- ||||                          GLOBALES SKRIPT                         |||| --
-- ||||                    --------------------------                    |||| --
-- ||||                            Testmap 04                            |||| --
-- ||||                           totalwarANGEL                          |||| --
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --

-- ========================================================================== --

Script.Load("maps/externalmap/" ..Framework.GetCurrentMapName().. "/libertica/librarian.lua");

if CONST_IS_IN_DEV then
    Lib.Loader.PushPath("E:/Repositories/libertica/var/");
end
Lib.Require("comfort/global/ReplaceEntity");
Lib.Require("core/Core");
Lib.Require("module/quest/Quest");
Lib.Require("module/npc/NPC");
Lib.Require("module/io/IO");
Lib.Require("module/io/IOChest");
Lib.Require("module/io/IOMine");
Lib.Require("module/ui/UIBuilding");
Lib.Require("module/faker/Technology");
Lib.Require("module/trade/Warehouse");
Lib.Require("module/city/Promotion");

-- ========================================================================== --

function TestSetupChests()
    CreateRandomGoldChest("chest1");
    CreateRandomResourceChest("chest2");
    CreateRandomLuxuryChest("chest3");
end

function TestSetupTradeposts()
    ReplaceEntity("TP2", Entities.B_TradePost, 1);
    ReplaceEntity("TP3", Entities.B_TradePost, 1);
    -- InteractiveObjectDeactivate("TP2");
    -- InteractiveObjectDeactivate("TP3");

    CreateWarehouse {
        ScriptName       = "TP2",
        Offers           = {
            {Amount      = 3,
             GoodType    = Goods.G_Stone,
             BasePrice   = 80},
            {Amount      = 3,
             GoodType    = Goods.G_Cheese,
             BasePrice   = 150},
            {GoodType    = Entities.U_Entertainer_NE_StrongestMan_Barrel,
             BasePrice   = 150,
             Refresh     = 500},
            {Amount      = 3,
             GoodType    = Entities.U_MilitaryBandit_Ranged_ME,
             PaymentType = Goods.G_Wood,
             BasePrice   = 3},
            {Amount      = 3,
             GoodType    = Entities.U_CatapultCart,
             BasePrice   = 1000},
            {Amount      = 3,
             GoodType    = Goods.G_Olibanum,
             GoodAmount  = 27,
             BasePrice   = 300},
        },
    };

    CreateWarehouse {
        ScriptName       = "TP3",
        Offers           = {
            {Amount      = 3,
             GoodType    = Goods.G_Iron,
             BasePrice   = 80},
            {Amount      = 3,
             GoodType    = Goods.G_Sausage,
             BasePrice   = 150},
            {GoodType    = Entities.U_Entertainer_NA_FireEater,
             BasePrice   = 150,
             Refresh     = 500},
            {Amount      = 3,
             GoodType    = Entities.U_MilitaryBandit_Melee_ME,
             PaymentType = Goods.G_Iron,
             BasePrice   = 3},
            {Amount      = 3,
             GoodType    = Entities.U_CatapultCart,
             BasePrice   = 1000},
            {Amount      = 3,
             GoodType    = Goods.G_Gems,
             GoodAmount  = 27,
             BasePrice   = 300},
            {Amount      = 3,
             GoodType    = Goods.G_MusicalInstrument,
             GoodAmount  = 27,
             BasePrice   = 300},
        },
    };
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
    ActivateDebugMode(true, true, true, true, false);
    TestSetupChests();
    TestSetupTradeposts();
    TestSetupRuins();
end

