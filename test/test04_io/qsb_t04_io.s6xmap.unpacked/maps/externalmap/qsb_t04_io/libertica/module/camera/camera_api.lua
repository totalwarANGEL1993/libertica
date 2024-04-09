Lib.Require("comfort/IsLocalScript");
Lib.Register("module/camera/Camera_API");

--- Changes the max rendering distance until something is clipped.
--- @param _View number Max randering distance
function SetRenderDistance(_View)
    if not IsLocalScript() then
        ExecuteLocal([[Lib.Camera.Local:SetRenderDistance(%f)]], _View);
        return;
    end
    Lib.Camera.Local:SetRenderDistance(_View);
end

--- Resets the clipping to it's default values.
function ResetRenderDistance()
    if not IsLocalScript() then
        ExecuteLocal([[Lib.Camera.Local:ResetRenderDistance()]]);
        return;
    end
    Lib.Camera.Local:ResetRenderDistance();
end

--- Activates border scroll and loosens camera fixation.
--- @param _PlayerID integer? ID of player
function ActivateBorderScroll(_PlayerID)
    _PlayerID = _PlayerID or -1;
    assert(_PlayerID == -1 or (_PlayerID >= 1 and _PlayerID <= 8));
    if not IsLocalScript() then
        ExecuteLocal(
            "Lib.Camera.Local:ActivateBorderScroll(%d)",
            _PlayerID
        );
        return;
    end
    Lib.Camera.Local:ActivateBorderScroll(_PlayerID);
end
API.ActivateBorderScroll = ActivateBorderScroll;

--- Deactivates border scroll and fixes camera.
--- @param _PlayerID integer? ID of player
--- @param _Position integer? (Optional) Entity to fix camera on
function DeactivateBorderScroll(_Position, _PlayerID)
    _PlayerID = _PlayerID or -1;
    assert(_PlayerID == -1 or (_PlayerID >= 1 and _PlayerID <= 8));
    local PositionID;
    if _Position then
        PositionID = GetID(_Position);
    end
    if not IsLocalScript() then
        ExecuteLocal(
            "Lib.Camera.Local:DeactivateBorderScroll(%d, %d)",
            _PlayerID,
            (PositionID or 0)
        );
        return;
    end
    Lib.Camera.Local:DeactivateBorderScroll(_PlayerID, PositionID);
end
API.DeactivateBorderScroll = DeactivateBorderScroll;

--- Allows/Prohibits the extended zoom for one or for all players.
--- @param _Flag boolean Extended zoom allowed
--- @param _PlayerID integer? ID of player
function AllowExtendedZoom(_Flag, _PlayerID)
    _PlayerID = _PlayerID or -1;
    if not GUI then
        ExecuteLocal([[API.AllowExtendedZoom(%s, %d)]], tostring(_Flag == true), _PlayerID);
        return;
    end
    if _PlayerID ~= -1 and GUI.GetPlayerID() ~= _PlayerID then
        return;
    end
    Lib.Camera.Local.ExtendedZoomAllowed = _Flag == true;
    if _Flag == true then
        Lib.Camera.Local:DescribeExtendedZoomShortcut();
    else
        Lib.Camera.Local:RemoveExtendedZoomShortcut();
        Lib.Camera.Local:DeactivateExtendedZoom(_PlayerID);
    end
end
API.AllowExtendedZoom = AllowExtendedZoom;

--- Focuses a camera on the players knight but does not lock the camera.
--- @param _PlayerID integer ID of player
--- @param _Rotation number Rotation angle
--- @param _ZoomFactor number Zoom factor
function FocusCameraOnKnight(_PlayerID, _Rotation, _ZoomFactor)
    FocusCameraOnEntity(Logic.GetKnightID(_PlayerID), _Rotation, _ZoomFactor)
end
API.FocusCameraOnKnight = FocusCameraOnKnight;

--- Focuses a camera on an entity but does not lock the camera.
--- @param _Entity any
--- @param _Rotation number Rotation angle
--- @param _ZoomFactor number Zoom factor
function FocusCameraOnEntity(_Entity, _Rotation, _ZoomFactor)
    if not GUI then
        local Subject = (type(_Entity) ~= "string" and _Entity) or ("'" .._Entity.. "'");
        ExecuteLocal([[API.FocusCameraOnEntity(%s, %f, %f)]], Subject, _Rotation, _ZoomFactor);
        return;
    end
    assert(type(_Rotation) == "number", "Rotation is wrong!");
    assert(type(_ZoomFactor) == "number", "Zoom factor is wrong!");
    assert(IsExisting(_Entity), "Entity does not exist!");
    Lib.Camera.Local:SetCameraToEntity(_Entity, _Rotation, _ZoomFactor);
end
API.FocusCameraOnEntity = FocusCameraOnEntity;

