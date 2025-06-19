#!/bin/bash

echo "🔐 A senha do usuário 'vps' é: root"
echo "🔧 Iniciando sessão sshx..."
curl -sSf https://sshx.io/get | sh
exec sshx
