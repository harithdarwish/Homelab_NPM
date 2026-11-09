#!/bin/bash
set -e

echo "=== Starting Docker & Docker Compose Installation for Debian 12 ==="

# 1. Add Docker's official GPG key:
echo "-> Adding Docker GPG key..."
apt update
apt install -y ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# 2. Add the repository to APT sources (Debian specific):
echo "-> Adding Docker repository to APT sources..."
tee /etc/apt/sources.list.d/docker.sources <<DEEOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "${VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
DEEOF

# 3. Update package index and install Docker + Compose plugin:
echo "-> Installing Docker Engine and Docker Compose..."
apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 4. Deploy Nginx Proxy Manager stack automatically
echo "=== Starting Nginx Proxy Manager Deployment ==="
if [ -f "docker-compose.yml" ]; then
    echo "-> Running docker compose up -d..."
    docker compose up -d
    echo "=== Nginx Proxy Manager Deployment Complete! ==="
else
    echo "Error: docker-compose.yml not found in the current directory!" >&2
    exit 1
fi
