Lib.Register("comfort/IsMultiplayerReady");

--- Returns if the multiplayer game is ready.
--- @return boolean GameReady Multiplayer game ready
function IsMultiplayerReady()
    return Framework.IsNetworkGame() and Network.SessionHaveAllPlayersFinishedLoading() == true;
end

