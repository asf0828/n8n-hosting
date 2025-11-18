#!/bin/sh
set -e

if [ "${ENV}" = "development" ]; then
  exec /docker-entrypoint.sh start --tunnel
else
  exec /docker-entrypoint.sh start
fi
