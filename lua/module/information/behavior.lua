--- Calls a mapscript function assuming it beeing a briefing.
---
--- Every briefing needs a unique name!
--- @param _Name string     Name of briefing
--- @param _Briefing string Name of function containing the briefing
function Reprisal_Briefing(_Name, _Briefing)
    return B_Reprisal_Briefing:new(_Name, _Briefing);
end

B_Reprisal_Briefing = {
    Name = "Reprisal_Briefing",
    Description = {
        en = "Reprisal: Calls a function to start an new briefing.",
        de = "Vergeltung: Ruft die Funktion auf und startet das enthaltene Briefing.",
        fr = "Rétribution: Appelle la fonction et démarre le briefing qu'elle contient.",
    },
    Parameter = {
        { ParameterType.Default, en = "Briefing name",     de = "Name des Briefing",     fr = "Nom du briefing" },
        { ParameterType.Default, en = "Briefing function", de = "Funktion mit Briefing", fr = "Fonction avec briefing" },
    },
}

function B_Reprisal_Briefing:GetReprisalTable()
    return { Reprisal.Custom,{self, self.CustomFunction} }
end

function B_Reprisal_Briefing:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.BriefingName = _Parameter;
    elseif (_Index == 1) then
        self.Function = _Parameter;
    end
end

function B_Reprisal_Briefing:CustomFunction(_Quest)
    _G[self.Function](self.BriefingName, _Quest.ReceivingPlayer);
end

function B_Reprisal_Briefing:Debug(_Quest)
    if self.BriefingName == nil or self.BriefingName == "" then
        error(string.format("%s: %s: Dialog name is invalid!", _Quest.Identifier, self.Name));
        return true;
    end
    if not type(_G[self.Function]) == "function" then
        error(_Quest.Identifier..": "..self.Name..": '"..self.Function.."' was not found!");
        return true;
    end
    return false;
end

if MapEditor or Lib.BriefingSystem then
    RegisterBehavior(B_Reprisal_Briefing);
end

-- -------------------------------------------------------------------------- --

--- Calls a mapscript function assuming it beeing a briefing.
---
--- Every briefing needs a unique name!
--- @param _Name string     Name of briefing
--- @param _Briefing string Name of function containing the briefing
function Reward_Briefing(_Name, _Briefing)
    return B_Reward_Briefing:new(_Name, _Briefing);
end

B_Reward_Briefing = CopyTable(B_Reprisal_Briefing);
B_Reward_Briefing.Name = "Reward_Briefing";
B_Reward_Briefing.Description.en = "Reward: Calls a function to start an new briefing.";
B_Reward_Briefing.Description.de = "Lohn: Ruft die Funktion auf und startet das enthaltene Briefing.";
B_Reward_Briefing.Description.fr = "Récompense: Appelle la fonction et démarre le briefing qu'elle contient.";
B_Reward_Briefing.GetReprisalTable = nil;

B_Reward_Briefing.GetRewardTable = function(self, _Quest)
    return { Reward.Custom,{self, self.CustomFunction} }
end

if MapEditor or Lib.BriefingSystem then
    RegisterBehavior(B_Reward_Briefing);
end

-- -------------------------------------------------------------------------- --

--- Checks if a briefing has concluded and then starts a quest.
--- @param _Name string      Name of briefing
--- @param _PlayerID integer Receiving player
--- @param _Waittime integer Time to wait after
function Trigger_Briefing(_Name, _PlayerID, _Waittime)
    return B_Trigger_Briefing:new(_Name, _PlayerID, _Waittime);
end

B_Trigger_Briefing = {
    Name = "Trigger_Briefing",
    Description = {
        en = "Trigger: Checks if an briefing has concluded and starts the quest if so.",
        de = "Auslöser: Prüft, ob ein Briefing beendet ist und startet dann den Quest.",
        fr = "Déclencheur: Vérifie si un briefing est terminé et lance ensuite la quête.",
    },
    Parameter = {
        { ParameterType.Default,  en = "Briefing name", de = "Name des Briefing", fr = "Nom du briefing" },
        { ParameterType.PlayerID, en = "Player ID",     de = "Player ID",         fr = "Player ID" },
        { ParameterType.Number,   en = "Wait time",     de = "Wartezeit",         fr = "Temps d'attente" },
    },
}

function B_Trigger_Briefing:GetTriggerTable()
    return { Triggers.Custom2,{self, self.CustomFunction} }
end

