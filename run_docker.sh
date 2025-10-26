#!/bin/bash
set -e
echo "Starting Docker containers..."
if command -v docker-compose &> /dev/null; then
    docker-compose up -d
else
    docker compose up -d
fi
echo "✓ Containers started!"
echo "Backend: http://localhost:8000"