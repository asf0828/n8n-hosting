#!/bin/bash

set -e

BACKUP_DIR="$1"

if [ -z "$BACKUP_DIR" ]; then
  echo "Usage: ./restore.sh <backup-folder>"
  exit 1
fi

echo "== Stopping containers =="
docker compose down

echo "== Restoring Postgres data =="
docker volume create n8n-hosting_postgres_data >/dev/null

docker run --rm \
  -v n8n-hosting_postgres_data:/volume \
  -v "$PWD/$BACKUP_DIR:/backup" \
  alpine sh -c "rm -rf /volume/* && tar xzf /backup/postgres_data.tar.gz -C /volume"

echo "== Restoring n8n data =="
docker volume create n8n-hosting_n8n_data >/dev/null

docker run --rm \
  -v n8n-hosting_n8n_data:/volume \
  -v "$PWD/$BACKUP_DIR:/backup" \
  alpine sh -c "rm -rf /volume/* && tar xzf /backup/n8n_data.tar.gz -C /volume"

echo "== Starting containers =="
docker compose up -d

echo "== Restore completed successfully =="
