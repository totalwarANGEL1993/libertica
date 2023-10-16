Lib.Require("comfort/IsLocalScript");
Lib.Register("module/lifestock/LifestockSystem_API");

--- Changes the parameters for raising cows.
---
--- If the feeding timer is set to 0 animals don't need to be fed at all. All
--- fields left out in the table will be reset to the default.
---
--- #### Fields
--- * `BasePrice`    - Base price at regular merchants (Default: 300)
--- * `GrainCost`    - Costs to buy a single animal (Default: 10)
--- * `GrainUpkeep`  - Costs to upkeep the animals (Default: 1)
--- * `FeedingTimer` - Frequency the upkeep is checked (Default: 0)
--- * `StarveChance` - Chance a animal starves if hungry (Default: 35)
---
--- @param _Data table Breeding configuration
function SetCattleBreedingParameters(_Data)
    assert(not IsLocalScript(), "Can not be used in local script!");
    assert(type(_Data) == "table", "Malformed data passed!");

    local CattleBasePrice = _Data.BasePrice or 300;
    local CattleGrainCost = _Data.GrainCost or 10;
    local CattleGrainUpkeep = _Data.GrainUpkeep or 1;
    local CattleFeedingTimer = _Data.FeedingTimer or 0;
    local CattleStarveChance = _Data.StarveChance or 35;

    ExecuteLocal([[Lib.LifestockSystem.Global.CattleBasePrice = %d]], CattleBasePrice);
    Lib.LifestockSystem.Global.CattleBasePrice = CattleBasePrice;
    ExecuteLocal([[MerchantSystem.BasePrices[Goods.G_Cow] = %d]], CattleGrainCost);
    MerchantSystem.BasePrices[Goods.G_Cow] = CattleBasePrice;
    ExecuteLocal([[Lib.LifestockSystem.Global.CattleGrainCost = %d]], CattleGrainCost);
    Lib.LifestockSystem.Global.CattleGrainCost = CattleGrainCost;
    ExecuteLocal([[Lib.LifestockSystem.Global.CattleGrainUpkeep = %d]], CattleGrainUpkeep);
    Lib.LifestockSystem.Global.CattleGrainUpkeep = CattleGrainUpkeep;
    ExecuteLocal([[Lib.LifestockSystem.Global.CattleFeedingTimer = %d]], CattleFeedingTimer);
    Lib.LifestockSystem.Global.CattleFeedingTimer = CattleFeedingTimer;
    ExecuteLocal([[Lib.LifestockSystem.Global.CattleStarveChance = %d]], CattleStarveChance);
    Lib.LifestockSystem.Global.CattleStarveChance = CattleStarveChance;
end
API.SetCattleBreedingParameters = SetCattleBreedingParameters;

--- Changes the parameters for raising sheeps.
---
--- If the feeding timer is set to 0 animals don't need to be fed at all. All
--- fields left out in the table will be reset to the default.
---
--- #### Fields
--- * `BasePrice`    - Base price at regular merchants (Default: 300)
--- * `GrainCost`    - Costs to buy a single animal (Default: 10)
--- * `GrainUpkeep`  - Costs to upkeep the animals (Default: 1)
--- * `FeedingTimer` - Frequency the upkeep is checked (Default: 0)
--- * `StarveChance` - Chance a animal starves if hungry (Default: 35)
---
--- @param _Data table Breeding configuration
function SetSheepBreedingParameters(_Data)
    assert(not IsLocalScript(), "Can not be used in local script!");
    assert(type(_Data) == "table", "Malformed data passed!");

    local SheepBasePrice = _Data.SheepBasePrice or 300;
    local SheepGrainCost = _Data.SheepGrainCost or 10;
    local SheepGrainUpkeep = _Data.SheepGrainUpkeep or 1;
    local SheepFeedingTimer = _Data.SheepFeedingTimer or 0;
    local SheepStarveChance = _Data.SheepStarveChance or 35;

    ExecuteLocal([[Lib.LifestockSystem.Global.SheepBasePrice = %d]], SheepBasePrice);
    Lib.LifestockSystem.Global.SheepBasePrice = SheepBasePrice;
    ExecuteLocal([[MerchantSystem.BasePrices[Goods.G_Sheep] = %d]], SheepBasePrice);
    MerchantSystem.BasePrices[Goods.G_Sheep] = SheepBasePrice;
    ExecuteLocal([[Lib.LifestockSystem.Global.SheepGrainCost = %d]], SheepGrainCost);
    Lib.LifestockSystem.Global.SheepGrainCost = SheepGrainCost;
    ExecuteLocal([[Lib.LifestockSystem.Global.SheepGrainUpkeep = %d]], SheepGrainUpkeep);
    Lib.LifestockSystem.Global.SheepGrainUpkeep = SheepGrainUpkeep;
    ExecuteLocal([[Lib.LifestockSystem.Global.SheepFeedingTimer = %d]], SheepFeedingTimer);
    Lib.LifestockSystem.Global.SheepFeedingTimer = SheepFeedingTimer;
    ExecuteLocal([[Lib.LifestockSystem.Global.SheepStarveChance = %d]], SheepStarveChance);
    Lib.LifestockSystem.Global.SheepStarveChance = SheepStarveChance;
end
API.SetSheepBreedingParameters = SetSheepBreedingParameters;

--- Sets the required title to breed cows.
---
--- Per default breeding cows is allowed from the start.
--- @param _Title integer Required title
function RequireTitleToBreedCattle(_Title)
    assert(not IsLocalScript(), "Can not be used in local script!");
    ExecuteLocal([[
        table.insert(NeedsAndRightsByKnightTitle[%d][4], 1, Technologies.R_Cattle)
        CreateTechnologyKnightTitleTable()
    ]], _Title);
    table.insert(NeedsAndRightsByKnightTitle[_Title][4], 1, Technologies.R_Cattle);
    CreateTechnologyKnightTitleTable()
    for i= 1, 8 do
        Logic.TechnologySetState(i, Technologies.R_Cattle, 0);
    end
end
API.RequireTitleToBreedCattle = RequireTitleToBreedCattle;

--- Sets the required title to breed sheeps.
---
--- Per default breeding sheeps is allowed from the start.
--- @param _Title integer Required title
function RequireTitleToBreedSheep(_Title)
    assert(not IsLocalScript(), "Can not be used in local script!");
    ExecuteLocal([[
        table.insert(NeedsAndRightsByKnightTitle[%d][4], 1, Technologies.R_Cattle)
        CreateTechnologyKnightTitleTable()
    ]], _Title);
    table.insert(NeedsAndRightsByKnightTitle[_Title][4], 1, Technologies.R_Sheep);
    CreateTechnologyKnightTitleTable()
    for i= 1, 8 do
        Logic.TechnologySetState(i, Technologies.R_Sheep, 0);
    end
end
API.RequireTitleToBreedSheep = RequireTitleToBreedSheep;

