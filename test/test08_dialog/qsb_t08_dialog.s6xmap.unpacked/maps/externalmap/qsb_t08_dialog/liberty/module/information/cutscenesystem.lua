--- Allows to define cutscenes
---
--- Cutscenes are XML defined camera movemehts that can be played by the
--- game engine. Cutscenes feature smooth camera animations.

Lib.CutsceneSystem = {
    Name = "CutsceneSystem",

    Global = {
        Cutscene = {},
        CutsceneQueue = {},
        CutsceneCounter = 0;
    },
    Local = {
        Cutscene = {},
    },

    Text = {
        FastForwardActivate   = {de = "Beschleunigen",      en = "Fast Forward", fr = "Accélérer"},
        FastForwardDeactivate = {de = "Zurücksetzen",       en = "Normal Speed", fr = "Réinitialiser"},
        FastFormardMessage    = {de = "SCHNELLER VORLAUF",  en = "FAST FORWARD", fr = "AVANCÉ RAPIDE"},
    },
}

Lib.Require("core/Core");
Lib.Require("module/uieffects/UIEffects");
Lib.Require("module/uitools/UITools");
Lib.Require("module/information/CutsceneSystem_API");
Lib.Register("module/information/CutsceneSystem");

CinematicEventTypes.Cutscene = 3;

-- -------------------------------------------------------------------------- --
-- Global

-- Global initalizer method
function Lib.CutsceneSystem.Global:Initialize()
    if not self.IsInstalled then
        Report.CutsceneStarted = CreateReport("Event_CutsceneStarted");
        Report.CutsceneEnded = CreateReport("Event_CutsceneEnded");
        Report.CutscenePageShown = CreateReport("Event_CutscenePageShown");
        Report.CutsceneSkipButtonPressed = CreateReport("Event_CutsceneSkipButtonPressed");
        Report.CutsceneFlightStarted = CreateReport("Event_CutsceneFlightStarted");
        Report.CutsceneFlightEnded = CreateReport("Event_CutsceneFlightEnded");

        for i= 1, 8 do
            self.CutsceneQueue[i] = {};
        end
        RequestHiResJob(function()
            Lib.CutsceneSystem.Global:UpdateQueue();
        end);

        -- Garbage collection
        Lib.CutsceneSystem.Local = nil;
    end
    self.IsInstalled = true;
end

-- Global load game
function Lib.CutsceneSystem.Global:OnSaveGameLoaded()
end

-- Global report listener
function Lib.CutsceneSystem.Global:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    elseif _ID == Report.EscapePressed then
        -- Nothing to do?
    elseif _ID == Report.CutsceneStarted then
        -- Nothing to do?
    elseif _ID == Report.CutsceneEnded then
        self:EndCutscene(arg[1]);
    elseif _ID == Report.CutsceneFlightStarted then
        self:StartCutsceneFlight(arg[1], arg[2], arg[3]);
    elseif _ID == Report.CutsceneFlightEnded then
        self:EndCutsceneFlight(arg[1], arg[2]);
    elseif _ID == Report.CutsceneSkipButtonPressed then
        SendReportToLocal(Report.CutsceneSkipButtonPressed, arg[1]);
    elseif _ID == Report.CutscenePageShown then
        SendReportToLocal(Report.CutscenePageShown, arg[1], arg[2], arg[3]);
    end
end

function Lib.CutsceneSystem.Global:UpdateQueue()
    for i= 1, 8 do
        if self:CanStartCutscene(i) then
            local Next = Lib.UIEffects.Global:LookUpCinematicInQueue(i);
            if Next and Next[1] == CinematicEventTypes.Cutscene then
                self:NextCutscene(i);
            end
        end
    end
end

function Lib.CutsceneSystem.Global:CreateCutsceneGetPage(_Cutscene)
    _Cutscene.GetPage = function(self, _PlayerID, _NameOrID)
        local ID = Lib.CutsceneSystem.Global:GetPageIDByName(_PlayerID, _NameOrID);
        return Lib.CutsceneSystem.Global.Cutscene[_PlayerID][ID];
    end
