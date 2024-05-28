-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
-- ||||                          LOKALES SKRIPT                          |||| --
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

