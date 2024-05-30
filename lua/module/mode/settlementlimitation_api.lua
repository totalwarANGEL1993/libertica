Lib.Require("comfort/IsLocalScript");
Lib.Register("module/mode/SettlementLimitation_API");

function ActivateSettlementLimitation(_Flag)
    Lib.SettlementLimitation.Global:ActivateSettlementLimitation(_Flag);
end

function SetTerritoryBuildingLimit(_PlayerID, _Territory, _Limit)
    local TerritoryID = GetTerritoryIDByName(_Territory);
    Lib.SettlementLimitation.Global:SetTerritoryBuildingLimit(_PlayerID, TerritoryID, _Limit);
end

function SetTerritoryBuildingTypeLimit(_PlayerID, _Territory, _Type, _Limit)
    local TerritoryID = GetTerritoryIDByName(_Territory);
    Lib.SettlementLimitation.Global:SetTerritoryBuildingTypeLimit(_PlayerID, TerritoryID, _Type, _Limit);
end

function ClearTerritoryBuildingLimit(_PlayerID, _ID)
    Lib.SettlementLimitation.Global:ClearTerritoryBuildingLimit(_PlayerID, _ID)
end

function ClearTerritoryBuildingTypeLimit(_PlayerID, _ID, _Type)
    Lib.SettlementLimitation.Global:ClearTerritoryBuildingTypeLimit(_PlayerID, _ID, _Type)
end

function SetTerritoryDevelopmentCost(_CostType1, _Amount1, _CostType2, _Amount2)
    Lib.SettlementLimitation.Global:SetTerritoryDevelopmentCost(_CostType1, _Amount1, _CostType2, _Amount2);
end