end

function Lib.CutsceneSystem.Global:CreateCutsceneAddPage(_Cutscene)
    _Cutscene.AddPage = function(self, _Page)
        if type(_Page) == "table" then
            -- Make page legit
            _Page.__Legit = true;

            -- Translate text
            _Page.Title = Localize(_Page.Title);
            if _Page.Text then
                _Page.Text = Localize(_Page.Text);
            end
            -- Translate text lines
            if _Page.Lines then
                _Page.Lines = Localize(_Page.Lines);
            end
            if not _Page.Lines and not _Page.Text then
                assert(false, "Missing Lines or Text attribute!");
                return;
            end

            -- Set bar default
            if _Page.BigBars == nil then
                _Page.BigBars = false;
            end
        end
        table.insert(_Cutscene, _Page);
        return _Page;
    end
end

function Lib.CutsceneSystem.Global:StartCutscene(_Name, _PlayerID, _Data)
    self.CutsceneQueue[_PlayerID] = self.CutsceneQueue[_PlayerID] or {};
    Lib.UIEffects.Global:PushCinematicEventToQueue(
        _PlayerID,
        CinematicEventTypes.Cutscene,
        _Name,
        _Data
    );
end

function Lib.CutsceneSystem.Global:EndCutscene(_PlayerID)
    Logic.SetGlobalInvulnerability(0);
    SendReportToLocal(Report.CutsceneEnded, _PlayerID);
    if self.Cutscene[_PlayerID].Finished then
        self.Cutscene[_PlayerID]:Finished();
    end
    FinishCinematicEvent(self.Cutscene[_PlayerID].Name, _PlayerID);
    self.Cutscene[_PlayerID] = nil;
end

function Lib.CutsceneSystem.Global:NextCutscene(_PlayerID)
    if self:CanStartCutscene(_PlayerID) then
        local CutsceneData = Lib.UIEffects.Global:PopCinematicEventFromQueue(_PlayerID);
        assert(CutsceneData[1] == CinematicEventTypes.Cutscene);
        StartCinematicEvent(CutsceneData[2], _PlayerID);

        local Cutscene = CutsceneData[3];
        Cutscene.Name = CutsceneData[2];
        Cutscene.PlayerID = _PlayerID;
        Cutscene.BarOpacity = Cutscene.BarOpacity or 1;
        Cutscene.CurrentPage = 0;
        self.Cutscene[_PlayerID] = Cutscene;

        if Cutscene.EnableGlobalImmortality then
            Logic.SetGlobalInvulnerability(1);
        end
        if self.Cutscene[_PlayerID].Starting then
            self.Cutscene[_PlayerID]:Starting();
        end

        SendReportToLocal(Report.CutsceneStarted, _PlayerID, Cutscene.Name, Cutscene);
        SendReport(Report.CutsceneStarted, _PlayerID, Cutscene.Name);
    end
end

function Lib.CutsceneSystem.Global:StartCutsceneFlight(_PlayerID, _PageID, _Duration)
    if self.Cutscene[_PlayerID] == nil then
        return;
    end
    self.Cutscene[_PlayerID][_PageID].Duration = _Duration;
    if self.Cutscene[_PlayerID][_PageID].Action then
        self.Cutscene[_PlayerID][_PageID]:Action();
    end

    SendReportToLocal(Report.CutsceneFlightStarted, _PlayerID, _PageID, _Duration);
end

function Lib.CutsceneSystem.Global:EndCutsceneFlight(_PlayerID, _PageID)
    if self.Cutscene[_PlayerID] == nil then
        return;
    end
    SendReportToLocal(Report.CutsceneFlightEnded, _PlayerID, _PageID);
end

function Lib.CutsceneSystem.Global:DisplayPage(_PlayerID, _PageID)
    if self.Cutscene[_PlayerID] == nil then
        return;
    end
    -- Nothing to do in global script so just propagete to local
    SendReportToLocal(Report.CutscenePageShown, _PlayerID, _PageID);
