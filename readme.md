# Casa

Casa is a private family-oriented web and mobile application for organizing everyday life.
It is built as a Dart monorepo with a Flutter frontend, a Shelf-based backend API, and a shared package for common contracts and models.

## Documentation

- [Get Started](docs/getstarted.md)
- [Architecture](docs/architecture.md)
- [Roadmap](roadmap.md)

## Goals

- Build a shared family app with modular features
- Implement core domains such as todos, calendar, and recipes
- Keep frontend and backend in Dart for high code consistency
- Share contracts and models across app and API via `shared/`
- Support responsive UX for web and mobile
- Provide straightforward Docker-based deployment

## Repository Structure

```text
/
├─ app/                      # Flutter app (web/mobile)
├─ api/                      # Dart Shelf API
├─ shared/                   # Shared models, interfaces, enums, utilities
├─ docs/                     # Project documentation
├─ docker-compose.yaml
├─ docker-compose-dev.yaml
├─ Dockerfile
└─ readme.md
```

## Architecture Summary

- `app/` uses a feature-first structure with clear separation between UI, routing, state, and data access.
- `api/` uses a layered approach: middleware -> controllers -> services/operations -> database adapters.
- `shared/` contains reusable contracts, models, response wrappers, and enums used by both app and API.
- Dependency injection is handled with `get_it` in app and API startup flows.

For full details, see [Architecture](docs/architecture.md).

## Quick Start

For full setup and deployment instructions, see [Get Started](docs/getstarted.md).

Typical local development flow:

```bash
cd shared && dart pub get
cd ../api && dart pub get
cd ../app && flutter pub get

cd ../api && dart run bin/server.dart
# in another terminal
cd ../app && flutter run -d chrome
```

## Deploy via GitHub Docker Image

This repository builds and publishes a Docker image to GitHub Container Registry (`ghcr.io`) through `.github/workflows/docker.yaml`.

Publishing behavior:

- A new image is pushed on every `push` to `develop`.
- A new image is pushed on every `push` to `main`.
- Pull requests are covered after merge, when the target branch (`develop` or `main`) receives the push.

Published tags:

- `ghcr.io/zamaruu/casa:sha-<commit_sha>`
- `ghcr.io/zamaruu/casa:<version>.dev` for `develop` pushes
- `ghcr.io/zamaruu/casa:<version>` for `main` pushes

### Option A: Use Docker Compose

Update the image tag in `docker-compose.yaml`:

```yaml
services:
  casa:
    image: ghcr.io/zamaruu/casa:<tag>
```

Then deploy:

```bash
docker compose -f docker-compose.yaml up -d
```

### Option B: Run image directly

```bash
docker run -d \
  --name casa \
  -p 8080:8080 \
  -e LOG_LEVEL=info \
  -e DB_TYPE=mongodb \
  -e DB_CONNECTION_STRING='mongodb://<user>:<password>@<host>:27017/casa?authSource=admin' \
  -e JWT_SECRET='<very-long-random-secret>' \
  -e JWT_EXPIRES_IN=48 \
  ghcr.io/zamaruu/casa:<tag>
```

## Planned Workspace Migration

In a coming release, this repository will migrate to a `melos`-based workspace workflow.
The package boundaries (`app/`, `api/`, `shared/`) will remain, while bootstrap/build/test/analyze/codegen commands will be standardized through `melos` scripts.
