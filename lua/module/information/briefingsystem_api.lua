Lib.Require("comfort/IsLocalScript");
Lib.Register("module/information/BriefingSystem_API");

--- Starts a briefing.
---
--- <h4>Settings</h4>
---
--- Possible fields for the briefing table:
--- * `Starting`                - Function called when briefing is started              
--- * `Finished`                - Function called when briefing is finished             
--- * `RestoreCamera`           - Camera position is saved and restored at briefing end 
--- * `RestoreGameSpeed`        - Game speed is saved and restored at briefing end      
--- * `EnableGlobalImmortality` - During briefings all entities are invulnerable        
--- * `EnableSky`               - Display the sky during the briefing                   
--- * `EnableFoW`               - Displays the fog of war during the briefing           
--- * `EnableBorderPins`        - Displays the border pins during the briefing          
---
--- *-> Example #1*
---
--- <h4>Animations</h4>
--- The camera settings can be separated from the text of the page. Not only
--- allows this to fluetly write dialogs, also more possibilities are unlocked
--- when using the notation. Th create a animation the page musn't have a
--- position. Otherwise defaults will be used.
---
--- *-> Example #2*
---
--- *-> Example #3*
---
--- *-> Example #4*
---
--- <h4>Parallax</h4>
--- In the context of a video game parallaxes are scrollable backgrounds. This
--- technique was used by side scrollers. During a briefing page up to 4 layers
--- of graphics can be shown and animated. Parallaxes are notated similar to
--- camera animations. Scrolling is done by setting UV coordinates.
---
--- Graphics mus allways be in 16:9 format. If a player has a 4:3 resolution
--- the image is cropped left and right to fit the frame. Coordinates - as long
--- as provided as relative coordinates - will be adjusted.
---
--- *-> Example #5*
---
--- *-> Example #6*
---
--- <h4>Examples</h4>
---
--- * Example #1: Basic structure
--- ```lua
--- function Briefing1(_Name, _PlayerID)
---     local Briefing = {};
---     local AP, ASP = AddBriefingPages(Briefing);
---
---     -- Pages ...
---
---     Briefing.Starting = function(_Data)
---     end
---     Briefing.Finished = function(_Data)
---     end
---     StartBriefing(Briefing, _Name, _PlayerID);
--- end
--- ```
---
--- * Example #2: Notation for animations
--- ```lua
--- Briefing.PageAnimations = {
---     ["Page1"] = {
---         {30, "pos4", -60, 2000, 35, "pos4", -30, 2000, 25},
---     },
---     ["Page3"] = {
---         {30, {"pos2", 500}, {"pos4", 0}, {"pos7", 1000}, {"pos8", 0}},
---     },
--- };
--- ```
---
--- * Example #3: Replace animations
--- ```lua
--- Briefing.PageAnimations = {
---     ["Page1"] = {
---         Clear = true,
---         {30, "pos4", -60, 2000, 35, "pos4", -30, 2000, 25},
---     },
--- };
--- ```
---
--- * Example #4: Animation in Endlosschleife
--- ```lua
--- Briefing.PageAnimations = {
---     ["Page1"] = {
---         Repeat = true,
---         {30, "pos4",   0, 4000, 35, "pos4", 180, 4000, 35},
---         {30, "pos4", 180, 4000, 35, "pos4", 360, 4000, 35},
---     },
--- };
--- ```
---
--- * Example #5: Notation of paralaxes
--- ```lua
--- Briefing.PageParallax = {
---     ["Page1"] = {
---         {"maps/externalmap/mapname/graphics/Parallax6.png", 60,
---          0, 0, 0.8, 1, 255,
---          0.2, 0, 1, 1, 255},
---     },
---     ["Page3"] = {
---         {"maps/externalmap/mapname/graphics/Parallax1.png", 1,
---          0, 0, 1, 1, 180},
---     }
--- };
--- ```
---
--- * Example #6: Replace parallaxes
--- ```lua
--- Briefing.PageParallax = {
---     ["Page1"] = {
---         Clear = true,
---         {"maps/externalmap/mapname/graphics/Parallax6.png",
---          60, 0, 0, 0.8, 1, 255, 0.2, 0, 1, 1, 255},
---     },
--- };
--- ```
---
--- @param _Briefing table   Briefing table
--- @param _Name string      Name of briefing
--- @param _PlayerID integer Player ID of receiver
function StartBriefing(_Briefing, _Name, _PlayerID)
    if GUI then
        return;
    end
    local PlayerID = _PlayerID;
    if not PlayerID and not Framework.IsNetworkGame() then
        PlayerID = 1; -- Human Player
    end
    assert(_Name ~= nil);
    assert(_PlayerID ~= nil);
    assert(type(_Briefing) == "table", "Briefing must be a table!");
    assert(#_Briefing > 0, "Briefing does not contain pages!");
    for i=1, #_Briefing do
        assert(
            type(_Briefing[i]) ~= "table" or _Briefing[i].__Legit,
            "A page is not initalized!"
        );
    end
    if _Briefing.EnableSky == nil then
        _Briefing.EnableSky = true;
    end
    if _Briefing.EnableFoW == nil then
        _Briefing.EnableFoW = false;
    end
    if _Briefing.EnableGlobalImmortality == nil then
        _Briefing.EnableGlobalImmortality = true;
    end
    if _Briefing.EnableBorderPins == nil then
        _Briefing.EnableBorderPins = false;
    end
    if _Briefing.RestoreGameSpeed == nil then
        _Briefing.RestoreGameSpeed = true;
    end
    if _Briefing.RestoreCamera == nil then
        _Briefing.RestoreCamera = true;
    end
    Lib.BriefingSystem.Global:StartBriefing(_Name, PlayerID, _Briefing);
end

--- Checks if a briefing ist active.
--- @param _PlayerID integer PlayerID of receiver
--- @return boolean IsActive Briefing is active
function IsBriefingActive(_PlayerID)
    if not IsLocalScript() then
        return Lib.BriefingSystem.Global:GetCurrentBriefing(_PlayerID) ~= nil;
    end
    return Lib.BriefingSystem.Local:GetCurrentBriefing(_PlayerID) ~= nil;
end

--- Prepares the briefing and returns the page functions.
---
--- Must be called before pages are added.
--- @param _Briefing table Briefing table
--- @return function AP  Page function
--- @return function ASP Short page function
function AddBriefingPages(_Briefing)
    Lib.BriefingSystem.Global:CreateBriefingGetPage(_Briefing);
    Lib.BriefingSystem.Global:CreateBriefingAddPage(_Briefing);
    Lib.BriefingSystem.Global:CreateBriefingAddMCPage(_Briefing);
    Lib.BriefingSystem.Global:CreateBriefingAddRedirect(_Briefing);

    local AP = function(_Page)
        local Page;
        if type(_Page) == "table" then
            if _Page.MC then
                Page = _Briefing:AddMCPage(_Page);
            else
                Page = _Briefing:AddPage(_Page);
            end
        else
            Page = _Briefing:AddRedirect(_Page);
        end
        return Page;
    end

    local ASP = function(...)
        _Briefing.PageAnimations = _Briefing.PageAnimations or {};

        local Name, Title,Text, Position;
        local DialogCam = false;
        local Action = function() end;
        local NoSkipping = false;

        -- Set page parameters
        if (#arg == 3 and type(arg[1]) == "string")
        or (#arg >= 4 and type(arg[4]) == "boolean") then
            Name = table.remove(arg, 1);
        end
        Title = table.remove(arg, 1);
        Text = table.remove(arg, 1);
        if #arg > 0 then
            DialogCam = table.remove(arg, 1) == true;
        end
        if #arg > 0 then
            Position = table.remove(arg, 1);
        end
        if #arg > 0 then
            Action = table.remove(arg, 1);
        end
        if #arg > 0 then
            NoSkipping = not table.remove(arg, 1);
        end

        -- Calculate camera rotation
        local Rotation;
        if Position then
            Rotation = CONST_BRIEFING.CAMERA_ROTATIONDEFAULT;
            if Position and Logic.IsSettler(GetID(Position)) == 1 then
                Rotation = Logic.GetEntityOrientation(GetID(Position)) + 90;
            end
        end

        -- Create page
        return _Briefing:AddPage {
            Name            = Name,
            Title           = Title,
            Text            = Text,
            Action          = Action,
            Position        = Position,
            DisableSkipping = NoSkipping,
            DialogCamera    = DialogCam,
            Rotation        = Rotation,
        };
    end

    return AP, ASP;
end

--- Creates a page.
---
--- <h4>Briefing Page</h4>
--- Possible fields for the page:
---
--- * `Title`           - Displayed page title
--- * `Text`            - Displayed page text
--- * `Position`        - Script name of position
--- * `Duration`        - Time until automatic skip
--- * `DialogCamera`    - Use closeup camera
--- * `DisableSkipping` - Allow/forbid skipping pages
--- * `Action`          - Function called when page is displayed
--- * `FarClipPlane`    - Render distance
--- * `Rotation`        - Camera rotation
--- * `Zoom`            - Camera zoom
--- * `Angle`           - Camera angle
--- * `FadeIn`          - Duration of fadein from black
--- * `FadeOut`         - Duration of fadeout to black
--- * `FaderAlpha`      - Mask alpha
--- * `BarOpacity`      - Opacity of bars
--- * `BigBars`         - Use big bars
--- * `FlyTo`           - Table with second set of camera configuration were camera flys to
--- * `MC`              - Table with choices to branch of in dialogs
---
--- *-> Example #1*
---
--- <h4>Flow control</h4>
--- In a briefing the player can be forced to make a choice that will have
--- different results. That is called multiple choice. Options must be provided
--- in a table. The target page can be defined with it's name or a function can
--- be provided for more control over the flow. Such funktions must return a
--- page name.
---
--- *-> Example #2*
---
--- Additionally each funktion can be marked to be removed when used
--- and not shown again when reentering the page.
---
--- *-> Example #3*
---
--- Also pages can be hidden by providing a function to check conditions.
---
--- *-> Example #4*
---
--- If a briefing is branched it must be manually ended after a branch is done
--- or it just simply shows the next page. To end a briefing, an empty page
--- must be added.
---
--- *-> Example #5*
---
--- Alternativly the briefing can continue at a different page. This allows to
--- create repeating structures within a briefing.
---
--- *-> Example #6*
---
--- To obtain selected answers at a later point the selection can be saved in a
--- global variable either in a option callback or in the finished function. The
--- number returned is the ID of the answer.
---
--- *-> Example #7*
---
--- <h4>Examples</h4>
---
--- * Example #1: A simple page
--- ```lua
--- AP {
---    Title        = "Marcus",
---    Text         = "This is a simple page.",
---    Position     = "Marcus",
---    Rotation     = 30,
---    DialogCamera = true,
--- };
--- ```
---
--- * Example #2: Usage of multiple choices
--- ```lua
--- AP {
---    Title        = "Marcus",
---    Text         = "That is a not so simple page.",
---    Position     = "Marcus",
---    Rotation     = 30,
---    DialogCamera = true,
---    MC = {
---        {"Option 1", "TargetPage"},
---        {"Option 2", Option2Clicked},
---    },
--- };
--- ```
---
--- * Example #3: One time usage option
--- ```lua
--- MC = {
---     ...
---     {"Option 3", "AnotherPage", Remove = true},
--- }
--- ```
---
--- * Example #4: Option with condition
--- ```lua
--- MC = {
---     ...
---     {"Option 3", "AnotherPage", Disable = OptionIsDisabled},
--- }
--- ```
---
--- * Example #5: Abort briefing
--- ```lua
--- AP()
--- ```
---
--- * Example #6: Jump to other page
--- ```lua
--- AP("SomePageName")
--- ```
---
--- * Example #7: Get selected option
--- ```lua
--- Briefing.Finished = function(_Data)
---     MyChoosenOption = _Data:GetPage("Choice"):GetSelected();
--- end
--- ```
---
--- @param _Data table Page data
function AP(_Data)
    assert(false);
end

--- Creates a page in a simplified manner.
---
--- The function can create a automatic page name based of the page index. A
--- name can be an optional parameter at the start.
---
--- <h4>Settings</h4>
--- The function expects the following parameters:
--- 
--- * `Name`           - (Optional) Name of page
--- * `Title`          - Displayed page title
--- * `Text`           - Displayed page text
--- * `DialogCamera`   - Use closeup camera
--- * `Position`       - (Optional) Scriptname of focused entity
--- * `Action`         - (Optional) Action when page is shown
--- * `EnableSkipping` - (Optional) Allow/Forbid skipping page
---
--- <h4>Examples</h4>
---
--- ```lua
--- -- Long shot
--- ASP("Title", "Some important text.", false, "HQ");
--- -- Page Name
--- ASP("Page1", "Title", "Some important text.", false, "HQ");
--- -- Close-Up
--- ASP("Title", "Some important text.", true, "Marcus");
--- -- Call action
--- ASP("Title", "Some important text.", true, "Marcus", MyFunction);
--- -- Allow/forbid skipping
--- ASP("Title", "Some important text.", true, "HQ", nil, true);
--- ```
---
--- @param ... any List of page parameters
function ASP(...)
    assert(false);
end

