--- 
Lib.Trade = {
    Name = "Trade",
    CinematicEvents = {},

    Global = {
        OfferSequence = 0,
        Warehouses = {Job = 0},
        Inflation = {
            Players = {},
            Inc = 0.12,
            Min = 0.50,
            Max = 1.75,
        },
    },
    Local = {
        Warehouses = {},
        Inflation = {
            Players = {},
            Inc = 0.12,
            Min = 0.50,
            Max = 1.75,
        },
    },

    Text = {
        NoOffer = {
            Title = {de = "Keine Angebote", en = "No Offers",},
        },
        BuyGood = {
            Text = {de = "%d %s kaufen%s", en = "Purchase %d %s%s",},
        },
        BuyEntertainer = {
            Text = {de = "%s anheuern", en = "Hire %s",},
        },
        BuyUnit = {
            Text = {de = "%s anheuern%s", en = "Hire %s%s",},
        },
        BuyWarMachine = {
            Text = {de = "%s kaufen%s", en = "Purchase %s%s",},
        },
    }
}

Lib.Require("comfort/GetSiegeengineTypeByCartType");
Lib.Require("comfort/IsMultiplayer");
Lib.Require("comfort/KeyOf");
Lib.Require("comfort/global/SendCart");
Lib.Require("core/Core");
Lib.Require("module/uitools/UITools");
Lib.Require("module/io/IO");
Lib.Require("module/uibuilding/UIBuilding");
Lib.Require("module/trade/Trade_API");
Lib.Register("module/trade/Trade");

-- -------------------------------------------------------------------------- --
-- Global

-- Global initalizer method
function Lib.Trade.Global:Initialize()
    if not self.IsInstalled then
        --- The player clicked an offer.
        ---
        --- #### Parameter
        --- * `PlayerID`      - ID of player
        --- * `ScriptName`    - Scriptname of warehouse
        --- * `Inflation`     - Calculated inflation
        --- * `OfferIndex`    - Index of offer
        --- * `OfferGood`     - Good or entity type purchased
        --- * `GoodAmount`    - Amount of goods
        --- * `PaymentType`   - Money good
        --- * `BasePrice`     - Base price
        Report.WarehouseOfferClicked = CreateReport("Event_WarehouseOfferClicked");

        Report.WarehouseOfferBought = CreateReport("Event_WarehouseOfferBought");

        self:OverwriteGameCallbacks();

        for i= 1, 8 do
            self.Inflation.Players[i] = {};
        end
        self.Warehouses.Job = RequestJob(function()
            Lib.Trade.Global:ControlWarehouse();
        end);
    end
    self.IsInstalled = true;
end

-- Global load game
function Lib.Trade.Global:OnSaveGameLoaded()
end

-- Global report listener
function Lib.Trade.Global:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    elseif _ID == Report.WarehouseOfferClicked then
        self:PerformTrade(unpack(arg));
        SendReportToLocal(_ID, unpack(arg));
    end
end

function Lib.Trade.Global:CreateWarehouse(_Data)
    local Warehouse = {
        ScriptName      = _Data.ScriptName,
        Offers          = {};
    }
    table.insert(self.Warehouses, Warehouse);

    for i= 1, 6 do
        if _Data.Offers[i] then
            self:CreateOffer(
                _Data.ScriptName,
                _Data.Offers[i].Amount,
                _Data.Offers[i].GoodType,
                _Data.Offers[i].GoodAmount,
                _Data.Offers[i].PaymentType,
                _Data.Offers[i].BasePrice,
                _Data.Offers[i].Refresh
            );
        end
    end
    ExecuteLocal([[Lib.Trade.Local:InitTradeButtons("%s")]], _Data.ScriptName .. "_Post");
end

function Lib.Trade.Global:GetIndex(_Name)
    for i= 1, #self.Warehouses do
        if self.Warehouses[i].ScriptName == _Name then
            return i;
        end
    end
    return 0;
end