function B_Trigger_Briefing:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.BriefingName = _Parameter;
    elseif (_Index == 1) then
        self.PlayerID = _Parameter * 1;
    elseif (_Index == 2) then
        _Parameter = _Parameter or 0;
        self.WaitTime = _Parameter * 1;
    end
end

function B_Trigger_Briefing:CustomFunction(_Quest)
    if GetCinematicEvent(self.BriefingName, self.PlayerID) == CinematicEventState.Concluded then
        if self.WaitTime and self.WaitTime > 0 then
            self.WaitTimeTimer = self.WaitTimeTimer or Logic.GetTime();
            if Logic.GetTime() >= self.WaitTimeTimer + self.WaitTime then
                return true;
            end
        else
            return true;
        end
    end
    return false;
end

function B_Trigger_Briefing:Debug(_Quest)
    if self.WaitTime < 0 then
        error(string.format("%s: %s: Wait time must be 0 or greater!", _Quest.Identifier, self.Name));
        return true;
    end
    if self.PlayerID < 1 or self.PlayerID > 8 then
        error(string.format("%s: %s: Player-ID must be between 1 and 8!", _Quest.Identifier, self.Name));
        return true;
    end
    if self.BriefingName == nil or self.BriefingName == "" then
        error(string.format("%s: %s: Dialog name is invalid!", _Quest.Identifier, self.Name));
        return true;
    end
    return false;
end

if MapEditor or Lib.BriefingSystem then
    RegisterBehavior(B_Trigger_Briefing);
end

-- -------------------------------------------------------------------------- --

--- Calls a mapscript function assuming it beeing a cutscene.
---
--- Every cutscene needs a unique name!
--- @param _Name string     Name of cutscene
--- @param _Cutscene string Name of function containing the cutscene
function Reprisal_Cutscene(_Name, _Cutscene)
    return B_Reprisal_Cutscene:new(_Name, _Cutscene);
end

B_Reprisal_Cutscene = {
    Name = "Reprisal_Cutscene",
    Description = {
        en = "Reprisal: Calls a function to start an new Cutscene.",
        de = "Vergeltung: Ruft die Funktion auf und startet die enthaltene Cutscene.",
        fr = "Rétribution : Appelle la fonction et démarre la cutscene contenue.",
    },
    Parameter = {
        { ParameterType.Default, en = "Cutscene name",     de = "Name der Cutscene",     fr = "Nom de la cutscene", },
        { ParameterType.Default, en = "Cutscene function", de = "Funktion mit Cutscene", fr = "Fonction avec cutscene", },
    },
}

function B_Reprisal_Cutscene:GetReprisalTable()
    return { Reprisal.Custom, {self, self.CustomFunction} }
end

function B_Reprisal_Cutscene:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.CutsceneName = _Parameter;
    elseif (_Index == 1) then
        self.Function = _Parameter;
    end
end

function B_Reprisal_Cutscene:CustomFunction(_Quest)
    _G[self.Function](self.CutsceneName, _Quest.ReceivingPlayer);
end

function B_Reprisal_Cutscene:Debug(_Quest)
    if self.CutsceneName == nil or self.CutsceneName == "" then
        error(string.format("%s: %s: Dialog name is invalid!", _Quest.Identifier, self.Name));
        return true;
    end
    if not type(_G[self.Function]) == "function" then
        error(_Quest.Identifier..": "..self.Name..": '"..self.Function.."' was not found!");
        return true;
    end
    return false;
end

if MapEditor or Lib.CutsceneSystem then
    RegisterBehavior(B_Reprisal_Cutscene);
end

-- -------------------------------------------------------------------------- --

--- Calls a mapscript function assuming it beeing a cutscene.
---
--- Every cutscene needs a unique name!
--- @param _Name string     Name of cutscene
--- @param _Cutscene string Name of function containing the cutscene
function Reward_Cutscene(_Name, _Cutscene)
    return B_Reward_Cutscene:new(_Name, _Cutscene);
end

B_Reward_Cutscene = CopyTable(B_Reprisal_Cutscene);
B_Reward_Cutscene.Name = "Reward_Cutscene";
B_Reward_Cutscene.Description.en = "Reward: Calls a function to start an new Cutscene.";
B_Reward_Cutscene.Description.de = "Lohn: Ruft die Funktion auf und startet die enthaltene Cutscene.";
B_Reward_Cutscene.Description.fr = "Récompense: Appelle la fonction et démarre la cutscene contenue.";
B_Reward_Cutscene.GetReprisalTable = nil;

B_Reward_Cutscene.GetRewardTable = function(self, _Quest)
    return { Reward.Custom, {self, self.CustomFunction} }
