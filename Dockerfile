# (debug) imprime versão do ffmpeg para confirmar instalação durante build
# stage downloader (já presente no seu repo) — mantenha como antes
# (este Dockerfile assume que o estágio 'downloader' já existe no seu repo original)
# Se houver diferenças, isto apenas adiciona um RUN de verificação no final.

FROM n8nio/n8n:latest

USER root

# tenta checar ambos os caminhos possíveis e imprime resultado
RUN if [ -x /usr/local/bin/ffmpeg ]; then \
      echo '--- ffmpeg via /usr/local/bin/ffmpeg ---' && /usr/local/bin/ffmpeg -version || true; \
    elif command -v ffmpeg >/dev/null 2>&1; then \
      echo '--- ffmpeg no PATH ---' && ffmpeg -version || true; \
    else \
      echo '--- ffmpeg NÃO ENCONTRADO ---'; \
    fi

USER node
