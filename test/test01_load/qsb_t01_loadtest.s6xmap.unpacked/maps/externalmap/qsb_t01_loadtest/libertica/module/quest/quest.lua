---@diagnostic disable: missing-return-value

Lib.Quest = Lib.Quest or {};
Lib.Quest.Name = "Quest";
Lib.Quest.Global = {
    ExternalTriggerConditions = {},
    ExternalTimerConditions = {},
    ExternalDecisionConditions = {},
    SegmentsOfQuest = {},
};
Lib.Quest.Local = {};

SegmentResult = {
    Success = 1,
    Failure = 2,
    Ignore  = 3,
}

Lib.Require("comfort/GetQuestID");
Lib.Require("comfort/IsValidQuest");
Lib.Require("comfort/IsValidQuestName");
Lib.Require("core/core");
Lib.Require("module/quest/Quest_API");
Lib.Register("module/quest/Quest");

-- -------------------------------------------------------------------------- --
-- Global

-- Global initalizer method
function Lib.Quest.Global:Initialize()
    if not self.IsInstalled then
        Quest_Loop = self.QuestLoop;
        self:OverrideKernelQuestApi();

        -- Garbage collection
        Lib.Quest.Local = nil;
    end
    self.IsInstalled = true;
end

-- Global load game
function Lib.Quest.Global:OnSaveGameLoaded()
end

-- Global report listener
function Lib.Quest.Global:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    elseif _ID == Report.ChatClosed then
    end
end

-- -------------------------------------------------------------------------- --

function Lib.Quest.Global:CreateNestedQuest(_Data)
    if not _Data.Segments then
        return;
    end
    -- Add behavior to check on segments
    table.insert(
        _Data,
        Goal_MapScriptFunction(self:GetCheckQuestSegmentsInlineGoal(), _Data.Name)
    )
    -- Create quest
    local Name = self:CreateSimpleQuest(_Data);
    if Name ~= nil then
        Quests[GetQuestID(Name)].Visible = false;
        self.SegmentsOfQuest[Name] = {};
        -- Create segments
        for i= 1, #_Data.Segments, 1 do
            self:CreateSegmentForSegmentedQuest(_Data.Segments[i], Name, i);
        end
    end
    return Name;
end

function Lib.Quest.Global:CreateSegmentForSegmentedQuest(_Data, _ParentName, _Index)
    local Name = _Data.Name or _ParentName.. "@Segment" .._Index;
    local Parent = Quests[GetQuestID(_ParentName)];

    local QuestDescription = {
        Name        = Name,
        Segments    = _Data.Segments,
        Result      = _Data.Result or SegmentResult.Success,
        Sender      = _Data.Sender or Parent.SendingPlayer,
        Receiver    = _Data.Receiver or Parent.ReceivingPlayer,
        Time        = _Data.Time,
        Suggestion  = _Data.Suggestion,
        Success     = _Data.Success,
        Failure     = _Data.Failure,
        Description = _Data.Description,
        Loop        = _Data.Loop,
        Callback    = _Data.Callback,
    };
    for i= 1, #_Data do
        table.insert(QuestDescription, _Data[i]);
    end

    table.insert(QuestDescription, Trigger_OnQuestActive(_ParentName, 0));
    if QuestDescription.Segments then
        self:CreateNestedQuest(QuestDescription);
    else
        self:CreateSimpleQuest(QuestDescription);
    end
    table.insert(self.SegmentsOfQuest[_ParentName], QuestDescription);
end

