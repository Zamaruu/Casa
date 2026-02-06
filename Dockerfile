# ---------- Flutter Build ----------
FROM ghcr.io/cirruslabs/flutter:stable AS flutter-build
WORKDIR /build

# --- Shared ---
COPY shared/ /build/shared
WORKDIR /build/shared
RUN flutter pub get
RUN dart run build_runner build --delete-conflicting-outputs

# --- App ---
COPY app/ /build/app
WORKDIR /build/app
RUN flutter pub get
RUN dart run build_runner build --delete-conflicting-outputs
RUN flutter build web --release


# ---------- API Build ----------
FROM dart:stable AS api-build
WORKDIR /build

# Arguments for versioning
ARG BUILD_DATE
ARG COMMIT
ARG BRANCH
ARG ENVIRONMENT
ARG VERSION
ARG MINIMUM_APP_VERSION

# --- Shared ---
COPY shared/ /build/shared
WORKDIR /build/shared
RUN dart pub get
RUN dart run build_runner build --delete-conflicting-outputs

# --- API ---
COPY api/ /build/api
COPY api/openapi/openapi.json /build/api/openapi/openapi.json
WORKDIR /build/api
RUN dart pub get
RUN dart run build_runner build --delete-conflicting-outputs

RUN dart compile exe bin/server.dart \
  -DBUILD_DATE="${BUILD_DATE}" \
  -DCOMMIT="${COMMIT}" \
  -DBRANCH="${BRANCH}" \
  -DENVIRONMENT="${ENVIRONMENT}" \
  -DVERSION="${VERSION}" \
  -DMINIMUM_APP_VERSION="${MINIMUM_APP_VERSION}" \
  -o /build/server

# ---------- Final Image ----------
FROM debian:bookworm-slim
WORKDIR /app

COPY --from=api-build /build/server /app/server
COPY --from=api-build /build/api/openapi/openapi.json /app/openapi/openapi.json
COPY --from=flutter-build /build/app/build/web /app/web


EXPOSE 8080
CMD ["/app/server"]