end

if MapEditor or Lib.CutsceneSystem then
    RegisterBehavior(B_Reward_Cutscene);
end

-- -------------------------------------------------------------------------- --

--- Checks if a cutscene has concluded and then starts a quest.
--- @param _Name string      Name of briefing
--- @param _PlayerID integer Receiving player
--- @param _Waittime integer Time to wait after
function Trigger_Cutscene(_Name, _PlayerID, _Waittime)
    return B_Trigger_Cutscene:new(_Name, _PlayerID, _Waittime);
end

B_Trigger_Cutscene = {
    Name = "Trigger_Cutscene",
    Description = {
        en = "Trigger: Checks if an Cutscene has concluded and starts the quest if so.",
        de = "Auslöser: Prüft, ob eine Cutscene beendet ist und startet dann den Quest.",
        fr = "Déclencheur: Vérifie si une cutscene est terminée et démarre ensuite la quête.",
    },
    Parameter = {
        { ParameterType.Default,  en = "Cutscene name", de = "Name der Cutscene", fr  ="Nom de la cutscene" },
        { ParameterType.PlayerID, en = "Player ID",     de = "Player ID",         fr  ="Player ID" },
        { ParameterType.Number,   en = "Wait time",     de = "Wartezeit",         fr  ="Temps d'attente" },
    },
}

function B_Trigger_Cutscene:GetTriggerTable()
    return { Triggers.Custom2,{self, self.CustomFunction} }
end

function B_Trigger_Cutscene:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.CutsceneName = _Parameter;
    elseif (_Index == 1) then
        self.PlayerID = _Parameter * 1;
    elseif (_Index == 2) then
        _Parameter = _Parameter or 0;
        self.WaitTime = _Parameter * 1;
    end
end

function B_Trigger_Cutscene:CustomFunction(_Quest)
    if GetCinematicEvent(self.CutsceneName, self.PlayerID) == CinematicEventState.Concluded then
        if self.WaitTime and self.WaitTime > 0 then
            self.WaitTimeTimer = self.WaitTimeTimer or Logic.GetTime();
            if Logic.GetTime() >= self.WaitTimeTimer + self.WaitTime then
                return true;
            end
        else
            return true;
        end
    end
    return false;
end

function B_Trigger_Cutscene:Debug(_Quest)
    if self.WaitTime < 0 then
        error(string.format("%s: %s: Wait time must be 0 or greater!", _Quest.Identifier, self.Name));
        return true;
    end
    if self.PlayerID < 1 or self.PlayerID > 8 then
        error(string.format("%s: %s: Player-ID must be between 1 and 8!", _Quest.Identifier, self.Name));
        return true;
    end
    if self.CutsceneName == nil or self.CutsceneName == "" then
        error(string.format("%s: %s: Dialog name is invalid!", _Quest.Identifier, self.Name));
        return true;
    end
    return false;
end

if MapEditor or Lib.CutsceneSystem then
    RegisterBehavior(B_Trigger_Cutscene);
end

-- -------------------------------------------------------------------------- --

--- Calls a mapscript function assuming it beeing a dialog.
---
--- Every briefing needs a unique name!
--- @param _Name string     Name of briefing
--- @param _Dialog string Name of function containing the briefing
function Reprisal_Dialog(_Name, _Dialog)
    return B_Reprisal_Dialog:new(_Name, _Dialog);
end

B_Reprisal_Dialog = {
    Name = "Reprisal_Dialog",
    Description = {
        en = "Reprisal: Calls a function to start an new dialog.",
        de = "Vergeltung: Ruft die Funktion auf und startet das enthaltene Dialog.",
        fr = "Rétribution: Appelle la fonction et démarre le dialogue contenu.",
    },
    Parameter = {
        { ParameterType.Default, en = "Dialog name",     de = "Name des Dialog",     fr = "Nom du dialogue" },
        { ParameterType.Default, en = "Dialog function", de = "Funktion mit Dialog", fr = "Fonction du dialogue" },
    },
}

function B_Reprisal_Dialog:GetReprisalTable()
    return { Reprisal.Custom,{self, self.CustomFunction} }
end

function B_Reprisal_Dialog:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.DialogName = _Parameter;
    elseif (_Index == 1) then
        self.Function = _Parameter;
    end
end

function B_Reprisal_Dialog:CustomFunction(_Quest)
    _G[self.Function](self.DialogName, _Quest.ReceivingPlayer);
end