function Lib.Quest.Global:GetCheckQuestSegmentsInlineGoal()
    return function (_QuestName)
        local AllSegmentsConcluded = true;
        local SegmentList = Lib.Quest.Global.SegmentsOfQuest[_QuestName];
        for i= 1, #SegmentList, 1 do
            local SegmentQuest = Quests[GetQuestID(SegmentList[i].Name)];
            -- Non existing segment fails quest
            if not SegmentQuest then
                return false;
            end
            -- Not expectec result of segment fails quest
            if SegmentQuest.State == QuestState.Over and SegmentQuest.Result ~= QuestResult.Interrupted then
                if SegmentList[i].Result == SegmentResult.Success and SegmentQuest.Result ~= QuestResult.Success then
                    Lib.Quest.Global:AbortAllQuestSegments(_QuestName);
                    return false;
                end
                if SegmentList[i].Result == SegmentResult.Failure and SegmentQuest.Result ~= QuestResult.Failure then
                    Lib.Quest.Global:AbortAllQuestSegments(_QuestName);
                    return false;
                end
            end
            -- Check if segment is concluded
            if SegmentQuest.State ~= QuestState.Over then
                AllSegmentsConcluded = false;
            end
        end
        -- Success after all segments have been completed
        if AllSegmentsConcluded then
            return true;
        end
    end;
end

function Lib.Quest.Global:AbortAllQuestSegments(_QuestName)
    for i= 1, #self.SegmentsOfQuest[_QuestName], 1 do
        local SegmentName = self.SegmentsOfQuest[_QuestName][i].Name;
        if IsValidQuest(_QuestName) and Quests[GetQuestID(SegmentName)].State ~= QuestState.Over then
            StopQuest(SegmentName, true);
        end
    end
end

function Lib.Quest.Global:CreateSimpleQuest(_Data)
    if not _Data.Name then
        AutomaticQuestNameCounter = (AutomaticQuestNameCounter or 0) +1;
        _Data.Name = string.format("AutoNamed_Quest_%d", AutomaticQuestNameCounter);
    end
    error(IsValidQuestName(_Data.Name), "Quest '%s': invalid questname! Contains forbidden characters!", tostring(_Data.Name));

    -- Fill quest data
    local QuestData = {
        _Data.Name,
        (_Data.Sender ~= nil and _Data.Sender) or 1,
        (_Data.Receiver ~= nil and _Data.Receiver) or 1,
        {},
        {},
        (_Data.Time ~= nil and _Data.Time) or 0,
        {},
        {},
        _Data.Callback,
        _Data.Loop,
        _Data.Visible == true or _Data.Suggestion ~= nil,
        _Data.EndMessage == true or (_Data.Failure ~= nil or _Data.Success ~= nil),
        ConvertPlaceholders((type(_Data.Description) == "table" and Localize(_Data.Description)) or _Data.Description),
        ConvertPlaceholders((type(_Data.Suggestion) == "table" and Localize(_Data.Suggestion)) or _Data.Suggestion),
        ConvertPlaceholders((type(_Data.Success) == "table" and Localize(_Data.Success)) or _Data.Success),
        ConvertPlaceholders((type(_Data.Failure) == "table" and Localize(_Data.Failure)) or _Data.Failure)
    };

    -- Validate data
    if not self:QuestValidateQuestData(QuestData) then
        DumpTable(QuestData, "Quest");
        error(false, "ModuleQuest: Failed to vaidate quest data. Table has been copied to log.");
    end

    -- Behaviour
    for k,v in pairs(_Data) do
        if tonumber(k) ~= nil then
            if type(v) == "table" then
                if v.GetGoalTable then
                    table.insert(QuestData[4], v:GetGoalTable());

                    local Idx = #QuestData[4];
                    QuestData[4][Idx].Context            = v;
                    QuestData[4][Idx].FuncOverrideIcon   = QuestData[4][Idx].Context.GetIcon;
                    QuestData[4][Idx].FuncOverrideMsgKey = QuestData[4][Idx].Context.GetMsgKey;
                elseif v.GetReprisalTable then
                    table.insert(QuestData[8], v:GetReprisalTable());
                elseif v.GetRewardTable then
                    table.insert(QuestData[7], v:GetRewardTable());
                else
                    table.insert(QuestData[5], v:GetTriggerTable());
                end
            end
        end
    end

    -- Default goal
    if #QuestData[4] == 0 then
        table.insert(QuestData[4], {Objective.Dummy});
    end
    -- Default trigger
    if #QuestData[5] == 0 then
        table.insert(QuestData[5], {Triggers.Time, 0 });
    end
    -- Enough space behavior
    if QuestData[11] then
        table.insert(QuestData[5], self:GetFreeSpaceInlineTrigger());
    end

    -- Create quest
    local QuestID, Quest = QuestTemplate:New(unpack(QuestData, 1, 16));
    Quest.MsgTableOverride = _Data.MSGKeyOverwrite;
    Quest.IconOverride = _Data.IconOverwrite;
    Quest.QuestInfo = _Data.InfoText;
    Quest.Arguments = (_Data.Arguments ~= nil and table.copy(_Data.Arguments)) or {};
    return _Data.Name, Quests[0];
