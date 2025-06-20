FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Instala XFCE, VNC, noVNC, etc.
RUN apt-get update && apt-get install -y \
  xfce4 xfce4-goodies x11vnc xvfb \
  wget net-tools curl \
  supervisor git python3 python3-pip \
  novnc websockify \
  && apt-get clean

# Cria usuário padrão
RUN useradd -m ubuntu && echo 'ubuntu:ubuntu' | chpasswd

# Define resoluções e configurações do VNC
ENV DISPLAY=:1
ENV RESOLUTION=1280x800

# Copia o script de inicialização
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expõe porta padrão do Railway (noVNC via web)
EXPOSE 80

CMD ["/start.sh"]
