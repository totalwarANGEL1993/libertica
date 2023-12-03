Lib.Require("comfort/IsLocalScript");
Lib.Register("module/city/SettlementSurvival_API");

--- Enables or disables animals dying from disease.
--- @param _Flag boolean Feature is active
function AnimalPlagueActivate(_Flag)
    Lib.SettlementSurvival.Global.AnimalPlague.IsActive = _Flag == true;
end
API.AnimalPlagueActivate = AnimalPlagueActivate;

--- Enables or disables animals dying from disease for AI players.
--- @param _Flag boolean Feature is active
function AnimalPlagueActivateForAI(_Flag)
    Lib.SettlementSurvival.Global.AnimalPlague.AffectAI = _Flag == true;
end
API.AnimalPlagueActivateForAI = AnimalPlagueActivateForAI;

--- Enables or disables animals becoming automatically sick.
--- @param _Flag boolean Feature is active
function AnimalInfectionActivateAutomatic(_Flag)
    Lib.SettlementSurvival.Global.AnimalPlague.AnimalsBecomeSick = _Flag == true;
end
API.AnimalInfectionActivateAutomatic = AnimalInfectionActivateAutomatic;

--- Changes the interval between deaths of sick animals.
--- @param _Interval integer New interval time
function AnimalPlagueSetDeathInterval(_Interval)
    Lib.SettlementSurvival.Shared.AnimalPlague.DeathTimer = _Interval;
    ExecuteLocal([[Lib.SettlementSurvival.Shared.AnimalPlague.DeathTimer = %d]], _Interval);
end
API.AnimalPlagueSetDeathInterval = AnimalPlagueSetDeathInterval;

--- Changes the chance of death for sick animals.
--- @param _Chance integer Chance (between 1 and 100)
function AnimalPlagueSetDeathChance(_Chance)
    Lib.SettlementSurvival.Shared.AnimalPlague.DeathChance = _Chance;
    ExecuteLocal([[Lib.SettlementSurvival.Shared.AnimalPlague.DeathChance = %d]], _Chance);
end
API.AnimalPlagueSetDeathChance = AnimalPlagueSetDeathChance;

--- Changes the interval between infections for animals.
--- @param _Interval integer New interval time
function AnimalPlagueSetInfectionInterval(_Interval)
    Lib.SettlementSurvival.Shared.AnimalPlague.InfectionTimer = _Interval;
    ExecuteLocal([[Lib.SettlementSurvival.Shared.AnimalPlague.InfectionTimer = %d]], _Interval);
end
API.AnimalPlagueSetInfectionInterval = AnimalPlagueSetInfectionInterval;

--- Changes the chance of infection for animals.
--- @param _Chance integer Chance (between 1 and 100)
function AnimalPlagueSetInfectionChance(_Chance)
    Lib.SettlementSurvival.Shared.AnimalPlague.InfectionChance = _Chance;
    ExecuteLocal([[Lib.SettlementSurvival.Shared.AnimalPlague.InfectionChance = %d]], _Chance);
end
API.AnimalPlagueSetInfectionChance = AnimalPlagueSetInfectionChance;

--- nables or disables city fires.
--- @param _Flag boolean Feature is active
function HotWeatherActivate(_Flag)
    Lib.SettlementSurvival.Global.HotWeather.IsActive = _Flag == true;
end
API.HotWeatherActivate = HotWeatherActivate;

--- Enables or disables city fires for AI players.
--- @param _Flag boolean Feature is active
function HotWeatherActivateForAI(_Flag)
    Lib.SettlementSurvival.Global.HotWeather.AffectAI = _Flag == true;
end
API.HotWeatherActivateForAI = HotWeatherActivateForAI;

--- Sets the temperature at which buildings catch fire.
--- @param _Temperature integer Start of cold temperatures 
function HotWeatherSetTemperature(_Temperature)
    Lib.SettlementSurvival.Shared.HotWeather.Temperature = _Temperature;
    ExecuteLocal([[Lib.SettlementSurvival.Shared.HotWeather.Temperature = %d]], _Temperature);
end
API.HotWeatherSetTemperature = HotWeatherSetTemperature;

--- Changes the chance of buildings catching fire.
--- @param _Chance integer Chance (between 1 and 100)
function HotWeatherSetIgnitionChance(_Chance)
    Lib.SettlementSurvival.Shared.HotWeather.IgnitionChance = _Chance;
    ExecuteLocal([[Lib.SettlementSurvival.Shared.HotWeather.IgnitionChance = %d]], _Chance);
end
API.HotWeatherSetIgnitionChance = HotWeatherSetIgnitionChance;

--- Enables or disables need for firewood.
--- @param _Flag boolean Feature is active
function ColdWeatherActivate(_Flag)
    Lib.SettlementSurvival.Global.ColdWeather.IsActive = _Flag == true;
end
API.ColdWeatherActivate = ColdWeatherActivate;

--- Enables or disables need for firewood for AI players.
--- @param _Flag boolean Feature is active
function ColdWeatherActivateForAI(_Flag)
    Lib.SettlementSurvival.Global.ColdWeather.AffectAI = _Flag == true;
end
API.ColdWeatherActivateForAI = ColdWeatherActivateForAI;

--- Sets the temperature at which the weather is considered uncomfortable.
--- @param _Temperature integer Start of cold temperatures 
function ColdWeatherSetTemperature(_Temperature)
    Lib.SettlementSurvival.Shared.ColdWeather.Temperature = _Temperature;
    ExecuteLocal([[Lib.SettlementSurvival.Shared.ColdWeather.Temperature = %d]], _Temperature);
