# stage que contém ffmpeg (alpine-based)
FROM jrottenberg/ffmpeg:6.0-alpine AS ffmpeg

# sua imagem base (n8n)
FROM n8nio/n8n:latest

USER root

# copia os binários e libs do ffmpeg (cobre /usr/bin, /usr/lib)
COPY --from=ffmpeg /usr/bin /usr/bin
COPY --from=ffmpeg /usr/lib /usr/lib

RUN chmod +x /usr/bin/ffmpeg /usr/bin/ffprobe || true

USER node
