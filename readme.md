This is a script library for THE SETTLERS - Rise of a kingdom.

This library will extend upon the default QSB and extend it with additional
features. Components are all optional (expect for the core) and therefore not
always needed for a running map.

## Requirements

The script will run Lua code. You will need to install Lua on your PC. In the 
`bin` directory is a full version of Lua 5.1 for you to install. Follow the
instructions in the readme file. 
(You can also use any other Lua distribution but keep in mind that the game
uses Lua 5.1!)

## Usage

#### Default

- Build library by the command `exe/build -b` or `"exe/build.bat" -b`
  (plus -c if you want bytecode)
- Import generated `liberty` folder in map archive
- import `qsb.lua` as `questsystembehavior.lua`
- Load `liberator.lua` at the start of your scripts
  (both global and local)
- Use Require to load components AFTER that
- Include `questsystembehavior.lua` as usual in Mission_FirstMapAction
- call `Liberate()` in Mission_FirstMapAction

#### Single File

- Build library by the command `exe/build -b -s` or `"exe/build.bat" -b -s`
  (plus -c if you want bytecode)
- import `qsb.lua` as `questsystembehavior.lua`
- Include `questsystembehavior.lua` as usual in Mission_FirstMapAction
- Include also in Mission_LocalOnMapStart (local script)
- call `Liberate()` in Mission_FirstMapAction