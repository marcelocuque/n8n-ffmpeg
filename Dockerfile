# Multi-stage: pega ffmpeg de imagem ubuntu-based (glibc) e copia para a imagem oficial do n8n
FROM jrottenberg/ffmpeg:6.0-ubuntu AS ffmpeg

FROM n8nio/n8n:latest

USER root

# copia somente os binários (e torná-los executáveis)
COPY --from=ffmpeg /usr/bin/ffmpeg /usr/bin/ffmpeg
COPY --from=ffmpeg /usr/bin/ffprobe /usr/bin/ffprobe
RUN chmod +x /usr/bin/ffmpeg /usr/bin/ffprobe || true

# voltar para usuário padrão da imagem n8n
USER node
WORKDIR /home/node

EXPOSE 5678

# iniciar n8n via CLI correto
CMD ["n8n"]
