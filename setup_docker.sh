#!/bin/bash
set -e
echo "Building Docker containers..."
if command -v docker-compose &> /dev/null; then
    docker-compose build --no-cache
else
    docker compose build --no-cache
fi
echo "✓ Build complete!"