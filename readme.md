# Casa 🏡

**Casa** ist eine private, familieninterne Mobile- und Web-Applikation zur Organisation des Alltags.  
Ziel des Projekts ist es, eine modulare, skalierbare und moderne Full-Stack-Anwendung mit **Flutter** (Frontend) und **Dart/Shelf** (Backend) zu entwickeln – mit Fokus auf Lernfortschritt, sauberer Architektur und Wiederverwendbarkeit von Code.

Die App ist ausschließlich für den privaten Gebrauch innerhalb der Familie gedacht.

---

## 🎯 Ziele des Projekts

- Entwicklung einer **gemeinsamen Familien-App**
- Zentrale Funktionen:
    - 📅 Gemeinsamer Kalender
    - ✅ Todos / Aufgaben
    - 🍲 Rezepte
- **Frontend & Backend in Dart**
- **Code-Sharing** zwischen App und API (Models, Contracts)
- Moderne Architektur (Clean-ish, Feature-first)
- OAuth2-basierte Authentifizierung über bestehende **Authentik**-Instanz
- Responsive UI (Mobile, Tablet, Web, Desktop)
- Docker-basiertes Deployment

---

## 🧱 Projektaufbau

Das Repository ist als **Monorepo** aufgebaut:

```text
/
├─ app/            # Flutter App (Mobile & Web)
├─ api/            # Dart Backend (Shelf)
├─ shared/         # Geteilter Code (Models, Contracts, DTOs)
│
├─ docker-compose.yml
├─ Dockerfile.api
├─ Dockerfile.app
├─ README.md
```

### 📦 Shared Package (shared/)
Beinhaltet plattformneutrale Domänenlogik, die von App und API genutzt wird.

```text
shared/lib/
├─ models/         # Domain Models (Todo, CalendarEvent, Recipe, User, …)
├─ dtos/           # API DTOs (Requests / Responses)
├─ contracts/      # API Contracts / Interfaces
└─ utils/          # Reine Helper (Validation, Parsing, etc.)
```

### 📱 App (app/)

Flutter App für Mobile & Web.

Architekturprinzipien
- Feature-first
- Trennung von:
 - UI (Presentation)
 - State (Riverpod)
 - Infrastruktur (API, Auth, Storage)
- Adaptive Navigation (Drawer / NavigationRail)
- Zentrales CasaScaffold
- 
```text
app/lib/src/
├─ app/            # App-Setup (Theme, Router, App Widget)
├─ core/           # App-weite Infrastruktur (Auth, API, DI)
├─ features/       # Fachliche Features (todos, calendar, recipes)
├─ shared_widgets/ # Wiederverwendbare UI-Komponenten
```

**Wichtige Technologien**
- Flutter (Material 3)
- GoRouter (Navigation)
- Riverpod (State Management)
- get_it (Dependency Injection)

### 🌐 API (api/)

Backend-API auf Basis von **Dart + Shelf**.

**Aufgaben**
- OAuth2-Authentifizierung (z.B. Authentik)
- REST-API für App
- Validierung & Business Logic
- Zugriff auf Datenbank / Services (später)

```text
api/lib/src/
├─ server.dart
├─ middleware/     # Auth, Logging, Error Handling
├─ routes/         # Feature-Routen
├─ services/       # Business Logic
└─ repositories/  # Datenzugriff
```
