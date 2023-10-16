Lib.Require("comfort/IsLocalScript");
Lib.Register("module/io/IOChest_API");

--- Creates a random chest with specific content.
--- @param _Name string Script name of entity
--- @param _Good integer Good type
--- @param _Min integer Minimum amount
--- @param _Max integer? (Optional) Maximum amount
--- @param _Condition function? (Optional) Condition function
--- @param _Action function? (Optional) Action function
function CreateRandomChest(_Name, _Good, _Min, _Max, _Condition, _Action)
    if IsLocalScript() then
        return;
    end
    if not _Action then
        _Action = _Condition;
        _Condition = nil;
    end
    assert(IsExisting(_Name), "Entity does not exist!");
    assert(GetNameOfKeyInTable(Goods, _Good) ~= nil, "Good type is invalid!");
    assert(type(_Min) == "number" and _Min >= 1, "Minimum is to low!");
    _Max = _Max or _Min;
    assert(type(_Max) == "number" or _Max >= 1, "Maximum is to low!");
    assert(_Max >= _Min, "Maximum can not be lower than minimum!");
    Lib.IOChest.Global:CreateRandomChest(_Name, _Good, _Min, _Max, false, false, _Condition, _Action);
end
API.CreateRandomChest = CreateRandomChest;

--- Creates a random ruin with specific content.
--- @param _Name string Script name of entity
--- @param _Good integer Good type
--- @param _Min integer Minimum amount
--- @param _Max integer? (Optional) Maximum amount
--- @param _Condition function? (Optional) Condition function
--- @param _Action function? (Optional) Action function
function CreateRandomChest(_Name, _Good, _Min, _Max, _Condition, _Action)
    if IsLocalScript() then
        return;
    end
    if not _Action then
        _Action = _Condition;
        _Condition = nil;
    end
    assert(IsExisting(_Name), "Entity does not exist!");
    assert(GetNameOfKeyInTable(Goods, _Good) ~= nil, "Good type is invalid!");
    assert(type(_Min) == "number" and _Min >= 1, "Minimum is to low!");
    _Max = _Max or _Min;
    assert(type(_Max) == "number" or _Max >= 1, "Maximum is to low!");
    assert(_Max >= _Min, "Maximum can not be lower than minimum!");
    Lib.IOChest.Global:CreateRandomChest(_Name, _Good, _Min, _Max, false, true, _Condition, _Action);
end
API.CreateRandomChest = CreateRandomChest;

--- Creates a chest with random gold.
--- @param _Name string Script name of entity
function CreateRandomGoldChest(_Name)
    if IsLocalScript() then
        return;
    end
    assert(IsExisting(_Name), "Entity does not exist!");
    Lib.IOChest.Global:CreateRandomGoldChest(_Name);
end
API.CreateRandomGoldChest = CreateRandomGoldChest;

--- Creates a chest with random resources.
--- @param _Name string Script name of entity
function CreateRandomResourceChest(_Name)
    if IsLocalScript() then
        return;
    end
    assert(IsExisting(_Name), "Entity does not exist!");
    Lib.IOChest.Global:CreateRandomResourceChest(_Name);
end
API.CreateRandomResourceChest = CreateRandomResourceChest;

--- Creates a chest with a random luxury.
--- @param _Name string Script name of entity
function CreateRandomLuxuryChest(_Name)
    if IsLocalScript() then
        return;
    end
    assert(IsExisting(_Name), "Entity does not exist!");
    Lib.IOChest.Global:CreateRandomLuxuryChest(_Name);
end
API.CreateRandomLuxuryChest = CreateRandomLuxuryChest;

