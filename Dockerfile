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

COPY api/ api/
COPY shared/ shared/

WORKDIR /build/api
RUN dart pub get
RUN dart compile exe bin/server.dart -o /build/server

# ---------- Final Image ----------
FROM debian:bookworm-slim
WORKDIR /app

COPY --from=api-build /build/server /app/server
COPY --from=flutter-build /build/app/build/web /app/web

EXPOSE 8080
CMD ["/app/server"]