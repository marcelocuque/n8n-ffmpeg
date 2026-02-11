FROM n8nio/n8n:latest

# só para debug — retire depois
USER root
RUN cat /etc/os-release || true && \
    uname -a || true && \
    command -v apk || true && \
    command -v apt-get || true
