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

Lib.Core.Job = {
    EventJobMappingID = 0;
    EventJobMapping = {},
    EventJobs = {},

    SecondsSinceGameStart = 0;
    LastTimeStamp = 0;
}

Lib.Register("core/feature/Job");

-- -------------------------------------------------------------------------- --

function Lib.Core.Job:Initialize()
    self:StartJobs();
end

function Lib.Core.Job:OnSaveGameLoaded()
end

-- -------------------------------------------------------------------------- --

function Lib.Core.Job:StartJobs()
    -- Update Real time variable
    self:CreateEventJob(
        Events.LOGIC_EVENT_EVERY_TURN,
        function()
            Lib.Core.Job:RealtimeController();
        end
    )
end

function Lib.Core.Job:CreateEventJob(_Type, _Function, ...)
    self.EventJobMappingID = self.EventJobMappingID +1;
    local ID = Trigger.RequestTrigger(
        _Type,
        "",
        "LibertyCore_Job_EventJobExecutor",
        1,
        {},
        {self.EventJobMappingID}
    );
    self.EventJobs[ID] = {ID, true, _Function, arg};
    self.EventJobMapping[self.EventJobMappingID] = ID;
    return ID;
end

function Lib.Core.Job:EventJobExecutor(_MappingID)
    local ID = self.EventJobMapping[_MappingID];
    if ID and self.EventJobs[ID] and self.EventJobs[ID][2] then
        local Parameter = self.EventJobs[ID][4];
        if self.EventJobs[ID][3](unpack(Parameter)) then
            self.EventJobs[ID][2] = false;
        end
    end
end

function Lib.Core.Job:RealtimeController()
    if not self.LastTimeStamp then
        self.LastTimeStamp = math.floor(Framework.TimeGetTime());
    end
    local CurrentTimeStamp = math.floor(Framework.TimeGetTime());

    if self.LastTimeStamp ~= CurrentTimeStamp then
        self.LastTimeStamp = CurrentTimeStamp;
        self.SecondsSinceGameStart = self.SecondsSinceGameStart +1;
    end
end

-- -------------------------------------------------------------------------- --

function LibertyCore_Job_EventJobExecutor(_MappingID)
    Lib.Core.Job:EventJobExecutor(_MappingID);
end

-- -------------------------------------------------------------------------- --

--- Requests a job of the passed event type.
--- @param _EventType integer Type of job
--- @param _Function any Function reference or name
--- @param ... unknown Parameter
--- @return integer ID ID of job
function RequestJobByEventType(_EventType, _Function, ...)
    local Function = _G[_Function] or _Function;
    assert(type(Function) == "function", "Function does not exist!");
    return Lib.Core.Job:CreateEventJob(_EventType, _Function, unpack(arg));
end

--- Requests a job that triggers each second.
--- @param _Function any Function reference or name
--- @param ... unknown Parameter
--- @return integer ID ID of job
function RequestJob(_Function, ...)
    local Function = _G[_Function] or _Function;
    assert(type(Function) == "function", "Function does not exist!");
    return RequestJobByEventType(Events.LOGIC_EVENT_EVERY_SECOND, Function, unpack(arg));
end
StartSimpleJob = RequestJob;
StartSimpleJobEx = RequestJob;

--- Requests a job that triggers each turn.
--- @param _Function any Function reference or name
--- @param ... unknown Parameter
--- @return integer ID ID of job
function RequestHiResJob(_Function, ...)
    local Function = _G[_Function] or _Function;
    assert(type(Function) == "function", "Function does not exist!");
    return RequestJobByEventType(Events.LOGIC_EVENT_EVERY_TURN, Function, unpack(arg));
end
StartSimpleHiResJob = RequestHiResJob;
StartSimpleHiResJobEx = RequestHiResJob;

--- Requests a delayed action delayed by seconds.
--- @param _Waittime integer Seconds
--- @param _Function any Function reference or name
--- @param ... unknown Parameter
--- @return integer ID ID of job
function RequestDelay(_Waittime, _Function, ...)
    local Function = _G[_Function] or _Function;
    assert(type(Function) == "function", "Function does not exist!");
    return RequestJob(
        function(_StartTime, _Delay, _Callback, _Arguments)
            if _StartTime + _Delay <= Logic.GetTime() then
                _Callback(unpack(_Arguments or {}));
                return true;
            end
        end,
        Logic.GetTime(),
        _Waittime,
        _Function,
        {...}
    );
end

--- Requests a delayed action delayed by turns
--- @param _Waittime integer Turns
--- @param _Function any Function reference or name
--- @param ... unknown Parameter
--- @return integer ID ID of job
function RequestHiResDelay(_Waittime, _Function, ...)
    local Function = _G[_Function] or _Function;
    assert(type(Function) == "function", "Function does not exist!");
    return RequestHiResJob(
        function(_StartTime, _Delay, _Callback, _Arguments)
            if _StartTime + _Delay <= Logic.GetCurrentTurn() then
                _Callback(unpack(_Arguments or {}));
                return true;
            end
        end,
        Logic.GetTime(),
        _Waittime,
        _Function,
        {...}
    );
end

--- Requests a delayed action delayed by realtime seconds.
--- @param _Waittime integer Seconds
--- @param _Function any Function reference or name
--- @param ... unknown Parameter
--- @return integer ID ID of job
function RequestRealTimeDelay(_Waittime, _Function, ...)
    local Function = _G[_Function] or _Function;
    assert(type(Function) == "function", "Function does not exist!");
    return RequestHiResJob(
        function(_StartTime, _Delay, _Callback, _Arguments)
            if (Lib.Core.Job.SecondsSinceGameStart >= _StartTime + _Delay) then
                _Callback(unpack(_Arguments or {}));
                return true;
            end
        end,
        Lib.Core.Job.SecondsSinceGameStart,
        _Waittime,
        _Function,
        {...}
    );
end

--- Ends a job. The job can not be reactivated.
--- @param _JobID integer ID of job
function StopJob(_JobID)
    if Lib.Core.Job.EventJobs[_JobID] then
        Trigger.UnrequestTrigger(Lib.Core.Job.EventJobs[_JobID][1]);
        Lib.Core.Job.EventJobs[_JobID] = nil;
        return;
    end
    EndJob(_JobID);
end

--- Returns if the job is running.
--- @param _JobID integer ID of job
--- @return boolean Running Job is runnung
function IsJobRunning(_JobID)
    if Lib.Core.Job.EventJobs[_JobID] then
        return Lib.Core.Job.EventJobs[_JobID][2] == true;
    end
    return JobIsRunning(_JobID);
end

--- Resumes a paused job.
--- @param _JobID integer ID of job
function ResumeJob(_JobID)
    if Lib.Core.Job.EventJobs[_JobID] then
        if Lib.Core.Job.EventJobs[_JobID][2] ~= true then
            Lib.Core.Job.EventJobs[_JobID][2] = true;
        end
        return;
    end
    assert(false, "Failed to resume job.");
end

--- Pauses a runnung job.
--- @param _JobID integer ID of job
function YieldJob(_JobID)
    if Lib.Core.Job.EventJobs[_JobID] then
        if Lib.Core.Job.EventJobs[_JobID][2] == true then
            Lib.Core.Job.EventJobs[_JobID][2] = false;
        end
        return;
    end
    assert(false, "Failed to yield job.");
end

--- Returns the real time seconds passed since game start.
--- @return integer Seconds Amount of seconds
function GetSecondsRealTime()
    return Lib.Core.Job.SecondsSinceGameStart;
end

