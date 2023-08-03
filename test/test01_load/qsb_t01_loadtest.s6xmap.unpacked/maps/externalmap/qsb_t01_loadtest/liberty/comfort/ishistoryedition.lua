Lib.Register("comfort/IsHistoryEdition");

--- Returns if the game version is history edition.
--- @return boolean IsHistoryEdition Game is history edition
function IsHistoryEdition()
    return Network.IsNATReady ~= nil;
end