end

function Lib.CutsceneSystem.Global:GetCurrentCutscene(_PlayerID)
    return self.Cutscene[_PlayerID];
end

function Lib.CutsceneSystem.Global:GetCurrentCutscenePage(_PlayerID)
    if self.Cutscene[_PlayerID] then
        local PageID = self.Cutscene[_PlayerID].CurrentPage;
        return self.Cutscene[_PlayerID][PageID];
    end
end

function Lib.CutsceneSystem.Global:GetPageIDByName(_PlayerID, _Name)
    if type(_Name) == "string" then
        if self.Cutscene[_PlayerID] ~= nil then
            for i= 1, #self.Cutscene[_PlayerID], 1 do
                if type(self.Cutscene[_PlayerID][i]) == "table" and self.Cutscene[_PlayerID][i].Name == _Name then
                    return i;
                end
            end
        end
        return 0;
    end
    return _Name;
end

function Lib.CutsceneSystem.Global:CanStartCutscene(_PlayerID)
    return  self.Cutscene[_PlayerID] == nil and
            not IsCinematicEventActive(_PlayerID) and
            self.LoadscreenClosed;
end

-- -------------------------------------------------------------------------- --
-- Local

-- Local initalizer method
function Lib.CutsceneSystem.Local:Initialize()
    if not self.IsInstalled then
        Report.CutsceneStarted = CreateReport("Event_CutsceneStarted");
        Report.CutsceneEnded = CreateReport("Event_CutsceneEnded");
        Report.CutscenePageShown = CreateReport("Event_CutscenePageShown");
        Report.CutsceneSkipButtonPressed = CreateReport("Event_CutsceneSkipButtonPressed");
        Report.CutsceneFlightStarted = CreateReport("Event_CutsceneFlightStarted");
        Report.CutsceneFlightEnded = CreateReport("Event_CutsceneFlightEnded");

        self:OverrideThroneRoomFunctions();

        -- Garbage collection
        Lib.CutsceneSystem.Global = nil;
    end
    self.IsInstalled = true;
end

-- Local load game
function Lib.CutsceneSystem.Local:OnSaveGameLoaded()
end

-- Local report listener
function Lib.CutsceneSystem.Local:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    elseif _ID == Report.EscapePressed then
        -- Nothing to do?
    elseif _ID == Report.CutsceneStarted then
        self:StartCutscene(arg[1], arg[2], arg[3]);
    elseif _ID == Report.CutsceneEnded then
        self:EndCutscene(arg[1]);
    elseif _ID == Report.CutsceneFlightStarted then
        self:StartCutsceneFlight(arg[1], arg[2], arg[3]);
    elseif _ID == Report.CutsceneFlightEnded then
        self:EndCutsceneFlight(arg[1], arg[2]);
    elseif _ID == Report.CutsceneSkipButtonPressed then
        self:SkipButtonPressed(arg[1]);
    elseif _ID == Report.CutscenePageShown then
        -- Nothing to do?
    end
end

function Lib.CutsceneSystem.Local:StartCutscene(_PlayerID, _CutsceneName, _Cutscene)
    if GUI.GetPlayerID() ~= _PlayerID then
        return;
    end
    self.Cutscene[_PlayerID] = _Cutscene;
    self.Cutscene[_PlayerID].LastSkipButtonPressed = 0;
    self.Cutscene[_PlayerID].CurrentPage = 0;

    DeactivateNormalInterface(_PlayerID);
    DeactivateBorderScroll(_PlayerID);

    if not Framework.IsNetworkGame() then
        Game.GameTimeSetFactor(_PlayerID, 1);
    end
    self:ActivateCinematicMode(_PlayerID);
    self:NextFlight(_PlayerID);
end

