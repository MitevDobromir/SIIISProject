#!/bin/bash
set -e
echo "Stopping Docker containers..."
if command -v docker-compose &> /dev/null; then
    docker-compose down
else
    docker compose down
fi
echo "✓ Containers stopped"