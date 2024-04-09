Lib.Require("comfort/IsLocalScript");
Lib.Register("module/ui/UIEffects_API");

--- Shows a black background behind the interface and over the game world.
--- @param _PlayerID integer ID of player
function ActivateColoredScreen(_PlayerID, _Red, _Green, _Blue, _Alpha)
    ActivateImageScreen(_PlayerID, "", _Red or 0, _Green or 0, _Blue or 0, _Alpha or 255);
end
API.ActivateColoredScreen = ActivateColoredScreen;

--- Hides the black screen.
--- @param _PlayerID integer ID of player
function DeactivateColoredScreen(_PlayerID)
    DeactivateImageScreen(_PlayerID);
end
API.DeactivateColoredScreen = DeactivateColoredScreen;

--- Shows a full screen graphic over the game world and below the interface.
---
--- The graphic must be supplied in 16:9 ratio. For 4:3 resolutions the graphic
--- is centered left and right to fit the format.
---
--- @param _PlayerID integer ID of player
--- @param _Image string     Path to graphic
--- @param _Red integer?     (Optional) Red value (default: 255)
--- @param _Green integer?   (Optional) Green value (default: 255)
--- @param _Blue integer?    (Optional) Blue value (default: 255)
--- @param _Alpha integer?   (Optional) Alpha value (default: 255)
function ActivateImageScreen(_PlayerID, _Image, _Red, _Green, _Blue, _Alpha)
    assert(_PlayerID and _PlayerID >= 1 and _PlayerID <= 8);
    if not IsLocalScript() then
        ExecuteLocal(
            [[Lib.UIEffects.Local:InterfaceActivateImageBackground(%d, "%s", %d, %d, %d, %d)]],
            _PlayerID,
            _Image,
            (_Red ~= nil and _Red) or 255,
            (_Green ~= nil and _Green) or 255,
            (_Blue ~= nil and _Blue) or 255,
            (_Alpha ~= nil and _Alpha) or 255
        );
        return;
    end
    Lib.UIEffects.Local:InterfaceActivateImageBackground(_PlayerID, _Image, _Red, _Green, _Blue, _Alpha);
end
API.ActivateImageScreen = ActivateImageScreen;

--- Hides the full screen picture.
--- @param _PlayerID integer ID of player
function DeactivateImageScreen(_PlayerID)
    assert(_PlayerID and _PlayerID >= 1 and _PlayerID <= 8);
    if not IsLocalScript() then
        ExecuteLocal(
            "Lib.UIEffects.Local:InterfaceDeactivateImageBackground(%d)",
            _PlayerID
        );
        return;
    end
    Lib.UIEffects.Local:InterfaceDeactivateImageBackground(_PlayerID);
end
API.DeactivateImageScreen = DeactivateImageScreen;

--- Shows the normal game interface.
--- @param _PlayerID integer ID of player
function ActivateNormalInterface(_PlayerID)
    assert(_PlayerID and _PlayerID >= 1 and _PlayerID <= 8);
    if not IsLocalScript() then
        ExecuteLocal(
            "Lib.UIEffects.Local:InterfaceActivateNormalInterface(%d)",
            _PlayerID
        );
        return;
    end
    Lib.UIEffects.Local:InterfaceActivateNormalInterface(_PlayerID);
end
API.ActivateNormalInterface = ActivateNormalInterface;

--- Hides the normal game interface.
--- @param _PlayerID integer ID of player
function DeactivateNormalInterface(_PlayerID)
    assert(_PlayerID and _PlayerID >= 1 and _PlayerID <= 8);
    if not IsLocalScript() then
        ExecuteLocal(
            "Lib.UIEffects.Local:InterfaceDeactivateNormalInterface(%d)",
            _PlayerID
        );
        return;
    end
    Lib.UIEffects.Local:InterfaceDeactivateNormalInterface(_PlayerID);
end
API.DeactivateNormalInterface = DeactivateNormalInterface;

--- Propagates the start of a cinema event.
--- @param _Name     string  Bezeichner
--- @param _PlayerID integer ID of player
function StartCinematicEvent(_Name, _PlayerID)
    assert(IsLocalScript() == false);
    assert(_PlayerID and _PlayerID >= 1 and _PlayerID <= 8);
    Lib.UIEffects.CinematicEvents[_PlayerID] = Lib.UIEffects.CinematicEvents[_PlayerID] or {};
    local ID = Lib.UIEffects.Global:ActivateCinematicEvent(_PlayerID);
    Lib.UIEffects.CinematicEvents[_PlayerID][_Name] = ID;
end
API.StartCinematicEvent = StartCinematicEvent;

--- Propagates the end of a cinema event.
--- @param _Name     string  Bezeichner
--- @param _PlayerID integer ID of player
function FinishCinematicEvent(_Name, _PlayerID)
    assert(IsLocalScript() == false);
    assert(_PlayerID and _PlayerID >= 1 and _PlayerID <= 8);
    Lib.UIEffects.CinematicEvents[_PlayerID] = Lib.UIEffects.CinematicEvents[_PlayerID] or {};
    if Lib.UIEffects.CinematicEvents[_PlayerID][_Name] then
        Lib.UIEffects.Global:ConcludeCinematicEvent(
            Lib.UIEffects.CinematicEvents[_PlayerID][_Name],
            _PlayerID
        );
    end
