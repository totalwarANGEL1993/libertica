CONST_IS_IN_DEV = true;
local Path = "maps/externalmap/qsb_t22_supermarket/libertica/qsb.lua";
if CONST_IS_IN_DEV then
    Path = "E:/Repositories/libertica/test/test22_supermarket/qsb_t22_supermarket.s6xmap.unpacked/" ..Path;
end
Script.Load(Path);