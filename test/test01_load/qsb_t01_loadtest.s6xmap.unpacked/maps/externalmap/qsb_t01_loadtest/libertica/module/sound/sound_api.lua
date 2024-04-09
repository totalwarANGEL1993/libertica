Lib.Require("comfort/IsLocalScript");
Lib.Register("module/Sound/Sound_API");

--- Starts an event playlist.
---
--- It is possible to import custom files into the game by saving them into
--- the map archive. A playlist needs a XML file defining it and the files
--- with the music.
---
--- To avoid problems with music files it is best practice to give all files
--- a unique name. For example find a short prefix for all files taken from
--- the map name. If multiple maps with the same files inside the playlist or
--- music directory are present then files will be overwritten!
---
--- #### File structure for custom playlists:
--- ```xml
--- map_xyz.s6xmap.unpacked
--- |-- music/*
--- |-- config/sound/*
--- |-- maps/externalmap/map_xyz/*
--- |-- ...
--- ```
---
--- #### Example structure of playlist:
--- ```xml
--- <?xml version="1.0" encoding="utf-8"?>
--- <PlayList>
---  <PlayListEntry>
---    <FileName>Music\some_music_file.mp3</FileName>
---    <Type>Loop</Type>
---  </PlayListEntry>
---  <!-- Add entries here -->
--- </PlayList>
--- ```
---
--- Playlist entries can be looped by using `Loop` as type or be played once
--- with `Normal` as type.
---
--- Also a propability can be used. This indicates the probability of a track
--- being played.
--- 
--- ```xml
--- <Chance>10</Chance>
--- ```
--- @param _Playlist string Name of playlist
--- @param _PlayerID integer ID of player
function StartEventPlaylist(_Playlist, _PlayerID)
    _PlayerID = _PlayerID or 1;
    if not GUI then
        ExecuteLocal("StartEventPlaylist('%s', %d)", _Playlist, _PlayerID);
        return;
    end
    if _PlayerID == GUI.GetPlayerID() then
        Sound.MusicStartEventPlaylist(_Playlist)
    end
end
API.StartEventPlaylist = StartEventPlaylist;

--- Stops an event playlist.
--- @param _Playlist string Name of playlist
--- @param _PlayerID integer ID of player
function StopEventPlaylist(_Playlist, _PlayerID)
    _PlayerID = _PlayerID or 1;
    if not GUI then
        ExecuteLocal("StopEventPlaylist('%s', %d)", _Playlist, _PlayerID);
        return;
    end
    if _PlayerID == GUI.GetPlayerID() then
        Sound.MusicStopEventPlaylist(_Playlist)
    end
end
API.StopEventPlaylist = StopEventPlaylist;

--- Plays an interface sound.
---
--- It is possible to import custom files into the game by saving them into
--- the map archive. To avoid naming problems give all files a unique name.
---
--- #### File structure for custom sounds:
--- ```xml
--- map_xyz.s6xmap.unpacked
--- |-- sounds/high/ui/*
--- |-- sounds/low/ui/*
--- |-- maps/externalmap/map_xyz/*
--- |-- ...
--- ```
--- @param _Sound string Path to sound
--- @param _PlayerID integer ID of player
function Play2DSound(_Sound, _PlayerID)
    _PlayerID = _PlayerID or 1;
    if not GUI then
        ExecuteLocal([[Play2DSound("%s", %d)]], _Sound, _PlayerID);
        return;
    end
    if _PlayerID == GUI.GetPlayerID() then
        Sound.FXPlay2DSound(_Sound:gsub("/", "\\"));
    end
end
API.Play2DSound = Play2DSound;

--- Plays a sound at a world coordinate.
---
--- It is possible to import custom files into the game by saving them into
--- the map archive. To avoid naming problems give all files a unique name.
---
--- #### File structure for custom sounds:
--- ```xml
--- map_xyz.s6xmap.unpacked
--- |-- sounds/high/ui/*
--- |-- sounds/low/ui/*
--- |-- maps/externalmap/map_xyz/*
--- |-- ...
--- ```
--- @param _Sound string Path to sound
--- @param _X number X coordinate of sound
--- @param _Y number Y coordinate of sound
--- @param _Z number Z coordinate of sound
--- @param _PlayerID integer ID of player
function Play3DSound(_Sound, _X, _Y, _Z, _PlayerID)
    _PlayerID = _PlayerID or 1;
    _X = _X or 1;
    _Y = _Y or 1
    _Z = _Z or 0
    if not GUI then
        ExecuteLocal([[Play3DSound("%s", %f, %f, %d)]], _Sound, _X, _Y, _PlayerID);
        return;
    end
    if _PlayerID == GUI.GetPlayerID() then
        Sound.FXPlay3DSound(_Sound:gsub("/", "\\"), _X, _Y, _Z);
    end
