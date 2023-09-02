Lib.Require("comfort/IsLocalScript");
Lib.Register("module/trade/Trade_API");

--- Defines a tradepost construction site as warehouse.
---
--- #### Config parameters
--- * `ScriptName` - Script name of construction site
--- * `Offers`     - List of offers (max. 6 visible offers)
---
--- #### Examples
--- ```lua
--- CreateWarehouse {
---     ScriptName       = "TP3",
---     Offers           = {
---         -- Resource offer
---         {Amount      = 3,
---          GoodType    = Goods.G_Iron,
---          BasePrice   = 80},
---         -- Product offer
---         {Amount      = 3,
---          GoodType    = Goods.G_Sausage,
---          BasePrice   = 150},
---         -- Luxury offer
---         {Amount      = 3,
---          GoodType    = Goods.G_Gems,
---          GoodAmount  = 27,
---          BasePrice   = 300},
---         -- Entertainer offer
---         {GoodType    = Entities.U_Entertainer_NA_FireEater,
---          BasePrice   = 250,
---          Refresh     = 500},
---         -- Mercenary offer
---         {Amount      = 3,
---          GoodType    = Entities.U_MilitaryBandit_Melee_ME,
---          PaymentType = Goods.G_Iron,
---          BasePrice   = 3},
---         -- Mercenary offer
---         {Amount      = 3,
---          GoodType    = Entities.U_CatapultCart,
---          BasePrice   = 1000},
---     },
--- };
--- ```
---
--- @param _Data table Config of warehouse
function CreateWarehouse(_Data)
    Lib.Trade.Global:CreateWarehouse(_Data);
end

--- Creates an offer for the warehouse.
--- @param _Name string                     Scriptname of warehouse
--- @param _Amount integer                  Amount of offers
--- @param _GoodOrEntityType integer        Type of offered good or entity
--- @param __GoodOrEntityTypeAmount integer Amount of sold (only goods)
--- @param _Payment integer                 Type of paymend good (resource only)
--- @param _BasePrice integer               Basic price without inflation
--- @param _Refresh integer                 Time until offer respawns (0 = no respawn)
--- @return integer ID ID of offer or 0 on error
function CreateOffer(_Name, _Amount, _GoodOrEntityType, __GoodOrEntityTypeAmount, _Payment, _BasePrice, _Refresh)
    return Lib.Trade.Global:CreateOffer(_Name, _Amount, _GoodOrEntityType, __GoodOrEntityTypeAmount, _Payment, _BasePrice, _Refresh);
end

--- Removes the offer from the warehouse.
--- @param _Name string Scriptname of warehouse
--- @param _ID integer ID of offer
function RemoveOffer(_Name, _ID)
    Lib.Trade.Global:RemoveOffer(_Name, _ID);
end

--- Removes the offer from the warehouse.
--- @param _Name string Scriptname of warehouse
--- @param _ID integer ID of offer
--- @param _Active boolean Offer is active
function DeactivateOffer(_Name, _ID, _Active)
    Lib.Trade.Global:DeactivateOffer(_Name, _ID, _Active);
end

--- Returns the global inflation for the good or entity type.
--- @param _PlayerID integer ID of player
--- @param _GoodOrEntityType integer Offer type
--- @return number Inflation Inflation factor
function GetInflation(_PlayerID, _GoodOrEntityType)
    return Lib.Trade.Global:GetInflation(_PlayerID, _GoodOrEntityType);
end

--- Changes the global inflation for the good or entity type.
--- @param _PlayerID integer ID of player
--- @param _GoodOrEntityType integer Offer type
--- @param _Inflation number Inflation factor
function SetInflation(_PlayerID, _GoodOrEntityType, _Inflation)
    Lib.Trade.Global:SetInflation(_PlayerID, _GoodOrEntityType, _Inflation);
end

