# Stage que baixa o FFmpeg estático (debian)
FROM debian:bookworm-slim AS downloader

RUN apt-get update \
 && apt-get install -y --no-install-recommends curl xz-utils ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# baixa release estática do John Van Sickle e extrai em /tmp
RUN curl -L -o /tmp/ffmpeg.tar.xz "https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz" \
 && tar -xJf /tmp/ffmpeg.tar.xz -C /tmp

# Imagem final (n8n)
FROM n8nio/n8n:latest

USER root

# copia os binários ffmpeg/ffprobe para /usr/local/bin
COPY --from=downloader /tmp/ffmpeg-*-amd64-static/ffmpeg /usr/local/bin/ffmpeg
COPY --from=downloader /tmp/ffmpeg-*-amd64-static/ffprobe /usr/local/bin/ffprobe

# garante permissão e cria symlinks comuns, e imprime a versão (DEBUG)
RUN chmod +x /usr/local/bin/ffmpeg /usr/local/bin/ffprobe \
 && ln -sf /usr/local/bin/ffmpeg /usr/bin/ffmpeg || true \
 && ln -sf /usr/local/bin/ffprobe /usr/bin/ffprobe || true \
 && echo '--- ffmpeg version check ---' \
 && /usr/local/bin/ffmpeg -version || true

USER node
