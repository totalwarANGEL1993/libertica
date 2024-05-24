Lib.Require("comfort/IsLocalScript");
Lib.Register("module/entity/EntityDamage_API");

function SetEntityTypeDamage(_Type, _Damage, ...)
    Lib.EntityDamage.Global:SetEntityTypeDamage(_Type, _Damage, ...);
end

function SetEntityNameDamage(_Name, _Damage, ...)
    Lib.EntityDamage.Global:SetEntityNameDamage(_Name, _Damage, ...);
end

function SetEntityTypeArmor(_Type, _Armor)
    Lib.EntityDamage.Global:SetEntityTypeArmor(_Type, _Armor);
end

function SetEntityNameArmor(_Name, _Armor)
    Lib.EntityDamage.Global:SetEntityNameArmor(_Name, _Armor);
end

function SetTerritoryBonus(_PlayerID, _Bonus)
    Lib.EntityDamage.Global:SetTerritoryBonus(_PlayerID, _Bonus);
end

function SetHeightModifier(_PlayerID, _Bonus)
    Lib.EntityDamage.Global:SetHeightModifier(_PlayerID, _Bonus);
end

function IsInvulnerable(_Entity)
    return Lib.EntityDamage.Global:IsInvulnerable(_Entity);
end

