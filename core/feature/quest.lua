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

Lib.Require("comfort/IsLocalScript");
Lib.Require("comfort/ToBoolean");
Lib.Require("comfort/GetHealth");
Lib.Require("comfort/CopyTable");
Lib.Require("comfort/global/SendCart");
Lib.Require("core/feature/Report");
Lib.Register("core/feature/Quest");

LibertyCore.Quest = {
    QuestCounter = 0,
    Text = {
        ActivateBuff = {
            Pattern = {
                de = "BONUS AKTIVIEREN{cr}{cr}%s",
                en = "ACTIVATE BUFF{cr}{cr}%s",
                fr = "ACTIVER BONUS{cr}{cr}%s",
            },
            BuffsVanilla = {
                ["Buff_Spice"]                  = {de = "Salz", en = "Salt", fr = "Sel"},
                ["Buff_Colour"]                 = {de = "Farben", en = "Color", fr = "Couleurs"},
                ["Buff_Entertainers"]           = {de = "Entertainer", en = "Entertainer", fr = "Artistes"},
                ["Buff_FoodDiversity"]          = {de = "Vielfältige Nahrung", en = "Food diversity", fr = "Diversité alimentaire"},
                ["Buff_ClothesDiversity"]       = {de = "Vielfältige Kleidung", en = "Clothes diversity", fr = "Diversité vestimentaire"},
                ["Buff_HygieneDiversity"]       = {de = "Vielfältige Reinigung", en = "Hygiene diversity", fr = "Diversité hygiénique"},
                ["Buff_EntertainmentDiversity"] = {de = "Vielfältige Unterhaltung", en = "Entertainment diversity", fr = "Diversité des dievertissements"},
                ["Buff_Sermon"]                 = {de = "Predigt", en = "Sermon", fr = "Sermon"},
                ["Buff_Festival"]               = {de = "Fest", en = "Festival", fr = "Festival"},
                ["Buff_ExtraPayment"]           = {de = "Sonderzahlung", en = "Extra payment", fr = "Paiement supplémentaire"},
                ["Buff_HighTaxes"]              = {de = "Hohe Steuern", en = "High taxes", fr = "Hautes taxes"},
                ["Buff_NoPayment"]              = {de = "Kein Sold", en = "No payment", fr = "Aucun paiement"},
                ["Buff_NoTaxes"]                = {de = "Keine Steuern", en = "No taxes", fr = "Aucune taxes"},
            },
            BuffsEx1 = {
                ["Buff_Gems"]              = {de = "Edelsteine", en = "Gems", fr = "Gemmes"},
                ["Buff_MusicalInstrument"] = {de = "Musikinstrumente", en = "Musical instruments", fr = "Instruments musicaux"},
                ["Buff_Olibanum"]          = {de = "Weihrauch", en = "Olibanum", fr = "Encens"},
            }
        },
        SoldierCount = {
            Pattern = {
                de = "SOLDATENANZAHL {cr}Partei: %s{cr}{cr}%s %d",
                en = "SOLDIER COUNT {cr}Faction: %s{cr}{cr}%s %d",
                fr = "NOMBRE DE SOLDATS {cr}Faction: %s{cr}{cr}%s %d",
            },
            Relation = {
                ["true"]  = {de = "Weniger als ", en = "Less than ", fr = "Moins de"},
                ["false"] = {de = "Mindestens ", en = "At least ", fr = "Au moins"},
            }
        },
        Festivals = {
            Pattern = {
                de = "FESTE FEIERN {cr}{cr}Partei: %s{cr}{cr}Anzahl: %d",
                en = "HOLD PARTIES {cr}{cr}Faction: %s{cr}{cr}Amount: %d",
                fr = "FESTIVITÉS {cr}{cr}Faction: %s{cr}{cr}Nombre : %d",
            },
        }
    }
}

QSB.EffectNameToID = {};
QSB.InitalizedObjekts = {};

-- -------------------------------------------------------------------------- --

function SaveCustomVariable(_Name, _Value)
    LibertyCore.Quest:SetCustomVariable(_Name, _Value);
end

function ObtainCustomVariable(_Name, _Default)
    local Value = QSB.CustomVariable[_Name];
    if not Value and _Default then
        Value = _Default;
    end
    return Value;