end

function Lib.Quest.Global:QuestValidateQuestData(_Data)
    return (
        (type(_Data[1]) == "string" and IsValidQuestName(_Data[1]) and Quests[GetQuestID(_Data[1])] == nil) and
        (type(_Data[2]) == "number" and _Data[2] >= 1 and _Data[2] <= 8) and
        (type(_Data[3]) == "number" and _Data[3] >= 1 and _Data[3] <= 8) and
        (type(_Data[6]) == "number" and _Data[6] >= 0) and
        ((_Data[9] ~= nil and type(_Data[9]) == "function") or (_Data[9] == nil)) and
        ((_Data[10] ~= nil and type(_Data[10]) == "function") or (_Data[10] == nil)) and
        (type(_Data[11]) == "boolean") and
        (type(_Data[12]) == "boolean") and
        ((_Data[13] ~= nil and type(_Data[13]) == "string") or (_Data[13] == nil)) and
        ((_Data[14] ~= nil and type(_Data[14]) == "string") or (_Data[14] == nil)) and
        ((_Data[15] ~= nil and type(_Data[15]) == "string") or (_Data[15] == nil)) and
        ((_Data[16] ~= nil and type(_Data[16]) == "string") or (_Data[16] == nil))
    );
end

-- This prevents from triggering a quest when all slots are occupied. But the
-- mapper who uses this automation must also keep in mind that they might soft
-- lock the game if fully relying on this trigger without thinking! This is
-- only here to ensure functionality in case of errors and NOT to support the
-- sloth of mappers!
-- Also this technically is a bugfix but can not be put into the kernel.
function Lib.Quest.Global:GetFreeSpaceInlineTrigger()
    return {
        Triggers.Custom2, {
            {},
            function(_Data, _Quest)
                local VisbleQuests = 0;
                if Quests[0] > 0 then
                    for i= 1, Quests[0], 1 do
                        if Quests[i].State == QuestState.Active and Quests[i].Visible == true then
                            VisbleQuests = VisbleQuests +1;
                        end
                    end
                end
                return VisbleQuests < 6;
            end
        }
    };
end

-- -------------------------------------------------------------------------- --

