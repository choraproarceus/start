#!/bin/bash

# Exibe hostname e IP (opcional, ajuda na identificação)
echo "🔧 Container iniciado:"
hostname
ip a

# Executa o SSHX para abrir o terminal remoto
curl -sSf https://sshx.io/get | sh -s run
