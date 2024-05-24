Lib.Require("comfort/IsLocalScript");
Lib.Register("module/entity/EntityDamage_API");

function SetEntityTypeDamage(_Type, _Damage, ...)
    Lib.EntityDamage.Global:SetEntityTypeDamage(_Type, _Damage, ...);
end
API.SetEntityTypeDamage = SetEntityTypeDamage;

function SetEntityNameDamage(_Name, _Damage, ...)
    Lib.EntityDamage.Global:SetEntityNameDamage(_Name, _Damage, ...);
end
API.SetEntityNameDamage = SetEntityNameDamage;

function SetEntityTypeArmor(_Type, _Armor)
    Lib.EntityDamage.Global:SetEntityTypeArmor(_Type, _Armor);
end
API.SetEntityTypeArmor = SetEntityTypeArmor;

function SetEntityNameArmor(_Name, _Armor)
    Lib.EntityDamage.Global:SetEntityNameArmor(_Name, _Armor);
end
API.SetEntityNameArmor = SetEntityNameArmor;

function SetTerritoryBonus(_PlayerID, _Bonus)
    Lib.EntityDamage.Global:SetTerritoryBonus(_PlayerID, _Bonus);
end
API.SetTerritoryBonus = SetTerritoryBonus;

function SetHeightModifier(_PlayerID, _Bonus)
    Lib.EntityDamage.Global:SetHeightModifier(_PlayerID, _Bonus);
end
API.SetHeightModifier = SetHeightModifier;

function IsInvulnerable(_Entity)
    return Lib.EntityDamage.Global:IsInvulnerable(_Entity);
end
API.IsInvulnerable = IsInvulnerable;

