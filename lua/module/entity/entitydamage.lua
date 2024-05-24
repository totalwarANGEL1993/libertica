Lib.EntityDamage = Lib.EntityDamage or {};
Lib.EntityDamage.Name = "EntityDamage";
Lib.EntityDamage.Global = {
    InvulnerableList = {},
    --
    EntityTypeDamage = {},
    EntityNameDamage = {},
    EntityTypeArmor = {},
    EntityNameArmor = {},
    --
    TerritoryBonus = {},
    HeightModifier = {},
    --
    EntityBaseDamage = {},
};
Lib.EntityDamage.Local  = {};

Lib.Require("core/Core");
Lib.Require("module/entity/EntityEvent");
Lib.Require("module/entity/EntityDamage_API");
Lib.Register("module/entity/EntityDamage");

-- -------------------------------------------------------------------------- --
-- Global

-- Global initalizer method
function Lib.EntityDamage.Global:Initialize()
    if not self.IsInstalled then
        for PlayerID = 0, 8 do
            self.TerritoryBonus[PlayerID] = 1;
            self.HeightModifier[PlayerID] = 1;
        end
        self:OverwriteVulnerabilityFunctions();
        self:InitEntityBaseDamage();

        -- Garbage collection
        Lib.EntityDamage.Local = nil;
    end
    self.IsInstalled = true;
end

-- Global load game
function Lib.EntityDamage.Global:OnSaveGameLoaded()
end

-- Global report listener
function Lib.EntityDamage.Global:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    elseif _ID == Report.EntityDestroyed then
        self.InvulnerableList[arg[1]] = nil;
    elseif _ID == Report.EntityHurt then
        self:OnEntityHurtEntity(arg[1], arg[2], arg[3], arg[4]);
    end
end

function Lib.EntityDamage.Global:SetEntityTypeDamage(_Type, _Damage)
    assert(type(_Damage) == "number");
    self.EntityTypeDamage[_Type] = _Damage;
end

function Lib.EntityDamage.Global:SetEntityNameDamage(_Name, _Damage)
    assert(type(_Damage) == "number");
    self.EntityNameDamage[_Name] = _Damage;
end

function Lib.EntityDamage.Global:SetEntityTypeArmor(_Type, _Armor)
    assert(type(_Armor) == "number");
    self.EntityTypeArmor[_Type] = _Armor;
end

function Lib.EntityDamage.Global:SetEntityNameArmor(_Name, _Armor)
    assert(type(_Armor) == "number");
    self.EntityNameArmor[_Name] = _Armor;
end

function Lib.EntityDamage.Global:SetTerritoryBonus(_PlayerID, _Bonus)
    assert(type(_Bonus) == "number");
    self.TerritoryBonus[_PlayerID] = _Bonus or 1;
end

function Lib.EntityDamage.Global:SetHeightModifier(_PlayerID, _Bonus)
    assert(type(_Bonus) == "number");
    self.HeightModifier[_PlayerID] = _Bonus or 1;
end

function Lib.EntityDamage.Global:IsInvulnerable(_Entity)
    return self.InvulnerableList[GetID(_Entity)] ~= nil;
end

function Lib.EntityDamage.Global:InitEntityBaseDamage()
    self.EntityBaseDamage[Entities.U_MilitaryBow] = 20;
    self.EntityBaseDamage[Entities.U_MilitaryBow_RedPrince] = 20;
    self.EntityBaseDamage[Entities.U_MilitarySword] = 30;
    self.EntityBaseDamage[Entities.U_MilitarySword_RedPrince] = 30;
    --
    self.EntityBaseDamage[Entities.U_MilitaryBandit_Melee_ME] = 30;
    self.EntityBaseDamage[Entities.U_MilitaryBandit_Ranged_ME] = 20;
    self.EntityBaseDamage[Entities.U_MilitaryBandit_Melee_NA] = 30;
    self.EntityBaseDamage[Entities.U_MilitaryBandit_Ranged_NA] = 20;
    self.EntityBaseDamage[Entities.U_MilitaryBandit_Melee_NE] = 30;
    self.EntityBaseDamage[Entities.U_MilitaryBandit_Ranged_NE] = 20;
    self.EntityBaseDamage[Entities.U_MilitaryBandit_Melee_SE] = 30;
    self.EntityBaseDamage[Entities.U_MilitaryBandit_Ranged_SE] = 20;
    --
    self.EntityBaseDamage[Entities.U_MilitaryBallista] = 50;
    self.EntityBaseDamage[Entities.U_MilitaryBatteringRam] = 120;
    self.EntityBaseDamage[Entities.U_MilitaryCatapult] = 50;
    self.EntityBaseDamage[Entities.U_MilitarySiegeTower] = 0;
    self.EntityBaseDamage[Entities.U_MilitaryTrap] = 800;
    --
    self.EntityBaseDamage[Entities.A_ME_Bear] = 120;
    self.EntityBaseDamage[Entities.A_ME_Bear_black] = 120;
    self.EntityBaseDamage[Entities.A_ME_Wolf] = 20;
    self.EntityBaseDamage[Entities.A_NA_Lion_Female] = 40;
    self.EntityBaseDamage[Entities.A_NA_Lion_Male] = 40;
    self.EntityBaseDamage[Entities.A_NE_PolarBear] = 120;

    if g_GameExtraNo == 0 then
        return;
    end

    self.EntityBaseDamage[Entities.U_MilitaryBow_Khana] = 20;
    self.EntityBaseDamage[Entities.U_MilitarySword_Khana] = 30;
    --
    self.EntityBaseDamage[Entities.U_MilitaryBandit_Melee_AS] = 30;
    self.EntityBaseDamage[Entities.U_MilitaryBandit_Ranged_AS] = 20;
    --
    self.EntityBaseDamage[Entities.A_AS_BearBlack] = 120;
    self.EntityBaseDamage[Entities.A_AS_Tiger] = 40;
