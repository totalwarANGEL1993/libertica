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

Lib.Core.Text = {
    Languages = {
        {"de", "Deutsch", "en"},
        {"en", "English", "en"},
        {"fr", "Français", "en"},
    },

    Colors = {
        red     = "{@color:255,80,80,255}",
        blue    = "{@color:104,104,232,255}",
        yellow  = "{@color:255,255,80,255}",
        green   = "{@color:80,180,0,255}",
        white   = "{@color:255,255,255,255}",
        black   = "{@color:0,0,0,255}",
        grey    = "{@color:140,140,140,255}",
        azure   = "{@color:0,160,190,255}",
        orange  = "{@color:255,176,30,255}",
        amber   = "{@color:224,197,117,255}",
        violet  = "{@color:180,100,190,255}",
        pink    = "{@color:255,170,200,255}",
        scarlet = "{@color:190,0,0,255}",
        magenta = "{@color:190,0,89,255}",
        olive   = "{@color:74,120,0,255}",
        celeste = "{@color:145,170,210,255}",
        tooltip = "{@color:51,51,120,255}",
        lucid   = "{@color:0,0,0,0}",
        none    = "{@color:none}"
    },

    Placeholders = {
        Names = {},
        EntityTypes = {},
    },
}

Lib.Require("core/feature/Core_Report");
Lib.Register("core/feature/Core_Text");

CONST_LANGUAGE = "de";

-- -------------------------------------------------------------------------- --

function Lib.Core.Text:Initialize()
    Report.LanguageChanged = CreateReport("Event_LanguageChanged");
    self:DetectLanguage();
end

function Lib.Core.Text:OnSaveGameLoaded()
end

function Lib.Core.Text:OnReportReceived(_ID, ...)
end

-- -------------------------------------------------------------------------- --

function Lib.Core.Text:DetectLanguage()
    local DefaultLanguage = Network.GetDesiredLanguage();
    if DefaultLanguage ~= "de" and DefaultLanguage ~= "fr" then
        DefaultLanguage = "en";
    end
    CONST_LANGUAGE = DefaultLanguage;
end

function Lib.Core.Text:OnLanguageChanged(_PlayerID, _GUI_PlayerID, _Language)
    self:ChangeSystemLanguage(_PlayerID, _Language, _GUI_PlayerID);
end

function Lib.Core.Text:ChangeSystemLanguage(_PlayerID, _Language, _GUI_PlayerID)
    local OldLanguage = CONST_LANGUAGE;
    local NewLanguage = _Language;
    if _GUI_PlayerID == nil or _GUI_PlayerID == _PlayerID then
        CONST_LANGUAGE = _Language;
    end

    SendReport(Report.LanguageChanged, OldLanguage, NewLanguage);
    ExecuteLocal([[
        if GUI.GetPlayerID() == %d then
            SendReport(Report.LanguageChanged, "%s", "%s")
        end
    ]],_PlayerID, OldLanguage, NewLanguage);
end

function Lib.Core.Text:Localize(_Text)
    local LocalizedText = "ERROR_NO_TEXT";
    if type(_Text) == "table" then
        if _Text[CONST_LANGUAGE] then
            LocalizedText = _Text[CONST_LANGUAGE];
        else
            for k, v in pairs(self.Languages) do
                if v[1] == CONST_LANGUAGE and v[3] and _Text[v[3]] then
                    LocalizedText = _Text[v[3]];
                    break;
                end
            end
        end
    else
        LocalizedText = tostring(_Text);
    end
    return LocalizedText;
end

