# multi-stage: baixar release estático do ffmpeg e copiar para a imagem oficial do n8n
FROM debian:bookworm-slim AS downloader

# ferramentas para baixar e extrair o ffmpeg estático
RUN apt-get update \
 && apt-get install -y --no-install-recommends curl ca-certificates xz-utils \
 && rm -rf /var/lib/apt/lists/*

# baixar e extrair o ffmpeg estático (johnvansickle builds)
RUN curl -L -o /tmp/ffmpeg.tar.xz "https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz" \
 && tar -xJf /tmp/ffmpeg.tar.xz -C /tmp

# imagem final: imagem oficial do n8n
FROM n8nio/n8n:latest

USER root

# copia apenas os binários ffmpeg e ffprobe do estágio downloader
# o padrão do tar cria uma pasta com nome ffmpeg-*-amd64-static
COPY --from=downloader /tmp/ffmpeg-*-amd64-static/ffmpeg /usr/local/bin/ffmpeg
COPY --from=downloader /tmp/ffmpeg-*-amd64-static/ffprobe /usr/local/bin/ffprobe

RUN chmod +x /usr/local/bin/ffmpeg /usr/local/bin/ffprobe || true

# voltar para o usuário padrão (imagem oficial usa 'node' ou outro)
USER node
WORKDIR /home/node

EXPOSE 5678

# comando correto para iniciar n8n
CMD ["n8n"]
