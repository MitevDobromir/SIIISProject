#!/bin/bash

################################################################################
# Setup Dependencies - Install system requirements
# Installs: Docker, Docker Compose, PostgreSQL (optional), Python, Git
################################################################################

set -e

echo "========================================="
echo "📦 Installing Dependencies"
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
# DETECT OS
################################################################################

detect_os() {
    print_step "Detecting operating system..."
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/arch-release ]; then
            OS="arch"
            print_success "Detected: Arch Linux"
        elif [ -f /etc/debian_version ]; then
            OS="debian"
            print_success "Detected: Debian/Ubuntu"
        elif [ -f /etc/fedora-release ] || [ -f /etc/redhat-release ]; then
            OS="fedora"
            print_success "Detected: Fedora/RHEL/CentOS"
        else
            OS="unknown"
            print_error "Unknown Linux distribution"
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        print_success "Detected: macOS"
    else
        OS="unknown"
        print_error "Unsupported operating system"
        exit 1
    fi
}

################################################################################
# INSTALL DOCKER
################################################################################

install_docker() {
    print_step "Installing Docker..."
    
    case $OS in
        arch)
            print_info "Installing Docker with pacman..."
            sudo pacman -Sy --noconfirm --needed docker docker-compose
            print_success "Docker installed"
            ;;
            
        debian)
            print_info "Installing Docker with apt..."
            
            # Remove old versions
            sudo apt-get remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true
            
            # Install dependencies
            sudo apt-get update
            sudo apt-get install -y ca-certificates curl gnupg lsb-release
            
            # Add Docker's GPG key
            sudo mkdir -p /etc/apt/keyrings
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
            
            # Add repository
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            
            # Install Docker
            sudo apt-get update
            sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
            
            # Also install standalone docker-compose
            sudo apt-get install -y docker-compose
            
            print_success "Docker installed"
            ;;
            
        fedora)
            print_info "Installing Docker with dnf..."
            
            # Remove old versions
            sudo dnf remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-selinux docker-engine-selinux docker-engine 2>/dev/null || true
            
            # Add repository
            sudo dnf -y install dnf-plugins-core
            sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
            
            # Install Docker
            sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-compose
            
            print_success "Docker installed"
            ;;
            
        macos)
            print_info "Checking for Homebrew..."
            if ! command -v brew &> /dev/null; then
                print_error "Homebrew not found. Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            
            print_info "Installing Docker with Homebrew..."
            brew install --cask docker
            print_success "Docker installed"
            print_info "Please start Docker Desktop from Applications"
            ;;
    esac
}

################################################################################
# INSTALL PYTHON & GIT
################################################################################

install_python_git() {
    print_step "Installing Python and Git..."
    
    case $OS in
        arch)
            sudo pacman -S --noconfirm --needed python python-pip git
            ;;
        debian)
            sudo apt-get install -y python3 python3-pip git
            ;;
        fedora)
            sudo dnf install -y python3 python3-pip git
            ;;
        macos)
            brew install python git
            ;;
    esac
    
    print_success "Python and Git installed"
}

################################################################################
# INSTALL POSTGRESQL (Optional)
################################################################################

install_postgresql() {
    print_step "Do you want to install PostgreSQL? (y/n)"
    print_info "Not required for Docker setup, but useful for native development"
    read -p "> " -n 1 -r
    echo ""
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Skipping PostgreSQL installation"
        return
    fi
    
    print_info "Installing PostgreSQL..."
    
    case $OS in
        arch)
            sudo pacman -S --noconfirm --needed postgresql
            print_info "Initialize with: sudo -u postgres initdb -D /var/lib/postgres/data"
            ;;
        debian)
            sudo apt-get install -y postgresql postgresql-contrib libpq-dev
            ;;
        fedora)
            sudo dnf install -y postgresql postgresql-server postgresql-devel
            ;;
        macos)
            brew install postgresql
            ;;
    esac
    
    print_success "PostgreSQL installed"
}

################################################################################
# START DOCKER SERVICE
################################################################################

start_docker() {
    print_step "Starting Docker service..."
    
    case $OS in
        arch|debian|fedora)
            sudo systemctl start docker
            sudo systemctl enable docker
            print_success "Docker service started and enabled"
            ;;
        macos)
            print_info "Please start Docker Desktop manually"
            ;;
    esac
}

################################################################################
# ADD USER TO DOCKER GROUP
################################################################################

configure_docker_permissions() {
    print_step "Configuring Docker permissions..."
    
    if [[ "$OS" != "macos" ]]; then
        if groups $USER | grep &>/dev/null '\bdocker\b'; then
            print_success "User already in docker group"
        else
            sudo usermod -aG docker $USER
            print_success "User added to docker group"
            print_info ""
            print_info "⚠️  IMPORTANT: Run 'newgrp docker' or logout/login for changes to take effect"
            print_info ""
        fi
    fi
}

################################################################################
# VERIFY INSTALLATION
################################################################################

verify_installation() {
    print_step "Verifying installation..."
    echo ""
    
    # Check Docker
    if command -v docker &> /dev/null; then
        DOCKER_VER=$(docker --version)
        print_success "Docker: $DOCKER_VER"
    else
        print_error "Docker not found"
    fi
    
    # Check Docker Compose
    if command -v docker-compose &> /dev/null; then
        COMPOSE_VER=$(docker-compose --version)
        print_success "Docker Compose: $COMPOSE_VER"
    elif docker compose version &> /dev/null 2>&1; then
        COMPOSE_VER=$(docker compose version)
        print_success "Docker Compose: $COMPOSE_VER"
    else
        print_error "Docker Compose not found"
    fi
    
    # Check Python
    if command -v python3 &> /dev/null; then
        PYTHON_VER=$(python3 --version)
        print_success "Python: $PYTHON_VER"
    else
        print_error "Python not found"
    fi
    
    # Check Git
    if command -v git &> /dev/null; then
        GIT_VER=$(git --version)
        print_success "Git: $GIT_VER"
    else
        print_error "Git not found"
    fi
    
    # Check PostgreSQL (if installed)
    if command -v psql &> /dev/null; then
        PSQL_VER=$(psql --version)
        print_success "PostgreSQL: $PSQL_VER"
    fi
}

################################################################################
# MAIN
################################################################################

main() {
    echo ""
    detect_os
    echo ""
    
    # Check if already installed
    if command -v docker &> /dev/null && command -v docker-compose &> /dev/null; then
        print_info "Docker and Docker Compose already installed"
        read -p "Reinstall/update? (y/n): " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Skipping installation"
            verify_installation
            exit 0
        fi
    fi
    
    install_docker
    echo ""
    
    install_python_git
    echo ""
    
    install_postgresql
    echo ""
    
    start_docker
    echo ""
    
    configure_docker_permissions
    echo ""
    
    verify_installation
    echo ""
    
    echo "========================================="
    print_success "✓ Dependencies Installed!"
    echo "========================================="
    echo ""
    
    print_info "Next steps:"
    echo "  1. Run: newgrp docker  (or logout/login)"
    echo "  2. Run: ./setup_docker.sh"
    echo "  3. Run: ./run_docker.sh"
    echo ""
}

main
