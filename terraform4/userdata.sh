#!/bin/bash
set -euxo pipefail

# Install Docker (same approach as terraform3)
curl -fsSL https://get.docker.com | sh
systemctl enable --now docker

# Make sure the Compose plugin is available for `docker compose`
if ! docker compose version >/dev/null 2>&1; then
  DEBIAN_FRONTEND=noninteractive apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get install -y docker-compose-plugin
fi

# Allow SSM sessions to use Docker without sudo
id ssm-user &>/dev/null || useradd -m ssm-user
usermod -aG docker ssm-user
id ubuntu &>/dev/null && usermod -aG docker ubuntu || true

# Deploy Rackula with server-side persistence.
# UI/nginx listens on 8080; the API listens on 3001 internally and is not
# published on the host (see deploy/docker-compose.persist.yml).
mkdir -p /opt/rackula/data
cd /opt/rackula
curl -fsSL https://raw.githubusercontent.com/RackulaLives/Rackula/main/deploy/docker-compose.persist.yml -o docker-compose.yml
chown -R 1001:1001 /opt/rackula/data
docker compose up -d
