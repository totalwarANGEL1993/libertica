-- ...................../´¯¯/)
-- ...................,/¯.../
-- .................../..../
-- .............../´¯/'..'/´¯¯`·¸
-- .........../'/.../..../....../¨¯\
-- ..........('(....´...´... ¯~/'..')
-- ...........\..............'...../
-- ............\....\.........._.·´
-- .............\..............(
-- ..............\..............\
-- Steal my IP and I'll sue you!

Lib.Require("comfort/global/GetQuestID");
Lib.Require("comfort/global/IsValidQuest");
Lib.Register("module/quest/QuestModule");

Lib.Quest = {
    Name = "Quest",

    Global = {
        IsInstalled = false;
    },
    Local = {
        IsInstalled = false;
    },
}

-- -------------------------------------------------------------------------- --
-- Global

-- Global initalizer method
function Lib.Quest.Global:Initialize()
    if not self.IsInstalled then

    end
    self.IsInstalled = true;
end

-- Global load game
function Lib.Quest.Global:OnSaveGameLoaded()
end

-- -------------------------------------------------------------------------- --
-- Local

-- Local initalizer method
function Lib.Quest.Local:Initialize()
    if not self.IsInstalled then

    end
    self.IsInstalled = true;
end

-- Local load game
function Lib.Quest.Local:OnSaveGameLoaded()
end

-- -------------------------------------------------------------------------- --

RegisterModule(Lib.Quest.Name);

