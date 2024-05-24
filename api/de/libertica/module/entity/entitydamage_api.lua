--- Ermöglicht die Veränderung der Schadenswerte von Einheiten.
---
--- Hinweis: Die Funktionen `MakeVulnerable` und `MakeInvulnerable` wurden
--- überschrieben. Die Funktion `Logic.SetEntityInvulnerabilityFlag` wird
--- stattdessen intern benutzt und darf nicht mehr verwendet werden!
---
--- Funktionen:
--- * Besseres Balancing für Bogenschützen
--- * Anpassen der Kampfkraft von Einheiten über Lua
--- * Zusätzliche Rüstung für Einheiten vergeben
--- * Anpassen des Own Territoy bonus
--- * Anpassen des Height Modifier
---
Lib.EntityDamage = Lib.EntityDamage or {};

--- Setzt den Schaden für einen Entitätstypen.
---
--- Der angegebene Schaden ersetzt den Basischaden des Entitätstypen. Der
--- tatsächliche Schaden Ergibt sich aus Moral, Höhenbonus und Territorienbonus.
---
--- @param _Type integer Entitätstyp
--- @param _Damage integer Höhe des Schaden
function SetEntityTypeDamage(_Type, _Damage)
end

--- Setzt den Schaden für eine benannte Entität.
---
--- Der angegebene Schaden ersetzt den Basischaden der Entität. Der tatsächliche
--- Schaden Ergibt sich aus Moral, Höhenbonus und Territorienbonus.
---
--- @param _Name string Scriptname der Entität
--- @param _Damage integer Höhe des Schaden
function SetEntityNameDamage(_Name, _Damage)
end

--- Setzt Die Rüstung für einen Entitätstypen.
---
--- Der Rüstungswert wird nach der eigentlichen Schadensberechnung vom übrigen
--- Schaden abgezogen. Der Schaden kann niemals kleiner als 1 werden.
---
--- @param _Type integer Entitätstyp
--- @param _Armor integer Stärke der Rüstung
function SetEntityTypeArmor(_Type, _Armor)
end

--- Setzt die Rüstung für eine benannte Entität.
---
--- Der Rüstungswert wird nach der eigentlichen Schadensberechnung vom übrigen
--- Schaden abgezogen. Der Schaden kann niemals kleiner als 1 werden.
---
--- @param _Name string Scriptname der Entität
--- @param _Armor integer Stärke der Rüstung
function SetEntityNameArmor(_Name, _Armor)
end

--- Setzt den Bonusfaktor für den Schaden bei Kämpfen auf eigenem Gebiet.
---
--- Der angegebene Faktor wird mit dem eigentlichen Faktor ultipliziert. Für
--- 0.5 bedeutet dies, der Territorienbonus wird halbiert. Bei der Berechnung
--- wird der Territorienbonus zur Moral dazu addiert.
---
--- @param _PlayerID integer ID des Spielers
--- @param _Bonus number Faktor
function SetTerritoryBonus(_PlayerID, _Bonus)
end

--- Setzt den Bonusfaktor für den Schaden bei Kämpfen von erhöhter Position.
---
--- Der angegebene Faktor wird mit dem eigentlichen Faktor ultipliziert. Für
--- 0.5 bedeutet dies, der Hohenbonus wird halbiert. Bei der Berechnung wird
--- die Summe von Moral und Territorienbonus mit dem Höhenbonus multipliziert.
---
--- @param _PlayerID integer ID des Spielers
--- @param _Bonus number Faktor
function SetHeightModifier(_PlayerID, _Bonus)
end

--- Prüft, ob die Entität unverwundbar ist.
--- @param _Entity any Skriptname oder Entität-ID
--- @return boolean Invulnerable Entität ist unverwundbar
function IsInvulnerable(_Entity)
    return true;
end

