#!/bin/bash

set -e

BACKUP_DIR="backups/$(date +%Y-%m-%d_%H-%M-%S)"
mkdir -p "$BACKUP_DIR"

echo "== Backing up Postgres volume =="
docker run --rm \
  -v n8n-hosting_postgres_data:/volume \
  -v "$PWD/$BACKUP_DIR:/backup" \
  alpine sh -c "cd /volume && tar czf /backup/postgres_data.tar.gz ."

echo "== Backing up n8n data volume =="
docker run --rm \
  -v n8n-hosting_n8n_data:/volume \
  -v "$PWD/$BACKUP_DIR:/backup" \
  alpine sh -c "cd /volume && tar czf /backup/n8n_data.tar.gz ."

echo "Backup created in: $BACKUP_DIR"
