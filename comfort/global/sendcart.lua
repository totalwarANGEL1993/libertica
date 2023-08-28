Lib.Require("comfort/global/CreateStock");
Lib.Require("comfort/global/CreateCartByGoodType");
Lib.Register("comfort/global/SendCart");

--- Sends a cart with a good to a player.
--- @param _Position any ID or script name
--- @param _PlayerID integer Receiving player ID
--- @param _GoodType integer Type of good
--- @param _Amount integer Amount of good
--- @param _CartOverlay? integer Type of cart
--- @param _IgnoreReservation? boolean Ignore if market full
--- @param _Overtake? boolean Replace script entity
--- @return integer ID ID of cart
function SendCart(_Position, _PlayerID, _GoodType, _Amount, _CartOverlay, _IgnoreReservation, _Overtake)
    assert(Lib.IsLocalEnv == false, "Can only be used in global script.");
    local OriginalID = GetID(_Position);
    if not IsExisting(OriginalID) then
        return 0;
    end
    local Orientation = Logic.GetEntityOrientation(OriginalID);
    local ScriptName = Logic.GetEntityName(OriginalID);
    local ID = CreateCartByGoodType(_PlayerID, OriginalID, _GoodType, Orientation, _CartOverlay);
    assert(ID ~= 0, "Cart was not created properly.");
    CreateStock(_PlayerID, _GoodType);
    Logic.HireMerchant(ID, _PlayerID, _GoodType, _Amount, _PlayerID, _IgnoreReservation);
    if _Overtake and Logic.IsBuilding(OriginalID) == 0 then
        Logic.SetEntityName(ID, ScriptName);
        DestroyEntity(OriginalID);
    end
    return ID;
end
API.SendCart = SendCart;

