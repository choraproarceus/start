FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Instala pacotes básicos
RUN apt-get update && apt-get install -y \
    curl \
    bash \
    sudo \
    openssh-client \
    net-tools \
    iproute2 \
    passwd \
    vim \
    htop \
    && rm -rf /var/lib/apt/lists/*

# Cria usuário vps e define senha
RUN useradd -ms /bin/bash vps \
    && echo 'vps:root' | chpasswd \
    && echo 'vps ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Copia script de entrada
COPY entrypoint.sh /home/vps/entrypoint.sh
RUN chown vps:vps /home/vps/entrypoint.sh && chmod +x /home/vps/entrypoint.sh

# Muda para o usuário normal
USER vps
WORKDIR /home/vps

# Roda sshx como o usuário normal
CMD ["./entrypoint.sh"]
