#!/bin/bash

echo "🔧 Instalando sshx..."
curl -sSf https://sshx.io/get | sh

echo "🚀 Iniciando sessão sshx como usuário comum..."
exec sshx
