--- 
Lib.ScourgeSystem = {
    Name = "ScourgeSystem",

    Global = {
        AnimalPlague = {},
        Plague = {}
    },
    Local  = {
        AnimalPlague = {},
        Plague = {}
    },
};

Lib.Require("core/Core");
Lib.Require("module/uitools/UITools");
Lib.Require("module/entity/ScourgeSystem_API");
Lib.Register("module/entity/ScourgeSystem");

-- -------------------------------------------------------------------------- --
-- Global

-- Global initalizer method
function Lib.ScourgeSystem.Global:Initialize()
    if not self.IsInstalled then
        Report.FireAlarmDeactivated = CreateReport("Event_FireAlarmDeactivated");
        Report.FireAlarmActivated = CreateReport("Event_FireAlarmActivated");
        Report.RepairAlarmDeactivated = CreateReport("Event_RepairAlarmFeactivated");
        Report.RepairAlarmActivated = CreateReport("Event_RepairAlarmActivated");

        for i= 1,8 do
            self.AnimalPlague[i] = {};
            self.Plague[i] = {
                SuspendedSettlers = {},
            };
        end

        -- Garbage collection
        Lib.ScourgeSystem.Local = nil;
    end
    self.IsInstalled = true;
end

-- Global load game
function Lib.ScourgeSystem.Global:OnSaveGameLoaded()
    self:RestoreSettlerSuspension();
end

-- Global report listener
function Lib.ScourgeSystem.Global:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    elseif _ID == Report.FireAlarmDeactivated then
        self:RestoreSettlerSuspension();
    elseif _ID == Report.FireAlarmActivated then
        self:RestoreSettlerSuspension();
    elseif _ID == Report.RepairAlarmDeactivated then
        self:RestoreSettlerSuspension();
    elseif _ID == Report.RepairAlarmActivated then
        self:RestoreSettlerSuspension();
    end
end

-- Resumes a settler.
function Lib.ScourgeSystem.Global:ResumeSettler(_Entity)
    local EntityID = GetID(_Entity);
    local PlayerID = Logic.EntityGetPlayer(EntityID);
    local StoreHouseID = Logic.GetStoreHouse(PlayerID);
    if StoreHouseID ~= 0 then
        Logic.SetTaskList(EntityID, TaskLists.TL_WAIT_THEN_WALK);
        Logic.SetVisible(EntityID, true);
        if self.Plague[PlayerID].SuspendedSettlers[EntityID] then
            ExecuteLocal("Lib.ScourgeSystem.Local.Plague[%d].SuspendedSettlers[%d] = nil", PlayerID, EntityID);
            self.Plague[PlayerID].SuspendedSettlers[EntityID] = nil;
        end
    end
end

-- Suspend a settler.
function Lib.ScourgeSystem.Global:SuspendSettler(_Entity)
    local EntityID = GetID(_Entity);
    local PlayerID = Logic.EntityGetPlayer(EntityID);
    local StoreHouseID = Logic.GetStoreHouse(PlayerID);
    if StoreHouseID ~= 0 then
        local x,y,z = Logic.EntityGetPos(StoreHouseID);
        Logic.DEBUG_SetSettlerPosition(EntityID, x, y);
        Logic.SetVisible(EntityID, false);
        Logic.SetTaskList(EntityID, TaskLists.TL_NPC_IDLE);
        ExecuteLocal("Lib.ScourgeSystem.Local.Plague[%d].SuspendedSettlers[%d] = true", PlayerID, EntityID);
        self.Plague[PlayerID].SuspendedSettlers[EntityID] = true;
    end
end

-- Restores tasklist and position of fake dead settlers.
function Lib.ScourgeSystem.Global:RestoreSettlerSuspension()
    for PlayerID = 1, 8 do
        for k,v in pairs(self.Plague[PlayerID].SuspendedSettlers) do
            if not IsExisting(k) then
                ExecuteLocal("Lib.ScourgeSystem.Local.Plague[%d].SuspendedSettlers[%d] = nil", PlayerID, k);
                self.Plague[PlayerID].SuspendedSettlers[k] = nil;
            else
                self:SuspendSettler(k);
            end
        end
    end
end

-- -------------------------------------------------------------------------- --
-- Local

-- Local initalizer method
function Lib.ScourgeSystem.Local:Initialize()
    if not self.IsInstalled then
        Report.FireAlarmDeactivated = CreateReport("Event_FireAlarmDeactivated");
        Report.FireAlarmActivated = CreateReport("Event_FireAlarmActivated");
        Report.RepairAlarmDeactivated = CreateReport("Event_RepairAlarmFeactivated");
        Report.RepairAlarmActivated = CreateReport("Event_RepairAlarmActivated");

        self:OverwriteAlarmButtons();
        self:OverwriteOnBuildingBurning();
        self:OverwriteJumpToWorker();

        for i= 1,8 do
            self.AnimalPlague[i] = {};
            self.Plague[i] = {
                SuspendedSettlers = {},
            };
        end

        -- Garbage collection
        Lib.ScourgeSystem.Global = nil;
    end
    self.IsInstalled = true;
