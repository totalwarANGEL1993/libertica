CONST_IS_IN_DEV = true;
local Path = "maps/externalmap/qsb_t23_diplomacy/";
if CONST_IS_IN_DEV then
    Path = "E:/Repositories/libertica/var/";
end
Script.Load(Path.. "libertica/qsb.lua");