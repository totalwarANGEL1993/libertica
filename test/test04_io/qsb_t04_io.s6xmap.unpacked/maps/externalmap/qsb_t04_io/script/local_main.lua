-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
-- ||||                          LOKALES SKRIPT                          |||| --
-- ||||                    --------------------------                    |||| --
-- ||||                            Testmap 04                            |||| --
-- ||||                           totalwarANGEL                          |||| --
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --

-- ========================================================================== --

if CONST_IS_IN_DEV then
    Script.Load("E:/Repositories/libertica/var/libertica/librarian.lua");
    Lib.Loader.PushPath("E:/Repositories/libertica/var/");
else
    Script.Load("maps/externalmap/qsb_t04_io/libertica/librarian.lua");
end
Lib.Require("core/Core");
Lib.Require("module/quest/Quest");
Lib.Require("module/entity/NPC");
Lib.Require("module/io/IO");
Lib.Require("module/io/IOChest");
Lib.Require("module/io/IOMine");
Lib.Require("module/ui/UIBuilding");
Lib.Require("module/faker/Technology");
Lib.Require("module/trade/Warehouse");
Lib.Require("module/city/Promotion");

-- ========================================================================== --

function TestBuildingButtons()
    SpecialButtonID = AddBuildingButtonByEntity(
        "HQ1",
        -- Aktion
        function(_WidgetID, _BuildingID)
            GUI.AddNote("Hier passiert etwas!");
        end,
        -- Tooltip
        function(_WidgetID, _BuildingID)
            -- Es MUSS ein Kostentooltip verwendet werden.
            SetTooltipCosts("Beschreibung", "Das ist die Beschreibung!");
        end,
        -- Update
        function(_WidgetID, _BuildingID)
            -- Ausblenden, wenn noch in Bau
            if Logic.IsConstructionComplete(_BuildingID) == 0 then
                XGUIEng.ShowWidget(_WidgetID, 0);
                return;
            end
            -- Deaktivieren, wenn ausgebaut wird.
            if Logic.IsBuildingBeingUpgraded(_BuildingID) then
                XGUIEng.DisableButton(_WidgetID, 1);
            end
            SetIcon(_WidgetID, {1, 1});
        end
    );
end

-- ========================================================================== --

function GameCallback_Lib_LoadingFinished()
    TestBuildingButtons();
end

