# Multi-stage: baixa um ffmpeg estático e copia para a imagem oficial do n8n
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

# temporariamente root para copiar binários e ajustar permissões
USER root

# copia apenas os binários ffmpeg e ffprobe do estágio downloader
COPY --from=downloader /tmp/ffmpeg-*-amd64-static/ffmpeg /usr/local/bin/ffmpeg
COPY --from=downloader /tmp/ffmpeg-*-amd64-static/ffprobe /usr/local/bin/ffprobe

RUN chmod +x /usr/local/bin/ffmpeg /usr/local/bin/ffprobe || true

# volta ao usuário padrão (a imagem oficial usa um usuário não-root)
USER node
WORKDIR /home/node

# NOTA: não definimos CMD/ENTRYPOINT aqui — usamos o entrypoint da imagem oficial
EXPOSE 5678

# start usando a variável PORT que você definirá no Render
CMD ["sh", "-lc", "n8n start --port $PORT"]