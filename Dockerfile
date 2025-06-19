FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Instala dependências
RUN apt-get update && apt-get install -y \
    curl \
    bash \
    sudo \
    openssh-client \
    iproute2 \
    net-tools \
    htop \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Cria um usuário não-root chamado "vps" com home
RUN useradd -ms /bin/bash vps \
    && echo "vps ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Copia o script de entrada
COPY entrypoint.sh /home/vps/entrypoint.sh
RUN chmod +x /home/vps/entrypoint.sh

# Muda para o usuário normal
USER vps
WORKDIR /home/vps

# Executa o script com sshx como usuário comum
CMD ["./entrypoint.sh"]
