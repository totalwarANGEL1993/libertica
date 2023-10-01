LibWriter = {
    ComponentList = {
        "core/Core",
        "module/construction/Construction",
        "module/npc/NPC",
        "module/promotion/Promotion",
        "module/io/IO",
        "module/iochest/IOChest",
        "module/iomine/IOMine",
        "module/quest/Quest",
        "module/technology/Technology",
        "module/warehouse/Warehouse",
        "module/uitools/UITools",
        "module/uieffects/UIEffects",
        "module/uibuilding/UIBuilding",
        "module/information/BriefingSystem",
        "module/information/CutsceneSystem",
        "module/information/DialogSystem",
    },
    Behaviors = "",
    Compile = false,
    LoadOrderFromFile = false,
    SingleFile = false,
}

--- Runs the build process.
--- @param ... unknown Program arguments
function LibWriter:Run(...)
    local Action = self:ProcessArguments();
    if Action == 0 then
        print("Usage:");
        print("-b [-c] [-s] [-o] [Files] - build library in var/liberty");
        print("                            * -c compiles files to bytecode");
        print("                            * -s creates a single file version");
        print("                            * -o loadorder from following wile");
        print("-l [-o] [Files]           - alphabetical list of loaded dependencies");
        print("-h                        - show this help");
        return;
    end

    if Action == 1 then
        os.execute('rm -rf var');
        if self.SingleFile then
            os.execute('mkdir "var"');
            self:CreateSingleFile();
        else
            os.execute('mkdir "var/liberty"');
            self:CopyModules();
            self:CreateQsb();
        end
    elseif Action == 2 then
        print("Files loaded:");
        local Files = self:ReadFilesLoop();
        table.sort(Files);
        for i= 1, #Files do
            print("> " ..Files[i]:lower());
        end
    end
end

--- Takes the programm arguments and processes them as source paths.
--- * 0  Arguments: Take default component list
--- * 1  Argument:  Load list from file
--- * 2+ Arguments: Load as components in this order
function LibWriter:ProcessArguments()
    if #arg > 0 then
        local Command = table.remove(arg, 1);
        local Parameter = arg;
        if Command == "-b" or Command == "build" then
            -- Compile?
            Command = arg[1];
            if Command and Command == "-c" then
                self.Compile = true;
                table.remove(arg, 1);
            end
            -- Single file?
            Command = arg[1];
            if Command and Command == "-s" then
                self.SingleFile = true;
                table.remove(arg, 1);
            end
            -- load order from file?
            Command = arg[1];
            if Command and Command == "-o" then
                self.LoadOrderFromFile = true;
                table.remove(arg, 1);
            end

            if #Parameter > 0 then
                if self.LoadOrderFromFile then
                    self.ComponentList = self:GetLoadOrderFromFile(Parameter[1]);
                else
                    self.ComponentList = Parameter;
                end
            end
            return 1;
        elseif Command == "-l" or Command == "list" then
            -- load order from file?
            Command = arg[1];
            if Command and Command == "-o" then
                self.LoadOrderFromFile = true;
                table.remove(arg, 1);
            end

            if #Parameter > 0 then
                if self.LoadOrderFromFile then
                    self.ComponentList = self:GetLoadOrderFromFile(Parameter[1]);
                else
                    self.ComponentList = Parameter;
                end
            end
            return 2;
        end
    end
    return 0;
end

--- Creates a single file version of the library.
function LibWriter:CreateSingleFile()
    local code = "";
    local fh, behaviors, content;

    -- Read loader mock
    fh = assert(io.open("loadersf.lua", "rb"));
    content = fh:read("*all");
    code = code .. content;
    fh:close();

    -- Read components
    local imports = self:ReadFilesLoop();
    table.sort(imports, function(a,b)
        if string.find(a, "_") and not string.find(b, "_") then
            return false;
        end
        if string.find(b, "_") and not string.find(a, "_") then
            return true;
        end
        return a < b;
    end);
    for i= 1, #imports do
        fh = assert(io.open("lua/" ..imports[i].. ".lua", "rb"));
        content = fh:read("*all");
        code = code .. content;
        fh:close();
    end

    -- Read behaviors
    behaviors = self:ConcatBehaviors();
    code = code .. behaviors;

    -- Create file
    fh = assert(io.open("var/qsb.lua", "wb"));
    fh:write(code);
    fh:close();
    self:CompileFile('var/qsb.lua', 'var/qsb.lua');
end