function Lib.CutsceneSystem.Local:EndCutscene(_PlayerID)
    if GUI.GetPlayerID() ~= _PlayerID then
        return;
    end

    if not Framework.IsNetworkGame() then
        Game.GameTimeSetFactor(_PlayerID, 1);
    end
    self:DeactivateCinematicMode(_PlayerID);
    ActivateNormalInterface(_PlayerID);
    ActivateBorderScroll(_PlayerID);
    Lib.UITools.Widget:UpdateHiddenWidgets();

    self.Cutscene[_PlayerID] = nil;
end

function Lib.CutsceneSystem.Local:NextFlight(_PlayerID)
    if self.Cutscene[_PlayerID] then
        self.Cutscene[_PlayerID].CurrentPage = self.Cutscene[_PlayerID].CurrentPage +1;
        local PageID = self.Cutscene[_PlayerID].CurrentPage;

        if self.Cutscene[_PlayerID][PageID] then
            local Flight = self.Cutscene[_PlayerID][PageID].Flight;
            if Camera.IsValidCutscene(Flight) then
                if GUI.GetPlayerID() == _PlayerID then
                    Camera.StartCutscene(Flight);
                end
            else
                -- This shouldn't happen!
                error("Lib.CutsceneSystem.Local:NextFlight: %s is an invalid flight!", tostring(Flight));
                self:PropagateCutsceneEnded(_PlayerID);
            end
        else
            self:PropagateCutsceneEnded(_PlayerID);
        end
    end
end

function Lib.CutsceneSystem.Local:PropagateCutsceneEnded(_PlayerID)
    if not self.Cutscene[_PlayerID] then
        return;
    end
    SendReportToGlobal(Report.CutsceneEnded, _PlayerID);
end

function Lib.CutsceneSystem.Local:FlightStarted(_Duration)
    local PlayerID = GUI.GetPlayerID();
    if self.Cutscene[PlayerID] then
        local PageID = self.Cutscene[PlayerID].CurrentPage;

        -- Far Clip Plane
        -- The clipping is changed by every camera event. To reset it to the
        -- desired value, we must update it here.
        local Page = self.Cutscene[PlayerID][PageID];
        if Page.FarClipPlane then
            Lib.CutsceneSystem.Local:SetFarClipPlane(Page.FarClipPlane);
        end

        SendReportToGlobal(Report.CutsceneFlightStarted, PlayerID, PageID, _Duration);
    end
end
CutsceneFlightStarted = function(_Duration)
    Lib.CutsceneSystem.Local:FlightStarted(_Duration);
end

function Lib.CutsceneSystem.Local:StartCutsceneFlight(_PlayerID, _PageID, _Duration)
    if self.Cutscene[_PlayerID] == nil then
        return;
    end
    self:DisplayPage(_PlayerID, _PageID, _Duration);
end

function Lib.CutsceneSystem.Local:FlightFinished()
    local PlayerID = GUI.GetPlayerID();
    if self.Cutscene[PlayerID] then
        local PageID = self.Cutscene[PlayerID].CurrentPage;
        SendReportToGlobal(Report.CutsceneFlightEnded, PlayerID, PageID);
    end
end
CutsceneFlightFinished = function()
    Lib.CutsceneSystem.Local:FlightFinished();
end

function Lib.CutsceneSystem.Local:EndCutsceneFlight(_PlayerID, _PageID)
    if self.Cutscene[_PlayerID] == nil then
        return;
    end
    self:NextFlight(_PlayerID);
end

function Lib.CutsceneSystem.Local:DisplayPage(_PlayerID, _PageID, _Duration)
    if GUI.GetPlayerID() ~= _PlayerID then
        return;
    end
    self.Cutscene[_PlayerID].AnimationQueue = self.Cutscene[_PlayerID].AnimationQueue or {};
    self.Cutscene[_PlayerID].CurrentPage = _PageID;
    if type(self.Cutscene[_PlayerID][_PageID]) == "table" then
        self.Cutscene[_PlayerID][_PageID].Started = Logic.GetTime();
        self.Cutscene[_PlayerID][_PageID].Duration = _Duration;
        Lib.UIEffects.Local:ResetFarClipPlane();
        self:DisplayPageBars(_PlayerID, _PageID);
        self:DisplayPageTitle(_PlayerID, _PageID);
        self:DisplayPageText(_PlayerID, _PageID);
        self:DisplayPageControls(_PlayerID, _PageID);
        self:DisplayPageFader(_PlayerID, _PageID);
        SendReportToGlobal(Report.CutscenePageShown, _PlayerID, _PageID, _Duration);
    end
