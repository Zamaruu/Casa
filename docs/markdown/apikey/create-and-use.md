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
