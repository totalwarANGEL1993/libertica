Lib.Register("comfort/GetCategoriesOfType");

--- Returns all categories the type is in.
--- @param _Type integer Entity type
--- @return table Categories List of categories
function GetCategoriesOfType(_Type)
    local Categories = {};
    for k, v in pairs(EntityCategories) do
        if Logic.IsEntityTypeInCategory(_Type, v) == 1 then
            table.insert(Categories, v);
        end
    end
    return Categories;
end