end
API.ColdWeatherSetTemperature = ColdWeatherSetTemperature;

--- Changes the interval between two consumtions of firewood.
--- @param _Interval integer New interval time
function ColdWeatherSetConsumptionInterval(_Interval)
    Lib.SettlementSurvival.Shared.ColdWeather.ConsumptionTimer = _Interval;
    ExecuteLocal([[Lib.SettlementSurvival.Shared.ColdWeather.ConsumptionTimer = %d]], _Interval);
end
API.ColdWeatherSetConsumptionInterval = ColdWeatherSetConsumptionInterval;

--- Changes the chance of infection because of cold weather.
--- @param _Chance integer Chance (between 1 and 100)
function ColdWeatherSetInfectionChance(_Chance)
    Lib.SettlementSurvival.Shared.ColdWeather.InfectionChance = _Chance;
    ExecuteLocal([[Lib.SettlementSurvival.Shared.ColdWeather.InfectionChance = %d]], _Chance);
end
API.ColdWeatherSetInfectionChance = ColdWeatherSetInfectionChance;

--- Enables or disables starvation of settlers.
--- @param _Flag boolean Feature is active
function FamineActivate(_Flag)
    Lib.SettlementSurvival.Global.Famine.IsActive = _Flag == true;
end
API.FamineActivate = FamineActivate;

--- Enables or disables starvation of settlers for AI players.
--- @param _Flag boolean Feature is active
function FamineActivateForAI(_Flag)
    Lib.SettlementSurvival.Global.Famine.AffectAI = _Flag == true;
end
API.FamineActivateForAI = FamineActivateForAI;

--- Changes the interval between deaths because of starvation.
--- @param _Interval integer New interval time
function FamineSetDeathInterval(_Interval)
    Lib.SettlementSurvival.Shared.Famine.DeathTimer = _Interval;
    ExecuteLocal([[Lib.SettlementSurvival.Shared.Famine.DeathTimer = %d]], _Interval);
end
API.FamineSetDeathInterval = FamineSetDeathInterval;

--- Changes the chance of death for starving settlers.
--- @param _Chance integer Chance (between 1 and 100)
function FamineSetDeathChance(_Chance)
    Lib.SettlementSurvival.Shared.Famine.DeathChance = _Chance;
    ExecuteLocal([[Lib.SettlementSurvival.Shared.Famine.DeathChance = %d]], _Chance);
end
API.FamineSetDeathChance = FamineSetDeathChance;

--- Enables or disables settlers becoming ill due to neglect.
--- @param _Flag boolean Feature is active
function NegligenceActivate(_Flag)
    Lib.SettlementSurvival.Global.Negligence.IsActive = _Flag == true;
end
API.NegligenceActivate = NegligenceActivate;

--- Enables or disables settlers becoming ill due to neglect for AI players.
--- @param _Flag boolean Feature is active
function NegligenceActivateForAI(_Flag)
    Lib.SettlementSurvival.Global.Negligence.AffectAI = _Flag == true;
end
API.NegligenceActivateForAI = NegligenceActivateForAI;

--- Changes the interval between infections due to neglect.
--- @param _Interval integer New interval time
function NegligenceSetInfectionInterval(_Interval)
    Lib.SettlementSurvival.Shared.Negligence.InfectionTimer = _Interval;
    ExecuteLocal([[Lib.SettlementSurvival.Shared.Negligence.InfectionTimer = %d]], _Interval);
end
API.NegligenceSetInfectionInterval = NegligenceSetInfectionInterval;

--- Changes the chance of infection due to neglect.
--- @param _Chance integer Chance (between 1 and 100)
function NegligenceSetInfectionChance(_Chance)
    Lib.SettlementSurvival.Shared.Negligence.InfectionChance = _Chance;
    ExecuteLocal([[Lib.SettlementSurvival.Shared.Negligence.InfectionChance = %d]], _Chance);
end
API.NegligenceSetInfectionChance = NegligenceSetInfectionChance;

--- Enables or disables settlers dying from disease.
--- @param _Flag boolean Feature is active
function PlagueActivate(_Flag)
    Lib.SettlementSurvival.Global.Plague.IsActive = _Flag == true;
end
API.PlagueActivate = PlagueActivate;

--- Enables or disables settlers dying from disease for AI players.
--- @param _Flag boolean Feature is active
function PlagueActivateForAI(_Flag)
    Lib.SettlementSurvival.Global.Plague.AffectAI = _Flag == true;
end
API.PlagueActivateForAI = PlagueActivateForAI;

--- Changes the interval between deaths of sick settlers.
--- @param _Interval integer New interval time
function PlagueSetDeathInterval(_Interval)
    Lib.SettlementSurvival.Shared.Plague.DeathTimer = _Interval;
    ExecuteLocal([[Lib.SettlementSurvival.Shared.Plague.DeathTimer = %d]], _Interval);
end
API.PlagueSetDeathInterval = PlagueSetDeathInterval;

--- Changes the chance of death for sick settlers.
--- @param _Chance integer Chance (between 1 and 100)
function PlagueSetDeathChance(_Chance)
    Lib.SettlementSurvival.Shared.Plague.DeathChance = _Chance;
    ExecuteLocal([[Lib.SettlementSurvival.Shared.Plague.DeathChance = %d]], _Chance);
end
API.PlagueSetDeathChance = PlagueSetDeathChance;

