#!/bin/bash
set -e

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_DIR="./backups/$TIMESTAMP"
mkdir -p "$BACKUP_DIR"

echo "== Backup of Postgres =="
docker run --rm \
  -v postgres_data:/data \
  -v $(pwd)/"$BACKUP_DIR":/backup \
  alpine tar czf /backup/postgres_data.tar.gz -C /data .

echo "== Backup of n8n =="
tar czf "$BACKUP_DIR/n8n_data.tar.gz" ./data/n8n

echo "Backup completed in $BACKUP_DIR"