end

function Lib.EntityDamage.Global:GetEntityBaseDamage(_Type)
    -- Return type damage or assume it being a hero
    return self.EntityBaseDamage[_Type] or 25;
end

function Lib.EntityDamage.Global:SetEntityBaseDamage(_Type, _Damage)
    assert(type(_Damage) == "number");
    self.EntityBaseDamage[_Type] = _Damage;
end

function Lib.EntityDamage.Global:OverwriteVulnerabilityFunctions()
    MakeInvulnerable = function(_Entity)
        if IsExisting(_Entity) then
            local ID = GetID(_Entity);
            Lib.EntityDamage.Global.InvulnerableList[ID] = nil;
            Logic.SetEntityInvulnerabilityFlag(ID, 1);
        end
    end

    MakeVulnerable = function(_Entity)
        if IsExisting(_Entity) then
            local ID = GetID(_Entity);
            Lib.EntityDamage.Global.InvulnerableList[ID] = true;
            Logic.SetEntityInvulnerabilityFlag(ID, 0);
        end
    end
end

function Lib.EntityDamage.Global:OnEntityHurtEntity(_EntityID1, _PlayerID1, _EntityID2, _PlayerID2)
    -- Get target
    local TargetID = self:GetTargetEntityID(_EntityID2);
    if TargetID == 0 then
        return;
    end

    -- Set initial invulnerability
    Logic.SetEntityInvulnerabilityFlag(TargetID, 1);

    -- Do not touch the invincible
    if self.InvulnerableList[TargetID] then
        return;
    end

    -- Player properties
    local TerritoryBonus = Logic.GetTerritoryBonus(_EntityID1) * self.TerritoryBonus[_PlayerID1];
    local HeightModifier = Logic.GetHeightDamageModifier(_EntityID1) * self.HeightModifier[_PlayerID1];

    -- Get attacker properties
    local EntityType1 = Logic.GetEntityType(_EntityID1);
    local EntityName1 = Logic.GetEntityName(_EntityID1);
    local MoralFactor  = Logic.GetPlayerMorale(_PlayerID1);
    local Damage = self:GetEntityBaseDamage(EntityType1);
    if self.EntityTypeDamage[EntityType1] then
        Damage = self.EntityTypeDamage[EntityType1];
    end
    if self.EntityNameDamage[EntityName1] then
        Damage = self.EntityNameDamage[EntityName1];
    end

    -- Get defender properties
    local EntityType2 = Logic.GetEntityType(TargetID);
    local EntityName2 = Logic.GetEntityName(TargetID);
    local Armor = 0;
    if self.EntityTypeArmor[EntityType2] then
        Armor = self.EntityTypeArmor[EntityType2];
    end
    if self.EntityNameArmor[EntityName2] then
        Armor = self.EntityNameArmor[EntityName2];
    end

    -- Calculate damage
    Damage = Damage * (MoralFactor + TerritoryBonus) * HeightModifier;
    Damage = math.max(1, math.ceil(Damage - Armor));
    if GameCallback_Lib_CalculateBattleDamage ~= nil then
        Damage = GameCallback_Lib_CalculateBattleDamage(_EntityID1, _PlayerID1, TargetID, _PlayerID2, Damage);
    end

    -- Apply damage
    local Health = Logic.GetEntityHealth(TargetID);
    Damage = math.min(Health, Damage);
    Logic.SetEntityInvulnerabilityFlag(TargetID, 0);
    Logic.HurtEntity(TargetID, Damage);

    -- Reset invulnerability
    if Health > Damage then
        Logic.SetEntityInvulnerabilityFlag(TargetID, 1);
    end
end

function Lib.EntityDamage.Global:GetTargetEntityID(_EntityID)
    -- Find first alive soldier if entity is leader
    if Logic.IsLeader(_EntityID) == 1 then
        local Soldiers = {Logic.GetSoldiersAttachedToLeader(_EntityID)};
        for i= 2, Soldiers[1] +1 do
            if Logic.GetEntityHealth(Soldiers[i]) > 0 then
                return Soldiers[i];
            end
        end
        return 0;
    end
    -- Otherwise check if entity has health
    if Logic.GetEntityHealth(_EntityID) == 0 then
        return 0;
    end
    return _EntityID;
end

-- -------------------------------------------------------------------------- --
-- Local

-- Local initalizer method
function Lib.EntityDamage.Local:Initialize()
    if not self.IsInstalled then

        -- Garbage collection
        Lib.EntityDamage.Global = nil;
    end
    self.IsInstalled = true;
end

-- Local load game
function Lib.EntityDamage.Local:OnSaveGameLoaded()
end

-- Local report listener
function Lib.EntityDamage.Local:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    end
end

-- -------------------------------------------------------------------------- --

RegisterModule(Lib.EntityDamage.Name);

