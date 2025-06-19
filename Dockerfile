FROM ubuntu:latest

# Instalar curl e bash (precisa para o script)
RUN apt-get update && apt-get install -y curl bash && rm -rf /var/lib/apt/lists/*

# Copiar o script para o container
COPY start.sh /start.sh

# Dar permissão de execução ao script
RUN chmod +x /start.sh

# Rodar o script quando o container iniciar
CMD ["/start.sh"]