end
API.Play3DSound = Play3DSound;

--- Sets the master volume of the sound.
---
--- The current values are automatically saved as default if no default
--- is found.
--- @param _Volume integer Volume of sound property
function SoundSetVolume(_Volume)
    _Volume = (_Volume < 0 and 0) or math.floor(_Volume);
    if not GUI then
        ExecuteLocal("SoundSetVolume(%d)", _Volume);
        return;
    end
    Lib.Sound.Local:AdjustSound(_Volume, nil, nil, nil, nil);
end
API.SoundSetVolume = SoundSetVolume;

--- Sets the volume of the music.
---
--- The current values are automatically saved as default if no default
--- is found.
--- @param _Volume integer Volume of sound property
function SoundSetMusicVolume(_Volume)
    _Volume = (_Volume < 0 and 0) or math.floor(_Volume);
    if not GUI then
        ExecuteLocal("SoundSetMusicVolume(%d)", _Volume);
        return;
    end
    Lib.Sound.Local:AdjustSound(nil, _Volume, nil, nil, nil);
end
API.SoundSetMusicVolume = SoundSetMusicVolume;

--- Sets the volume of voices.
---
--- The current values are automatically saved as default if no default
--- is found.
--- @param _Volume integer Volume of sound property
function SoundSetVoiceVolume(_Volume)
    _Volume = (_Volume < 0 and 0) or math.floor(_Volume);
    if not GUI then
        ExecuteLocal("SoundSetVoiceVolume(%d)", _Volume);
        return;
    end
    Lib.Sound.Local:AdjustSound(nil, nil, _Volume, nil, nil);
end
API.SoundSetVoiceVolume = SoundSetVoiceVolume;

--- Sets the volume of atmospheric sounds.
---
--- The current values are automatically saved as default if no default
--- is found.
--- @param _Volume integer Volume of sound property
function SoundSetAtmoVolume(_Volume)
    _Volume = (_Volume < 0 and 0) or math.floor(_Volume);
    if not GUI then
        ExecuteLocal("SoundSetAtmoVolume(%d)", _Volume);
        return;
    end
    Lib.Sound.Local:AdjustSound(nil, nil, nil, _Volume, nil);
end
API.SoundSetAtmoVolume = SoundSetAtmoVolume;

--- Sets the volume of interface sounds.
---
--- The current values are automatically saved as default if no default
--- is found.
--- @param _Volume integer Volume of sound property
function SoundSetUIVolume(_Volume)
    _Volume = (_Volume < 0 and 0) or math.floor(_Volume);
    if not GUI then
        ExecuteLocal("SoundSetUIVolume(%d)", _Volume);
        return;
    end
    Lib.Sound.Local:AdjustSound(nil, nil, nil, nil, _Volume);
end
API.SoundSetUIVolume = SoundSetUIVolume;

--- Manually saves the sound volumes as default.
function SoundSave()
    if not GUI then
        Logic.ExecuteInLuaLocalState("SoundSave()");
        return;
    end
    Lib.Sound.Local:SaveSound();
end
API.SoundSave = SoundSave;

--- Manually restores the sound volumes to default.
function SoundRestore()
    if not GUI then
        ExecuteLocal("SoundRestore()");
        return;
    end
    Lib.Sound.Local:RestoreSound();
end
API.SoundRestore = SoundRestore;

--- Plays a sound file as voice.
--- @param _File string Path to sound
function PlayVoice(_File)
    if not GUI then
        ExecuteLocal([[PlayVoice("%s")]], _File);
        return;
    end
    StopVoice();
    Sound.PlayVoice("ImportantStuff", _File);
end
API.PlayVoice = PlayVoice;

--- Stops a playing voice.
function StopVoice()
    if not GUI then
        ExecuteLocal("StopVoice()");
        return;
    end
    Sound.StopVoice("ImportantStuff");
end
API.StopVoice = StopVoice;

