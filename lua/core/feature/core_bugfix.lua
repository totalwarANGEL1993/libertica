---@diagnostic disable: duplicate-set-field

Lib.Core.Bugfix = {};

Lib.Require("comfort/IsLocalScript");
Lib.Require("comfort/GetDistance");
Lib.Require("core/feature/Core_Text");
Lib.Register("core/feature/Core_Bugfix");

function Lib.Core.Bugfix:Initialize()
    if not IsLocalScript() then
        self:FixResourceSlotsInStorehouses();
        self:FixMiddleEuropeNpcBarracks();
        self:FixMerchantArrivedCheckpoints();
        self:FixDestroyAllPlayerUnits();
    end
    if IsLocalScript() then
        self:FixInteractiveObjectClicked();
		self:FixBigCathedralName();
        self:FixAbilityInfoWhenHomeless();
    end
end

function Lib.Core.Bugfix:OnSaveGameLoaded()
end

function Lib.Core.Bugfix:OnReportReceived(_ID, ...)
end

-- -------------------------------------------------------------------------- --
-- Luxury for NPCs

function Lib.Core.Bugfix:FixResourceSlotsInStorehouses()
    for i= 1, 8 do
        local StoreHouseID = Logic.GetStoreHouse(i);
        if StoreHouseID ~= 0 then
            Logic.AddGoodToStock(StoreHouseID, Goods.G_Salt, 0, true, true);
            Logic.AddGoodToStock(StoreHouseID, Goods.G_Dye, 0, true, true);
        end
    end
end

-- -------------------------------------------------------------------------- --
-- Respawning for ME barracks

function Lib.Core.Bugfix:FixMiddleEuropeNpcBarracks()
    GameCallback_OnBuildingConstructionComplete_Orig_Core_Bugfix = GameCallback_OnBuildingConstructionComplete;
    GameCallback_OnBuildingConstructionComplete = function(_PlayerID, _EntityID)
        GameCallback_OnBuildingConstructionComplete_Orig_Core_Bugfix(_PlayerID, _EntityID);
        local EntityType = Logic.GetEntityType(_EntityID);
        if EntityType == Entities.B_NPC_Barracks_ME then
            Logic.RespawnResourceSetMaxSpawn(_EntityID, 0.01);
            Logic.RespawnResourceSetMinSpawn(_EntityID, 0.01);
        end
    end

    for k, v in pairs(Logic.GetEntitiesOfType(Entities.B_NPC_Barracks_ME)) do
        Logic.RespawnResourceSetMaxSpawn(v, 0.01);
        Logic.RespawnResourceSetMinSpawn(v, 0.01);
    end
end

-- -------------------------------------------------------------------------- --
-- Delivery checkpoint

function Lib.Core.Bugfix:FixMerchantArrivedCheckpoints()
    function QuestTemplate:IsMerchantArrived(objective)
        if objective.Data[3] ~= nil then
            if objective.Data[3] == 1 then
                if objective.Data[5].ID ~= nil then
                    objective.Data[3] = objective.Data[5].ID;
                    DeleteQuestMerchantWithID(objective.Data[3]);
                    if MapCallback_DeliverCartSpawned then
                        MapCallback_DeliverCartSpawned(self, objective.Data[3], objective.Data[1]);
                    end
                end
            elseif Logic.IsEntityDestroyed(objective.Data[3]) then
                DeleteQuestMerchantWithID(objective.Data[3]);
                objective.Data[3] = nil;
                objective.Data[5].ID = nil;
            else
                local Target = objective.Data[6] and objective.Data[6] or self.SendingPlayer;
                local StorehouseID = Logic.GetStoreHouse(Target);
                local MarketplaceID = Logic.GetStoreHouse(Target);
                local HeadquartersID = Logic.GetStoreHouse(Target);
                local HasArrived = nil;

                if StorehouseID > 0 then
                    local x,y = Logic.GetBuildingApproachPosition(StorehouseID);
                    HasArrived = GetDistance(objective.Data[3], {X= x, Y= y}) < 1000;
                end
                if MarketplaceID > 0 then
                    local x,y = Logic.GetBuildingApproachPosition(MarketplaceID);
                    HasArrived = HasArrived or GetDistance(objective.Data[3], {X= x, Y= y}) < 1000;
                end
                if HeadquartersID > 0 then
                    local x,y = Logic.GetBuildingApproachPosition(HeadquartersID);
                    HasArrived = HasArrived or GetDistance(objective.Data[3], {X= x, Y= y}) < 1000;
                end
                return HasArrived;
            end
        end
        return false;
    end
end

-- -------------------------------------------------------------------------- --
-- IO costs

