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

Lib.Require("core/LibertyCore");
Lib.Register("module/questsystem/questsystem");

QuestModule = {
    Name = "QuestModule",

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
function QuestModule.Global:Initialize()
    if not self.IsInstalled then

    end
    self.IsInstalled = true;
end

-- Global load game
function QuestModule.Global:OnSaveGameLoaded()
end

-- -------------------------------------------------------------------------- --
-- Local

-- Local initalizer method
function QuestModule.Local:Initialize()
    if not self.IsInstalled then

    end
    self.IsInstalled = true;
end

-- Local load game
function QuestModule.Local:OnSaveGameLoaded()
end

-- -------------------------------------------------------------------------- --

RegisterModule(QuestModule.Name);

