# Legecy bugs

## Behavior constructor

Location: libertica\core\qsb.lua
Summary:  `_G["B_" .. Behavior.Name].new` hat an error where index i and index j
          where swapped on more than on place.

## Quest Jornal
Location: libertica\module\quest\questjornal.lua
Summary:  Only the first player note is colored violet.

## Console commands
Location: any occurances of `:ProcessChatInput`
Summary:  Input is parsed into `Commands` and then iterated. But the Index was
          missing and certain commands did not work because of this.