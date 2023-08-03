Lib = {
    Paths = {
        -- Search in map file
        "maps/externalmap/" ..Framework.GetCurrentMapName().. "/",
        -- Search in script directory
        "script/",
    },

    Version = "1.0.0",
    Root = "liberty",
    IsLocalEnv = GUI ~= nil,
    IsHistoryEdition = Network.IsNATReady ~= nil,

    Sources = {},
    Loaded = {},
};

--- Loads a component at the given relative path.
---
--- Must be called before questsystembehavior.lua is loaded (if loaded).
---
--- If the path does contain "/global/" or "/local/" then the operation will
--- be aborted if the environment does not match. Scripts outside of those
--- folders will be treated as shared scripts and are always loaded.
---
--- @param _Path string Relative path
function Lib.Require(_Path)
    _Path = _Path:lower();
    local Key = _Path:gsub("/", "_");

    -- Do not load globals in local
    if Lib.IsLocalEnv == true and _Path:find("/global/") then
        return;
    end
    -- Do not load locals in global
    if Lib.IsLocalEnv == false and _Path:find("/local/") then
        return;
    end

    for i= 1, #Lib.Paths do
        if not Lib.Loaded[Key] then
            Lib.Sources[Key] = Lib.Paths[i];
            Lib.Load(Lib.Paths[i], _Path);
        end
    end
    assert(Lib.Loaded[Key] ~= nil, "\nFile not found: \n".._Path);
    Lib.Sources[Key] = nil;
end

--- Adds a custom path at the top of the search order.
--- @param _Path string Relative path
function Lib.PushPath(_Path)
    table.insert(Lib.Paths, 1, _Path:lower());
end

--- DO NOT USE THIS MANUALLY!
--- Registers a component as found.
--- @param _Path string Relative path
function Lib.Register(_Path)
    local Key = _Path:gsub("/", "_"):lower();
    Lib.Loaded[Key] = Lib.Sources[Key] .. Lib.Root .. "/";
end

--- DO NOT USE THIS MANUALLY!
--- Loads the component from the source folder.
--- @param _Source string Path where the component is loaded from
--- @param _Path string   Relative path of component
function Lib.Load(_Source, _Path)
    local Path = _Source .. Lib.Root .. "/" .._Path:lower();
    Script.Load(Path.. ".lua");
end

