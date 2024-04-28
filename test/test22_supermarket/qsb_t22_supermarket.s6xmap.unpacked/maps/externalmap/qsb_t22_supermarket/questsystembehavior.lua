CONST_IS_IN_DEV = true;
local Path = "maps/externalmap/qsb_t22_supermarket/";
if CONST_IS_IN_DEV then
    Path = "E:/Repositories/libertica/release/";
end
Script.Load(Path.. "libertica/qsb.lua");