end
API.FinishCinematicEvent = FinishCinematicEvent;

---
-- Gibt den Zustand des Kinoevent zurück.
--
-- @param _Identifier            Bezeichner oder ID
-- @param[type=number] _PlayerID ID des Spielers
-- @return[type=number] Zustand des Kinoevent
-- @within Anwenderfunktionen
--
function GetCinematicEvent(_Identifier, _PlayerID)
    assert(_PlayerID and _PlayerID >= 1 and _PlayerID <= 8);
    Lib.UIEffects.CinematicEvents[_PlayerID] = Lib.UIEffects.CinematicEvents[_PlayerID] or {};
    if type(_Identifier) == "number" then
        if IsLocalScript() then
            return Lib.UIEffects.Local:GetCinematicEventStatus(_Identifier);
        end
        return Lib.UIEffects.Global:GetCinematicEventStatus(_Identifier);
    end
    if Lib.UIEffects.CinematicEvents[_PlayerID][_Identifier] then
        if IsLocalScript() then
            return Lib.UIEffects.Local:GetCinematicEventStatus(Lib.UIEffects.CinematicEvents[_PlayerID][_Identifier]);
        end
        return Lib.UIEffects.Global:GetCinematicEventStatus(Lib.UIEffects.CinematicEvents[_PlayerID][_Identifier]);
    end
    return CinematicEventState.NotTriggered;
end
API.GetCinematicEvent = GetCinematicEvent;

---
-- Prüft ob gerade ein Kinoevent für den Spieler aktiv ist.
--
-- @param[type=number] _PlayerID ID des Spielers
-- @return[type=boolean] Kinoevent ist aktiv
-- @within Anwenderfunktionen
--
function IsCinematicEventActive(_PlayerID)
    assert(_PlayerID and _PlayerID >= 1 and _PlayerID <= 8);
    Lib.UIEffects.CinematicEvents[_PlayerID] = Lib.UIEffects.CinematicEvents[_PlayerID] or {};
    for k, v in pairs(Lib.UIEffects.CinematicEvents[_PlayerID]) do
        if GetCinematicEvent(k, _PlayerID) == CinematicEventState.Active then
            return true;
        end
    end
    return false;
end
API.IsCinematicEventActive = IsCinematicEventActive;

--- Displays a text byte by byte.
---
--- If used at game start the text starts, after the map is loaded. If another
--- cinema event is running the typewriter waits for completion.
---
--- Controll symbols like {cr} are evaluated as one token and are handled as
--- an atomic token and are displayed immedaitly. More than 1 space in a row
--- is atomaticaly trunk to 1 space (by the game engine).
---
--- #### Fields of table
--- * Text         - Text to display
--- * Name         - (Optional) Name for event
--- * PlayerID     - (Optional) Player text is shown
--- * Callback     - (Optional) Callback function
--- * TargetEntity - (Optional) Entity camera is focused on
--- * CharSpeed    - (Optional) Factor of typing speed (default: 1.0)
--- * Waittime     - (Optional) Initial waittime before typing
--- * Opacity      - (Optional) Opacity of background (default: 1.0)
--- * Color        - (Optional) Background color (default: {R= 0, G= 0, B= 0})
--- * Image        - (Optional) Background image (needs to be 16:9 ratio)
---
--- #### Examples
--- ```lua
--- local EventName = StartTypewriter {
---     PlayerID = 1,
---     Text     = "Lorem ipsum dolor sit amet, consetetur "..
---                "sadipscing elitr, sed diam nonumy eirmod "..
---                "tempor invidunt ut labore et dolore magna "..
---                "aliquyam erat, sed diam voluptua.",
---     Callback = function(_Data)
---     end
--- };
--- ```
---
--- @param _Data table Data table
--- @return string? EventName Name of event
function StartTypewriter(_Data)
    if Framework.IsNetworkGame() ~= true then
        _Data.PlayerID = _Data.PlayerID or 1; -- Human Player
    end
    if _Data.PlayerID == nil or (_Data.PlayerID < 1 or _Data.PlayerID > 8) then
        return;
    end
    _Data.Text = Localize(_Data.Text or "");
    _Data.Callback = _Data.Callback or function() end;
    _Data.CharSpeed = _Data.CharSpeed or 1;
    _Data.Waittime = (_Data.Waittime or 8) * 10;
    _Data.TargetEntity = GetID(_Data.TargetEntity or 0);
    _Data.Image = _Data.Image or "";
    _Data.Color = _Data.Color or {
        R = (_Data.Image and _Data.Image ~= "" and 255) or 0,
        G = (_Data.Image and _Data.Image ~= "" and 255) or 0,
        B = (_Data.Image and _Data.Image ~= "" and 255) or 0,
        A = 255
    };
    if _Data.Opacity and _Data.Opacity >= 0 and _Data.Opacity then
        _Data.Color.A = math.floor((255 * _Data.Opacity) + 0.5);
    end
    _Data.Delay = 15;
    _Data.Index = 0;
    return Lib.UIEffects.Global:StartTypewriter(_Data);
end
API.StartTypewriter = StartTypewriter;

