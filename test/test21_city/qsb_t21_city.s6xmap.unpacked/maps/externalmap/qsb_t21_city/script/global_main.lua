-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
-- ||||                          GLOBALES SKRIPT                         |||| --
-- ||||                    --------------------------                    |||| --
-- ||||                            Testmap 21                            |||| --
-- ||||                           totalwarANGEL                          |||| --
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --

-- ========================================================================== --

if CONST_IS_IN_DEV then
    Script.Load("E:/Repositories/libertica/var/libertica/librarian.lua");
    Lib.Loader.PushPath("E:/Repositories/libertica/var/");
else
    Script.Load("maps/externalmap/qsb_t21_city/libertica/librarian.lua");
end
Lib.Require("comfort/KeyOf");
Lib.Require("core/Core");
Lib.Require("module/city/Promotion");
Lib.Require("module/city/Construction");
Lib.Require("module/city/LifestockSystem");
Lib.Require("module/mode/SettlementSurvival");
Lib.Require("module/entity/EntitySelection");
Lib.Require("module/balancing/Damage");
Lib.Require("module/quest/Quest");
Lib.Require("module/mode/SettlementLimitation");
Lib.Require("module/entity/EntitySearch");

-- ========================================================================== --

function TestTextDivision()
    Lib.Core.Text:GetAmountOfLines([[Dieser Modus schränkt die Baumöglichkeiten ein, sodass der Bau der Stadt bessere Planung erfordert.{cr}{cr}{cr}1. Das Heimatgebiet hat keine Einschränkungen.{cr}{cr}2. In anderen Territorien können nur 3 Gebäude gebaut werden. Jeder Gebäudetyp kann nur einmal auf dem Gebiet gebaut werden.{cr}{cr}3. Der Ausbau des Außenposten gewährt dauerhaft ein zusätzliches Gebäude. Außerdem können für Gold Gebäudetypen doppelt gebaut werden.{cr}{cr}4. Stadtgebäude können nur auf dem Heimatgebiet gebaut werden.{cr}{cr}5. Bienenstöcke, Felder und Ziergebäude zählen nicht als Gebäude.]],170)
end

-- ========================================================================== --

-- > TestQuestForCommands()
function TestQuestForCommands()
    SetupQuest {
        Name        = "TestQuest1",
        Suggestion  = "It just work's!",
        Receiver    = 1,

        Goal_NoChange(),
        Trigger_NeverTriggered(),
    }
end

-- ========================================================================== --

function TestConstructBuildingBlackList()
    BlackListHerbGatherer = BlacklistConstructTypeInTerritory(1, Entities.B_HerbGatherer, 1);
end

function TestConstructBuildingWhiteList()
    WhiteListCityBuilding = WhitelistConstructCategoryInTerritory(1, EntityCategories.CityBuilding, 1);
end

function TestKnockdownBuildingBlackList()
    BlackListBaker = BlacklistKnockdownTypeInTerritory(1, Entities.B_Baker, 1);
end

function TestKnockdownBuildingWhiteList()
    WhiteListButcher = WhitelistKnockdownTypeInTerritory(1, Entities.B_Butcher, 1);
end

function TestConstructRoadBlackList()
    BlacklstRoad = BlacklistConstructRoadInTerritory(1, true, 1);
end

function TestConstructRoadWhiteList()

end

function TestConstructWallBlackList()

end

function TestConstructWallWhiteList()
    PalisadesInHomeTerritory = WhitelistConstructWallInTerritory(1, false, 1);
    WallsInHomeTerritory = WhitelistConstructWallInTerritory(1, true, 1);
end

function TestCustomConstructPalisade()
    CustomRuleConstructWall(1, "BuildRule_Palisade", 1, Entities.B_Outpost_ME);
    CustomRuleConstructBuilding(1, "BuildRule_PalisadeGate", 1, Entities.B_Outpost_ME);
end

function TestCustomConstructWall()
    CustomRuleConstructWall(1, "BuildRule_Wall", 1);
    CustomRuleConstructBuilding(1, "BuildRule_WallGate", 1);
end

BuildRule_PalisadeGate = function(_PlayerID, _Type, _x, _y, _HomeTerritoryID, _OutpostType)
    local TerritoryID = Logic.GetTerritoryAtPosition(_x, _y);
    local n, OutpostID = Logic.GetPlayerEntitiesInArea(_PlayerID, _OutpostType, _x, _y, 1500, 1);
    if  Logic.IsEntityTypeInCategory(_Type, EntityCategories.Wall) == 1
    and TerritoryID ~= _HomeTerritoryID then
        return n > 0 and Logic.IsConstructionComplete(OutpostID) == 1;
    end
    return true;
end

BuildRule_WallGate = function(_PlayerID, _Type, _x, _y, _HomeTerritoryID)
    local TerritoryID = Logic.GetTerritoryAtPosition(_x, _y);
    if Logic.IsEntityTypeInCategory(_Type, EntityCategories.Wall) == 1 then
        return TerritoryID == _HomeTerritoryID;
    end
    return true;
end

-- ========================================================================== --

function GameCallback_Lib_LoadingFinished()
    ActivateDebugMode(true, true, true, true, false);

    AddGood(Goods.G_Gold, 2500, 1);
    AddGood(Goods.G_Wood, 20, 1);
    AddGood(Goods.G_Stone, 25, 1);
    AddGood(Goods.G_Grain, 10, 1);
    AddGood(Goods.G_RawFish, 10, 1);
    AddGood(Goods.G_Milk, 10, 1);
    AddGood(Goods.G_Carcass, 10, 1);
end

