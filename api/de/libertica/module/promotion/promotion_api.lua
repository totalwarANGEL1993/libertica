--- Ermöglicht das Ändern der Beförderungsanforderungen.
--- 
--- Einige Technologien sind jetzt in der nächsten Titelrechtsliste versteckt:
--- - Technologies.R_Barracks
--- - Technologies.R_SwordSmith
--- - Technologies.R_BarracksArchers
--- - Technologies.R_BowMaker
---
--- Um die Technologien für Schwertkämpfer und Bogenschützen zu ersetzen,
--- wurden 2 neue Technologien eingeführt. Sie können nicht verwendet werden, 
--- um Funktionen zu verbieten, sondern um dem Spieler anzuzeigen, dass sie 
--- diese Einheiten mit dem nächsten Rang rekrutieren können. Daher müssen 
--- die alten Technologien nicht zu den Rechten hinzugefügt werden. Wenn die
--- Technologien verboten sind, werden sie nicht freigeschaltet.
---
--- ##### Technologies.R_MilitarySword
--- Diese Technologie soll dem Spieler zeigen, dass er in der Lage sein wird, 
--- Schwertkämpfer zu rekrutieren.
---
--- Entsperrt: Technologies.R_Barracks und Technologies.R_SwordSmith
---
--- ##### Technologies.R_MilitaryBow
--- Diese Technologie soll dem Spieler zeigen, dass er in der Lage sein wird, 
--- Bogenschützen zu rekrutieren.
---
--- Entsperrt: Technologies.R_BarracksArchers und Technologies.R_BowMaker
---
Lib.Promotion = Lib.Promotion or {};
