Lib.Require("comfort/IsLocalScript");
Lib.Register("module/entity/EntityEvent_API");

--- Sucht alle Entitäten des Spielers.
--- @param _PlayerID integer ID des Spielers
--- @param _WithoutDefeatResistant boolean Ignoriere niederlageirrelevant
--- @return table Results Liste mit Entitäten
function SearchEntities(_PlayerID, _WithoutDefeatResistant)
    return {};
end
API.SearchEntities = SearchEntities;

--- Searches player entities of a type in the area.
--- @param _Area integer Größe des Gebiet
--- @param _Position any Entität oder Position
--- @param _Type integer Gesuchter Typ
--- @param _PlayerID integer ID des Spielers
--- @return table Results Liste mit Entitäten
function SearchEntitiesOfTypeInArea(_Area, _Position, _Type, _PlayerID)
    return {};
end
API.SearchEntitiesOfTypeInArea = SearchEntitiesOfTypeInArea;

--- Searches player entities of a category in the area.
--- @param _Area integer Größe des Gebiet
--- @param _Position any Entität oder Position
--- @param _Category integer Gesuchte Kategorie
--- @param _PlayerID integer ID des Spielers
--- @return table Results Liste mit Entitäten
function SearchEntitiesOfCategoryInArea(_Area, _Position, _Category, _PlayerID)
    return {};
end
API.SearchEntitiesOfCategoryInArea = SearchEntitiesOfCategoryInArea;

--- Searches player entities of a type in the territory.
--- @param _Territory integer ID des Territorium
--- @param _Type integer Gesuchter Typ
--- @param _PlayerID integer ID des Spielers
--- @return table Results Liste mit Entitäten
function SearchEntitiesOfTypeInTerritory(_Territory, _Type, _PlayerID)
    return {};
end
API.SearchEntitiesOfTypeInTerritory = SearchEntitiesOfTypeInTerritory;

--- Searches player entities of a category in the territory.
--- @param _Territory integer ID des Territorium
--- @param _Category integer Gesuchte Kategorie
--- @param _PlayerID integer ID des Spielers
--- @return table Results Liste mit Entitäten
function SearchEntitiesOfCategoryInTerritory(_Territory, _Category, _PlayerID)
    return {};
end
API.SearchEntitiesOfCategoryInTerritory = SearchEntitiesOfCategoryInTerritory;
API.GetEntitiesOfCategoryInTerritory = SearchEntitiesOfCategoryInTerritory;

--- Sucht Entitäten mit einem Skriptnamen, der zu dem Muster passt.
---
--- **Hinweis**: Siehe dazu Pattern Matching in Lua 5.1 für mehr Infos!
--- @param _Pattern string Suchmuster
--- @return table Results Liste mit Entitäten
function SearchEntitiesByScriptname(_Pattern)
    return {};
end
API.SearchEntitiesByScriptname = SearchEntitiesByScriptname;

--- Sucht Entitäten anhand des übergebenen Filters.
---
--- Ein Filter ist eine Funktion, die für jede gefundene Entität prüft, ob sie
--- zur Ergebnismenge gehört oder nicht.
---
--- #### Beispiel:
--- Dieser Filter akzeptiert alle Entitäten von Spieler 1.
--- ```lua
--- local Filter = function(_ID)
---     if Logic.EntityGetPlayer(_ID) ~= 1 then
---         return false;
---     end
---     return true;
--- end
--- ```
--- @param _Filter any
--- @return table Results Liste mit Entitäten
function CommenceEntitySearch(_Filter)
    return {};
end
API.CommenceEntitySearch = CommenceEntitySearch;

--- Aktiviert/Deaktiviert die Sabotage eines Lagerhauses durch Diebe.
--- @param _Flag boolean Aktivieren/Deaktivieren
function ThiefDisableStorehouseEffect(_Flag)
end
API.ThiefDisableStorehouseEffect = ThiefDisableStorehouseEffect;

--- Aktiviert/Deaktiviert Die Sabotage einer Kirche durch Diebe.
--- @param _Flag boolean Aktivieren/Deaktivieren
function ThiefDisableCathedralEffect(_Flag)
end
API.ThiefDisableCathedralEffect = ThiefDisableCathedralEffect;

--- Aktiviert/Deaktiviert Die Sabotage von Brunnen durch Diebe.
---
--- (Benötigt das Addon "Reich des Ostens")
---
--- @param _Flag boolean Aktivieren/Deaktivieren
function ThiefDisableCisternEffect(_Flag)
end
API.ThiefDisableCisternEffect = ThiefDisableCisternEffect;