function Lib.Core.Text:ConvertPlaceholders(_Text)
    local s1, e1, s2, e2;
    assert(type(_Text) == "table", "Can only format strings.");
    while true do
        local Before, Placeholder, After, Replacement, s1, e1, s2, e2;
        if _Text:find("{n:") then
            Before, Placeholder, After, s1, e1, s2, e2 = self:SplicePlaceholderText(_Text, "{n:");
            Replacement = self.Placeholders.Names[Placeholder];
            _Text = Before .. self:Localize(Replacement or ("n:" ..tostring(Placeholder).. ": not found")) .. After;
        elseif _Text:find("{t:") then
            Before, Placeholder, After, s1, e1, s2, e2 = self:SplicePlaceholderText(_Text, "{t:");
            Replacement = self.Placeholders.EntityTypes[Placeholder];
            _Text = Before .. self:Localize(Replacement or ("n:" ..tostring(Placeholder).. ": not found")) .. After;
        elseif _Text:find("{v:") then
            Before, Placeholder, After, s1, e1, s2, e2 = self:SplicePlaceholderText(_Text, "{v:");
            Replacement = self:ReplaceValuePlaceholder(Placeholder);
            _Text = Before .. self:Localize(Replacement or ("v:" ..tostring(Placeholder).. ": not found")) .. After;
        end
        if s1 == nil or e1 == nil or s2 == nil or e2 == nil then
            break;
        end
    end
    _Text = self:ReplaceColorPlaceholders(_Text);
    return _Text;
end

function Lib.Core.Text:SplicePlaceholderText(_Text, _Start)
    local s1, e1      = _Text:find(_Start);
    local s2, e2      = _Text:find("}", e1);
    local Before      = _Text:sub(1, s1-1);
    local Placeholder = _Text:sub(e1+1, s2-1);
    local After       = _Text:sub(e2+1);
    return Before, Placeholder, After, s1, e1, s2, e2;
end

function Lib.Core.Text:ReplaceColorPlaceholders(_Text)
    for k, v in pairs(self.Colors) do
        _Text = _Text:gsub("{" ..k.. "}", v);
    end
    return _Text;
end

function Lib.Core.Text:ReplaceValuePlaceholder(_Text)
    local Ref = _G;
    local Slice = string.slice(_Text, "%.");
    for i= 1, #Slice do
        local KeyOrIndex = Slice[i];
        local Index = tonumber(KeyOrIndex);
        if Index ~= nil then
            KeyOrIndex = Index;
        end
        if not Ref[KeyOrIndex] then
            return nil;
        end
        Ref = Ref[KeyOrIndex];
    end
    return Ref;
end

-- -------------------------------------------------------------------------- --

--- Localizes the passed text or table. 
--- @param _Text any Text to localize
--- @return string Localized Localized text
function Localize(_Text)
    return Lib.Core.Text:Localize(_Text);
end

--- Replaces all placeholders inside the string with their respective values.
---
--- * {n:xyz} Replaces a scriptname with a predefined value
--- * {t:xyz} Replaces a type with a predefined value
--- * {v:xyz} Replaces a variable in _G with it's value.
--- * {color} Replaces the name of the color with it's color code.
--- 
--- Colors:
--- red, blue, yellow, green, white, black, grey, azure, orange, amber, violet,
--- pink, scarlet, magenta, olive, tooltip, none
---
--- @param _Text string Text to format
--- @return string Formatted Formatted text
function ConvertPlaceholders(_Text)
    return Lib.Core.Text:ConvertPlaceholders(_Text);
end

--- Prints a message into the debug text window.
--- @param _Text any Text as string or table
function AddNote(_Text)
    _Text = ConvertPlaceholders(Localize(_Text));
    if not GUI then
        Logic.DEBUG_AddNote(_Text);
        return;
    end
    GUI.AddNote(_Text);
end

--- Prints a message into the debug text window. The messages stays until it
--- is actively removed.
--- @param _Text any Text as string or table
function AddStaticNote(_Text)
    _Text = ConvertPlaceholders(Localize(_Text));
    if not GUI then
        ExecuteLocal([[GUI.AddStaticNote("%s")]], _Text);
        return;
    end
    GUI.AddStaticNote(_Text);
end

--- Prints a message into the message window.
--- @param _Text any Text as string or table
--- @param _Sound? string Sound to play
function AddMessage(_Text, _Sound)
    _Text = ConvertPlaceholders(Localize(_Text));
    if not GUI then
        ExecuteLocal([[AddMessage("%s", %s)]], _Text, _Sound);
        return;
    end
    _Text = ConvertPlaceholders(Localize(_Text));
    Message(_Text, (_Sound and _Sound:gsub("/", "\\")) or nil);
end

---Removes all text from the debug text window.
function ClearNotes()
    if not GUI then
        ExecuteLocal([[API.ClearNotes()]]);
        return;
    end
    GUI.ClearNotes();
end

