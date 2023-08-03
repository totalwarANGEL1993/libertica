LibWriter = {
    ComponentList = {
        "core/libertycore",
        -- Modules
        "module/questsystem/questsystem"
    },
    Behaviors = "",
}

function LibWriter:Run(...)
    os.execute('rm -rf var');
    os.execute('mkdir "var/liberty"');

    if #arg > 0 then
        self.ComponentList = {unpack(arg)};
    end

    os.execute('cp "loader.lua" "var/liberty/liberator.lua');

    -- copy modules
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

    -- build qsb
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

function LibWriter:ReadFilesLoop()
    local Paths = {};
    for i= #self.ComponentList, 1, -1 do
        self:ReadFileAndDependencies(self.ComponentList[i], Paths);
        table.insert(Paths, self.ComponentList[i]);
    end
    return Paths;
end

function LibWriter:ReadFileAndDependencies(_Path, _Paths)
    local Paths = {};
    for line in io.lines(_Path:lower() .. ".lua") do
        if line:find("Lib.Register") then
            break;
        end
        local s,e = line:find("Lib%.Require%(\".*\"");
        if s and s > 0 then
            table.insert(Paths, line:sub(s+13, e-1));
        end
    end
    for i= 1, #Paths do
        local IsIn = false;
        for j= 1, #_Paths do
            if Paths[i] == _Paths[j] then
                IsIn = true;
                break;
            end
        end
        if not IsIn then
            table.insert(_Paths, Paths[i]);
            self:ReadFileAndDependencies(Paths[i], _Paths);
        end
    end
end

function LibWriter:IsDir(_File)
    return self:FileExists(_File.. "/");
end

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

