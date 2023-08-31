Lib.Register("comfort/CopyTable");

--- Clones a table with all non-meta contents into a new table
--- @param _Table1 table  Source table
--- @param _Table2? table Destination table
--- @return table Copy Copy of table
function CopyTable(_Table1, _Table2)
    _Table1 = _Table1 or {};
    _Table2 = _Table2 or {};
    for k, v in pairs(_Table1) do
        if "table" == type(v) then
            _Table2[k] = _Table2[k] or {};
            for kk, vv in pairs(CopyTable(v, _Table2[k])) do
                _Table2[k][kk] = _Table2[k][kk] or vv;
            end
        else
            _Table2[k] = v;
        end
    end
    return _Table2;
end
API.CopyTable = CopyTable;

