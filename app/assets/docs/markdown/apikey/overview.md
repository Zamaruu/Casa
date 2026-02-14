# API-Schlüssel im Admin-Bereich

API-Schlüssel sind für technische Zugriffe gedacht, z. B. für Skripte, Dienste oder Automationen.

## Wann API-Schlüssel sinnvoll sind

- Für Server-zu-Server-Kommunikation
- Für interne Tools ohne Benutzer-Login
- Für automatisierte Jobs (Backups, Syncs, Health-Checks)

## Wann API-Schlüssel nicht sinnvoll sind

- Für normale Benutzeranmeldung in der App
- Für geteilte Team-Logins
- Für dauerhaft unkontrollierte Zugänge ohne Ablaufdatum

## Wichtige Hinweise

- Ein API-Schlüssel wird nur **einmal** im Klartext angezeigt.
- Danach ist nur noch der Hash in Casa gespeichert.
- Verlorene Schlüssel können nicht wieder angezeigt werden und müssen neu erstellt werden.


# API-Schlüssel erstellen und verwenden

## 1. Schlüssel erstellen

1. Öffne **Administration -> API**.
2. Klicke auf **API-Schlüssel**.
3. Trage Name und optional Beschreibung ein.
4. Setze ein Ablaufdatum, wenn der Zugriff nur temporär gebraucht wird.
5. Speichere den Schlüssel.

## 2. Schlüssel sicher speichern

Nach dem Anlegen zeigt Casa den Roh-Schlüssel (`rawKey`) genau einmal an.

- Direkt in einen Passwort-Manager kopieren
- Nicht im Chat, Ticket oder Klartext in Quellcode speichern
- Nicht in öffentliche Repositories committen

## 3. Schlüssel verwenden

Sende den Schlüssel im HTTP-Header:

```http
Authorization: ApiKey <DEIN_SCHLUESSEL>
```

Beispiel mit `curl`:

```bash
curl -H "Authorization: ApiKey <DEIN_SCHLUESSEL>" https://<dein-server>/api/meta/healthcheck
```


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
