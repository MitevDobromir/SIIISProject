#!/bin/bash

################################################################################
# Run Docker - Start the application
# Run after setup_docker.sh
################################################################################

set -e

echo "========================================="
echo "🚀 Starting Todo App"
echo "========================================="
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✓ $1${NC}"; }
print_info() { echo -e "${YELLOW}ℹ $1${NC}"; }
print_step() { echo -e "${BLUE}➜ $1${NC}"; }
print_error() { echo -e "${RED}✗ $1${NC}"; }

################################################################################
# CHECK AND AUTO-ACTIVATE DOCKER GROUP
################################################################################

check_docker_group() {
    # Check if user is in docker group
    if groups | grep -q '\bdocker\b'; then
        # User is in group, check if it's active in current session
        if ! docker ps &> /dev/null && docker ps 2>&1 | grep -q "permission denied"; then
            print_info "Docker group not active in current session"
            print_info "Activating docker group automatically..."
            
            # Re-execute script with sg (like newgrp but for scripts)
            exec sg docker "$0 $@"
        fi
    fi
}

################################################################################
# DETECT DOCKER COMPOSE COMMAND
################################################################################

detect_compose() {
    # First check docker group
    check_docker_group
    
    if command -v docker-compose &> /dev/null; then
        COMPOSE_CMD="docker-compose"
    elif docker compose version &> /dev/null 2>&1; then
        COMPOSE_CMD="docker compose"
    else
        print_error "Docker Compose not found!"
        print_info "Please run: ./setup_dependencies.sh"
        exit 1
    fi
}

################################################################################
# CHECK IF CONTAINERS ARE BUILT
################################################################################

check_built() {
    print_step "Checking if containers are built..."
    
    if ! $COMPOSE_CMD images | grep -q "todo_project"; then
        print_info "Containers not built yet"
        print_info "Please run: ./setup_docker.sh"
        exit 1
    fi
    
    print_success "Containers are built"
}

################################################################################
# START CONTAINERS
################################################################################

start_containers() {
    print_step "Starting containers..."
    
    $COMPOSE_CMD up -d
    
    print_success "Containers started"
}

################################################################################
# WAIT FOR SERVICES
################################################################################

wait_for_services() {
    print_step "Waiting for services to be ready..."
    
    echo -n "  "
    for i in {1..10}; do
        echo -n "."
        sleep 1
    done
    echo ""
    
    # Check if containers are running
    if $COMPOSE_CMD ps | grep -q "Up"; then
        print_success "Services are ready!"
    else
        print_error "Services failed to start"
        print_info "Check logs with: $COMPOSE_CMD logs"
        exit 1
    fi
}

################################################################################
# DISPLAY INFO
################################################################################

display_info() {
    echo ""
    echo "========================================="
    print_success "✓ Application Running!"
    echo "========================================="
    echo ""
    
    echo "📍 Access your application:"
    echo ""
    echo "  🌐 Backend API:      http://localhost:8000"
    echo "  📚 API Endpoints:    http://localhost:8000/api/todos/"
    echo "  👤 Admin Panel:      http://localhost:8000/admin"
    echo "  💻 Frontend:         Open frontend/index.html in browser"
    echo ""
    
    echo "🔧 Useful commands:"
    echo ""
    echo "  View logs:           $COMPOSE_CMD logs -f"
    echo "  Stop application:    $COMPOSE_CMD down"
    echo "  Restart:             $COMPOSE_CMD restart"
    echo "  Create admin user:   $COMPOSE_CMD exec backend python manage.py createsuperuser"
    echo ""
    
    echo "📊 Container status:"
    $COMPOSE_CMD ps
    echo ""
}

################################################################################
# SHOW LOGS
################################################################################

show_logs() {
    print_info "Would you like to view the logs? (y/n)"
    read -p "> " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo ""
        print_info "Showing logs... (Press Ctrl+C to exit)"
        echo ""
        sleep 2
        $COMPOSE_CMD logs -f
    fi
}

################################################################################
# MAIN
################################################################################

main() {
    detect_compose
    echo ""
    
    check_built
    echo ""
    
    start_containers
    echo ""
    
    wait_for_services
    echo ""
    
    display_info
    
    show_logs
}

# Check directory
if [ ! -f "docker-compose.yml" ]; then
    print_error "docker-compose.yml not found!"
    print_info "Please run from project root directory"
    exit 1
fi

main "$@"