function Lib.Quest.Global:OverrideKernelQuestApi()
    FailQuest_Orig_ModuleQuest = FailQuest;
    FailQuest = function(_QuestName, _NoMessage)
        -- Fail segments of quest fist
        if Lib.Quest.Global.SegmentsOfQuest[_QuestName] then
            for k, v in pairs(Lib.Quest.Global.SegmentsOfQuest[_QuestName]) do
                if IsValidQuest(v.Name) and Quests[GetQuestID(v.Name)].State ~= QuestState.Over then
                    FailQuest_Orig_ModuleQuest(v.Name, true);
                end
            end
        end
        -- Proceed with failing
        FailQuest_Orig_ModuleQuest(_QuestName, _NoMessage);
    end

    RestartQuest_Orig_ModuleQuest = RestartQuest;
    RestartQuest = function(_QuestName, _NoMessage)
        -- Restart segments of quest first
        if Lib.Quest.Global.SegmentsOfQuest[_QuestName] then
            for k, v in pairs(Lib.Quest.Global.SegmentsOfQuest[_QuestName]) do
                if IsValidQuest(v.Name) then
                    StopQuest_Orig_ModuleQuest(v.Name, true);
                    RestartQuest_Orig_ModuleQuest(v.Name, true);
                end
            end
        end
        -- Proceed with restarting
        RestartQuest_Orig_ModuleQuest(_QuestName, _NoMessage);
    end

    StartQuest_Orig_ModuleQuest = StartQuest;
    StartQuest = function(_QuestName, _NoMessage)
        -- Start segments of quest first
        if Lib.Quest.Global.SegmentsOfQuest[_QuestName] then
            for k, v in pairs(Lib.Quest.Global.SegmentsOfQuest[_QuestName]) do
                if IsValidQuest(v.Name) and Quests[GetQuestID(v.Name)].State ~= QuestState.Over then
                    StartQuest_Orig_ModuleQuest(v.Name, true);
                end
            end
        end
        -- Proceed with starting
        StartQuest_Orig_ModuleQuest(_QuestName, _NoMessage);
    end

    StopQuest_Orig_ModuleQuest = StopQuest;
    StopQuest = function(_QuestName, _NoMessage)
        -- Stop segments of quest first
        if Lib.Quest.Global.SegmentsOfQuest[_QuestName] then
            for k, v in pairs(Lib.Quest.Global.SegmentsOfQuest[_QuestName]) do
                if IsValidQuest(v.Name) and Quests[GetQuestID(v.Name)].State ~= QuestState.Over then
                    StopQuest_Orig_ModuleQuest(v.Name, true);
                end
            end
        end
        -- Proceed with stopping
        StopQuest_Orig_ModuleQuest(_QuestName, _NoMessage);
    end

    WinQuest_Orig_ModuleQuest = WinQuest;
    WinQuest = function(_QuestName, _NoMessage)
        -- Stop segments of quest first
        if Lib.Quest.Global.SegmentsOfQuest[_QuestName] then
            for k, v in pairs(Lib.Quest.Global.SegmentsOfQuest[_QuestName]) do
                if IsValidQuest(v.Name) and Quests[GetQuestID(v.Name)].State ~= QuestState.Over then
                    StopQuest_Orig_ModuleQuest(v.Name, true);
                end
            end
        end
        -- Proceed with winning
        WinQuest_Orig_ModuleQuest(_QuestName, _NoMessage);
    end
end

-- -------------------------------------------------------------------------- --

