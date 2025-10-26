#!/bin/bash
set -e

command -v docker-compose &> /dev/null && COMPOSE="docker-compose" || COMPOSE="docker compose"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

success() { echo -e "${GREEN}$1${NC}"; }
info() { echo -e "${YELLOW}$1${NC}"; }
error() { echo -e "${RED}$1${NC}"; }

build() {
    echo "Building containers..."
    $COMPOSE build --no-cache
    echo ""
    success "Build complete"
    info "Next: ./app.sh start"
}

start_backend() {
    echo "Starting backend..."
    $COMPOSE up -d
    sleep 5
    echo ""
    success "Backend running"
    echo "  API: http://localhost:8000/api/todos/"
    echo ""
}

start_frontend() {
    [ ! -d "frontend" ] && { error "frontend directory not found"; exit 1; }
    cd frontend
    echo ""
    success "Frontend running: http://localhost:3000"
    info "Press Ctrl+C to stop"
    echo ""
    python3 -m http.server 3000
}

start_all() {
    echo "Starting everything..."
    $COMPOSE up -d
    sleep 5
    cd frontend
    python3 -m http.server 3000 > /dev/null 2>&1 &
    FRONTEND_PID=$!
    cd ..
    echo ""
    success "Everything running"
    echo "  Frontend: http://localhost:3000"
    echo "  API:      http://localhost:8000/api/todos/"
    echo ""
    info "Press Ctrl+C to stop"
    trap "echo ''; echo 'Stopping...'; kill $FRONTEND_PID 2>/dev/null; $COMPOSE down; echo 'Stopped'; exit" INT
    wait $FRONTEND_PID
}

stop() {
    echo "Stopping..."
    pkill -f "python3 -m http.server 3000" 2>/dev/null || true
    $COMPOSE down
    echo ""
    success "Stopped"
}

status() {
    echo "Containers:"
    $COMPOSE ps
    echo ""
    echo "Frontend:"
    pgrep -f "python3 -m http.server 3000" > /dev/null && success "Running" || info "Not running"
    echo ""
}

logs() {
    $COMPOSE logs --tail=50 -f
}

restart() {
    stop
    sleep 2
    start_all
}

show_help() {
    echo ""
    echo "Usage: ./app.sh [command]"
    echo ""
    echo "Commands:"
    echo "  build      Build containers"
    echo "  start      Start everything"
    echo "  stop       Stop everything"
    echo "  backend    Start backend only"
    echo "  frontend   Start frontend only"
    echo "  status     Show status"
    echo "  logs       View logs"
    echo "  restart    Restart"
    echo "  help       Show help"
    echo ""
}

case "${1:-help}" in
    build) build ;;
    start) start_all ;;
    stop) stop ;;
    backend) start_backend ;;
    frontend) start_frontend ;;
    status) status ;;
    logs) logs ;;
    restart) restart ;;
    help|--help|-h) show_help ;;
    *) error "Unknown command: $1"; show_help; exit 1 ;;
esac