end

function Lib.CutsceneSystem.Local:DisplayPageBars(_PlayerID, _PageID)
    local Page = self.Cutscene[_PlayerID][_PageID];
    local Opacity = (Page.Opacity ~= nil and Page.Opacity) or 1;
    local OpacityBig = (255 * Opacity);
    local OpacitySmall = (255 * Opacity);

    local BigVisibility = (Page.BigBars and 1) or 0;
    local SmallVisibility = (Page.BigBars and 0) or 1;
    if Opacity == 0 then
        BigVisibility = 0;
        SmallVisibility = 0;
    end

    XGUIEng.ShowWidget("/InGame/ThroneRoomBars", BigVisibility);
    XGUIEng.ShowWidget("/InGame/ThroneRoomBars_2", SmallVisibility);
    XGUIEng.ShowWidget("/InGame/ThroneRoomBars_Dodge", BigVisibility);
    XGUIEng.ShowWidget("/InGame/ThroneRoomBars_2_Dodge", SmallVisibility);

    XGUIEng.SetMaterialAlpha("/InGame/ThroneRoomBars/BarBottom", 1, OpacityBig);
    XGUIEng.SetMaterialAlpha("/InGame/ThroneRoomBars/BarTop", 1, OpacityBig);
    XGUIEng.SetMaterialAlpha("/InGame/ThroneRoomBars_2/BarBottom", 1, OpacitySmall);
    XGUIEng.SetMaterialAlpha("/InGame/ThroneRoomBars_2/BarTop", 1, OpacitySmall);
end

function Lib.CutsceneSystem.Local:DisplayPageTitle(_PlayerID, _PageID)
    local Page = self.Cutscene[_PlayerID][_PageID];
    local TitleWidget = "/InGame/ThroneRoom/Main/DialogTopChooseKnight/ChooseYourKnight";
    XGUIEng.SetText(TitleWidget, "");
    if Page.Title then
        local Title = ConvertPlaceholders(Localize(Page.Title));
        if Title:find("^[A-Za-Z0-9_]+/[A-Za-Z0-9_]+$") then
            Title = XGUIEng.GetStringTableText(Title);
        end
        if Title:sub(1, 1) ~= "{" then
            Title = "{@color:255,250,0,255}{center}" ..Title;
        end
        XGUIEng.SetText(TitleWidget, Title);
    end
end

function Lib.CutsceneSystem.Local:DisplayPageText(_PlayerID, _PageID)
    local Page = self.Cutscene[_PlayerID][_PageID];
    local TextWidget = "/InGame/ThroneRoom/Main/MissionBriefing/Text";
    XGUIEng.SetText(TextWidget, "Bockwurst");
    if Page.Text then
        local Text = ConvertPlaceholders(Localize(Page.Text));
        if Text:find("^[A-Za-Z0-9_]+/[A-Za-Z0-9_]+$") then
            Text = XGUIEng.GetStringTableText(Text);
        end
        if Text:sub(1, 1) ~= "{" then
            Text = "{center}" ..Text;
        end
        if not Page.BigBars then
            Text = "{cr}{cr}{cr}" .. Text;
        end
        XGUIEng.SetText(TextWidget, Text);
    end
end

function Lib.CutsceneSystem.Local:DisplayPageControls(_PlayerID, _PageID)
    local Page = self.Cutscene[_PlayerID][_PageID];
    local SkipFlag = 1;
    if Page.DisableSkipping == true then
        self.Cutscene[_PlayerID].FastForward = false;
        Game.GameTimeSetFactor(_PlayerID, 1);
        SkipFlag = 0;
    end
    XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/Skip", SkipFlag);