function Lib.Quest.Global.QuestLoop(_arguments)
    local self = JobQueue_GetParameter(_arguments);
    if self.LoopCallback ~= nil then
        self:LoopCallback();
    end
    if self.State == QuestState.NotTriggered then
        local triggered = true;
        -- Are triggers active?
        for i= 1, #Lib.Quest.Global.ExternalTriggerConditions, 1 do
            if not Lib.Quest.Global.ExternalTriggerConditions[i](self.ReceivingPlayer, self) then
                triggered = false;
                break;
            end
        end
        -- Normal condition
        if triggered then
            for i = 1, self.Triggers[0] do
                -- Write Trigger to Log
                local Text = Lib.Quest.Global:SerializeBehavior(self.Triggers[i], Triggers.Custom2, 4);
                if Text then
                    log("Quest '" ..self.Identifier.. "' " ..Text, true);
                end
                -- Check Trigger
                triggered = triggered and self:IsTriggerActive(self.Triggers[i]);
            end
        end
        if triggered then
            self:SetMsgKeyOverride();
            self:SetIconOverride();
            self:Trigger();
        end
    elseif self.State == QuestState.Active then
        -- Do timers tick?
        for i= 1, #Lib.Quest.Global.ExternalTimerConditions, 1 do
            if not Lib.Quest.Global.ExternalTimerConditions[i](self.ReceivingPlayer, self) then
                self.StartTime = self.StartTime +1;
                break;
            end
        end
        -- Are goals checked?
        local CheckBehavior = true;
        for i= 1, #Lib.Quest.Global.ExternalDecisionConditions, 1 do
            if not Lib.Quest.Global.ExternalDecisionConditions[i](self.ReceivingPlayer, self) then
                CheckBehavior = false;
                break;
            end
        end
        if CheckBehavior then
            local allTrue = true;
            local anyFalse = false;
            for i = 1, self.Objectives[0] do
                -- Write Trigger to Log
                local Text = Lib.Quest.Global:SerializeBehavior(self.Objectives[i], Objective.Custom2, 1);
                if Text then
                    log("Quest '" ..self.Identifier.. "' " ..Text, true);
                end
                -- Check Goal
                local completed = self:IsObjectiveCompleted(self.Objectives[i]);
                if self.Objectives[i].Type == Objective.Deliver and completed == nil then
                    if self.Objectives[i].Data[4] == nil then
                        self.Objectives[i].Data[4] = 0;
                    end
                    if self.Objectives[i].Data[3] ~= nil then
                        self.Objectives[i].Data[4] = self.Objectives[i].Data[4] + 1;
                    end
                    local st = self.StartTime;
                    local sd = self.Duration;
                    local dt = self.Objectives[i].Data[4];
                    local sum = self.StartTime + self.Duration - self.Objectives[i].Data[4];
                    if self.Duration > 0 and self.StartTime + self.Duration + self.Objectives[i].Data[4] < Logic.GetTime() then
                        completed = false;
                    end
                else
                    if self.Duration > 0 and self.StartTime + self.Duration < Logic.GetTime() then
                        if completed == nil and
                            (self.Objectives[i].Type == Objective.Protect or self.Objectives[i].Type == Objective.Dummy or self.Objectives[i].Type == Objective.NoChange) then
                            completed = true;
                        elseif completed == nil or self.Objectives[i].Type == Objective.DummyFail then
                            completed = false;
                    end
                    end
                end
                allTrue = (completed == true) and allTrue;
                anyFalse = completed == false or anyFalse;
            end
            if allTrue then
                self:Success();
            elseif anyFalse then
                self:Fail();
            end
        end
    else
        if self.IsEventQuest == true then
            Logic.ExecuteInLuaLocalState("StopEventMusic(nil, "..self.ReceivingPlayer..")");
        end
        if self.Result == QuestResult.Success then
            for i = 1, self.Rewards[0] do
                -- Write Trigger to Log
                local Text = Lib.Quest.Global:SerializeBehavior(self.Rewards[i], Reward.Custom, 3);
                if Text then
                    log("Quest '" ..self.Identifier.. "' " ..Text, true);
                end
                -- Add Reward
                self:AddReward(self.Rewards[i]);
            end
        elseif self.Result == QuestResult.Failure then
            for i = 1, self.Reprisals[0] do
                -- Write Trigger to Log
                local Text = Lib.Quest.Global:SerializeBehavior(self.Reprisals[i], Reprisal.Custom, 3);
                if Text then
                    log("Quest '" ..self.Identifier.. "' " ..Text, true);
                end
                -- Add Reward
                self:AddReprisal(self.Reprisals[i]);
            end
        end
        if self.EndCallback ~= nil then
            self:EndCallback();
        end
        return true;
    end
end

