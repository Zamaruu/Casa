
# ----------- BUILD STAGE -----------
FROM debian:bookworm-slim AS build

ENV FLUTTER_VERSION=3.38.5
ENV FLUTTER_HOME=/usr/local/flutter
ENV PATH="$FLUTTER_HOME/bin:$PATH"

RUN apt-get update && apt-get install -y \
    git curl unzip xz-utils zip libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/flutter/flutter.git -b $FLUTTER_VERSION $FLUTTER_HOME
# RUN flutter config --enable-web

WORKDIR /app

# Nur pubspec reinwerfen und Abhängigkeiten laden
COPY pubspec.* ./
RUN flutter pub get

# Jetzt erst den Rest
COPY . .

# Sicherheitshalber: Alte Artefakte killen
RUN rm -rf .dart_tool build
RUN flutter clean
RUN flutter pub get
RUN flutter build web --release

# ----------- RUNTIME STAGE -----------
FROM nginx:alpine AS runtime

RUN rm -rf /usr/share/nginx/html/*
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
