FROM ubuntu:22.04

# Evita prompts interativos
ENV DEBIAN_FRONTEND=noninteractive

# Instalar curl, bash e outras ferramentas básicas
RUN apt-get update && apt-get install -y \
    curl \
    bash \
    sudo \
    iproute2 \
    net-tools \
    htop \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Copiar script de entrada
COPY entrypoint.sh /entrypoint.sh

# Dar permissão de execução
RUN chmod +x /entrypoint.sh

# Executar o script ao iniciar o container
CMD ["/entrypoint.sh"]
