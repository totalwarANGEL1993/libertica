Lib.Require("comfort/IsLocalScript");
Lib.Register("module/faker/Technology_API");

--- Initializes a pseudo technology.
--- @param _Key string Name of technology
--- @param _Name string|table Description of Technology
--- @param _Icon table Icon
function AddCustomTechnology(_Key, _Name, _Icon)
    Lib.Technology.Shared:AddCustomTechnology(_Key, _Name, _Icon);
end
API.AddCustomTechnology = AddCustomTechnology;

