Lib.Require("comfort/IsLocalScript");
Lib.Register("module/city/SettlementSurvival_API");

--- Enables or disables animals dying from disease.
--- @param _Flag boolean Feature is active
function ActivateAnimalPlague(_Flag)
    Lib.SettlementSurvival.Global.AnimalPlague.IsActive = _Flag == true;
end

--- Enables or disables animals dying from disease for AI players.
--- @param _Flag boolean Feature is active
function ActivateAnimalPlagueForAI(_Flag)
    Lib.SettlementSurvival.Global.AnimalPlague.AffectAI = _Flag == true;
end

--- Enables or disables animals becoming automatically sick.
--- @param _Flag boolean Feature is active
function ActivateAutomaticAnimalInfection(_Flag)
    Lib.SettlementSurvival.Global.AnimalPlague.AnimalsBecomeSick = _Flag == true;
end

--- Changes the interval between deaths of sick animals.
--- @param _Interval integer New interval time
function SetAnimalPlagueDeathInterval(_Interval)
    Lib.SettlementSurvival.Shared.AnimalPlague.DeathTimer = _Interval;
end

--- Changes the chance of death for sick animals.
--- @param _Chance integer Chance (between 1 and 100)
function SetAnimalPlagueDeathChance(_Chance)
    Lib.SettlementSurvival.Shared.AnimalPlague.DeathChance = _Chance;
end

--- Changes the interval between infections for animals.
--- @param _Interval integer New interval time
function SetAnimalPlagueInfectionInterval(_Interval)
    Lib.SettlementSurvival.Shared.AnimalPlague.InfectionTimer = _Interval;
end

--- Changes the chance of infection for animals.
--- @param _Chance integer Chance (between 1 and 100)
function SetAnimalPlagueInfectionChance(_Chance)
    Lib.SettlementSurvival.Shared.AnimalPlague.InfectionChance = _Chance;
end

--- Enables or disables need for firewood.
--- @param _Flag boolean Feature is active
function ActivateColdWeather(_Flag)
    Lib.SettlementSurvival.Global.ColdWeather.IsActive = _Flag == true;
end

--- Enables or disables need for firewood for AI players.
--- @param _Flag boolean Feature is active
function ActivateColdWeatherForAI(_Flag)
    Lib.SettlementSurvival.Global.ColdWeather.AffectAI = _Flag == true;
end

--- Sets the temperature above which the weather is considered uncomfortable.
--- @param _Temperature integer Start of cold temperatures 
function SetColdWeatherTemperature(_Temperature)
    Lib.SettlementSurvival.Shared.ColdWeather.Temperature = _Temperature;
end

--- Changes the interval between two consumtions of firewood.
--- @param _Interval integer New interval time
function SetColdWeatherConsumptionInterval(_Interval)
    Lib.SettlementSurvival.Shared.ColdWeather.ConsumptionTimer = _Interval;
end

--- Changes the chance of infection because of cold weather.
--- @param _Chance integer Chance (between 1 and 100)
function SetColdWeatherInfectionChance(_Chance)
    Lib.SettlementSurvival.Shared.ColdWeather.InfectionChance = _Chance;
end

--- Enables or disables starvation of settlers.
--- @param _Flag boolean Feature is active
function ActivateFamine(_Flag)
    Lib.SettlementSurvival.Global.Famine.IsActive = _Flag == true;
end

--- Enables or disables starvation of settlers for AI players.
--- @param _Flag boolean Feature is active
function ActivateFamineForAI(_Flag)
    Lib.SettlementSurvival.Global.Famine.AffectAI = _Flag == true;
end

--- Changes the interval between deaths because of starvation.
--- @param _Interval integer New interval time
function SetFamineDeathInterval(_Interval)
    Lib.SettlementSurvival.Shared.Famine.DeathTimer = _Interval;
end

--- Changes the chance of death for starving settlers.
--- @param _Chance integer Chance (between 1 and 100)
function SetFamineDeathChance(_Chance)
    Lib.SettlementSurvival.Shared.Famine.DeathChance = _Chance;
end

--- Enables or disables settlers becoming ill due to neglect.
--- @param _Flag boolean Feature is active
function ActivateNegligence(_Flag)
    Lib.SettlementSurvival.Global.Negligence.IsActive = _Flag == true;
end

--- Enables or disables settlers becoming ill due to neglect for AI players.
--- @param _Flag boolean Feature is active
function ActivateNegligenceForAI(_Flag)
    Lib.SettlementSurvival.Global.Negligence.AffectAI = _Flag == true;
end

--- Changes the interval between infections due to neglect.
--- @param _Interval integer New interval time
function SetNegligenceInfectionInterval(_Interval)
    Lib.SettlementSurvival.Shared.Negligence.InfectionTimer = _Interval;
end

--- Changes the chance of infection due to neglect.
--- @param _Chance integer Chance (between 1 and 100)
function SetNegligenceInfectionChance(_Chance)
    Lib.SettlementSurvival.Shared.Negligence.InfectionChance = _Chance;
end

--- Enables or disables settlers dying from disease.
--- @param _Flag boolean Feature is active
function ActivatePlague(_Flag)
    Lib.SettlementSurvival.Global.Plague.IsActive = _Flag == true;
end

--- Enables or disables settlers dying from disease for AI players.
--- @param _Flag boolean Feature is active
function ActivatePlagueForAI(_Flag)
    Lib.SettlementSurvival.Global.Plague.AffectAI = _Flag == true;
end

--- Changes the interval between deaths of sick settlers.
--- @param _Interval integer New interval time
function SetPlagueDeathInterval(_Interval)
    Lib.SettlementSurvival.Shared.Plague.DeathTimer = _Interval;
end

--- Changes the chance of death for sick settlers.
--- @param _Chance integer Chance (between 1 and 100)
function SetPlagueDeathChance(_Chance)
    Lib.SettlementSurvival.Shared.Plague.DeathChance = _Chance;
end

