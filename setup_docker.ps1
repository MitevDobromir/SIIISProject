# Setup Docker - Build containers (Windows)
# Run after setup_dependencies.ps1

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "🐳 Docker Setup - Building Containers" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Check Docker
Write-Host "Checking Docker..." -ForegroundColor Yellow

try {
    $dockerVersion = docker --version
    Write-Host "✓ Docker found: $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ Docker not found!" -ForegroundColor Red
    Write-Host "Please run: .\setup_dependencies.ps1" -ForegroundColor Yellow
    pause
    exit
}

# Check Docker Compose
try {
    $composeVersion = docker-compose --version
    Write-Host "✓ Docker Compose found: $composeVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ Docker Compose not found!" -ForegroundColor Red
    pause
    exit
}

Write-Host ""

# Check files
Write-Host "Checking configuration files..." -ForegroundColor Yellow

if (-not (Test-Path "docker-compose.yml")) {
    Write-Host "✗ docker-compose.yml not found!" -ForegroundColor Red
    exit
}

if (-not (Test-Path "Dockerfile")) {
    Write-Host "✗ Dockerfile not found!" -ForegroundColor Red
    exit
}

Write-Host "✓ Configuration files found" -ForegroundColor Green
Write-Host ""

# Build containers
Write-Host "Building Docker containers..." -ForegroundColor Yellow
Write-Host "This may take a few minutes on first run..." -ForegroundColor Cyan
Write-Host ""

docker-compose build

Write-Host ""
Write-Host "✓ Containers built successfully" -ForegroundColor Green
Write-Host ""

# Create .env file if needed
if (-not (Test-Path ".env")) {
    Write-Host "Creating .env file..." -ForegroundColor Yellow
    
    @"
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
"@ | Out-File -FilePath ".env" -Encoding UTF8
    
    Write-Host "✓ .env file created" -ForegroundColor Green
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "✓ Docker Setup Complete!" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""

Write-Host "Containers are built and ready to run" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next step:" -ForegroundColor Yellow
Write-Host "  Run: .\run_docker.ps1" -ForegroundColor White
Write-Host ""

pause
