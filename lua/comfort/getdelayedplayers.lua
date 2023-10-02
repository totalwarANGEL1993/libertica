Lib.Require("comfort/GetActivePlayers");
Lib.Register("comfort/GetDelayedPlayers");

--- Returns all players that are currently loading in the multiplayer game.
--- @return table PlayerList List of delayed players
function GetDelayedPlayers()
    local PlayerList = {};
    for k, v in pairs(GetActivePlayers()) do
        if Network.IsWaitingForNetworkSlotID(API.GetPlayerSlotID(v)) then
            table.insert(PlayerList, v);
        end
    end
    return PlayerList;
end
API.GetDelayedPlayers = GetDelayedPlayers;

