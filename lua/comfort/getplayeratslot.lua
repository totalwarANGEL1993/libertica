Lib.Register("comfort/GetPlayerAtSlot");

--- Returns the player ID of the player at the slot in a multiplayer game.
--- @param _SlotID integer ID of slot
--- @return integer ID Player at slot
function GetPlayerAtSlot(_SlotID)
    if Network.IsNetworkSlotIDUsed(_SlotID) then
        local CurrentPlayerID = Logic.GetSlotPlayerID(_SlotID);
        if Logic.PlayerGetIsHumanFlag(CurrentPlayerID)  then
            return CurrentPlayerID;
        end
    end
    return 0;
end
API.GetSlotPlayerID = GetPlayerAtSlot;

