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
