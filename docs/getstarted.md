# Casa - Get Started

This guide helps developers quickly pull the project, run it locally, and deploy it with Docker.

## Documentation

- [Architecture](architecture.md)

## 1) Prerequisites

- `git`
- `dart` SDK `3.10.x` (API + shared)
- `flutter` `3.38.x` (app)
- Optional for deployment/containerized runs: `docker` + `docker compose`
- Access to a MongoDB instance

## 2) Pull the code

Clone once:

```bash
git clone <your-repo-url> casa
cd casa
```

Update an existing checkout:

```bash
git pull --rebase
```

## 3) Configure environment

Create or update `.env` in the repo root.

Required variables:

```env
LOG_LEVEL=info
ENABLE_OPENAPI=true

DB_TYPE=mongodb
DB_CONNECTION_STRING=mongodb://<user>:<password>@<host>:27017/casa?authSource=admin

JWT_SECRET=<very-long-random-secret>
JWT_EXPIRES_IN=48
```

Notes:

- `JWT_EXPIRES_IN` is in hours.
- `DB_CONNECTION_STRING` must point to a reachable MongoDB.

## 4) Local development

### 4.1 Install dependencies

```bash
cd shared && dart pub get
cd ../api && dart pub get
cd ../app && flutter pub get
cd ..
```

### 4.2 (Optional) Regenerate code

Run this after model/config annotation changes.

```bash
cd shared && dart run build_runner build --delete-conflicting-outputs
cd ../api && dart run build_runner build --delete-conflicting-outputs
cd ../app && dart run build_runner build --delete-conflicting-outputs
cd ..
```

### 4.3 Start API

```bash
cd api
dart run bin/server.dart
```

API runs on `http://localhost:8080` by default.

### 4.4 Start Flutter app (web)

In a second terminal:

```bash
cd app
flutter run -d chrome
```

In debug web mode, the app targets `http://<browser-host>:8080/api`, so keep the API running on port `8080`.

## 5) Run tests

```bash
cd shared && dart test
cd ../api && dart test
cd ../app && flutter test
```

## 6) Deploy with Docker

### Option A: Build and run locally (dev compose)

Uses `docker-compose-dev.yaml` and `.env`:

```bash
docker compose -f docker-compose-dev.yaml up --build -d
```

This maps container port `8080` to host port `8088`.

### Option B: Run prebuilt image

`docker-compose.yaml` points to `ghcr.io/zamaruu/casa:tag`.
Update `tag` first, then run:

```bash
docker compose -f docker-compose.yaml up -d
```

This maps container port `8080` to host port `8080`.

## 7) Common troubleshooting

- API fails on startup: check `.env` values, especially `DB_CONNECTION_STRING` and `JWT_SECRET`.
- App cannot reach API: verify API is running and reachable on port `8080`.
- Docker container exits: check logs with `docker compose logs -f`.
