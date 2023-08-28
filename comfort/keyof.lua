Lib.Register("comfort/KeyOf");

--- Returns the kay of the value in the table.
--- @param _wert  any   Value to search
--- @param _table table Table to check
--- @return any Key Key of value
--- @author mcb
function KeyOf(_wert, _table)
    if _table == nil then
        return false;
    end
    for k, v in pairs(_table) do
        if v == _wert then
            return k;
        end
    end
end

