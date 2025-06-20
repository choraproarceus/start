#!/bin/bash

# Inicia display virtual
Xvfb :1 -screen 0 ${RESOLUTION}x24 &

# Espera o X iniciar
sleep 2

# Inicia o XFCE
su - ubuntu -c "startxfce4 &"

# Inicia o VNC (sem senha)
x11vnc -display :1 -forever -nopw -shared -bg

# Inicia o noVNC na porta 80
websockify --web=/usr/share/novnc/ 80 localhost:5900
