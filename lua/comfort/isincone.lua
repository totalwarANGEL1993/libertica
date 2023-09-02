Lib.Require("comfort/GetAngleBetween");
Lib.Register("comfort/IsInCone");

--- Clones a table with all non-meta contents into a new table
--- @param _Position table Position to check
--- @param _Center table Position of cone center
--- @param _MiddleAlpha number Middle Alpha
--- @param _BetaAvaiable number Beta Alpha
--- @return boolean InCone Position in cone
--- @author mcb
function IsInCone(_Position, _Center, _MiddleAlpha, _BetaAvaiable)
	local a = GetAngleBetween(_Center, _Position);
	local lb = _MiddleAlpha - _BetaAvaiable;
	local hb = _MiddleAlpha + _BetaAvaiable;
	if a >= lb and a <= hb then
		return true;
	end
	if (a + 180) % 360 >= (lb + 180) % 360 and (a + 180) % 360 <= (hb + 180) % 360 then
		return true;
    end
    return false;
end
API.IsInCone = IsInCone;