function Lib.Trade.Global:CreateOffer(_Name, _Amount, _GoodType, _GoodAmount, _Payment, _BasePrice, _Refresh)
    local Index = self:GetIndex(_Name);
    if Index ~= 0 then
        -- Get amount
        local Amount = _Amount or 1;
        if  KeyOf(_GoodType, Goods) == nil and KeyOf(_GoodType, Entities) ~= nil
        and Logic.IsEntityTypeInCategory(_GoodType, EntityCategories.Military) == 0 then
            Amount = 1;
        end
        -- Insert offer
        self.OfferSequence = self.OfferSequence + 1;
        local ID = self.OfferSequence;
        table.insert(self.Warehouses[Index].Offers, {
            ID = ID,
            BuyLock = false,
            Active = true,
            Current = Amount,
            Amount = Amount,
            Timer = _Refresh or (3*60),
            Refresh = _Refresh or (3*60),
            GoodType = _GoodType,
            GoodAmount = _GoodAmount or 9,
            PaymentType = _Payment or Goods.G_Gold,
            BasePrice = _BasePrice or 3,
        });
        return ID;
    end
    return 0;
end

function Lib.Trade.Global:RemoveOffer(_Name, _ID)
    local Index = self:GetIndex(_Name);
    if Index ~= 0 then
        for i= #self.Warehouses[Index].Offers, 1, -1 do
            if self.Warehouses[Index].Offers[i].ID == _ID then
                table.remove(self.Warehouses[Index].Offers, i);
                break;
            end
        end
    end
end

function Lib.Trade.Global:DeactivateOffer(_Name, _ID, _Active)
    local Index = self:GetIndex(_Name);
    if Index ~= 0 then
        for i= #self.Warehouses[Index].Offers, 1, -1 do
            if self.Warehouses[Index].Offers[i].ID == _ID then
                self.Warehouses[Index].Offers[i].Active = _Active == true;
                break;
            end
        end
    end
end

function Lib.Trade.Global:ChangeOfferAmount(_Name, _ID, _Amount)
    local Index = self:GetIndex(_Name);
    if Index ~= 0 then
        for i= #self.Warehouses[Index].Offers, 1, -1 do
            if self.Warehouses[Index].Offers[i].ID == _ID then
                local Max = self.Warehouses[Index].Offers[_ID].Amount;
                self.Warehouses[Index].Offers[_ID].Current = math.min(_Amount, Max);
                break;
            end
        end
    end
end

function Lib.Trade.Global:GetInflation(_PlayerID, _GoodType)
    return self.Inflation.Players[_PlayerID][_GoodType] or 1.0;
end

function Lib.Trade.Global:SetInflation(_PlayerID, _GoodType, _Inflation)
    self.Inflation.Players[_PlayerID][_GoodType] = _Inflation or 1.0;
    ExecuteLocal(
        [[Lib.Trade.Local.Inflation.Players[%d][%d] = %f]],
        _PlayerID,
        _GoodType,
        _Inflation or 1.0
    )
end

function Lib.Trade.Global:CalculateInflation(_PlayerID, _GoodType)
    local Factor = (self.Inflation.Players[_PlayerID][_GoodType] or 1.0) + self.Inflation.Inc;
    Factor = math.max(self.Inflation.Min, Factor);
    Factor = math.min(Factor, self.Inflation.Max);
    return Factor;
end

