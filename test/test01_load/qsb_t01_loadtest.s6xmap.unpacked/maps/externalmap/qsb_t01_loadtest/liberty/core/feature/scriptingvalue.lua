-- ...................../´¯¯/)
-- ...................,/¯.../
-- .................../..../
-- .............../´¯/'..'/´¯¯`·¸
-- .........../'/.../..../....../¨¯\
-- ..........('(....´...´... ¯~/'..')
-- ...........\..............'...../
-- ............\....\.........._.·´
-- .............\..............(
-- ..............\..............\
-- Steal my IP and I'll sue you!

Lib.Core.ScriptingValue = {
    SV = {
        Game = "Vanilla",
        Vanilla = {
            Destination = {X = 19, Y= 20},
            Health      = -41,
            Player      = -71,
            Size        = -45,
            Visible     = -50,
            NPC         = 6,
        },
        HistoryEdition = {
            Destination = {X = 17, Y= 18},
            Health      = -38,
            Player      = -68,
            Size        = -42,
            Visible     = -47,
            NPC         = 6,
        }
    }
}

Lib.Require("comfort/IsHistoryEdition");
Lib.Require("core/feature/Report");
Lib.Require("core/feature/LuaExtension");
Lib.Register("core/feature/ScriptingValue");

CONST_SCRIPTING_VALUES = Lib.Core.ScriptingValue.SV.Vanilla;

-- -------------------------------------------------------------------------- --

function Lib.Core.ScriptingValue:Initialize()
    if IsHistoryEdition() then
        self.SV.Game = "HistoryEdition";
    end
    CONST_SCRIPTING_VALUES = self.SV[self.SV.Game];
end

function Lib.Core.ScriptingValue:OnSaveGameLoaded()
    if IsHistoryEdition() then
        self.SV.Game = "HistoryEdition";
    end
    CONST_SCRIPTING_VALUES = self.SV[self.SV.Game];
end

-- -------------------------------------------------------------------------- --

function Lib.Core.ScriptingValue:BitsInteger(num)
    local t = {};
    while num > 0 do
        local rest = math.qmod(num, 2);
        table.insert(t,1,rest);
        num=(num-rest)/2;
    end
    table.remove(t, 1);
    return t;
end

function Lib.Core.ScriptingValue:BitsFraction(num, t)
    for i = 1, 48 do
        num = num * 2;
        if(num >= 1) then
            table.insert(t, 1);
            num = num - 1;
        else
            table.insert(t, 0);
        end
        if(num == 0) then
            return t;
        end
    end
    return t;
end

function Lib.Core.ScriptingValue:IntegerToFloat(num)
    if(num == 0) then
        return 0;
    end
    local sign = 1;
    if (num < 0) then
        num = 2147483648 + num;
        sign = -1;
    end
    local frac = math.qmod(num, 8388608);
    local headPart = (num-frac)/8388608;
    local expNoSign = math.qmod(headPart, 256);
    local exp = expNoSign-127;
    local fraction = 1;
    local fp = 0.5;
    local check = 4194304;
    for i = 23, 0, -1 do
        if (frac - check) > 0 then
            fraction = fraction + fp;
            frac = frac - check;
        end
        check = check / 2;
        fp = fp / 2;
    end
    return fraction * math.pow(2, exp) * sign;
end

function Lib.Core.ScriptingValue:FloatToInteger(fval)
    if(fval == 0) then
        return 0;
    end
    local signed = false;
    if (fval < 0) then
        signed = true;
        fval = fval * -1;
    end
    local outval = 0;
    local bits;
    local exp = 0;
    if fval >= 1 then
        local intPart = math.floor(fval);
        local fracPart = fval - intPart;
        bits = self:BitsInteger(intPart);
        exp = #bits;
        self:BitsFraction(fracPart, bits);
    else
        bits = {};
        self:BitsFraction(fval, bits);
        while(bits[1] == 0) do
            exp = exp - 1;
            table.remove(bits, 1);
        end
        exp = exp - 1;
        table.remove(bits, 1);
    end
    local bitVal = 4194304;
    local start = 1;
    for bpos = start, 23 do
        local bit = bits[bpos];
        if(not bit) then
            break;
        end
        if(bit == 1) then
            outval = outval + bitVal;
        end
        bitVal = bitVal / 2;
    end
    outval = outval + (exp+127)*8388608;
    if(signed) then
        outval = outval - 2147483648;
    end
    return outval;
end

-- -------------------------------------------------------------------------- --

--- Returns the value of the index as integer.
--- @param _Entity any ID or script name
--- @param _SV integer Index of scripting value
--- @return integer Value Value at index
function GetInteger(_Entity, _SV)
    local ID = GetID(_Entity);
    assert(IsExisting(ID), "Entity does not exist.");
    return Logic.GetEntityScriptingValue(ID, _SV);
end

--- Returns the value of the index as double.
--- @param _Entity any ID or script name
--- @param _SV integer Index of scripting value
--- @return number Value Value at index
function GetFloat(_Entity, _SV)
    local ID = GetID(_Entity);
    assert(IsExisting(ID), "Entity does not exist.");
    local Value = Logic.GetEntityScriptingValue(ID, _SV);
    return ConvertIntegerToFloat(Value);
end

--- Sets an integer value at the index.
--- @param _Entity any ID or script name
--- @param _SV integer Index of scripting value
--- @param _Value integer Value to set
function SetInteger(_Entity, _SV, _Value)
    local ID = GetID(_Entity);
    assert(IsExisting(ID), "Entity does not exist.");
    Logic.SetEntityScriptingValue(ID, _SV, _Value);
end

--- Sets a double value at the index.
--- @param _Entity any ID or script name
--- @param _SV integer Index of scripting value
--- @param _Value number Value to set
function SetFloat(_Entity, _SV, _Value)
    local ID = GetID(_Entity);
    assert(IsExisting(ID), "Entity does not exist.");
    Logic.SetEntityScriptingValue(ID, _SV, ConvertFloatToInteger(_Value));
end

--- Converts the double value into integer representation.
--- @param _Value number Integer value
--- @return number Value Double value
function ConvertIntegerToFloat(_Value)
    return Lib.Core.ScriptingValue:IntegerToFloat(_Value);
end

--- Converts the integer value into double representation.
--- @param _Value number Double value
--- @return integer Value Integer value
function ConvertFloatToInteger(_Value)
    return Lib.Core.ScriptingValue:FloatToInteger(_Value);
end

