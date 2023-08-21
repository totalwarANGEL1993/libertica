--- @diagnostic disable: cast-local-type
--- @diagnostic disable: duplicate-set-field
--- @diagnostic disable: missing-return-value

Lib = {
    Loader = {
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
    },
};

function Lib.Loader.PushPath(_Path)
end

function Lib.Loader.Require(_Path)
end
Lib.Require = Lib.Loader.Require;

function Lib.Loader.Register(_Path)
end
Lib.Register = Lib.Loader.Register;

function Lib.Loader.LoadSourceFile(_Source, _Path)
end

-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
-- ||||                                                                  |||| --
-- |||| MAIN                                                             |||| --
-- ||||                                                                  |||| --
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --

