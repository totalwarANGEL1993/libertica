-- Define module table
ExampleModule = {
    Global = {
        IsInstalled = false;
    },
    Local = {
        IsInstalled = false;
    },
}

-- Require dependencies
Lib.Require("comfort/global/ReplaceEntity");
Lib.Require("comfort/Round");
-- Require module components
Lib.Require("core/LibertyCore");
Lib.Require("module/example/global/Test1");
Lib.Require("module/example/global/Test2");
Lib.Require("module/example/local/Test1");
-- Register module
Lib.Register("module/example/ExampleModule");

-- Global initalizer method
function ExampleModule.Global:Install()
    LibertyCore.Global:Install();
    if not self.IsInstalled then

    end
    self.IsInstalled = true;
end

-- Local initalizer method
function ExampleModule.Local:Install()
    LibertyCore.Local:Install();
    if not self.IsInstalled then

    end
    self.IsInstalled = true;
end