end

-- Local load game
function Lib.ScourgeSystem.Local:OnSaveGameLoaded()
end

-- Local report listener
function Lib.ScourgeSystem.Local:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    end
end

function Lib.ScourgeSystem.Local:OverwriteJumpToWorker()
    GUI_BuildingInfo.JumpToWorkerClicked = function()
        Sound.FXPlay2DSound( "ui\\menu_click");
        local PlayerID = GUI.GetPlayerID();
        local SelectedEntityID = GUI.GetSelectedEntity();
        local InhabitantsBuildingID = 0;
        local IsSettlerSelected;
        if Logic.IsBuilding(SelectedEntityID) == 1 then
            InhabitantsBuildingID = SelectedEntityID;
            IsSettlerSelected = false;
        else
            if Logic.IsWorker(SelectedEntityID) == 1
            or Logic.IsSpouse(SelectedEntityID) == true
            or Logic.GetEntityType(SelectedEntityID) == Entities.U_Priest then
                InhabitantsBuildingID = Logic.GetSettlersWorkBuilding(SelectedEntityID);
                IsSettlerSelected = true;
            end
        end
        if InhabitantsBuildingID ~= 0 then
            local WorkersAndSpousesInBuilding = {Logic.GetWorkersAndSpousesForBuilding(InhabitantsBuildingID)}

            -- To pretend settlers of the building have died, we need to remove
            -- them from the intabitants list.
            for i = #WorkersAndSpousesInBuilding, 1, -1 do
                local SettlerID = WorkersAndSpousesInBuilding[i];
                if Lib.ScourgeSystem.Local.Plague[PlayerID] then
                    if Lib.ScourgeSystem.Local.Plague[PlayerID].SuspendedSettlers[SettlerID] then
                        table.remove(WorkersAndSpousesInBuilding, i);
                    end
                end
            end

            local InhabitantID
            if g_CloseUpView.Active == false and IsSettlerSelected == true then
                InhabitantID = SelectedEntityID;
            else
                local InhabitantPosition = 1;
                for i = 1, #WorkersAndSpousesInBuilding do
                    if WorkersAndSpousesInBuilding[i] == g_LastSelectedInhabitant then
                        InhabitantPosition = i + 1;
                        break;
                    end
                end
                InhabitantID = WorkersAndSpousesInBuilding[InhabitantPosition];
                if InhabitantID == 0 then
                    InhabitantID = WorkersAndSpousesInBuilding[InhabitantPosition + 1];
                end
            end
            if InhabitantID == nil then
                local x,y = Logic.GetEntityPosition(InhabitantsBuildingID);
                g_LastSelectedInhabitant = nil;
                ShowCloseUpView(0, x, y);
                GUI.SetSelectedEntity(InhabitantsBuildingID);
            else
                GUI.SetSelectedEntity(InhabitantID);
                ShowCloseUpView(InhabitantID);
                g_LastSelectedInhabitant = InhabitantID;
            end
        end
    end
end

function Lib.ScourgeSystem.Local:OverwriteOnBuildingBurning()
    GameCallback_Feedback_OnBuildingBurning_Orig_ScourgeSystem = GameCallback_Feedback_OnBuildingBurning;
    GameCallback_Feedback_OnBuildingBurning = function(_PlayerID, _EntityID)
        GameCallback_Feedback_OnBuildingBurning_Orig_ScourgeSystem(_PlayerID, _EntityID);
        SendReportToGlobal(Report.FireAlarmActivated, _EntityID);
    end
end

function Lib.ScourgeSystem.Local:OverwriteAlarmButtons()
    GUI_BuildingButtons.StartStopFireAlarmClicked_Orig_ScourgeSystem = GUI_BuildingButtons.StartStopFireAlarmClicked;
    GUI_BuildingButtons.StartStopFireAlarmClicked = function()
        GUI_BuildingButtons.StartStopFireAlarmClicked_Orig_ScourgeSystem();
        local EntityID = GUI.GetSelectedEntity()
        if Logic.IsFireAlarmActiveAtBuilding(EntityID) == true then
            SendReportToGlobal(Report.FireAlarmActivated, EntityID);
        else
            SendReportToGlobal(Report.FireAlarmDeactivated, EntityID);
        end
    end

    GUI_BuildingButtons.StartStopRepairAlarmClicked_Orig_ScourgeSystem = GUI_BuildingButtons.StartStopRepairAlarmClicked;
    GUI_BuildingButtons.StartStopRepairAlarmClicked = function()
        GUI_BuildingButtons.StartStopRepairAlarmClicked_Orig_ScourgeSystem();
        local EntityID = GUI.GetSelectedEntity()
        if Logic.IsRepairAlarmActiveAtBuilding(EntityID) == true then
            SendReportToGlobal(Report.RepairAlarmActivated, EntityID);
        else
            SendReportToGlobal(Report.RepairAlarmDeactivated, EntityID);
        end
    end
end

-- -------------------------------------------------------------------------- --

RegisterModule(Lib.ScourgeSystem.Name);

