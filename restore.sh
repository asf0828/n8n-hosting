#!/bin/bash
set -e

if [ -z "$1" ]; then
  echo "Usage: ./restore.sh <backup_directory>"
  echo "Example: ./restore.sh backups/2025-01-20_10-22-11"
  exit 1
fi

BACKUP_DIR="$1"

if [ ! -d "$BACKUP_DIR" ]; then
  echo "ERROR: Backup directory $BACKUP_DIR does not exist."
  exit 1
fi

POSTGRES_BACKUP="$BACKUP_DIR/postgres_data.tar.gz"
N8N_BACKUP="$BACKUP_DIR/n8n_data.tar.gz"

if [ ! -f "$POSTGRES_BACKUP" ] || [ ! -f "$N8N_BACKUP" ]; then
  echo "ERROR: Backup directory $BACKUP_DIR does not contain the files postgres_data.tar.gz and n8n_data.tar.gz"
  exit 1
fi

echo "== Stopping containers =="
docker compose down || true

echo "== Restoring Postgres volume =="

# Create volume if it doesn't exist
docker volume create postgres_data >/dev/null 2>&1 || true

# Empty volume and restore with Alpine
docker run --rm \
  -v postgres_data:/data \
  -v $(pwd)/"$BACKUP_DIR":/backup \
  alpine sh -c "
    rm -rf /data/* &&
    tar xzf /backup/postgres_data.tar.gz -C /data
  "

echo "== Restoring n8n data =="
mkdir -p ./data/n8n
rm -rf ./data/n8n/*

tar xzf "$N8N_BACKUP" -C ./data/n8n

echo "== Starting containers =="
docker compose up -d

echo "== Restore completed successfully =="
