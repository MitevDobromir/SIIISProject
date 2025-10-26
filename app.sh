#!/bin/bash

################################################################################
# Todo App - All-in-One Management Script
################################################################################

set -e

# Detect docker-compose command
if command -v docker-compose &> /dev/null; then
    COMPOSE="docker-compose"
else
    COMPOSE="docker compose"
fi

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_header() {
    echo ""
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}=========================================${NC}"
    echo ""
}

print_success() { echo -e "${GREEN}✓ $1${NC}"; }
print_info() { echo -e "${YELLOW}➜ $1${NC}"; }
print_error() { echo -e "${RED}✗ $1${NC}"; }

################################################################################
# BUILD - Build Docker containers
################################################################################

build() {
    print_header "🔨 Building Docker Containers"
    
    echo "Building containers..."
    $COMPOSE build --no-cache
    
    echo ""
    print_success "Build complete!"
    echo ""
    print_info "Next: ./app.sh start"
}

################################################################################
# START BACKEND - Start Docker containers only
################################################################################

start_backend() {
    print_header "🐳 Starting Backend"
    
    echo "Starting Docker containers..."
    $COMPOSE up -d
    
    echo ""
    echo "Waiting for services..."
    sleep 5
    
    echo ""
    print_success "Backend running!"
    echo ""
    echo "  Backend API:  http://localhost:8000/api/todos/"
    echo "  Admin Panel:  http://localhost:8000/admin"
    echo ""
    print_info "To start frontend: ./app.sh frontend"
}

################################################################################
# START FRONTEND - Start frontend web server only
################################################################################

start_frontend() {
    print_header "🎨 Starting Frontend"
    
    if [ ! -d "frontend" ]; then
        print_error "frontend directory not found!"
        exit 1
    fi
    
    cd frontend
    
    echo ""
    print_success "Frontend running at: http://localhost:3000"
    echo ""
    print_info "Press Ctrl+C to stop"
    echo ""
    
    python3 -m http.server 3000
}

################################################################################
# START ALL - Start everything together
################################################################################

start_all() {
    print_header "🚀 Starting Everything"
    
    # Start Docker containers
    echo "Starting backend and database..."
    $COMPOSE up -d
    
    echo ""
    echo "Waiting for services..."
    sleep 5
    
    # Start frontend in background
    echo "Starting frontend server..."
    cd frontend
    python3 -m http.server 3000 > /dev/null 2>&1 &
    FRONTEND_PID=$!
    cd ..
    
    echo ""
    print_header "✓ Everything is Running!"
    
    echo "📍 Access Points:"
    echo "  Frontend:     http://localhost:3000      ← Use this!"
    echo "  Backend API:  http://localhost:8000/api/todos/"
    echo "  Admin Panel:  http://localhost:8000/admin"
    echo ""
    echo "🔧 Management:"
    echo "  View logs:    $COMPOSE logs -f"
    echo "  Stop:         ./app.sh stop"
    echo ""
    echo "Frontend PID: $FRONTEND_PID"
    echo ""
    print_info "Press Ctrl+C to stop everything..."
    
    # Trap Ctrl+C to clean up
    trap "echo ''; echo 'Stopping...'; kill $FRONTEND_PID 2>/dev/null; $COMPOSE down; echo 'Stopped.'; exit" INT
    
    # Keep script running
    wait $FRONTEND_PID
}

################################################################################
# STOP - Stop everything
################################################################################

stop() {
    print_header "🛑 Stopping Everything"
    
    # Stop frontend
    echo "Stopping frontend server..."
    pkill -f "python3 -m http.server 3000" 2>/dev/null || true
    
    # Stop Docker containers
    echo "Stopping Docker containers..."
    $COMPOSE down
    
    echo ""
    print_success "Everything stopped"
    echo ""
    print_info "To start again: ./app.sh start"
}

################################################################################
# STATUS - Show current status
################################################################################

status() {
    print_header "📊 Application Status"
    
    echo "Docker Containers:"
    $COMPOSE ps
    
    echo ""
    echo "Frontend Server:"
    if pgrep -f "python3 -m http.server 3000" > /dev/null; then
        print_success "Running on http://localhost:3000"
    else
        print_info "Not running"
    fi
    echo ""
}

################################################################################
# LOGS - Show logs
################################################################################

logs() {
    print_header "📋 Application Logs"
    
    print_info "Showing last 50 lines (Ctrl+C to exit)..."
    echo ""
    $COMPOSE logs --tail=50 -f
}

################################################################################
# HELP - Show usage
################################################################################

show_help() {
    echo ""
    echo -e "${CYAN}Todo App Management Script${NC}"
    echo ""
    echo "Usage: ./app.sh [command]"
    echo ""
    echo "Commands:"
    echo "  ${GREEN}build${NC}      Build Docker containers (first time setup)"
    echo "  ${GREEN}start${NC}      Start everything (backend + frontend)"
    echo "  ${GREEN}stop${NC}       Stop everything"
    echo "  ${GREEN}backend${NC}    Start backend only"
    echo "  ${GREEN}frontend${NC}   Start frontend only"
    echo "  ${GREEN}status${NC}     Show what's running"
    echo "  ${GREEN}logs${NC}       View application logs"
    echo "  ${GREEN}restart${NC}    Restart everything"
    echo "  ${GREEN}help${NC}       Show this help"
    echo ""
    echo "Examples:"
    echo "  ${YELLOW}./app.sh build${NC}      # First time setup"
    echo "  ${YELLOW}./app.sh start${NC}      # Start everything"
    echo "  ${YELLOW}./app.sh stop${NC}       # Stop everything"
    echo "  ${YELLOW}./app.sh status${NC}     # Check what's running"
    echo ""
    echo "Quick Start:"
    echo "  ${YELLOW}./app.sh build && ./app.sh start${NC}"
    echo "  ${YELLOW}Open: http://localhost:3000${NC}"
    echo ""
}

################################################################################
# RESTART - Restart everything
################################################################################

restart() {
    print_header "🔄 Restarting Everything"
    
    stop
    sleep 2
    start_all
}

################################################################################
# MAIN - Parse command and execute
################################################################################

case "${1:-help}" in
    build)
        build
        ;;
    start)
        start_all
        ;;
    stop)
        stop
        ;;
    backend)
        start_backend
        ;;
    frontend)
        start_frontend
        ;;
    status)
        status
        ;;
    logs)
        logs
        ;;
    restart)
        restart
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        print_error "Unknown command: $1"
        show_help
        exit 1
        ;;
esac
