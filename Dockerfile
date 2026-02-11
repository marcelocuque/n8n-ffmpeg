FROM node:18-bullseye-slim

USER root

# instalar ffmpeg e dependências mínimas
RUN apt-get update \
 && apt-get install -y --no-install-recommends ffmpeg ca-certificates curl build-essential \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# instalar n8n globalmente
RUN npm install -g n8n

# usar usuário 'node' (já existe na imagem)
USER node
WORKDIR /home/node

# expor porta padrão do n8n
EXPOSE 5678

# start padrão do n8n (note: somente "n8n")
CMD ["n8n"]
