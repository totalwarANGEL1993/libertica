-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
-- ||||                          LOKALES SKRIPT                          |||| --
-- ||||                    --------------------------                    |||| --
-- ||||                            Testmap 21                            |||| --
-- ||||                           totalwarANGEL                          |||| --
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --

-- ========================================================================== --

Script.Load("maps/externalmap/" ..Framework.GetCurrentMapName().. "/liberty/liberator.lua");

if CONST_IS_IN_DEV then
    Lib.Loader.PushPath("E:/Repositories/liberty/var/");
end
Lib.Require("comfort/KeyOf");
Lib.Require("core/Core");
Lib.Require("module/promotion/Promotion");
Lib.Require("module/construction/Construction");
Lib.Require("module/lifestock/LifestockSystem");

-- ========================================================================== --

BuildRule_Palisade = function(_PlayerID, _IsWall, _x, _y, _HomeTerritoryID, _OutpostType)
    local TerritoryID = Logic.GetTerritoryAtPosition(_x, _y);
    local n, OutpostID = Logic.GetPlayerEntitiesInArea(_PlayerID, _OutpostType, _x, _y, 1500, 1);
    if not _IsWall and TerritoryID ~= _HomeTerritoryID then
        return n > 0 and Logic.IsConstructionComplete(OutpostID) == 1;
    end
    return true;
end

BuildRule_Wall = function(_PlayerID, _IsWall, _x, _y, _HomeTerritoryID)
    local TerritoryID = Logic.GetTerritoryAtPosition(_x, _y);
    if _IsWall then
        return TerritoryID == _HomeTerritoryID;
    end
    return true;
end

-- ========================================================================== --

function GameCallback_Lib_LoadingFinished()
end