end

function Lib.CutsceneSystem.Local:DisplayPageFader(_PlayerID, _PageID)
    local Page = self.Cutscene[_PlayerID][_PageID];
    g_Fade.To = Page.FaderAlpha or 0;

    local PageFadeIn = Page.FadeIn;
    if PageFadeIn then
        FadeIn(PageFadeIn);
    end

    local PageFadeOut = Page.FadeOut;
    if PageFadeOut then
        -- FIXME: This would create jobs that are only be paused at the end!
        self.Cutscene[_PlayerID].FaderJob = RequestHiResJob(function(_Time, _FadeOut)
            if Logic.GetTimeMs() > _Time - (_FadeOut * 1000) then
                FadeOut(_FadeOut);
                return true;
            end
        end, (Page.Started * 1000) + (Page.Duration * 100), PageFadeOut);
    end
end

function Lib.CutsceneSystem.Local:ThroneRoomCameraControl(_PlayerID, _Page)
    if _Page then
        if _Page.DisableSkipping then
            XGUIEng.SetText("/InGame/ThroneRoom/Main/MissionBriefing/Objectives", " ");
            -- XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/Skip", 0);
            return;
        end
        -- XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/Skip", 1);

        -- Button text
        local SkipText = Localize(Lib.CutsceneSystem.Text.FastForwardActivate);
        if self.Cutscene[_PlayerID].FastForward then
            SkipText = Localize(Lib.CutsceneSystem.Text.FastForwardDeactivate);
        end
        XGUIEng.SetText("/InGame/ThroneRoom/Main/Skip", "{center}" ..SkipText);

        -- Fast forward message
        if self.Cutscene[_PlayerID].FastForward then
            local RealTime = GetSecondsRealTime();
            if not self.Cutscene[_PlayerID].FastForwardRealTime then
                self.Cutscene[_PlayerID].FastForwardRealTime = RealTime;
            end
            if self.Cutscene[_PlayerID].FastForwardRealTime < RealTime then
                self.Cutscene[_PlayerID].FastForwardIndent = (self.Cutscene[_PlayerID].FastForwardIndent or 0) +1;
                if self.Cutscene[_PlayerID].FastForwardIndent > 4 then
                    self.Cutscene[_PlayerID].FastForwardIndent = 1;
                end
                self.Cutscene[_PlayerID].FastForwardRealTime = RealTime;
            end
            local Text = "{cr}{cr}" ..Localize(Lib.CutsceneSystem.Text.FastFormardMessage);
            local Indent = string.rep("  ", (self.Cutscene[_PlayerID].FastForwardIndent or 0));
            XGUIEng.SetText("/InGame/ThroneRoom/Main/MissionBriefing/Objectives", Text..Indent.. ". . .");
        else
            XGUIEng.SetText("/InGame/ThroneRoom/Main/MissionBriefing/Objectives", " ");
        end
    end
end

function Lib.CutsceneSystem.Local:SkipButtonPressed(_PlayerID)
    if self.Cutscene[_PlayerID] == nil then
        return;
    end
    if (self.Cutscene[_PlayerID].LastSkipButtonPressed + 500) < Logic.GetTimeMs() then
        self.Cutscene[_PlayerID].LastSkipButtonPressed = Logic.GetTimeMs();

        -- Change speed of cutscene is only possible in singleplayer!
        if not Framework.IsNetworkGame() then
            if self.Cutscene[_PlayerID].FastForward then
                self.Cutscene[_PlayerID].FastForward = false;
                Game.GameTimeSetFactor(_PlayerID, 1);
            else
                self.Cutscene[_PlayerID].FastForward = true;
                Game.GameTimeSetFactor(_PlayerID, 10);
            end
        end
    end
end

function Lib.CutsceneSystem.Local:GetCurrentCutscene(_PlayerID)
    return self.Cutscene[_PlayerID];
end

