# Casa – Roadmap

Diese Roadmap beschreibt die geplante funktionale und technische Entwicklung von **Casa** im Jahr **2026**.  
Der Fokus liegt auf einer **modularen, selbst hostbaren Familien-App**, die sowohl für den produktiven Einsatz als auch als sauberes Open-Source-Lern- und Referenzprojekt geeignet ist.

Die Versionierung orientiert sich an klar abgegrenzten Meilensteinen mit wachsendem Nutzwert.

---

## 🧭 Leitprinzipien

- **Self-hosted first** (keine externen Abhängigkeiten notwendig)
- **Optional statt verpflichtend** (Firebase, OAuth, Push, etc.)
- **Modular & erweiterbar** (Feature-Toggles, klare Bounded Contexts)
- **Geteilte Domänenmodelle** (App ↔ API via `shared/`)
- **Saubere Rechte- & Rollenmodelle** als Fundament

---

## 🧪 Version 0.5 – Basis, Verwaltung & Konfiguration

> Ziel: Eine technisch vollständige, konfigurierbare und administrierbare Plattform schaffen.  
> Noch kein Fokus auf Endnutzer-Features, sondern auf **Stabilität, Erweiterbarkeit und Betrieb**.

### 🔐 Authentifizierung & Benutzerverwaltung

- Lokales Benutzermanagement
  - Benutzer-CRUD (Create, Read, Update, Delete)
  - Passwort-Hashing & sichere Speicherung
- JWT-basierte Authentifizierung
- Auswahl der Datenbank als Auth-Backend
  - SQLite
  - MongoDB
- Erstes Rollen- & Rechtemodell
  - z. B. `admin`, `user`, `guest`
  - Basis-Permissions (read/write/admin)

---

### 👮 Admin-Modus

- Separater Admin-Bereich (UI + API)
- Übersicht:
  - Benutzer
  - Rollen & Rechte
  - Feature-Konfiguration
  - Systemstatus
- Schutz über dedizierte Admin-Permissions

---

### 🧩 Konfiguration & Modularität

- Zentrale Konfigurationsstruktur (Server-seitig)
- Feature Toggles:
  - Aktivieren / Deaktivieren von Modulen
- Datenbank-Auswahl:
  - SQLite oder MongoDB
  - Einheitliche Repository-Abstraktionen

---

### 🔑 OAuth-Integration (optional)

- Konfigurierbarer OAuth-Provider
  - Authentik
  - Keycloak
  - Authelia
  - Erweiterbar
- Mapping auf internes Benutzer- & Rollenmodell
- Koexistenz mit lokalem JWT-Login

---

### 🔔 Firebase (optional)

- Optionales Hinterlegen einer Firebase-Konfiguration
- Pro Instanz / Betreiber konfigurierbar
- Features:
  - Firebase Cloud Messaging
  - Optional Crashlytics
- Kein Zwang zur Nutzung von Firebase

---

### 🪵 Logging, Monitoring & Support

- Persistentes Logging
  - API: Request-, Error- und Security-Logs
  - App: Client-seitige Logs
- Konfigurierbare Log-Level
- Optional:
  - Crashlytics-Integration (nur bei Firebase)
- Support-Features:
  - Automatische Erstellung strukturierter GitHub-Issues
  - Vorbefüllte Logs, App-Version, Plattform

---

### 🎯 Ergebnis von Version 0.5

- Vollständig lauffähige Self-Hosted-Plattform
- Administrierbar, sicher, konfigurierbar
- Technisches Fundament für alle weiteren Features

---

## ✅ Version 1.0 – Erste produktiv nutzbare Features

> Ziel: Casa wird im Alltag nutzbar und liefert echten Mehrwert für Familien.

---

### 📝 Todos & Einkaufslisten

- Todo-Listen
  - Persönlich & gemeinsam
  - Mehrere Listen pro Nutzer/Familie
- Multi-User-Unterstützung
  - Zuweisungen
  - Verantwortlichkeiten
- Features:
  - Ablaufdaten
  - Status (offen, erledigt, archiviert)
  - Prioritäten
  - Datei-Anhänge
- Benachrichtigungen:
  - Neue Aufgaben
  - Änderungen
  - Fälligkeiten

---

### 📅 Familien-Kalender

- Persönliche Termine
- Gemeinsame Familien-Termine
- Einladungen:
  - Nutzer einladen
  - Zu-/Absagen
- Benachrichtigungen:
  - Neue Termine
  - Änderungen
  - Erinnerungen
- Termin-Details:
  - Beschreibung
  - Ort / Zusatzinfos
- Vorbereitung für spätere Erweiterungen:
  - WYSIWYG-Editor für Beschreibungen

---

### 🎯 Ergebnis von Version 1.0

- Casa ist im Alltag einsetzbar
- Zentrale Funktionen für Organisation & Planung
- Solide UX für mehrere Nutzer

---

## 🍲 Version 2.0 – Rezepte & Küche

> Ziel: Erweiterung von Casa um ein inhaltliches Kernfeature für den Familienalltag.

---

### 📖 Rezepte-Management

- Erfassen von Rezepten:
  - Titel
  - Zutaten
  - Schritte
  - Bilder
  - Kategorien & Tags
- Bearbeiten & Löschen
- Gemeinsame Rezept-Sammlung

---

### 🔍 Rezepte-Browser

- Durchsuchen & Filtern
- Kategorien & Tags
- Favoriten
- Schnelle Übersicht

---

### 🍳 „Rezept kochen“-Modus

- Schritt-für-Schritt-Anzeige
- Abhaken von Schritten
- Fokus-Modus für Küche/Tablet
- Optional:
  - Mengenanpassung
  - Timer

---

### 🎯 Ergebnis von Version 2.0

- Casa als zentrale Familien-App für Organisation **und** Küche
- Hoher Alltagsnutzen

---

## 🗓️ Zeitlicher Rahmen

- **2026**
  - Version 0.5 → Fundament & Technik
  - Version 1.0 → Alltagstaugliche Kernfeatures
  - Version 2.0 → Inhaltliche Erweiterung (Rezepte)

---

## 🔮 Ausblick (nach 2.0)

- Wiki / Knowledge Base
- App- & Service-Hub (Self-Hosted Links)
- Dokumentenverwaltung
- Smart-Home-Readonly-Integrationen
- Erweiterte Rollen & Berechtigungen
- Plugin-/Modul-System

---

Diese Roadmap ist bewusst **ambitioniert, aber realistisch** gehalten und dient als Orientierung – nicht als starre Verpflichtung.