function Lib.Quest.Global:SerializeBehavior(_Data, _CustomType, _Typ)
    local BehaviorType = "Objective";
    local BehaTable = Objective;
    if _Typ == 2 then
        BehaviorType = "Reprisal";
        BehaTable = Reprisal;
    elseif _Typ == 3 then
        BehaviorType = "Reward";
        BehaTable = Reward;
    elseif _Typ == 4 then
        BehaviorType = "Trigger";
        BehaTable = Triggers;
    end

    local Info = "Running {";
    local Beha = GetNameOfKeyInTable(BehaTable, _Data.Type);

    if _Data.Type == _CustomType then
        local FunctionName = _Data.Data[1].FuncName;
        Info = Info.. BehaviorType.. "." ..Beha.. "";
        if FunctionName == nil then
            return;
        else
            Info = Info.. ", " ..tostring(FunctionName);
        end
        if _Data.Data and _Data.Data[1].i47ya_6aghw_frxil and #_Data.Data[1].i47ya_6aghw_frxil > 0 then
            for j= 1, #_Data.Data[1].i47ya_6aghw_frxil, 1 do
                Info = Info.. ", (" ..type(_Data.Data[1].i47ya_6aghw_frxil[j]).. ") " ..tostring(_Data.Data[1].i47ya_6aghw_frxil[j]);
            end
        end
    else
        Info = Info.. BehaviorType.. "." ..Beha.. "";
        if _Data.Data then
            if type(_Data.Data) == "table" then
                for j= 1, #_Data.Data do
                    Info = Info.. ", (" ..type(_Data.Data[j]).. ") " ..tostring(_Data.Data[j]);
                end
            else
                Info = Info.. ", (" ..type(_Data.Data).. ") " ..tostring(_Data.Data);
            end
        end
    end
    Info = Info.. "}";
    return Info;
end

-- -------------------------------------------------------------------------- --
-- Chat Commands

function Lib.Quest.Global:FindQuestNames(_Pattern, _ExactName)
    local FoundQuests = FindQuestsByName(_Pattern, _ExactName);
    if #FoundQuests == 0 then
        return {};
    end
    local NamesOfFoundQuests = {};
    for i= 1, #FoundQuests, 1 do
        table.insert(NamesOfFoundQuests, FoundQuests[i].Identifier);
    end
    return NamesOfFoundQuests;
end

function Lib.Quest.Global:ProcessChatInput(_Text, _PlayerID, _IsDebug)
    if _IsDebug then
        local Commands = Lib.Core.Debug:CommandTokenizer(_Text);
        for i= 1, #Commands, 1 do
            if Commands[i][1] == "fail"
            or Commands[i][1] == "start"
            or Commands[i][1] == "restart"
            or Commands[i][1] == "stop"
            or Commands[i][1] == "win" then
                local FoundQuests = self:FindQuestNames(Commands[i][2], true);
                error(#FoundQuests == 1, "Unable to find quest containing '" ..Commands[i][2].. "'");
                if Commands[i][1] == "fail" then
                    FailQuest(FoundQuests[1]);
                    log("fail quest '" ..FoundQuests[1].. "'");
                elseif Commands[i][1] == "restart" then
                    RestartQuest(FoundQuests[1]);
                    log("restart quest '" ..FoundQuests[1].. "'");
                elseif Commands[i][1] == "start" then
                    StartQuest(FoundQuests[1]);
                    log("trigger quest '" ..FoundQuests[1].. "'");
                elseif Commands[i][1] == "stop" then
                    StopQuest(FoundQuests[1]);
                    log("interrupt quest '" ..FoundQuests[1].. "'");
                elseif Commands[i][1] == "win" then
                    WinQuest(FoundQuests[1]);
                    log("win quest '" ..FoundQuests[1].. "'");
                end
            end
        end
    end
end

-- -------------------------------------------------------------------------- --
-- Local

-- Local initalizer method
function Lib.Quest.Local:Initialize()
    if not self.IsInstalled then
        -- Garbage collection
        Lib.Quest.Global = nil;
    end
    self.IsInstalled = true;
end

-- Local load game
function Lib.Quest.Local:OnSaveGameLoaded()
end

-- Global report listener
function Lib.Quest.Local:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    elseif _ID == Report.ChatClosed then
        self:ProcessChatInput(arg[1], arg[2], arg[3]);
    end
end

function Lib.Quest.Local:ProcessChatInput(_Text, _PlayerID, _IsDebug)
    if not _IsDebug or GUI.GetPlayerID() ~= _PlayerID then
        return;
    end
    ExecuteGlobal(
        [[Lib.Quest.Global:ProcessChatInput("%s", %d, %s)]],
        _Text, _PlayerID, tostring(_IsDebug == true)
    );
end

-- -------------------------------------------------------------------------- --

RegisterModule(Lib.Quest.Name);