function Lib.Trade.Global:PerformTrade(_PlayerID, _ScriptName, _Inflation, _Index, _OfferGood, _GoodAmount, _PaymentGood, _BasePrice)
    -- Send good type
    if KeyOf(_OfferGood, Goods) ~= nil then
        SendCart(_ScriptName.. "_Post", _PlayerID, _OfferGood, _GoodAmount);
    -- Create units
    elseif KeyOf(_OfferGood, Entities) ~= nil then
        if Logic.IsEntityTypeInCategory(_OfferGood, EntityCategories.Military) == 1 then
            local x,y = Logic.GetBuildingApproachPosition(GetID(_ScriptName.. "_Post"));
            local Orientation = Logic.GetEntityOrientation(GetID(_ScriptName.. "_Post")) - 90;
            local ID  = Logic.CreateBattalionOnUnblockedLand(_OfferGood, x, y, Orientation, _PlayerID);
            Logic.MoveSettler(ID, x, y, -1);
        else
            local x,y = Logic.GetBuildingApproachPosition(GetID(_ScriptName.. "_Post"));
            Logic.HireEntertainer(_OfferGood, _PlayerID, x, y);
        end
    end
    -- Pay offer
    local PaymentAmount = math.floor((_BasePrice * _Inflation) + 0.5);
    AddGood(_PaymentGood, (-1) * PaymentAmount, _PlayerID);
    ExecuteLocal([[GUI_FeedbackWidgets.GoldAdd(%d, nil, {3, 1, 1}, g_TexturePositions.Goods[%d])]], (-1) * PaymentAmount, _PaymentGood);
    -- Uodate offer
    self:UpdateOnPurchase(_PlayerID, _ScriptName, _Index);
    -- Send reports
    SendReport(Report.WarehouseOfferBought, _OfferGood, _GoodAmount, _PaymentGood, PaymentAmount);
    SendReportToLocal(Report.WarehouseOfferBought, _OfferGood, _GoodAmount, _PaymentGood, PaymentAmount);
end

function Lib.Trade.Global:UpdateOnPurchase(_PlayerID, _ScriptName, _ButtonIndex)
    local Index = self:GetIndex(_ScriptName);
    if Index ~= 0 then
        local Offer = self.Warehouses[Index].Offers[_ButtonIndex];
        -- Update offer amount
        self.Warehouses[Index].Offers[_ButtonIndex].Current = Offer.Current - 1;
        -- Update inflation
        local Inflation = self:CalculateInflation(_PlayerID, Offer.GoodType);
        self:SetInflation(_PlayerID, Offer.GoodType, Inflation);
    end
end

function Lib.Trade.Global:OverwriteGameCallbacks()
    self.Orig_GameCallback_OnBuildingConstructionComplete = GameCallback_OnBuildingConstructionComplete;
    GameCallback_OnBuildingConstructionComplete = function(_PlayerID, _EntityID)
        Lib.Trade.Global.Orig_GameCallback_OnBuildingConstructionComplete(_PlayerID, _EntityID);
        local Type = Logic.GetEntityType(_EntityID);
        if Type == Entities.B_TradePost then
            Lib.Trade.Global:OnTradepostConstructed(_EntityID);
        end
    end

    self.Orig_GameCallback_BuildingDestroyed = GameCallback_BuildingDestroyed;
    GameCallback_BuildingDestroyed = function(_EntityID, _PlayerID, _KnockedDown)
        Lib.Trade.Global.Orig_GameCallback_BuildingDestroyed(_EntityID, _PlayerID, _KnockedDown);
        local Type = Logic.GetEntityType(_EntityID);
        if Type == Entities.B_TradePost then
            Lib.Trade.Global:OnTradepostDestroyed(_EntityID);
        end
    end
end

function Lib.Trade.Global:OnTradepostConstructed(_EntityID)
    local x,y,z = Logic.EntityGetPos(_EntityID);
    local dx,dy = Logic.GetBuildingApproachPosition(_EntityID);
    local n, SiteID = Logic.GetEntitiesInArea(Entities.I_X_TradePostConstructionSite, x, y, 100, 1);
    if SiteID ~= 0 then
        local ScriptName = Logic.GetEntityName(SiteID);
        local Index = self:GetIndex(ScriptName);
        if Index ~= 0 then
            Logic.SetEntityName(_EntityID, ScriptName .. "_Post");
            local DoorPosID = Logic.CreateEntity(Entities.XD_ScriptEntity, dx, dy, 0, 0);
            Logic.SetEntityName(DoorPosID, ScriptName .. "_DoorPos");
        end
    end
end

function Lib.Trade.Global:OnTradepostDestroyed(_EntityID)
    local ScriptName = Logic.GetEntityName(_EntityID);
    local s,e = string.find(ScriptName, "_Post");
    local SiteName = string.sub(ScriptName, 1, s-1);
    local Index = self:GetIndex(ScriptName);
    if Index ~= 0 then
        DestroyEntity(SiteName .. "_DoorPos");
    end
