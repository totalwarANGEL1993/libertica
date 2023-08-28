Lib = {
    Loader = {
        Paths = {
            -- Search in map file
            "maps/externalmap/" ..Framework.GetCurrentMapName().. "/",
            -- Search in script directory
            "script/",
        },

        Version = "LIB 1.0.0",
        Root = "liberty",
        IsLocalEnv = GUI ~= nil,
        IsHistoryEdition = Network.IsNATReady ~= nil,

        Sources = {},
        Loaded = {},
    },
};

API = {};
QSB = {};

--- @diagnostic disable: cast-local-type
--- @diagnostic disable: duplicate-set-field
--- @diagnostic disable: missing-return-value

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

