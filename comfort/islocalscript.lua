Lib.Register("comfort/IsLocalScript");

--- Returns if the environment is the local script.
--- @return boolean IsLocalEnv Enviroment is local script
function IsLocalScript()
    return GUI ~= nil;
end
API.IsLocalScript = IsLocalScript;