end

function Lib.Trade.Global:ControlWarehouse()
    -- Refresh goods
    for i= 1, #self.Warehouses do
        if self.Warehouses[i] then
            for j= 1, #self.Warehouses[i].Offers do
                local Offer = self.Warehouses[i].Offers[j];
                if Offer.Active and Offer.Refresh > 0 then
                    if self.Warehouses[i].Offers[j].Current < Offer.Amount then
                        self.Warehouses[i].Offers[j].Timer = Offer.Timer - 1;
                        if Offer.Timer == 0 then
                            self.Warehouses[i].Offers[j].Current = Offer.Current + 1;
                            self.Warehouses[i].Offers[j].Timer = Offer.Refresh;
                        end
                    end
                end
            end
        end
    end
    -- Mirror in local script
    local Table = table.tostring(self.Warehouses);
    ExecuteLocal([[Lib.Trade.Local.Warehouses = %s]], Table);
end

-- -------------------------------------------------------------------------- --
-- Local

-- Local initalizer method
function Lib.Trade.Local:Initialize()
    if not self.IsInstalled then
        Report.WarehouseOfferClicked = CreateReport("Event_WarehouseOfferClicked");

        for i= 1, 8 do
            self.Inflation.Players[i] = {};
        end
    end
    self.IsInstalled = true;
end

-- Local load game
function Lib.Trade.Local:OnSaveGameLoaded()
end

-- Local report listener
function Lib.Trade.Local:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    elseif _ID == Report.WarehouseOfferClicked then
        if GUI.GetPlayerID() == arg[2] then
            local Index = self:GetIndex(arg[2]);
            if self.Warehouses[Index] then
                self.Warehouses[Index].Offers[arg[4]].BuyLock = false;
            end
        end
    end
end

function Lib.Trade.Local:GetIndex(_Name)
    for i= 1, #self.Warehouses do
        if self.Warehouses[i].ScriptName == _Name then
            return i;
        end
    end
    return 0;
end

function Lib.Trade.Local:GetPrice(_PlayerID, _GoodType, _BasePrice)
    return math.floor(((self.Inflation.Players[_PlayerID][_GoodType] or 1.0) * _BasePrice) + 0.5);
end

function Lib.Trade.Local:GetInflation(_PlayerID, _GoodType)
    return self.Inflation.Players[_PlayerID][_GoodType] or 1.0;
end

-- -------------------------------------------------------------------------- --

