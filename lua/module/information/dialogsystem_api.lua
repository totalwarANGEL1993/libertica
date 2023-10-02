Lib.Require("comfort/IsLocalScript");
Lib.Register("module/information/DialogSystem_API");

--- Starts a dialog.
---
--- #### Settings
---
--- Possible fields for the dialog table:
--- * `Starting`                - Function called when dialog is started              
--- * `Finished`                - Function called when dialog is finished             
--- * `RestoreCamera`           - Camera position is saved and restored at dialog end 
--- * `RestoreGameSpeed`        - Game speed is saved and restored at dialog end      
--- * `EnableGlobalImmortality` - During dialogs all entities are invulnerable        
--- * `EnableSky`               - Display the sky during the dialog                   
--- * `EnableFoW`               - Displays the fog of war during the dialog           
--- * `EnableBorderPins`        - Displays the border pins during the dialog 
---
--- #### Example
---
--- ```lua
--- function Dialog1(_Name, _PlayerID)
---     local Dialog = {
---         DisableFow = true,
---         DisableBoderPins = true,
---     };
---     local AP, ASP = API.AddDialogPages(Dialog);
---
---     -- Pages ...
---
---     Dialog.Starting = function(_Data)
---     end
---     Dialog.Finished = function(_Data)
---     end
---     API.StartDialog(Dialog, _Name, _PlayerID);
--- end
--- ```
---
--- @param _Dialog table     Dialog table
--- @param _Name string      Name of dialog
--- @param _PlayerID integer Player ID of receiver
function StartDialog(_Dialog, _Name, _PlayerID)
    if GUI then
        return;
    end
    local PlayerID = _PlayerID;
    if not PlayerID and not Framework.IsNetworkGame() then
        PlayerID = QSB.HumanPlayerID;
    end
    assert(_Name ~= nil);
    assert(_PlayerID ~= nil);
    assert(type(_Dialog) == "table", "Dialog must be a table!");
    assert(#_Dialog > 0, "Dialog does not contain pages!");
    for i=1, #_Dialog do
        assert(
            type(_Dialog[i]) ~= "table" or _Dialog[i].__Legit,
            "Page is not initialized!"
        );
    end
    if _Dialog.EnableSky == nil then
        _Dialog.EnableSky = true;
    end
    if _Dialog.EnableFoW == nil then
        _Dialog.EnableFoW = false;
    end
    if _Dialog.EnableGlobalImmortality == nil then
        _Dialog.EnableGlobalImmortality = true;
    end
    if _Dialog.EnableBorderPins == nil then
        _Dialog.EnableBorderPins = false;
    end
    if _Dialog.RestoreGameSpeed == nil then
        _Dialog.RestoreGameSpeed = true;
    end
    if _Dialog.RestoreCamera == nil then
        _Dialog.RestoreCamera = true;
    end
    Lib.DialogSystem.Global:StartDialog(_Name, PlayerID, _Dialog);
end
API.StartDialog = StartDialog;

--- Checks if a dialog ist active.
--- @param _PlayerID integer PlayerID of receiver
--- @return boolean IsActive Dialog is active
function IsDialogActive(_PlayerID)
    if not IsLocalScript() then
        return Lib.DialogSystem.Global:GetCurrentDialog(_PlayerID) ~= nil;
    end
    return Lib.DialogSystem.Local:GetCurrentDialog(_PlayerID) ~= nil;
end
API.IsDialogActive = IsDialogActive;

--- Prepares the dialog and returns the page functions.
---
--- Must be called before pages are added.
--- @param _Dialog table Dialog table
--- @return function AP  Page function
--- @return function ASP Short page function
function AddDialogPages(_Dialog)
    Lib.DialogSystem.Global:CreateDialogGetPage(_Dialog);
    Lib.DialogSystem.Global:CreateDialogAddPage(_Dialog);
    Lib.DialogSystem.Global:CreateDialogAddMCPage(_Dialog);
    Lib.DialogSystem.Global:CreateDialogAddRedirect(_Dialog);

    local AP = function(_Page)
        local Page;
        if type(_Page) == "table" then
            if _Page.MC then
                Page = _Dialog:AddMCPage(_Page);
            else
                Page = _Dialog:AddPage(_Page);
            end
        else
            Page = _Dialog:AddRedirect(_Page);
        end
        return Page;
    end

    local ASP = function(...)
        if type(arg[1]) ~= "number" then
            Name = table.remove(arg, 1);
        end
        local Sender   = table.remove(arg, 1);
        local Position = table.remove(arg, 1);
        local Title    = table.remove(arg, 1);
        local Text     = table.remove(arg, 1);
        local Dialog   = table.remove(arg, 1);
        local Action;
        if type(arg[1]) == "function" then
            Action = table.remove(arg, 1);
        end
        return _Dialog:AddPage{
            Name         = Name,
            Title        = Title,
            Text         = Text,
            Actor        = Sender,
            Target       = Position,
            DialogCamera = Dialog == true,
            Action       = Action,
        };
    end
    return AP, ASP;
end
API.AddDialogPages = AddDialogPages;

--- Creates a page.
---
--- #### Dialog Page
--- Possible fields for the page:
---
--- * `Actor`           - (optional) PlayerID of speaker
--- * `Title`           - (optional) Name of actor (only with actor)
--- * `Text`            - (optional) Displayed page text
--- * `Position`        - Position of camera (not with target)
--- * `Target`          - Entity the camera follows (not with position)
--- * `Distance`        - (optional) Distance of camera
--- * `Action`          - (optional) Function called when page is displayed
--- * `FadeIn`          - (optional) Duration of fadein from black
--- * `FadeOut`         - (optional) Duration of fadeout to black
--- * `FaderAlpha`      - (optional) Mask alpha
--- * `MC`              - (optional) Table with choices to branch of in dialogs
---
--- *-> Example #1*
---
--- #### Flow control
--- In a dialog the player can be forced to make a choice that will have
--- different results. That is called multiple choice. Options must be provided
--- in a table. The target page can be defined with it's name or a function can
--- be provided for more control over the flow. Such funktions must return a
--- page name.
---
--- *-> Example #2*
---
--- Additionally each function can be marked to be removed when used
--- and not shown again when reentering the page.
---
--- *-> Example #3*
---
--- Also pages can be hidden by providing a function to check conditions.
---
--- *-> Example #4*
---
--- If a dialog is branched it must be manually ended after a branch is done
--- or it just simply shows the next page. To end a dialog, an empty page
--- must be added.
---
--- *-> Example #5*
---
--- Alternativly the dialog can continue at a different page. This allows to
--- create repeating structures within a dialog.
---
--- *-> Example #6*
---
--- To obtain selected answers at a later point the selection can be saved in a
--- global variable either in a option callback or in the finished function. The
--- number returned is the ID of the answer.
---
--- *-> Example #7*
---
--- #### Examples
---
--- * Example #1: A simple page
--- ```lua
-- AP {
--     Title        = "Hero",
--     Text         = "This page has an actor and a choice.",
--     Actor        = 1,
--     Duration     = 2,
--     FadeIn       = 2,
--     Position     = "npc1",
--     DialogCamera = true,
-- };
--- ```
---
---
--- * Example #2: Usage of multiple choices
--- ```lua
-- AP {
---     Title        = "Hero",
---     Text         = "This page has an actor and a choice.",
---     Actor        = 1,
---     Duration     = 2,
---     FadeIn       = 2,
---     Position     = "npc1",
---     DialogCamera = true,
---     MC = {
---         {"Option 1", "TargetPage"},
---         {"Option 2", Option2Clicked},
---     },
--- };
--- ```
---
---
--- * Example #3: One time usage option
--- ```lua
--- MC = {
---     ...,
---     {"Option 3", "AnotherPage", Remove = true},
--- }
--- ```
---
---
--- * Example #4: Option with condition
--- ```lua
--- MC = {
---     ...,
---     {"Option 3", "AnotherPage", Disable = OptionIsDisabled},
--- }
--- ```
---
---
--- * Example #5: Abort dialog
--- ```lua
--- AP()
--- ```
---
---
--- * Example #6: Jump to other page
--- ```lua
--- AP("SomePageName")
--- ```
---
---
--- * Example #7: Get selected option
--- ```lua
--- Dialog.Finished = function(_Data)
---     MyChoosenOption = _Data:GetPage("Choice"):GetSelected();
--- end
--- ```
---
function AP(_Data)
    assert(false);
end

--- Creates a page in a simplified manner.
---
--- The function can create a automatic page name based of the page index. A
--- name can be an optional parameter at the start.
---
--- #### Settings
--- The function expects the following parameters:
--- 
--- * `Name`           - (Optional) Name of page
--- * `Sender`         - Player ID of actor
--- * `Target`         - Entity the camera is looking at
--- * `Title`          - Displayed page title
--- * `Text`           - Displayed page text
--- * `DialogCamera`   - Use closeup camera
--- * `Action`         - (Optional) Action when page is shown
---
--- #### Examples
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