end

-- -------------------------------------------------------------------------- --

function LibertyCore.Quest:Initalize()
    Report.CustomValueChanged = CreateReport("Event_CustomValueChanged");

    if not IsLocalScript() then
        self:OverrideQuestMarkers();
        self:OverwriteGeologistRefill();
    end
    if IsLocalScript() then
        self:OverrideDisplayQuestObjective();
    end
end

function LibertyCore.Quest:OnSaveGameLoaded()
end

-- -------------------------------------------------------------------------- --

function LibertyCore.Quest:OverrideQuestMarkers()
    QuestTemplate.RemoveQuestMarkers = function(self)
        for i=1, self.Objectives[0] do
            if self.Objectives[i].Type == Objective.Distance then
                if self.Objectives[i].Data[4] then
                    DestroyQuestMarker(self.Objectives[i].Data[2]);
                end
            end
        end
    end
    QuestTemplate.ShowQuestMarkers = function(self)
        for i=1, self.Objectives[0] do
            if self.Objectives[i].Type == Objective.Distance then
                if self.Objectives[i].Data[4] then
                    ShowQuestMarker(self.Objectives[i].Data[2]);
                end
            end
        end
    end

    function ShowQuestMarker(_Entity)
        local eID = GetID(_Entity);
        local x,y = Logic.GetEntityPosition(eID);
        local Marker = EGL_Effects.E_Questmarker_low;
        if Logic.IsBuilding(eID) == 1 then
            Marker = EGL_Effects.E_Questmarker;
        end
        DestroyQuestMarker(_Entity);
        Questmarkers[eID] = Logic.CreateEffect(Marker, x, y, 0);
    end
    function DestroyQuestMarker(_Entity)
        local eID = GetID(_Entity);
        if Questmarkers[eID] ~= nil then
            Logic.DestroyEffect(Questmarkers[eID]);
            Questmarkers[eID] = nil;
        end
    end
end

function LibertyCore.Quest:OverrideDisplayQuestObjective()
    GUI_Interaction.DisplayQuestObjective_Orig_QSB_Kernel = GUI_Interaction.DisplayQuestObjective
    GUI_Interaction.DisplayQuestObjective = function(_QuestIndex, _MessageKey)
        local Quest, QuestType = GUI_Interaction.GetPotentialSubQuestAndType(_QuestIndex);
        if QuestType == Objective.Distance then
            if Quest.Objectives[1].Data[1] == -65566 then
                Quest.Objectives[1].Data[1] = Logic.GetKnightID(Quest.ReceivingPlayer);
            end
        end
        GUI_Interaction.DisplayQuestObjective_Orig_QSB_Kernel(_QuestIndex, _MessageKey);
    end
end

function LibertyCore.Quest:IsQuestPositionReached(_Quest, _Objective)
    local IDdata2 = GetID(_Objective.Data[1]);
    if IDdata2 == -65566 then
        _Objective.Data[1] = Logic.GetKnightID(_Quest.ReceivingPlayer);
        IDdata2 = _Objective.Data[1];
    end
    local IDdata3 = GetID(_Objective.Data[2]);
    _Objective.Data[3] = _Objective.Data[3] or 2500;
    if not (Logic.IsEntityDestroyed(IDdata2) or Logic.IsEntityDestroyed(IDdata3)) then
        if Logic.GetDistanceBetweenEntities(IDdata2,IDdata3) <= _Objective.Data[3] then
            DestroyQuestMarker(IDdata3);
            return true;
        end
    else
        DestroyQuestMarker(IDdata3);
        return false;
    end
end

-- -------------------------------------------------------------------------- --

function LibertyCore.Quest:ChangeCustomQuestCaptionText(_Text, _Quest)
    if _Quest and _Quest.Visible then
        _Quest.QuestDescription = _Text;
        ExecuteLocal([[
            XGUIEng.ShowWidget("/InGame/Root/Normal/AlignBottomLeft/Message/QuestObjectives/Custom/BGDeco",0)
            local identifier = "%s"
            for i=1, Quests[0] do
                if Quests[i].Identifier == identifier then
                    local text = Quests[i].QuestDescription
                    XGUIEng.SetText("/InGame/Root/Normal/AlignBottomLeft/Message/QuestObjectives/Custom/Text", "%s")
                    break
                end
            end
        ]], _Quest.Identifier, _Text);
    end
