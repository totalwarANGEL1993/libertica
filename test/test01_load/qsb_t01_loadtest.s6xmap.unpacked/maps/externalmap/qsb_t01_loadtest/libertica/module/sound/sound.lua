--- @diagnostic disable: duplicate-set-field

--- This module enables to controll the sound.
---
--- #### Features
--- - Start/stop music playlists
--- - Start/stop voice playback
--- - Start/stop sound effecs
--- - Change sound configuration
Lib.Sound = {
    Name = "Sound",

    Global = {},
    Local = {
        SoundBackup = {},
    },
};

CONST_FARCLIPPLANE = 45000;
CONST_FARCLIPPLANE_DEFAULT = 0;

Lib.Require("core/Core");
Lib.Require("module/sound/Sound_API");
Lib.Register("module/sound/Sound");

-- -------------------------------------------------------------------------- --
-- Global

-- Global initalizer method
function Lib.Sound.Global:Initialize()
    if not self.IsInstalled then

        -- Garbage collection
        Lib.Sound.Local = nil;
    end
    self.IsInstalled = true;
end

-- Global load game
function Lib.Sound.Global:OnSaveGameLoaded()
end

-- Global report listener
function Lib.Sound.Global:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    end
end

-- -------------------------------------------------------------------------- --
-- Local

-- Local initalizer method
function Lib.Sound.Local:Initialize()
    if not self.IsInstalled then

        -- Garbage collection
        Lib.Sound.Global = nil;
    end
    self.IsInstalled = true;
end

-- Local load game
function Lib.Sound.Local:OnSaveGameLoaded()
end

-- Global report listener
function Lib.Sound.Local:OnReportReceived(_ID, ...)
    if _ID == Report.LoadingFinished then
        self.LoadscreenClosed = true;
    end
end

function Lib.Sound.Local:AdjustSound(_Global, _Music, _Voice, _Atmo, _UI)
    self:SaveSound();
    if _Global then
        Sound.SetGlobalVolume(_Global);
    end
    if _Music then
        Sound.SetMusicVolume(_Music);
    end
    if _Voice then
        Sound.SetSpeechVolume(_Voice);
    end
    if _Atmo then
        Sound.SetFXSoundpointVolume(_Atmo);
        Sound.SetFXAtmoVolume(_Atmo);
    end
    if _UI then
        Sound.Set2DFXVolume(_UI);
        Sound.SetFXVolume(_UI);
    end
end

function Lib.Sound.Local:SaveSound()
    if not self.SoundBackup.Saved then
        self.SoundBackup.Saved = true;
        self.SoundBackup.FXSP = Sound.GetFXSoundpointVolume();
        self.SoundBackup.FXAtmo = Sound.GetFXAtmoVolume();
        self.SoundBackup.FXVol = Sound.GetFXVolume();
        self.SoundBackup.Sound = Sound.GetGlobalVolume();
        self.SoundBackup.Music = Sound.GetMusicVolume();
        self.SoundBackup.Voice = Sound.GetSpeechVolume();
        self.SoundBackup.UI = Sound.Get2DFXVolume();
    end
end

function Lib.Sound.Local:RestoreSound()
    if self.SoundBackup.Saved then
        Sound.SetFXSoundpointVolume(self.SoundBackup.FXSP);
        Sound.SetFXAtmoVolume(self.SoundBackup.FXAtmo);
        Sound.SetFXVolume(self.SoundBackup.FXVol);
        Sound.SetGlobalVolume(self.SoundBackup.Sound);
        Sound.SetMusicVolume(self.SoundBackup.Music);
        Sound.SetSpeechVolume(self.SoundBackup.Voice);
        Sound.Set2DFXVolume(self.SoundBackup.UI);
        self.SoundBackup = {};
    end
end

-- -------------------------------------------------------------------------- --

RegisterModule(Lib.Sound.Name);

