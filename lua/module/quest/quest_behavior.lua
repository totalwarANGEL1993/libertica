function Goal_WinQuest(...)
    return B_Goal_WinQuest:new(...);
end

B_Goal_WinQuest = {
    Name = "Goal_WinQuest",
    Description = {
        en = "Goal: The player has to win a given quest.",
        de = "Ziel: Der Spieler muss eine angegebene Quest erfolgreich abschliessen.",
        fr = "Objectif: Le joueur doit réussir une quête indiquée.",
    },
    Parameter = {
        { ParameterType.QuestName, en = "Quest Name",  de = "Questname", fr = "Nom de la quête" },
    },
}

function B_Goal_WinQuest:GetGoalTable()
    return {Objective.Custom2, {self, self.CustomFunction}};
end

function B_Goal_WinQuest:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.Quest = _Parameter;
    end
end

function B_Goal_WinQuest:CustomFunction(_Quest)
    local quest = Quests[GetQuestID(self.Quest)];
    if quest then
        if quest.Result == QuestResult.Failure then
            return false;
        end
        if quest.Result == QuestResult.Success then
            return true;
        end
    end
    return nil;
end

function B_Goal_WinQuest:Debug(_Quest)
    if Quests[GetQuestID(self.Quest)] == nil then
        error(_Quest.Identifier.. ": " ..self.Name .. ": Quest '"..self.Quest.."' does not exist!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Goal_WinQuest);

-- -------------------------------------------------------------------------- --

function Trigger_OnAtLeastXOfYQuestsFailed(...)
    return B_Trigger_OnAtLeastXOfYQuestsFailed:new(...);
end

B_Trigger_OnAtLeastXOfYQuestsFailed = {
    Name = "Trigger_OnAtLeastXOfYQuestsFailed",
    Description = {
        en = "Trigger: if at least X of Y given quests has been finished successfully.",
        de = "Auslöser: wenn X von Y angegebener Quests fehlgeschlagen sind.",
        fr = "Déclencheur: lorsque X des Y quêtes indiquées ont échoué.",
    },
    Parameter = {
        { ParameterType.Custom,    en = "Least Amount", de = "Mindest Anzahl",  fr = "Nombre minimum" },
        { ParameterType.Custom,    en = "Quest Amount", de = "Quest Anzahl",    fr = "Nombre de quêtes" },
        { ParameterType.QuestName, en = "Quest name 1", de = "Questname 1",     fr = "Nom de la quête 1" },
        { ParameterType.QuestName, en = "Quest name 2", de = "Questname 2",     fr = "Nom de la quête 2" },
        { ParameterType.QuestName, en = "Quest name 3", de = "Questname 3",     fr = "Nom de la quête 3" },
        { ParameterType.QuestName, en = "Quest name 4", de = "Questname 4",     fr = "Nom de la quête 4" },
        { ParameterType.QuestName, en = "Quest name 5", de = "Questname 5",     fr = "Nom de la quête 5" },
    },
}

function B_Trigger_OnAtLeastXOfYQuestsFailed:GetTriggerTable()
    return { Triggers.Custom2,{self, self.CustomFunction} }
end

function B_Trigger_OnAtLeastXOfYQuestsFailed:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.LeastAmount = tonumber(_Parameter)
    elseif (_Index == 1) then
        self.QuestAmount = tonumber(_Parameter)
    elseif (_Index == 2) then
        self.QuestName1 = _Parameter
    elseif (_Index == 3) then
        self.QuestName2 = _Parameter
    elseif (_Index == 4) then
        self.QuestName3 = _Parameter
    elseif (_Index == 5) then
        self.QuestName4 = _Parameter
    elseif (_Index == 6) then
        self.QuestName5 = _Parameter
    end
end

function B_Trigger_OnAtLeastXOfYQuestsFailed:CustomFunction()
    local least = 0
    for i = 1, self.QuestAmount do
		local QuestID = GetQuestID(self["QuestName"..i]);
        if IsValidQuest(QuestID) then
			if (Quests[QuestID].Result == QuestResult.Failure) then
				least = least + 1
				if least >= self.LeastAmount then
					return true
				end
			end
        end
    end
    return false
end

function B_Trigger_OnAtLeastXOfYQuestsFailed:Debug(_Quest)
    local leastAmount = self.LeastAmount
    local questAmount = self.QuestAmount
    if leastAmount <= 0 or leastAmount >5 then
        error(_Quest.Identifier .. ":" .. self.Name .. ": LeastAmount is wrong")
        return true
    elseif questAmount <= 0 or questAmount > 5 then
        error(_Quest.Identifier.. ": " ..self.Name .. ": QuestAmount is wrong")
        return true
    elseif leastAmount > questAmount then
        error(_Quest.Identifier.. ": " ..self.Name .. ": LeastAmount is greater than QuestAmount")
        return true
    end
    for i = 1, questAmount do
        if not IsValidQuest(self["QuestName"..i]) then
            error(_Quest.Identifier.. ": " ..self.Name .. ": Quest ".. self["QuestName"..i] .. " not found")
            return true
        end
    end
    return false
end

function B_Trigger_OnAtLeastXOfYQuestsFailed:GetCustomData(_Index)
    if (_Index == 0) or (_Index == 1) then
        return {"1", "2", "3", "4", "5"}
    end
end

RegisterBehavior(B_Trigger_OnAtLeastXOfYQuestsFailed);

-- -------------------------------------------------------------------------- --

function Trigger_OnExactOneQuestIsWon(...)
    return B_Trigger_OnExactOneQuestIsWon:new(...);
end

B_Trigger_OnExactOneQuestIsWon = {
    Name = "Trigger_OnExactOneQuestIsWon",
    Description = {
        en = "Trigger: if one of two given quests has been finished successfully, but NOT both.",
        de = "Auslöser: wenn eine von zwei angegebenen Quests (aber NICHT beide) erfolgreich abgeschlossen wurde.",
        fr = "Déclencheur: lorsque l'une des deux quêtes indiquées (mais PAS les deux) a été accomplie avec succès.",
    },
    Parameter = {
        { ParameterType.QuestName, en = "Quest Name 1", de = "Questname 1", fr = "Nom de la quête 1", },
        { ParameterType.QuestName, en = "Quest Name 2", de = "Questname 2", fr = "Nom de la quête 2", },
    },
}

function B_Trigger_OnExactOneQuestIsWon:GetTriggerTable()
    return {Triggers.Custom2, {self, self.CustomFunction}};
end

function B_Trigger_OnExactOneQuestIsWon:AddParameter(_Index, _Parameter)
    self.QuestTable = {};

    if (_Index == 0) then
        self.Quest1 = _Parameter;
    elseif (_Index == 1) then
        self.Quest2 = _Parameter;
    end
end

function B_Trigger_OnExactOneQuestIsWon:CustomFunction(_Quest)
    local Quest1 = Quests[GetQuestID(self.Quest1)];
    local Quest2 = Quests[GetQuestID(self.Quest2)];
    if Quest2 and Quest1 then
        local Quest1Succeed = (Quest1.State == QuestState.Over and Quest1.Result == QuestResult.Success);
        local Quest2Succeed = (Quest2.State == QuestState.Over and Quest2.Result == QuestResult.Success);
        if (Quest1Succeed and not Quest2Succeed) or (not Quest1Succeed and Quest2Succeed) then
            return true;
        end
    end
    return false;
end

function B_Trigger_OnExactOneQuestIsWon:Debug(_Quest)
    if self.Quest1 == self.Quest2 then
        error(_Quest.Identifier.. ": " ..self.Name..": Both quests are identical!");
        return true;
    elseif not IsValidQuest(self.Quest1) then
        error(_Quest.Identifier.. ": " ..self.Name..": Quest '"..self.Quest1.."' does not exist!");
        return true;
    elseif not IsValidQuest(self.Quest2) then
        error(_Quest.Identifier.. ": " ..self.Name..": Quest '"..self.Quest2.."' does not exist!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Trigger_OnExactOneQuestIsWon);

-- -------------------------------------------------------------------------- --

function Trigger_OnExactOneQuestIsLost(...)
    return B_Trigger_OnExactOneQuestIsLost:new(...);
end

B_Trigger_OnExactOneQuestIsLost = {
    Name = "Trigger_OnExactOneQuestIsLost",
    Description = {
        en = "Trigger: If one of two given quests has been lost, but NOT both.",
        de = "Auslöser: Wenn einer von zwei angegebenen Quests (aber NICHT beide) fehlschlägt.",
        fr = "Déclencheur: Si l'une des deux quêtes indiquées (mais PAS les deux) échoue.",
    },
    Parameter = {
        { ParameterType.QuestName, en = "Quest Name 1", de = "Questname 1", fr = "Nom de la quête 1", },
        { ParameterType.QuestName, en = "Quest Name 2", de = "Questname 2", fr = "Nom de la quête 2", },
    },
}

function B_Trigger_OnExactOneQuestIsLost:GetTriggerTable()
    return {Triggers.Custom2, {self, self.CustomFunction}};
end

function B_Trigger_OnExactOneQuestIsLost:AddParameter(_Index, _Parameter)
    self.QuestTable = {};

    if (_Index == 0) then
        self.Quest1 = _Parameter;
    elseif (_Index == 1) then
        self.Quest2 = _Parameter;
    end
end

function B_Trigger_OnExactOneQuestIsLost:CustomFunction(_Quest)
    local Quest1 = Quests[GetQuestID(self.Quest1)];
    local Quest2 = Quests[GetQuestID(self.Quest2)];
    if Quest2 and Quest1 then
        local Quest1Succeed = (Quest1.State == QuestState.Over and Quest1.Result == QuestResult.Failure);
        local Quest2Succeed = (Quest2.State == QuestState.Over and Quest2.Result == QuestResult.Failure);
        if (Quest1Succeed and not Quest2Succeed) or (not Quest1Succeed and Quest2Succeed) then
            return true;
        end
    end
    return false;
end

function B_Trigger_OnExactOneQuestIsLost:Debug(_Quest)
    if self.Quest1 == self.Quest2 then
        error(_Quest.Identifier.. ": " ..self.Name..": Both quests are identical!");
        return true;
    elseif not IsValidQuest(self.Quest1) then
        error(_Quest.Identifier.. ": " ..self.Name..": Quest '"..self.Quest1.."' does not exist!");
        return true;
    elseif not IsValidQuest(self.Quest2) then
        error(_Quest.Identifier.. ": " ..self.Name..": Quest '"..self.Quest2.."' does not exist!");
        return true;
    end
    return false;
end

RegisterBehavior(B_Trigger_OnExactOneQuestIsLost);

-- -------------------------------------------------------------------------- --

