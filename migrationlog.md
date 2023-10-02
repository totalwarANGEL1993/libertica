# Legecy bugs

## Behavior constructor

Location: liberty\core\qsb.lua
Summary:  `_G["B_" .. Behavior.Name].new` hat an error where index i and index j
          where swapped on more than on place.

## Quest Jornal
Location: liberty\module\quest\questjornal.lua
Summary:  Only the first player note is colored violet.