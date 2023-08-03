Lib.Register("comfort/global/CreateStock");

--- Creates a stock in the players storehouse.
--- @param _PlayerID integer ID pf player
--- @param _GoodType integer Type of good
function CreateStock(_PlayerID, _GoodType)
    assert(Lib.IsLocalEnv == false, "Can only be used in global script.");
    local ResourceCategory = Logic.GetGoodCategoryForGoodType(_GoodType);
    if ResourceCategory == GoodCategories.GC_Resource or _GoodType == Goods.G_None then
        local StoreID = Logic.GetStoreHouse(_PlayerID);
        local CastleID = Logic.GetHeadquarters(_PlayerID);
        if StoreID ~= 0 and Logic.GetIndexOnInStockByGoodType(StoreID, _GoodType) == -1 then
            if _GoodType ~= Goods.G_Gold or (_GoodType == Goods.G_Gold and CastleID == 0) then
                Logic.AddGoodToStock(StoreID, _GoodType, 0, true, true);
            end
        end
    end
end

