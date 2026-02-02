# ---------- Flutter Build ----------
FROM ghcr.io/cirruslabs/flutter:stable AS flutter-build
WORKDIR /build/app
COPY app/ .
COPY shared/ ../shared
RUN flutter pub get
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

COPY api/ api/
COPY shared/ shared/

WORKDIR /build/api
RUN dart pub get
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
COPY --from=flutter-build /build/app/build/web /app/web

EXPOSE 8080
CMD ["/app/server"]