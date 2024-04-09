Lib.Require("comfort/IsMultiplayer");
Lib.Require("comfort/IsLocalScript");
Lib.Register("module/information/Requester_API");

--- opens a large text window with the provided text.
--- @param _Caption string Window title
--- @param _Content string Window content
--- @param _PlayerID integer ID of Receiver
---
--- #### Usage
---
--- ```lua
--- local Text = "Lorem ipsum dolor sit amet, consetetur".."..
---              " sadipscing elitr, sed diam nonumy eirmod"..
---              " tempor invidunt ut labore et dolore magna"..
---              " magna aliquyam erat, sed diam voluptua.";
--- TextWindow("Lorem ipsum", Text);
--- ```
function TextWindow(_Caption, _Content, _PlayerID)
    _PlayerID = _PlayerID or 1;
    _Caption = Localize(_Caption);
    _Content = Localize(_Content);
    if not GUI then
        ExecuteLocal(
            [[API.TextWindow("%s", "%s", %d)]],
            _Caption,
            _Content,
            _PlayerID
        );
        return;
    end
    Lib.Requester.Local:ShowTextWindow {
        PlayerID = _PlayerID,
        Caption  = _Caption,
        Content  = _Content,
    };
end
API.TextWindow = TextWindow;

--- Opens a simple dialog.
--- @param _PlayerID integer (Optional) ID of receiver
--- @param _Title any Title of window
--- @param _Text any Text of window
--- @param _Action function Action function
---
--- #### Usage
---
--- ```lua
--- DialogInfoBox("Information", "This is important!");
--- ```
function DialogInfoBox(_PlayerID, _Title, _Text, _Action)
    assert(IsLocalScript(), "Can not be used in global script.");
    if type(_PlayerID) ~= "number" then
        _Action = _Text;
        _Text = _Title;
        _Title = _PlayerID;
        _PlayerID = GUI.GetPlayerID();
    end
    if type(_Title) == "table" then
        _Title = Localize(_Title);
    end
    if type(_Text) == "table" then
        _Text  = Localize(_Text);
    end
    Lib.Requester.Local:OpenDialog(_PlayerID, _Title, _Text, _Action);
end
API.DialogInfoBox = DialogInfoBox;

--- Opens a dialog with a yes/no option.
--- @param _PlayerID integer (Optional) ID of receiver
--- @param _Title any Title of window
--- @param _Text any Text of window
--- @param _Action function Action function
--- @param _OkCancel boolean Use Okay/Cancel for buttons
---
--- #### Usage
---
--- ```lua
--- function YesNoAction(_Yes, _PlayerID)
---     if _Yes then
---         GUI.AddNote("'Yes' has been clicked!");
---     end
--- end
--- DialogRequestBox("Question", "Do you really want to do this?", YesNoAction, false);
--- ```
function DialogRequestBox(_PlayerID, _Title, _Text, _Action, _OkCancel)
    assert(IsLocalScript(), "Can not be used in global script.");
    if type(_PlayerID) ~= "number" then
        --- @diagnostic disable-next-line: cast-local-type
        _OkCancel = _Action;
        _Action = _Text;
        _Text = _Title;
        _Title = _PlayerID;
        _PlayerID = GUI.GetPlayerID();
    end
    if type(_Title) == "table" then
        _Title = Localize(_Title);
    end
    if type(_Text) == "table" then
        _Text  = Localize(_Text);
    end
    Lib.Requester.Local:OpenRequesterDialog(_PlayerID, _Title, _Text, _Action, _OkCancel);
end
API.DialogRequestBox = DialogRequestBox;

--- Opens a dialog with a option box.
--- @param _PlayerID integer (Optional) ID of receiver
--- @param _Title any Title of window
--- @param _Text any Text of window
--- @param _Action function Action function
--- @param _List table List of options
---
--- #### Usage
---
--- ```lua
--- function OptionsAction(_Idx, _PlayerID)
---     GUI.AddNote(_Idx.. " was chosen!");
--- end
--- local List = {"Option A", "Option B", "Option C"};
--- DialogSelectBox("Selection", "Choose an option!", OptionsAction, List);
--- ```
function DialogSelectBox(_PlayerID, _Title, _Text, _Action, _List)
    assert(IsLocalScript(), "Can not be used in global script.");
    if type(_PlayerID) ~= "number" then
        --- @diagnostic disable-next-line: cast-local-type
        _List = _Action;
        _Action = _Text;
        _Text = _Title;
        _Title = _PlayerID;
        _PlayerID = GUI.GetPlayerID();
    end
    if type(_Title) == "table" then
        _Title = Localize(_Title);
    end
    if type(_Text) == "table" then
        _Text  = Localize(_Text);
    end
    _Text = _Text .. "{cr}";
    Lib.Requester.Local:OpenSelectionDialog(_PlayerID, _Title, _Text, _Action, _List);
end
API.DialogSelectBox = DialogSelectBox;

--- Displays the language selection for a player.
--- @param _PlayerID integer ID pf receiver
function DialogLanguageSelection(_PlayerID)
    _PlayerID = _PlayerID or 0
    if not GUI then
        ExecuteLocal([[DialogLanguageSelection(%d)]], _PlayerID);
        return;
    end

    local ReceiverID = _PlayerID;
    local PlayerID = GUI.GetPlayerID();
    local IsGuiPlayer = ReceiverID == 0 or ReceiverID == PlayerID;
    if ReceiverID ~= 0 and GUI.GetPlayerID() ~= ReceiverID then
        return;
    end

    local DisplayedList = {};
    for i= 1, #Lib.Core.Text.Languages do
        table.insert(DisplayedList, Lib.Core.Text.Languages[i][2]);
    end
    local Action = function(_Selected)
        SendReportToGlobal(Report.LanguageSelectionClosed, PlayerID, IsGuiPlayer, Lib.Core.Text.Languages[_Selected][1]);
        SendReport(Report.LanguageSelectionClosed, PlayerID, IsGuiPlayer, Lib.Core.Text.Languages[_Selected][1]);
    end
    DialogSelectBox(
        PlayerID,
        Localize(Lib.Requester.Shared.Text.ChooseLanguage.Title),
        Localize(Lib.Requester.Shared.Text.ChooseLanguage.Text),
        Action,
        DisplayedList
    );
end
API.DialogLanguageSelection = DialogLanguageSelection;

