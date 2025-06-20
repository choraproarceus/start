FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    qemu-system-x86 \
    qemu-utils \
    cloud-image-utils \
    genisoimage \
    curl \
    unzip \
    openssh-client \
    openssh-server \
    net-tools \
    netcat-openbsd \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /data /opt/qemu /cloud-init /var/run/sshd

# Baixa a imagem do Ubuntu
RUN curl -L https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img \
    -o /opt/qemu/ubuntu.img

# Prepara arquivos de cloud-init
RUN echo "instance-id: ubuntu-vm\nlocal-hostname: ubuntu-vm" > /cloud-init/meta-data

RUN printf "#cloud-config\n\
preserve_hostname: false\n\
hostname: ubuntu-vm\n\
users:\n\
  - name: root\n\
    gecos: root\n\
    shell: /bin/bash\n\
    lock_passwd: false\n\
    passwd: \$6\$abcd1234\$W6wzBuvyE.D1mBGAgQw2uvUO/honRrnAGjFhMXSk0LUbZosYtoHy1tUtYhKlALqIldOGPrYnhSrOfAknpm91i0\n\
    sudo: ALL=(ALL) NOPASSWD:ALL\n\
disable_root: false\n\
ssh_pwauth: true\n\
chpasswd:\n\
  list: |\n\
    root:root\n\
  expire: false\n\
runcmd:\n\
  - systemctl enable ssh\n\
  - systemctl restart ssh\n" > /cloud-init/user-data

RUN genisoimage -output /opt/qemu/seed.iso -volid cidata -joliet -rock \
    /cloud-init/user-data /cloud-init/meta-data

# Instala o SSHX corretamente
RUN curl -sSf https://sshx.io/get | sh

# Script de inicialização
RUN cat <<'EOF' > /start.sh
#!/bin/bash
set -e

DISK="/data/vm.raw"
IMG="/opt/qemu/ubuntu.img"
SEED="/opt/qemu/seed.iso"

if [ ! -f "$DISK" ]; then
    echo "Creating VM disk..."
    qemu-img convert -f qcow2 -O raw "$IMG" "$DISK"
    qemu-img resize "$DISK" 50G
fi

# Start QEMU without KVM
qemu-system-x86_64 \
    -cpu qemu64 \
    -smp 2 \
    -m 4096 \
    -drive file="$DISK",format=raw,if=virtio \
    -drive file="$SEED",format=raw,if=virtio \
    -netdev user,id=net0,hostfwd=tcp::2222-:22 \
    -device virtio-net,netdev=net0 \
    -nographic \
    -daemonize

# Espera SSH da VM iniciar
for i in {1..30}; do
  nc -z localhost 2222 && echo "✅ VM is ready!" && break
  echo "⏳ Waiting for SSH..."
  sleep 2
done

# Inicia sessão SSHX apontando para a porta SSH da VM
echo "🔗 Starting SSHX session..."
sshx --forward localhost:2222 --name ubuntu-vm
EOF

RUN chmod +x /start.sh

# IMPORTANTE: Railway vai montar o volume externo aqui
# Ponto de montagem persistente: /data
# Configure isso no painel da Railway (Deploy > Volumes)

EXPOSE 2222

CMD ["/start.sh"]
