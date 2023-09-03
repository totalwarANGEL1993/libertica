Lib.Require("comfort/GetCategoriesOfType");
Lib.Register("comfort/GetCategoriesOfEntity");

--- Returns all categories the entity is in.
--- @param _Entity string|integer Entity ID or script name
--- @return table Categories List of categories
function GetCategoriesOfEntity(_Entity)
    local Type = Logic.GetEntityType(_Entity);
    return GetCategoriesOfType(Type);
end

