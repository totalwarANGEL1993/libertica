Lib.Require("comfort/IsLocalScript");
Lib.Register("module/entity/EntityEvent_API");

--- Seaches all entities of the player.
--- @param _PlayerID integer ID of player
--- @param _WithoutDefeatResistant boolean Ignore not defeat relevant entities
--- @return table Results List of entities
function SearchEntities(_PlayerID, _WithoutDefeatResistant)
    return {};
end
API.SearchEntities = SearchEntities;

--- Searches player entities of a type in the area.
--- @param _Area integer Area size
--- @param _Position any Entity or position of location
--- @param _Type integer Type to search
--- @param _PlayerID integer ID of player
--- @return table Results List of entities
function SearchEntitiesOfTypeInArea(_Area, _Position, _Type, _PlayerID)
    return {};
end
API.SearchEntitiesOfTypeInArea = SearchEntitiesOfTypeInArea;

--- Searches player entities of a category in the area.
--- @param _Area integer Area size
--- @param _Position any Entity or position of location
--- @param _Category integer Category to search
--- @param _PlayerID integer ID of player
--- @return table Results List of entities
function SearchEntitiesOfCategoryInArea(_Area, _Position, _Category, _PlayerID)
    return {};
end
API.SearchEntitiesOfCategoryInArea = SearchEntitiesOfCategoryInArea;

--- Searches player entities of a type in the territory.
--- @param _Territory integer ID of territory
--- @param _Type integer Type to search
--- @param _PlayerID integer ID of player
--- @return table Results List of entities
function SearchEntitiesOfTypeInTerritory(_Territory, _Type, _PlayerID)
    return {};
end
API.SearchEntitiesOfTypeInTerritory = SearchEntitiesOfTypeInTerritory;

--- Searches player entities of a category in the territory.
--- @param _Territory integer ID of territory
--- @param _Category integer Category to search
--- @param _PlayerID integer ID of player
--- @return table Results List of entities
function SearchEntitiesOfCategoryInTerritory(_Territory, _Category, _PlayerID)
    return {};
end
API.SearchEntitiesOfCategoryInTerritory = SearchEntitiesOfCategoryInTerritory;
API.GetEntitiesOfCategoryInTerritory = SearchEntitiesOfCategoryInTerritory;

--- Searches entities with a scriptname matching the pattern.
---
--- **Note**: See pattern matchin in Lua 5.1 for more information!
--- @param _Pattern string Search pattern
--- @return table Results List of entities
function SearchEntitiesByScriptname(_Pattern)
    return {};
end
API.SearchEntitiesByScriptname = SearchEntitiesByScriptname;

--- Searches entities that are matching the filter.
---
--- #### Example:
--- This filter accepts all entities of player 1.
--- ```lua
--- local Filter = function(_ID)
---     if Logic.EntityGetPlayer(_ID) ~= 1 then
---         return false;
---     end
---     return true;
--- end
--- ```
--- @param _Filter any
--- @return table Results List of entities
function CommenceEntitySearch(_Filter)
    return {};
end
API.CommenceEntitySearch = CommenceEntitySearch;

--- Enables od disables storehouse sabotage when thives infiltrate the building.
--- @param _Flag boolean Active or deactivate
function ThiefDisableStorehouseEffect(_Flag)
end
API.ThiefDisableStorehouseEffect = ThiefDisableStorehouseEffect;

--- Enables od disables cathedral sabotage when thives infiltrate the building.
--- @param _Flag boolean Active or deactivate
function ThiefDisableCathedralEffect(_Flag)
end
API.ThiefDisableCathedralEffect = ThiefDisableCathedralEffect;

--- Enables od disables the thiefs ability to sabotage the cistern.
---
--- (Requires the AddOn "Eastern Realm")
---
--- @param _Flag boolean Active or deactivate
function ThiefDisableCisternEffect(_Flag)
end
API.ThiefDisableCisternEffect = ThiefDisableCisternEffect;

