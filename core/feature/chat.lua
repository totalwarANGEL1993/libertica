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
Lib.Require("core/feature/Report");
Lib.Register("core/feature/Chat");

LibertyCore.Chat = {
    DebugInput = {};
};

-- -------------------------------------------------------------------------- --

function LibertyCore.Chat:Initalize()
    Report.ChatOpened = CreateReport("Event_ChatOpened");
    Report.ChatClosed = CreateReport("Event_ChatClosed");
    for i= 1, 8 do
        self.DebugInput[i] = {};
    end
end

function LibertyCore.Chat:OnSaveGameLoaded()
end

-- -------------------------------------------------------------------------- --

function LibertyCore.Chat:ShowTextInput(_PlayerID, _AllowDebug)
    if Lib.IsHistoryEdition and Framework.IsNetworkGame() then
        return;
    end
    if not GUI then
        ExecuteLocal([[Swift.Chat:ShowTextInput(%d, %s)]], _PlayerID,tostring(_AllowDebug == true));
        return;
    end
    _PlayerID = _PlayerID or GUI.GetPlayerID();
    self:PrepareInputVariable(_PlayerID);
    self:ShowInputBox(_PlayerID, _AllowDebug == true);
end

function LibertyCore.Chat:ShowInputBox(_PlayerID, _Debug)
    if GUI.GetPlayerID() ~= _PlayerID then
        return;
    end
    self.DebugInput[_PlayerID] = _Debug == true;

    RequestJobByEventType(
        Events.LOGIC_EVENT_EVERY_TURN,
        function ()
            -- Open chat
            Input.ChatMode();
            XGUIEng.SetText("/InGame/Root/Normal/ChatInput/ChatInput", "");
            XGUIEng.ShowWidget("/InGame/Root/Normal/ChatInput", 1);
            XGUIEng.SetFocus("/InGame/Root/Normal/ChatInput/ChatInput");
            -- Send events
            SendReportToGlobal(Report.ChatOpened, _PlayerID);
            SendReport(Report.ChatOpened,_PlayerID);

            -- Slow down game time. We can not set the game time to 0 because
            -- then Logic.ExecuteInLuaLocalState and GUI.SendScriptCommand do
            -- not work anymore.
            if not Framework.IsNetworkGame() then
                Game.GameTimeSetFactor(GUI.GetPlayerID(), 0.0000001);
            end
            return true;
        end
    )
end

function LibertyCore.Chat:PrepareInputVariable(_PlayerID)
    if not IsLocalScript() then
        return;
    end

    GUI_Chat.Abort_Orig_Swift = GUI_Chat.Abort_Orig_Swift or GUI_Chat.Abort;
    GUI_Chat.Confirm_Orig_Swift = GUI_Chat.Confirm_Orig_Swift or GUI_Chat.Confirm;

    GUI_Chat.Confirm = function()
        XGUIEng.ShowWidget("/InGame/Root/Normal/ChatInput", 0);
        local ChatMessage = XGUIEng.GetText("/InGame/Root/Normal/ChatInput/ChatInput");
        local IsDebug = LibertyCore.Chat.DebugInput[_PlayerID];
        LibertyCore.Chat.ChatBoxInput = ChatMessage;
        LibertyCore.Chat:SendInputAsEvent(ChatMessage, IsDebug);
        g_Chat.JustClosed = 1;
        if not Framework.IsNetworkGame() then
            Game.GameTimeSetFactor(_PlayerID, 1);
        end
        Input.GameMode();
        if  ChatMessage:len() > 0
        and Framework.IsNetworkGame()
        and not IsDebug then
            GUI.SendChatMessage(
                ChatMessage,
                _PlayerID,
                g_Chat.CurrentMessageType,
                g_Chat.CurrentWhisperTarget
            );
        end
    end

    if not Framework.IsNetworkGame() then
        GUI_Chat.Abort = function()
        end
    end
end

function LibertyCore.Chat:SendInputAsEvent(_Text, _Debug)
    _Text = (_Text == nil and "") or _Text;
    local PlayerID = GUI.GetPlayerID();
    -- Send chat input to global script
    SendReportToGlobal(
        Report.ChatClosed,
        (_Text or "<<<ES>>>"),
        GUI.GetPlayerID(),
        _Debug == true
    );
    -- Send chat input to local script
    SendReport(
        Report.ChatClosed,
        (_Text or "<<<ES>>>"),
        GUI.GetPlayerID(),
        _Debug == true
    );
    -- Reset debug flag
    self.DebugInput[PlayerID] = false;
end

-- -------------------------------------------------------------------------- --

--- Open the chat console.
--- @param _PlayerID number    ID of player
--- @param _AllowDebug boolean Debug codes allowed
function ShowTextInput(_PlayerID, _AllowDebug)
    LibertyCore.Chat:ShowTextInput(_PlayerID, _AllowDebug);
end

