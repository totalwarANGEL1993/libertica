Lib.Require("comfort/IsLocalScript");
Lib.Register("module/information/CutsceneSystem_API");

--- Starts a cutscene.
---
--- #### Settings
--- 
--- Possible fields for the cutscene table:
--- * `Starting`                - Function called when cutscene is started              
--- * `Finished`                - Function called when cutscene is finished                 
--- * `EnableGlobalImmortality` - During cutscenes all entities are invulnerable        
--- * `EnableSky`               - Display the sky during the cutscene                   
--- * `EnableFoW`               - Displays the fog of war during the cutscene           
--- * `EnableBorderPins`        - Displays the border pins during the cutscene 
---
--- #### Example
---
--- ```lua
--- function Cutscene1(_Name, _PlayerID)
---     local Cutscene = {};
---     local AP = API.AddCutscenePages(Cutscene);
---
---     -- Pages ...
---
---     Cutscene.Starting = function(_Data)
---     end
---     Cutscene.Finished = function(_Data)
---     end
---     API.StartCutscene(Cutscene, _Name, _PlayerID);
--- end
--- ```
---
--- @param _Cutscene table   Cutscene table
--- @param _Name string      Name of cutscene
--- @param _PlayerID integer Player ID of receiver
function StartCutscene(_Cutscene, _Name, _PlayerID)
    if GUI then
        return;
    end
    local PlayerID = _PlayerID;
    if not PlayerID and not Framework.IsNetworkGame() then
        PlayerID = 1; -- Human Player
    end
    assert(_Name ~= nil);
    assert(_PlayerID ~= nil);
    assert(type(_Cutscene) == "table", "Cutscene must be a table!");
    assert(#_Cutscene > 0, "Cutscene does not contain pages!");
    for i=1, #_Cutscene do
        assert(
            type(_Cutscene[i]) ~= "table" or _Cutscene[i].__Legit,
            "A page is not initialized!"
        );
    end
    if _Cutscene.EnableSky == nil then
        _Cutscene.EnableSky = true;
    end
    if _Cutscene.EnableFoW == nil then
        _Cutscene.EnableFoW = false;
    end
    if _Cutscene.EnableGlobalImmortality == nil then
        _Cutscene.EnableGlobalImmortality = true;
    end
    if _Cutscene.EnableBorderPins == nil then
        _Cutscene.EnableBorderPins = false;
    end
    Lib.CutsceneSystem.Global:StartCutscene(_Name, PlayerID, _Cutscene);
end

--- Checks if a cutscene ist active.
--- @param _PlayerID integer PlayerID of receiver
--- @return boolean IsActive Briefing is active
function IsCutsceneActive(_PlayerID)
    if not IsLocalScript() then
        return Lib.CutsceneSystem.Global:GetCurrentCutscene(_PlayerID) ~= nil;
    end
    return Lib.CutsceneSystem.Local:GetCurrentCutscene(_PlayerID) ~= nil;
end

--- Prepares the cutscene and returns the page function.
---
--- Must be called before pages are added.
--- @param _Cutscene table Cutscene table
--- @return function AP  Page function
function AddCutscenePages(_Cutscene)
    Lib.CutsceneSystem.Global:CreateCutsceneGetPage(_Cutscene);
    Lib.CutsceneSystem.Global:CreateCutsceneAddPage(_Cutscene);

    local AP = function(_Page)
        return _Cutscene:AddPage(_Page);
    end
    return AP;
end

--- Creates a page.
---
--- #### Cutscene Page
--- Possible fields for the page:
---
--- * `Flight`          - Name of flight XML (without .cs)
--- * `Title`           - Displayed page title
--- * `Text`            - Displayed page text
--- * `Action`          - Function called when page is displayed
--- * `FarClipPlane`    - Render distance
--- * `FadeIn`          - Duration of fadein from black
--- * `FadeOut`         - Duration of fadeout to black
--- * `FaderAlpha`      - Mask alpha
--- * `DisableSkipping` - Allow/forbid skipping pages
--- * `BarOpacity`      - Opacity of bars
--- * `BigBars`         - Use big bars
---
--- #### Example
---
--- ```lua
--- AP {
---     Flight       = "c02",
---     FarClipPlane = 45000,
---     Title        = "Title",
---     Text         = "Text of the flight.",
--- };
--- ```
---
--- @param _Data table Page data
function AP(_Data)
    assert(false);
end

