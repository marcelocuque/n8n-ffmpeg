# stage que contém ffmpeg (alpine-based)
FROM jrottenberg/ffmpeg:6.0-alpine AS ffmpeg

# sua imagem base (n8n)
FROM n8nio/n8n:latest

USER root

# copia os binários ffmpeg/ffprobe da imagem anterior
COPY --from=ffmpeg /usr/bin/ffmpeg /usr/bin/ffmpeg
COPY --from=ffmpeg /usr/bin/ffprobe /usr/bin/ffprobe

RUN chmod +x /usr/bin/ffmpeg /usr/bin/ffprobe || true

USER node