function Lib.Trade.Local:InitTradeButtons(_ScriptName)
    -- Button 1
    AddBuildingButtonByEntity(
        _ScriptName,
        function(_WidgetID, _EntityID) Lib.Trade.Local:WarehouseButtonAction(1, _WidgetID, _EntityID) end,
        function(_WidgetID, _EntityID) Lib.Trade.Local:WarehouseButtonTooltip(1, _WidgetID, _EntityID) end,
        function(_WidgetID, _EntityID) Lib.Trade.Local:WarehouseButtonUpdate(1, _WidgetID, _EntityID) end
    );
    -- Button 2
    AddBuildingButtonByEntity(
        _ScriptName,
        function(_WidgetID, _EntityID) Lib.Trade.Local:WarehouseButtonAction(2, _WidgetID, _EntityID) end,
        function(_WidgetID, _EntityID) Lib.Trade.Local:WarehouseButtonTooltip(2, _WidgetID, _EntityID) end,
        function(_WidgetID, _EntityID) Lib.Trade.Local:WarehouseButtonUpdate(2, _WidgetID, _EntityID) end
    );
    -- Button 3
    AddBuildingButtonByEntity(
        _ScriptName,
        function(_WidgetID, _EntityID) Lib.Trade.Local:WarehouseButtonAction(3, _WidgetID, _EntityID) end,
        function(_WidgetID, _EntityID) Lib.Trade.Local:WarehouseButtonTooltip(3, _WidgetID, _EntityID) end,
        function(_WidgetID, _EntityID) Lib.Trade.Local:WarehouseButtonUpdate(3, _WidgetID, _EntityID) end
    );
    -- Button 4
    AddBuildingButtonByEntity(
        _ScriptName,
        function(_WidgetID, _EntityID) Lib.Trade.Local:WarehouseButtonAction(4, _WidgetID, _EntityID) end,
        function(_WidgetID, _EntityID) Lib.Trade.Local:WarehouseButtonTooltip(4, _WidgetID, _EntityID) end,
        function(_WidgetID, _EntityID) Lib.Trade.Local:WarehouseButtonUpdate(4, _WidgetID, _EntityID) end
    );
    -- Button 5
    AddBuildingButtonByEntity(
        _ScriptName,
        function(_WidgetID, _EntityID) Lib.Trade.Local:WarehouseButtonAction(5, _WidgetID, _EntityID) end,
        function(_WidgetID, _EntityID) Lib.Trade.Local:WarehouseButtonTooltip(5, _WidgetID, _EntityID) end,
        function(_WidgetID, _EntityID) Lib.Trade.Local:WarehouseButtonUpdate(5, _WidgetID, _EntityID) end
    );
    -- Button 6
    AddBuildingButtonByEntity(
        _ScriptName,
        function(_WidgetID, _EntityID) Lib.Trade.Local:WarehouseButtonAction(6, _WidgetID, _EntityID) end,
        function(_WidgetID, _EntityID) Lib.Trade.Local:WarehouseButtonTooltip(6, _WidgetID, _EntityID) end,
        function(_WidgetID, _EntityID) Lib.Trade.Local:WarehouseButtonUpdate(6, _WidgetID, _EntityID) end
    );
end

function Lib.Trade.Local:WarehouseButtonAction(_ButtonIndex, _WidgetID, _EntityID)
    local PlayerID = GUI.GetPlayerID();
    local ScriptName = Logic.GetEntityName(_EntityID);
    local s,e = string.find(ScriptName, "_Post");
    ScriptName = string.sub(ScriptName, 1, s-1);
    local Index = self:GetIndex(ScriptName);
    if Index == 0 then
        return;
    end
    local Data = self.Warehouses[Index].Offers[_ButtonIndex];
    if not Data then
        return;
    end
    if self.Warehouses[Index].Offers[_ButtonIndex].BuyLock then
        return;
    end

    -- Get price
    local Price = self:GetPrice(PlayerID, Data.GoodType, Data.BasePrice);
    local Inflation = self:GetInflation(PlayerID, Data.GoodType);
    if GetPlayerGoodsInSettlement(Data.PaymentType, PlayerID) < Price then
        return;
    end
    -- Prevent click spam
    self.Warehouses[Index].Offers[_ButtonIndex].BuyLock = true;
    -- Send repot to global
    SendReportToGlobal(
        Report.WarehouseOfferClicked,
        PlayerID,
        ScriptName,
        Inflation,
        _ButtonIndex,
        Data.GoodType,
        Data.GoodAmount,
        Data.PaymentType,
        Data.BasePrice
    );
end

