#!/bin/bash

################################################################################
# Setup Docker - Build and configure Docker containers
# Run after setup_dependencies.sh
################################################################################

set -e

echo "========================================="
echo "🐳 Docker Setup - Building Containers"
echo "========================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✓ $1${NC}"; }
print_error() { echo -e "${RED}✗ $1${NC}"; }
print_info() { echo -e "${YELLOW}ℹ $1${NC}"; }
print_step() { echo -e "${BLUE}➜ $1${NC}"; }

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
            
            # Re-execute script with newgrp docker
            exec sg docker "$0 $@"
        fi
    fi
}

################################################################################
# CHECK DOCKER
################################################################################

check_docker() {
    print_step "Checking Docker installation..."
    
    if ! command -v docker &> /dev/null; then
        print_error "Docker not found!"
        print_info "Please run: ./setup_dependencies.sh"
        exit 1
    fi
    
    # Check if Docker daemon is running
    if ! docker info &> /dev/null; then
        # Try to check if it's a permission issue or daemon not running
        if docker info 2>&1 | grep -q "permission denied"; then
            print_error "Permission denied accessing Docker"
            print_info "Trying to activate docker group..."
            check_docker_group
            # If we get here, sg didn't work, try sudo
            print_info "Continuing with sudo..."
            USE_SUDO=true
        else
            print_error "Docker daemon is not running"
            print_info "Start Docker with: sudo systemctl start docker"
            exit 1
        fi
    else
        print_success "Docker is installed and running"
    fi
}

################################################################################
# CHECK DOCKER COMPOSE
################################################################################

check_compose() {
    print_step "Checking Docker Compose..."
    
    if command -v docker-compose &> /dev/null; then
        COMPOSE_CMD="docker-compose"
        print_success "Using docker-compose"
    elif docker compose version &> /dev/null 2>&1; then
        COMPOSE_CMD="docker compose"
        print_success "Using docker compose (v2)"
    else
        print_error "Docker Compose not found!"
        print_info "Please run: ./setup_dependencies.sh"
        exit 1
    fi
    
    # Add sudo if needed
    if [ "$USE_SUDO" = true ]; then
        COMPOSE_CMD="sudo $COMPOSE_CMD"
    fi
}

################################################################################
# CHECK FILES
################################################################################

check_files() {
    print_step "Checking configuration files..."
    
    if [ ! -f "docker-compose.yml" ]; then
        print_error "docker-compose.yml not found!"
        exit 1
    fi
    
    if [ ! -f "Dockerfile" ]; then
        print_error "Dockerfile not found!"
        exit 1
    fi
    
    if [ ! -f "backend/manage.py" ]; then
        print_error "backend/manage.py not found! Are you in the project root?"
        exit 1
    fi
    
    print_success "All configuration files found"
}

################################################################################
# BUILD CONTAINERS
################################################################################

build_containers() {
    print_step "Building Docker containers..."
    echo ""
    
    print_info "This may take a few minutes on first run..."
    echo ""
    
    $COMPOSE_CMD build
    
    print_success "Containers built successfully"
}

################################################################################
# CREATE .ENV FILE (OPTIONAL)
################################################################################

create_env_file() {
    if [ -f ".env" ]; then
        print_info ".env file already exists"
        return
    fi
    
    print_step "Creating .env file..."
    
    cat > .env << 'EOF'
# Database Configuration
DATABASE_NAME=todo_db
DATABASE_USER=todo_user
DATABASE_PASSWORD=todo_password
DATABASE_HOST=db
DATABASE_PORT=5432

# Django Configuration
DEBUG=True
SECRET_KEY=django-insecure-change-this-in-production
ALLOWED_HOSTS=localhost,127.0.0.1
EOF
    
    print_success ".env file created"
}

################################################################################
# MAIN
################################################################################

main() {
    echo ""
    
    # Auto-activate docker group if needed
    check_docker_group
    
    check_docker
    echo ""
    
    check_compose
    echo ""
    
    check_files
    echo ""
    
    create_env_file
    echo ""
    
    build_containers
    echo ""
    
    echo "========================================="
    print_success "✓ Docker Setup Complete!"
    echo "========================================="
    echo ""
    
    print_info "Containers are built and ready to run"
    echo ""
    
    print_info "Next step:"
    echo "  Run: ./run_docker.sh"
    echo ""
    
    print_info "Or manually:"
    echo "  Start:  $COMPOSE_CMD up -d"
    echo "  Stop:   $COMPOSE_CMD down"
    echo "  Logs:   $COMPOSE_CMD logs -f"
    echo ""
}

# Check directory
if [ ! -f "backend/manage.py" ]; then
    print_error "Please run from project root directory"
    exit 1
fi

main "$@"