--- Copies the module files with dependencies to the output folder.
function LibWriter:CopyModules()
    os.execute('cp "loader.lua" "var/liberty/liberator.lua');
    self:CompileFile('var/liberty/liberator.lua', 'var/liberty/liberator.lua');

    local imports = self:ReadFilesLoop();
    for i= #imports, 1, -1 do
        local index = string.find(imports[i], "/[^/]*$");
        local Path = 'var/liberty/'..imports[i]:sub(1, index-1);
        local File = imports[i]:sub(index+1):lower();
        if not self:IsDir(Path) then
            os.execute('mkdir "'..Path..'"');
        end
        os.execute('cp "lua/'..imports[i]..'.lua" "'..Path..'/'..File..'.lua"');
        self:CompileFile('"lua/'..imports[i]..'.lua"', Path.. '/' ..File.. '.lua');
    end
end

--- Concatinates all behavior.lua files in all active modules,
--- creates the QSB and writes it to output folder.
function LibWriter:CreateQsb()
    local behaviors = self:ConcatBehaviors();
    local fh = assert(io.open("var/liberty/qsb.lua", "wb"));
    fh:write(behaviors);
    fh:close();
    self:CompileFile('var/liberty/qsb.lua', 'var/liberty/qsb.lua');
end

--- Reads all behavior files from the components and returns them as lua string.
function LibWriter:ConcatBehaviors()
    local fh, index, content, template, behaviors;
    fh = assert(io.open("lua/core/qsb.lua", "rb"));
    template = fh:read("*all");
    fh:close();
    behaviors = template;
    for i= 1, #self.ComponentList do
        index = string.find(self.ComponentList[i], "/[^/]*$");
        fh = assert(io.open("lua/" ..self.ComponentList[i]:sub(1, index-1) .. "/behavior.lua", "rb"));
        content = fh:read("*all");
        fh:close();
        behaviors = behaviors .. content;
    end
    return behaviors;
end

--- Reads all dependencies from all active modules and saves them
--- into the component
function LibWriter:ReadFilesLoop()
    local Paths = {Result = {}};
    for i= #self.ComponentList, 1, -1 do
        Paths[i] = {};
        ---@diagnostic disable-next-line: param-type-mismatch
        self:ReadFileAndDependencies(self.ComponentList[i], Paths[i]);
        table.insert(Paths[i], self.ComponentList[i]:lower());
    end
    for i= 1, #Paths do
        for j= 1, #Paths[i] do
            if not self:InTable(Paths[i][j], Paths.Result) then
                table.insert(Paths.Result, Paths[i][j]);
            end
        end
    end
    return Paths.Result;
end

--- Recursivly searches for the dependencies of the passed file and
--- writes them all into the passed array.
--- Each entry is only added once.
--- @param _Path string Path of file
--- @param _Paths table Dependency array
function LibWriter:ReadFileAndDependencies(_Path, _Paths)
    local Paths = {};
    for line in io.lines("lua/" .._Path:lower() .. ".lua") do
        if line:find("Register") then
            break;
        end
        local s,e = line:find("Lib%.Require%(\".*\"");
        if s and s > 0 then
            table.insert(Paths, 1, line:sub(s+13, e-1):lower());
        end
    end
    for i= 1, #Paths do
        self:ReadFileAndDependencies(Paths[i], _Paths);
        table.insert(_Paths, Paths[i]);
    end
end

function LibWriter:InTable(_Entry, _Table)
    for i= 1, #_Table do
        if _Table[i] == _Entry then
            return true;
        end
    end
    return false;
end

--- Returns if the file is an directory.
--- @param _File string Path to file
--- @return boolean IsDir File is directory
function LibWriter:IsDir(_File)
    return self:FileExists(_File.. "/");
end

--- Checks if the file does exist.
--- @param _File string Path to file
--- @return boolean Exists File does exist
--- @return string? Error Optional error text
function LibWriter:FileExists(_File)
    local ok, err, code = os.rename(_File, _File);
    if not ok then
        if code == 13 then
            return true;
        end
    end
    return ok, err;
end

--- Compiles the source file and moves it to the destination.
--- @param _Source string Source file location
--- @param _Dest string   Destination location
function LibWriter:CompileFile(_Source, _Dest)
    if self.Compile then
        os.execute('luac "'.._Source..'"');
        os.execute('mv "luac.out" "'.._Dest..'"');
    end
end

--- Reads the load order from a file.
--- @param _Path string File location
--- @return table List List of modules
function LibWriter:GetLoadOrderFromFile(_Path)
    local Paths = {};
    if self:FileExists(_Path) then
        for line in io.lines(_Path:lower()) do
            table.insert(Paths, line);
        end
    end
    return Paths;
end

-- -------------------------------------------------------------------------- --

LibWriter:Run(unpack(arg));

