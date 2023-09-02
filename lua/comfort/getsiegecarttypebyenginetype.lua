Lib.Register("comfort/GetSiegecartTypeByEngineType");

CONST_CART_TO_ENGINE = {
    [Entities.U_MilitaryBatteringRam] = Entities.U_BatteringRamCart,
    [Entities.U_MilitaryCatapult] = Entities.U_CatapultCart,
    [Entities.U_MilitarySiegeTower] = Entities.U_SiegeTowerCart,
    -- TODO: Add CP types
};

--- Returns the siege engine type by cart type.
--- @param _Type integer Type of cart
--- @return integer? Type Type of engine
function GetSiegecartTypeByEngineType(_Type)
    return CONST_CART_TO_ENGINE[_Type];
end

