# Casa - Architecture

This document describes the current architecture of Casa and the preferred development patterns.

## 1) High-level overview

Casa is a Dart/Flutter monorepo with three main packages:

- `app/`: Flutter client (Web/Mobile)
- `api/`: Dart backend using Shelf
- `shared/`: shared contracts, models, enums, and utility logic used by app and API

The current structure is package-path based (`../shared` in `pubspec.yaml`) and built as a single repository.

## 2) Repository structure

```text
/
├─ app/                       # Flutter UI + client logic
│  └─ lib/src/
│     ├─ app/                 # app setup (theme, abstracts)
│     ├─ core/                # infrastructure (api, auth, router, services, models)
│     ├─ features/            # feature-first modules (auth, user, logs, settings, ...)
│     └─ widgets/             # reusable UI widgets
├─ api/                       # Shelf API
│  └─ lib/src/
│     ├─ config/              # env/config loading
│     ├─ controllers/         # endpoint controllers
│     ├─ middleware/          # auth/headers
│     ├─ database/            # db service + implementations
│     ├─ services/            # app services (auth, logs, startup)
│     ├─ abstract/            # shared base classes for controller/repository
│     └─ models/              # API-specific models
├─ shared/                    # shared package
│  └─ lib/src/
│     ├─ interfaces/          # package-wide contracts
│     ├─ models/              # shared domain/data objects
│     ├─ enums/               # shared enums
│     ├─ abstract/            # reusable abstract classes
│     └─ services/            # shared service implementations
└─ docs/                      # project documentation
```

## 3) Architectural patterns in use

### 3.1 Monorepo with shared domain contracts

- Shared types are centralized in `shared/` and reused in `app/` and `api/`.
- This reduces DTO drift and keeps client/server contracts aligned.

### 3.2 Feature-first frontend organization

- The app groups code by feature under `app/lib/src/features/*`.
- Feature modules typically contain:
  - `api/` (feature API client)
  - `data/` (repos/providers/interfaces)
  - `routes/` (navigation entry)
  - `widgets/` (feature-specific UI)

### 3.3 Layered backend architecture

- Request flow:
  - Shelf pipeline/middleware (`api/lib/src/core/pipeline.dart`)
  - controllers (`api/lib/src/controllers/*`)
  - service/repository operations (`api/lib/src/services/*`, `api/lib/src/database/*`)
- Public and protected routes are assembled centrally in `api/lib/src/controllers/controller_builder.dart`.

### 3.4 Dependency injection via `get_it`

- API DI root: `api/lib/src/services/service_locator.dart`
- App DI root: `app/lib/src/core/services/service_locator.dart`
- Startup wiring happens in:
  - `api/lib/src/services/service_initializer.dart`
  - `app/lib/src/core/services/service_initializer.dart`

### 3.5 Interface-first coding style

- Interfaces are explicit and commonly prefixed with `I*`.
- Concrete classes are swappable behind contracts (especially for operations/repositories/auth).

### 3.6 Response/result wrapper pattern

- Shared response types are used (`Response`, `ValueResponse`, `MultiResponse`, etc.).
- This keeps success/error handling consistent across layers.

## 4) Runtime flow summary

### 4.1 API

1. Load config from environment (`ConfigLoader`).
2. Initialize database, logging, auth, and services (`ServiceInitializer`).
3. Build Shelf pipeline with middleware and route groups.
4. Serve API endpoints and static web assets from the same process.

### 4.2 App

1. Load platform-aware app config (`AppConfigLoader`).
2. Initialize token provider + API service manager.
3. Start router and feature providers.
4. Call API via typed client/repository layers.

## 5) Best practices for contributors

- Keep shared contracts in `shared/`; avoid duplicating models in `app/` and `api/`.
- Add new functionality as a feature module first, not as cross-cutting loose files.
- Program against interfaces (`I*`) and register implementations in service initializer/locator.
- Preserve clear boundaries:
  - UI code in widgets/routes
  - business/data orchestration in repositories/services
  - transport concerns in api client/controller layers
- Keep controllers thin; move non-trivial logic into services/operations.
- Reuse shared response wrappers and error handling patterns.
- Regenerate code with `build_runner` after annotation/model changes.
- Update docs in `docs/` when adding/changing architecture-critical components.

## 6) Planned migration to `melos`

A coming release will migrate the monorepo workflow to `melos` CLI.

Planned goals:

- Standardized workspace bootstrap (single command to install all package deps)
- Centralized scripts for analyze/test/build/codegen across packages
- Consistent developer commands and CI workflows
- Easier scaling as package count and feature modules grow

Expected impact:

- Project structure (`app/`, `api/`, `shared/`) remains conceptually the same.
- Tooling/automation commands will move from ad-hoc per-package commands to `melos` scripts.
- Documentation in `docs/getstarted.md` will be updated when migration is released.