function B_Reprisal_Dialog:Debug(_Quest)
    if self.DialogName == nil or self.DialogName == "" then
        error(string.format("%s: %s: Dialog name is invalid!", _Quest.Identifier, self.Name));
        return true;
    end
    if not type(_G[self.Function]) == "function" then
        error(_Quest.Identifier..": "..self.Name..": '"..self.Function.."' was not found!");
        return true;
    end
    return false;
end

if MapEditor or Lib.DialogSystem then
    RegisterBehavior(B_Reprisal_Dialog);
end

-- -------------------------------------------------------------------------- --

--- Calls a mapscript function assuming it beeing a dialog.
---
--- Every briefing needs a unique name!
--- @param _Name string     Name of briefing
--- @param _Dialog string Name of function containing the briefing
function Reward_Dialog(_Name, _Dialog)
    return B_Reward_Dialog:new(_Name, _Dialog);
end

B_Reward_Dialog = CopyTable(B_Reprisal_Dialog);
B_Reward_Dialog.Name = "Reward_Dialog";
B_Reward_Dialog.Description.en = "Reward: Calls a function to start an new dialog.";
B_Reward_Dialog.Description.de = "Lohn: Ruft die Funktion auf und startet das enthaltene Dialog.";
B_Reward_Dialog.Description.fr = "Récompense: Appelle la fonction et lance le dialogue qu'elle contient.";
B_Reward_Dialog.GetReprisalTable = nil;

B_Reward_Dialog.GetRewardTable = function(self, _Quest)
    return { Reward.Custom,{self, self.CustomFunction} }
end

if MapEditor or Lib.DialogSystem then
    RegisterBehavior(B_Reward_Dialog);
end

-- -------------------------------------------------------------------------- --

--- Checks if a dialog has concluded and then starts a quest.
--- @param _Name string      Name of briefing
--- @param _PlayerID integer Receiving player
--- @param _Waittime integer Time to wait after
function Trigger_Dialog(_Name, _PlayerID, _Waittime)
    return B_Trigger_Dialog:new(_Name, _PlayerID, _Waittime);
end

B_Trigger_Dialog = {
    Name = "Trigger_Dialog",
    Description = {
        en = "Trigger: Checks if an dialog has concluded and starts the quest if so.",
        de = "Auslöser: Prüft, ob ein Dialog beendet ist und startet dann den Quest.",
        fr = "Déclencheur: Vérifie si un dialogue est terminé et démarre alors la quête.",
    },
    Parameter = {
        { ParameterType.Default,  en = "Dialog name", de = "Name des Dialog", fr = "Nom du dialogue" },
        { ParameterType.PlayerID, en = "Player ID",   de = "Player ID",       fr = "Player ID" },
        { ParameterType.Number,   en = "Wait time",   de = "Wartezeit",       fr = "Temps d'attente" },
    },
}

function B_Trigger_Dialog:GetTriggerTable()
    return { Triggers.Custom2,{self, self.CustomFunction} }
end

function B_Trigger_Dialog:AddParameter(_Index, _Parameter)
    if (_Index == 0) then
        self.DialogName = _Parameter;
    elseif (_Index == 1) then
        self.PlayerID = _Parameter * 1;
    elseif (_Index == 2) then
        _Parameter = _Parameter or 0;
        self.WaitTime = _Parameter * 1;
    end
end

function B_Trigger_Dialog:CustomFunction(_Quest)
    if GetCinematicEvent(self.DialogName, self.PlayerID) == CinematicEventState.Concluded then
        if self.WaitTime and self.WaitTime > 0 then
            self.WaitTimeTimer = self.WaitTimeTimer or Logic.GetTime();
            if Logic.GetTime() >= self.WaitTimeTimer + self.WaitTime then
                return true;
            end
        else
            return true;
        end
    end
    return false;
end

function B_Trigger_Dialog:Debug(_Quest)
    if self.WaitTime < 0 then
        error(string.format("%s: %s: Wait time must be 0 or greater!", _Quest.Identifier, self.Name));
        return true;
    end
    if self.PlayerID < 1 or self.PlayerID > 8 then
        error(string.format("%s: %s: Player-ID must be between 1 and 8!", _Quest.Identifier, self.Name));
        return true;
    end
    if self.DialogName == nil or self.DialogName == "" then
        error(string.format("%s: %s: Dialog name is invalid!", _Quest.Identifier, self.Name));
        return true;
    end
    return false;
end

if MapEditor or Lib.DialogSystem then
    RegisterBehavior(B_Trigger_Dialog);
end

-- -------------------------------------------------------------------------- --