function Lib.CutsceneSystem.Local:GetCurrentCutscenePage(_PlayerID)
    if self.Cutscene[_PlayerID] then
        local PageID = self.Cutscene[_PlayerID].CurrentPage;
        return self.Cutscene[_PlayerID][PageID];
    end
end

function Lib.CutsceneSystem.Local:GetPageIDByName(_PlayerID, _Name)
    if type(_Name) == "string" then
        if self.Cutscene[_PlayerID] ~= nil then
            for i= 1, #self.Cutscene[_PlayerID], 1 do
                if type(self.Cutscene[_PlayerID][i]) == "table" and self.Cutscene[_PlayerID][i].Name == _Name then
                    return i;
                end
            end
        end
        return 0;
    end
    return _Name;
end

function Lib.CutsceneSystem.Local:OverrideThroneRoomFunctions()
    self.Orig_GameCallback_Camera_SkipButtonPressed = GameCallback_Camera_SkipButtonPressed;
    GameCallback_Camera_SkipButtonPressed = function(_PlayerID)
        Lib.CutsceneSystem.Local.Orig_GameCallback_Camera_SkipButtonPressed(_PlayerID);
        if _PlayerID == GUI.GetPlayerID() then
            SendReportToGlobal(Report.CutsceneSkipButtonPressed, _PlayerID);
        end
    end

    self.Orig_GameCallback_Camera_ThroneroomCameraControl = GameCallback_Camera_ThroneroomCameraControl;
    GameCallback_Camera_ThroneroomCameraControl = function(_PlayerID)
        Lib.CutsceneSystem.Local.Orig_GameCallback_Camera_ThroneroomCameraControl(_PlayerID);
        if _PlayerID == GUI.GetPlayerID() then
            local Cutscene = Lib.CutsceneSystem.Local:GetCurrentCutscene(_PlayerID);
            if Cutscene ~= nil then
                Lib.CutsceneSystem.Local:ThroneRoomCameraControl(
                    _PlayerID,
                    Lib.CutsceneSystem.Local:GetCurrentCutscenePage(_PlayerID)
                );
            end
        end
    end

    self.Orig_GameCallback_Escape = GameCallback_Escape;
    GameCallback_Escape = function()
        if Lib.CutsceneSystem.Local.Cutscene[GUI.GetPlayerID()] then
            return;
        end
        Lib.CutsceneSystem.Local.Orig_GameCallback_Escape();
    end
end

