# Legecy bugs

## Behavior constructor

Location: liberty\core\qsb.lua
Summary:  `_G["B_" .. Behavior.Name].new` hat an error where index i and index j
          where swapped on more than on place.