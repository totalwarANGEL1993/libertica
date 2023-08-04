LibWriter = {
    ComponentList = {
        "core/Core",
        "module/quest/QuestModule"
    },
    Behaviors = "",
}

--- Runs the build process.
--- @param ... unknown Program arguments
function LibWriter:Run(...)
    local Action = self:ProcessArguments();
    if Action == 0 then
        return;
    end

    if Action == 1 then
        os.execute('rm -rf var');
        os.execute('mkdir "var/liberty"');
        self:CopyModules();
        self:ConcatBehaviors();
    elseif Action == 2 then
        print("Files loaded:");
        local Files = self:ReadFilesLoop();
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
            if #Parameter > 0 then
                self.ComponentList = Parameter;
            end
            return 1;
        elseif Command == "-l" or Command == "list" then
            if #Parameter > 0 then
                self.ComponentList = Parameter;
            end
            return 2;
        end
    end
    return 0;
end

--- Copies the module files with dependencies to the output folder.
function LibWriter:CopyModules()
    os.execute('cp "loader.lua" "var/liberty/liberator.lua');
    local imports = self:ReadFilesLoop();
    for i= #imports, 1, -1 do
        local index = string.find(imports[i], "/[^/]*$");
        local Path = 'var/liberty/'..imports[i]:sub(1, index-1);
        local File = imports[i]:sub(index+1):lower() ..".lua";
        if not self:IsDir(Path) then
            os.execute('mkdir "'..Path..'"');
        end
        os.execute('cp "'..imports[i]..'.lua" "'..Path..'/'..File..'');
    end
end

--- Concatinates all behavior.lua files in all active modules,
--- creates the QSB and writes it to output folder.
function LibWriter:ConcatBehaviors()
    local fhq = assert(io.open("qsb/template.lua", "rb"));
    local template = fhq:read("*all");
    fhq:close();
    local behaviors = template;
    for i= 1, #self.ComponentList do
        local index = string.find(self.ComponentList[i], "/[^/]*$");
        local f = io.open(self.ComponentList[i]:sub(1, index-1) .. "/behavior.lua", "rb");
        if f then
            local content = f:read("*all");
            f:close();
            behaviors = behaviors .. content;
        end
    end
    local dsf = assert(io.open("var/liberty/qsb.lua", "wb"));
    dsf:write(behaviors);
    dsf:close();
end

--- Reads all dependencies from all active modules and saves them
--- into the component
function LibWriter:ReadFilesLoop()
    local Paths = {};
    for i= 1, #self.ComponentList do
        self:ReadFileAndDependencies(self.ComponentList[i], Paths);
        if not self:InTable(self.ComponentList[i], Paths) then
            table.insert(Paths, self.ComponentList[i]);
        end
    end
    return Paths;
end

--- Recursivly searches for the dependencies of the passed file and
--- writes them all into the passed array.
--- Each entry is only added once.
--- @param _Path string Path of file
--- @param _Paths table Dependency array
function LibWriter:ReadFileAndDependencies(_Path, _Paths)
    local Paths = {};
    for line in io.lines(_Path:lower() .. ".lua") do
        if line:find("Register") then
            break;
        end
        local s,e = line:find("Lib%.Require%(\".*\"");
        if s and s > 0 then
            table.insert(Paths, line:sub(s+13, e-1));
        end
    end
    for i= 1, #Paths do
        self:ReadFileAndDependencies(Paths[i], _Paths);
        if not self:InTable(Paths[i], _Paths) then
            table.insert(_Paths, Paths[i]);
        end
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

-- -------------------------------------------------------------------------- --

LibWriter:Run(unpack(arg));

