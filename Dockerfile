# Dockerfile: n8n + ffmpeg (base Debian via Node official image)
FROM node:18-bullseye-slim

# criar usuário não-root (opcional, mas recomendado)
RUN useradd -m -u 1000 n8n

USER root
RUN apt-get update \
 && apt-get install -y --no-install-recommends ffmpeg ca-certificates curl \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# instala n8n globalmente (versão estável)
RUN npm install -g n8n

# use usuário não-root
USER n8n
WORKDIR /home/n8n

EXPOSE 5678

# Comando padrão para iniciar n8n (ajuste flags/variáveis se precisar)
CMD ["n8n", "start"]