function Lib.Core.Bugfix:FixInteractiveObjectClicked()
    GUI_Interaction.InteractiveObjectClicked = function()
        local ButtonNumber = tonumber(XGUIEng.GetWidgetNameByID(XGUIEng.GetCurrentWidgetID()));
        local ObjectID = g_Interaction.ActiveObjectsOnScreen[ButtonNumber];
        if ObjectID == nil or not Logic.InteractiveObjectGetAvailability(ObjectID) then
            return;
        end
        local PlayerID = GUI.GetPlayerID();
        local Costs = {Logic.InteractiveObjectGetEffectiveCosts(ObjectID, PlayerID)};
        local CanNotBuyString = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_NotEnough_Resources");

        -- Check activation costs
        local Affordable = true;
        if Affordable and Costs ~= nil and Costs[1] ~= nil then
            if Costs[1] == Goods.G_Gold then
                CanNotBuyString = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_NotEnough_G_Gold");
            end
            if Costs[1] ~= Goods.G_Gold and Logic.GetGoodCategoryForGoodType(Costs[1]) ~= GoodCategories.GC_Resource then
                error("Only resources can be used as costs for objects!");
                Affordable = false;
            end
            Affordable = Affordable and GetPlayerGoodsInSettlement(Costs[1], PlayerID, false) >= Costs[2];
        end
        if Affordable and Costs ~= nil and Costs[3] ~= nil then
            if Costs[3] == Goods.G_Gold then
                CanNotBuyString = XGUIEng.GetStringTableText("Feedback_TextLines/TextLine_NotEnough_G_Gold");
            end
            if Costs[3] ~= Goods.G_Gold and Logic.GetGoodCategoryForGoodType(Costs[3]) ~= GoodCategories.GC_Resource then
                error("Only resources can be used as costs for objects!");
                Affordable = false;
            end
            Affordable = Affordable and GetPlayerGoodsInSettlement(Costs[3], PlayerID, false) >= Costs[4];
        end
        if not Affordable then
            Message(CanNotBuyString);
            return;
        end

        -- Check click override
        if not GUI_Interaction.InteractionClickOverride
        or not GUI_Interaction.InteractionClickOverride(ObjectID) then
            Sound.FXPlay2DSound( "ui\\menu_click");
        end
        -- Check feedback speech override
        if not GUI_Interaction.InteractionSpeechFeedbackOverride
        or not GUI_Interaction.InteractionSpeechFeedbackOverride(ObjectID) then
            GUI_FeedbackSpeech.Add("SpeechOnly_CartsSent", g_FeedbackSpeech.Categories.CartsUnderway, nil, nil);
        end
        -- Check action override and perform action
        if not Mission_Callback_OverrideObjectInteraction
        or not Mission_Callback_OverrideObjectInteraction(ObjectID, PlayerID, Costs) then
            GUI.ExecuteObjectInteraction(ObjectID, PlayerID);
        end
    end
end

-- -------------------------------------------------------------------------- --
-- Destroy all units

function Lib.Core.Bugfix:FixDestroyAllPlayerUnits()
    QuestTemplate.IsObjectiveCompleted_Orig_Core_Bugfix = QuestTemplate.IsObjectiveCompleted;
    QuestTemplate.IsObjectiveCompleted = function(self, objective)
        local objectiveType = objective.Type;
        if objective.Completed ~= nil then
            return objective.Completed;
        end
        local data = objective.Data;

        -- Solves the problem that special entities and construction sites
        -- let the script beleave that the player is still alive.
        if objectiveType == Objective.DestroyAllPlayerUnits then
            local PlayerEntities = GetPlayerEntities(data, 0);
            local IllegalEntities = {};

            for i= #PlayerEntities, 1, -1 do
                local Type = Logic.GetEntityType(PlayerEntities[i]);
                if Logic.IsEntityInCategory(PlayerEntities[i], EntityCategories.AttackableBuilding) == 0
                or Logic.IsEntityInCategory(PlayerEntities[i], EntityCategories.Wall) == 0 then
                    if Logic.IsConstructionComplete(PlayerEntities[i]) == 0 then
                        table.insert(IllegalEntities, PlayerEntities[i]);
                    end
                end
                local IndestructableEntities = {
                    Entities.XD_ScriptEntity,
                    Entities.S_AIHomePosition,
                    Entities.S_AIAreaDefinition
                };
                if table.contains(IndestructableEntities, Type) then
                    table.insert(IllegalEntities, PlayerEntities[i]);
                end
            end

            if #PlayerEntities == 0 or #PlayerEntities - #IllegalEntities == 0 then
                objective.Completed = true;
            end
        elseif objectiveType == Objective.Distance then
            objective.Completed = Lib.Core.Quest:IsQuestPositionReached(self, objective);
        else
            return self:IsObjectiveCompleted_Orig_Core_Bugfix(objective);
        end
    end
end

-- -------------------------------------------------------------------------- --
-- Cathedral name

function Lib.Core.Bugfix:FixBigCathedralName()
    AddStringText(
        "Names/B_Cathedral_Big",
        {de = "Dom", en = "Cathedral", fr = "Cathédrale"}
    );
end

-- -------------------------------------------------------------------------- --
-- Ability info

function Lib.Core.Bugfix:FixAbilityInfoWhenHomeless()
    StartKnightVoiceForActionSpecialAbility = function(_KnightType, _NoPriority)
        local PlayerID = GUI.GetPlayerID();
        local StorehouseID = Logic.GetStoreHouse(PlayerID);
        local KnightType = Logic.GetEntityType(Logic.GetKnightID(PlayerID));
        if  _KnightType == KnightType and StorehouseID ~= 0 and ActionAbilityIsExplained == nil then
            LocalScriptCallback_StartVoiceMessage(PlayerID, "Hint_SpecialAbilityAction", false, PlayerID, _NoPriority);
            ActionAbilityIsExplained  = true;
        end
    end

    StartKnightVoiceForPermanentSpecialAbility = function(_KnightType)
        local PlayerID = GUI.GetPlayerID();
        local StorehouseID = Logic.GetStoreHouse(PlayerID);
        local KnightType = Logic.GetEntityType(Logic.GetKnightID(PlayerID));
        if _KnightType == KnightType and StorehouseID ~= 0 and PermanentAbilityIsExplained == nil then
            LocalScriptCallback_StartVoiceMessage(PlayerID, "Hint_SpecialAbilityPermanetly", false, PlayerID);
            PermanentAbilityIsExplained  = true;
        end
    end
end
