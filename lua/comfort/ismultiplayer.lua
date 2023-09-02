Lib.Register("comfort/IsMultiplayer");

--- Returns if the game is a network game.
--- @return boolean IsMultiplayer Game is multiplayer
function IsMultiplayer()
    return Framework.IsNetworkGame();
end
API.IsMultiplayer = IsMultiplayer;