function Lib.Trade.Local:WarehouseButtonTooltip(_ButtonIndex, _WidgetID, _EntityID)
    local PlayerID = GUI.GetPlayerID();
    local ScriptName = Logic.GetEntityName(_EntityID);
    local s,e = string.find(ScriptName, "_Post");
    ScriptName = string.sub(ScriptName, 1, s-1);
    if XGUIEng.IsButtonDisabled(_WidgetID) == 1 then
        SetTooltipCosts(ConvertPlaceholders(Localize(Lib.Trade.Text.NoOffer.Title)), "");
        return;
    end
    local Index = self:GetIndex(ScriptName);
    if Index == 0 then
        return;
    end
    local Data = self.Warehouses[Index].Offers[_ButtonIndex];
    if not Data then
        return;
    end

    -- Get price
    local Price = self:GetPrice(PlayerID, Data.GoodType, Data.BasePrice);
    local InSettlement = true;
    -- Get name and description
    local OfferName = "";
    local OfferDescription = "";
    local GoodTypeName = Logic.GetGoodTypeName(Data.GoodType);
    local EntityTypeName = Logic.GetEntityTypeName(Data.GoodType);
    local EngineType = GetSiegeengineTypeByCartType(Data.GoodType);
    if GoodTypeName ~= nil and GoodTypeName ~= "" then
        OfferName = GetStringText("UI_ObjectNames/" ..GoodTypeName);
        OfferDescription = GetStringText("UI_ObjectDescription/" ..GoodTypeName);
    else
        OfferName = GetStringText("UI_ObjectNames/HireEntertainer");
        OfferDescription = GetStringText("UI_ObjectDescription/HireEntertainer");
        if Logic.IsEntityTypeInCategory(Data.GoodType, EntityCategories.Soldier) == 1 then
            OfferName = GetStringText("UI_ObjectNames/HireMercenaries");
            OfferDescription = GetStringText("UI_ObjectDescription/HireMercenaries");
        elseif EngineType or Logic.IsEntityTypeInCategory(Data.GoodType, EntityCategories.SiegeEngine) == 1 then
            OfferName = GetStringText("Names/" ..EntityTypeName);
            local EngineTypeName = Logic.GetEntityTypeName(EngineType);
            OfferDescription = GetStringText("UI_ObjectDescription/Abilities_" ..EngineTypeName);
        end
    end

    -- Format quantity text
    local Quantity = "";
    if Data.Amount > 1 then
        Quantity = string.format(" (%d/%d)", Data.Current, Data.Amount);
    end
    -- Format tooltip text
    local OfferTitle = "";
    if KeyOf(Data.GoodType, Goods) ~= nil then
        OfferTitle = string.format(Localize(Lib.Trade.Text.BuyGood.Text), Data.GoodAmount, OfferName, Quantity);
    elseif KeyOf(Data.GoodType, Entities) ~= nil then
        if Logic.IsEntityTypeInCategory(Data.GoodType, EntityCategories.Military) == 1 then
            OfferTitle = string.format(Localize(Lib.Trade.Text.BuyUnit.Text), OfferName, Quantity);
        elseif Logic.IsEntityTypeInCategory(Data.GoodType, EntityCategories.SiegeEngine) == 1 then
            OfferTitle = string.format(Localize(Lib.Trade.Text.BuyWarMachine.Text), OfferName, Quantity);
        else
            OfferTitle = string.format(Localize(Lib.Trade.Text.BuyEntertainer.Text), OfferName);
        end
    end
    -- Set text
    SetTooltipCosts(
        OfferTitle,
        OfferDescription,
        nil,
        {Data.PaymentType, Price},
        InSettlement
    );
end

function Lib.Trade.Local:WarehouseButtonUpdate(_ButtonIndex, _WidgetID, _EntityID)
    local ScriptName = Logic.GetEntityName(_EntityID);
    local s,e = string.find(ScriptName, "_Post");
    ScriptName = string.sub(ScriptName, 1, s-1);
    local Index = self:GetIndex(ScriptName);
    if Index == 0 or not self.Warehouses[Index].Offers[_ButtonIndex]
    or not self.Warehouses[Index].Offers[_ButtonIndex].Active then
        XGUIEng.ShowWidget(_WidgetID, 0);
        return;
    end
    if not self.Warehouses[Index].Offers[_ButtonIndex].BuyLock
    and self.Warehouses[Index].Offers[_ButtonIndex].Current > 0 then
        XGUIEng.DisableButton(_WidgetID, 0);
    else
        XGUIEng.DisableButton(_WidgetID, 1);
    end

    local Good = self.Warehouses[Index].Offers[_ButtonIndex].GoodType;
    local Icon = g_TexturePositions.Goods[Good] or g_TexturePositions.Entities[Good];
    ChangeIcon(_WidgetID, Icon);
end

-- -------------------------------------------------------------------------- --

RegisterModule(Lib.Trade.Name);

