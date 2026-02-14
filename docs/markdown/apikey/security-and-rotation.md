# Sicherheit, Ablauf und Rotation

## Empfohlene Sicherheitsregeln

- Pro System einen eigenen Schlüssel verwenden
- Immer Name/Beschreibung so wählen, dass die Nutzung klar ist
- Möglichst kurze Ablaufzeiten setzen
- Nicht verwendete Schlüssel sofort löschen

## Rotation (regelmäßiger Austausch)

Empfohlener Ablauf:

1. Neuen Schlüssel erstellen
2. Zielsystem auf neuen Schlüssel umstellen
3. Funktion prüfen
4. Alten Schlüssel löschen

So vermeidest du Ausfälle und begrenzt Risiko bei Schlüssel-Leaks.

## Verdacht auf Kompromittierung

Wenn ein Schlüssel möglicherweise öffentlich wurde:

1. Schlüssel sofort löschen
2. Neuen Schlüssel erstellen
3. Betroffene Systeme aktualisieren
4. Logs prüfen (wann/wie der alte Schlüssel genutzt wurde)