end

-- -------------------------------------------------------------------------- --

function LibertyCore.Quest:OverwriteGeologistRefill()
    if Framework.GetGameExtraNo() >= 1 then
        GameCallback_OnGeologistRefill_Orig_QSB_Kernel = GameCallback_OnGeologistRefill;
        GameCallback_OnGeologistRefill = function(_PlayerID, _TargetID, _GeologistID)
            GameCallback_OnGeologistRefill_Orig_QSB_Kernel(_PlayerID, _TargetID, _GeologistID);
            if QSB.RefillAmounts[_TargetID] then
                local RefillAmount = QSB.RefillAmounts[_TargetID];
                local RefillRandom = RefillAmount + math.random(1, math.floor((RefillAmount * 0.2) + 0.5));
                Logic.SetResourceDoodadGoodAmount(_TargetID, RefillRandom);
                if RefillRandom > 0 then
                    if Logic.GetResourceDoodadGoodType(_TargetID) == Goods.G_Iron then
                        Logic.SetModel(_TargetID, Models.Doodads_D_SE_ResourceIron);
                    else
                        Logic.SetModel(_TargetID, Models.R_ResorceStone_Scaffold);
                    end
                end
            end
        end
    end
end

function LibertyCore.Quest:TriggerEntityKilledCallbacks(_Entity, _Attacker)
    local DefenderID = GetID(_Entity);
    local AttackerID = GetID(_Attacker or 0);
    if AttackerID == 0 or DefenderID == 0 or Logic.GetEntityHealth(DefenderID) > 0 then
        return;
    end
    local x, y, z     = Logic.EntityGetPos(DefenderID);
    local DefPlayerID = Logic.EntityGetPlayer(DefenderID);
    local DefType     = Logic.GetEntityType(DefenderID);
    local AttPlayerID = Logic.EntityGetPlayer(AttackerID);
    local AttType     = Logic.GetEntityType(AttackerID);

    GameCallback_EntityKilled(DefenderID, DefPlayerID, AttackerID, AttPlayerID, DefType, AttType);
    Logic.ExecuteInLuaLocalState(string.format(
        "GameCallback_Feedback_EntityKilled(%d, %d, %d, %d,%d, %d, %f, %f)",
        DefenderID, DefPlayerID, AttackerID, AttPlayerID, DefType, AttType, x, y
    ));
end

function LibertyCore.Quest:GetCustomVariable(_Name)
    return QSB.CustomVariable[_Name];
end

function LibertyCore.Quest:SetCustomVariable(_Name, _Value)
    self:UpdateCustomVariable(_Name, _Value);
    local Value = tostring(_Value);
    if type(_Value) ~= "number" then
        Value = [["]] ..Value.. [["]];
    end
    if not GUI then
        ExecuteLocal([[LibertyCore.Quest:UpdateCustomVariable("%s", %s)]], _Name, Value);
    end
end

function LibertyCore.Quest:UpdateCustomVariable(_Name, _Value)
    if QSB.CustomVariable[_Name] then
        local Old = QSB.CustomVariable[_Name];
        QSB.CustomVariable[_Name] = _Value;
        SendReport(Report.CustomValueChanged, _Name, Old, _Value);
    else
        QSB.CustomVariable[_Name] = _Value;
        SendReport(Report.CustomValueChanged, _Name, nil, _Value);
    end
end

-- -------------------------------------------------------------------------- --

function InteractiveObjectActivate(_ScriptName, _State)
    _State = _State or 0;
    if GUI or not IsExisting(_ScriptName) then
        return;
    end
    for i= 1, 8 do
        Logic.InteractiveObjectSetPlayerState(GetID(_ScriptName), i, _State);
    end
end

function InteractiveObjectDeactivate(_ScriptName)
    if GUI or not IsExisting(_ScriptName) then
        return;
    end
    for i= 1, 8 do
        Logic.InteractiveObjectSetPlayerState(GetID(_ScriptName), i, 2);
    end
end

