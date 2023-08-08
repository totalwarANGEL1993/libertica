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

CONST_LOG_LEVEL_ALL     = 4;
CONST_LOG_LEVEL_INFO    = 3;
CONST_LOG_LEVEL_WARNING = 2;
CONST_LOG_LEVEL_ERROR   = 1;
CONST_LOG_LEVEL_OFF     = 0;

Lib.Core.Logging = {
    FileLogLevel = CONST_LOG_LEVEL_INFO,
    LogLevel = CONST_LOG_LEVEL_ERROR,
}

Lib.Require("comfort/IsLocalScript");
Lib.Register("core/feature/Core_Logging");

-- -------------------------------------------------------------------------- --

function Lib.Core.Logging:Initialize()
end

function Lib.Core.Logging:OnSaveGameLoaded()
end

function Lib.Core.Logging:OnReportReceived(_ID, ...)
end

-- -------------------------------------------------------------------------- --

function Lib.Core.Logging:Log(_Text, _Level, _Verbose)
    if self.FileLogLevel >= _Level then
        local Level = _Text:sub(1, _Text:find(":"));
        local Text = _Text:sub(_Text:find(":")+1);
        Text = string.format(
            " (%s) %s%s",
            (IsLocalScript() and "local") or "global",
            Framework.GetSystemTimeDateString(),
            Text
        )
        Framework.WriteToLog(Level .. Text);
    end
    if _Verbose then
        if not IsLocalScript() then
            if self.LogLevel >= _Level then
                Logic.ExecuteInLuaLocalState(string.format(
                    [[GUI.AddStaticNote("%s")]],
                    _Text
                ));
            end
            return;
        end
        if self.LogLevel >= _Level then
            GUI.AddStaticNote(_Text);
        end
    end
end

function debug(_Text, _Silent)
    Lib.Core.Logging:Log("DEBUG: " .._Text, CONST_LOG_LEVEL_ALL, not _Silent);
end
function info(_Text, _Silent)
    Lib.Core.Logging:Log("INFO: " .._Text, CONST_LOG_LEVEL_INFO, not _Silent);
end
function warn(_Text, _Silent)
    Lib.Core.Logging:Log("WARNING: " .._Text, CONST_LOG_LEVEL_WARNING, not _Silent);
end
function error(_Text, _Silent)
    Lib.Core.Logging:Log("ERROR: " .._Text, CONST_LOG_LEVEL_ERROR, not _Silent);
end