function Lib.CutsceneSystem.Local:ActivateCinematicMode(_PlayerID)
    if self.CinematicActive or GUI.GetPlayerID() ~= _PlayerID then
        return;
    end
    self.CinematicActive = true;

    if not self.LoadscreenClosed then
        XGUIEng.PopPage();
    end
    local ScreenX, ScreenY = GUI.GetScreenSize();

    XGUIEng.ShowWidget("/InGame/ThroneRoom", 1);
    XGUIEng.PushPage("/InGame/ThroneRoomBars", false);
    XGUIEng.PushPage("/InGame/ThroneRoomBars_2", false);
    XGUIEng.PushPage("/InGame/ThroneRoom/Main", false);
    XGUIEng.PushPage("/InGame/ThroneRoomBars_Dodge", false);
    XGUIEng.PushPage("/InGame/ThroneRoomBars_2_Dodge", false);
    XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/Skip", 1);
    XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/StartButton", 0);
    XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/DialogTopChooseKnight", 1);
    XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/DialogTopChooseKnight/Frame", 0);
    XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/DialogTopChooseKnight/DialogBG", 0);
    XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/DialogTopChooseKnight/FrameEdges", 0);
    XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/DialogBottomRight3pcs", 0);
    XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/KnightInfoButton", 0);
    XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/Briefing", 0);
    XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/BackButton", 0);
    XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/Cutscene", 0);
    XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/TitleContainer", 0);
    XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/MissionBriefing/Text", 1);
    XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/MissionBriefing/Title", 1);
    XGUIEng.ShowWidget("/InGame/ThroneRoom/Main/MissionBriefing/Objectives", 1);
    XGUIEng.ShowWidget("/InGame/ThroneRoom/KnightInfo/BG", 0);
    XGUIEng.ShowWidget("/InGame/ThroneRoom/KnightInfo/LeftFrame", 0);

    -- Text
    XGUIEng.SetText("/InGame/ThroneRoom/Main/MissionBriefing/Text", " ");
    XGUIEng.SetText("/InGame/ThroneRoom/Main/MissionBriefing/Title", " ");
    XGUIEng.SetText("/InGame/ThroneRoom/Main/MissionBriefing/Objectives", " ");

    -- Title and back button position
    local x,y = XGUIEng.GetWidgetScreenPosition("/InGame/ThroneRoom/Main/DialogTopChooseKnight/ChooseYourKnight");
    XGUIEng.SetWidgetScreenPosition("/InGame/ThroneRoom/Main/DialogTopChooseKnight/ChooseYourKnight", x, 65 * (ScreenY/1080));

    self.SelectionBackup = {GUI.GetSelectedEntities()};
    GUI.ClearSelection();
    GUI.ClearNotes();
    GUI.ForbidContextSensitiveCommandsInSelectionState();
    GUI.ActivateCutSceneState();
    GUI.SetFeedbackSoundOutputState(0);
    GUI.EnableBattleSignals(false);
    Input.CutsceneMode();
    if not self.Cutscene[_PlayerID].EnableFoW then
        Display.SetRenderFogOfWar(0);
    end
    if self.Cutscene[_PlayerID].EnableSky then
        Display.SetRenderSky(1);
    end
    if not self.Cutscene[_PlayerID].EnableBorderPins then
        Display.SetRenderBorderPins(0);
    end
    Display.SetUserOptionOcclusionEffect(0);
    Camera.SwitchCameraBehaviour(5);

    InitializeFader();
    g_Fade.To = 1;
    SetFaderAlpha(1);

    if not self.LoadscreenClosed then
        XGUIEng.PushPage("/LoadScreen/LoadScreen", false);
    end
end

function Lib.CutsceneSystem.Local:DeactivateCinematicMode(_PlayerID)
    if not self.CinematicActive or GUI.GetPlayerID() ~= _PlayerID then
        return;
    end
    self.CinematicActive = false;

    g_Fade.To = 0;
    SetFaderAlpha(0);
    XGUIEng.PopPage();
    Camera.SwitchCameraBehaviour(0);
    Display.UseStandardSettings();
    Input.GameMode();
    GUI.EnableBattleSignals(true);
    GUI.SetFeedbackSoundOutputState(1);
    GUI.ActivateSelectionState();
    GUI.PermitContextSensitiveCommandsInSelectionState();
    for k, v in pairs(self.SelectionBackup) do
        GUI.SelectEntity(v);
    end
    Display.SetRenderSky(0);
    Display.SetRenderBorderPins(1);
    Display.SetRenderFogOfWar(1);
    if Options.GetIntValue("Display", "Occlusion", 0) > 0 then
        Display.SetUserOptionOcclusionEffect(1);
    end

    XGUIEng.PopPage();
    XGUIEng.PopPage();
    XGUIEng.PopPage();
    XGUIEng.PopPage();
    XGUIEng.PopPage();
    XGUIEng.ShowWidget("/InGame/ThroneRoom", 0);
    XGUIEng.ShowWidget("/InGame/ThroneRoomBars", 0);
    XGUIEng.ShowWidget("/InGame/ThroneRoomBars_2", 0);
    XGUIEng.ShowWidget("/InGame/ThroneRoomBars_Dodge", 0);
    XGUIEng.ShowWidget("/InGame/ThroneRoomBars_2_Dodge", 0);
    XGUIEng.SetText("/InGame/ThroneRoom/Main/MissionBriefing/Objectives", " ");

    Lib.UIEffects.Local:ResetFarClipPlane();
end

-- -------------------------------------------------------------------------- --

RegisterModule(Lib.CutsceneSystem.Name);
