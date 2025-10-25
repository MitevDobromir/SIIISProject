# Run Docker - Start the application (Windows)
# Run after setup_docker.ps1

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "🚀 Starting Todo App" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Check Docker Compose
try {
    docker-compose --version | Out-Null
} catch {
    Write-Host "✗ Docker Compose not found!" -ForegroundColor Red
    pause
    exit
}

# Check if containers are built
Write-Host "Checking if containers are built..." -ForegroundColor Yellow

$images = docker-compose images 2>&1
if (-not ($images -match "todo_project")) {
    Write-Host "✗ Containers not built yet" -ForegroundColor Red
    Write-Host "Please run: .\setup_docker.ps1" -ForegroundColor Yellow
    pause
    exit
}

Write-Host "✓ Containers are built" -ForegroundColor Green
Write-Host ""

# Start containers
Write-Host "Starting containers..." -ForegroundColor Yellow

docker-compose up -d

Write-Host "✓ Containers started" -ForegroundColor Green
Write-Host ""

# Wait for services
Write-Host "Waiting for services to be ready..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

Write-Host "✓ Services are ready!" -ForegroundColor Green
Write-Host ""

# Display info
Write-Host "=========================================" -ForegroundColor Green
Write-Host "✓ Application Running!" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""

Write-Host "📍 Access your application:" -ForegroundColor Cyan
Write-Host ""
Write-Host "  🌐 Backend API:      http://localhost:8000" -ForegroundColor White
Write-Host "  📚 API Endpoints:    http://localhost:8000/api/todos/" -ForegroundColor White
Write-Host "  👤 Admin Panel:      http://localhost:8000/admin" -ForegroundColor White
Write-Host "  💻 Frontend:         Open frontend\index.html in browser" -ForegroundColor White
Write-Host ""

Write-Host "🔧 Useful commands:" -ForegroundColor Cyan
Write-Host ""
Write-Host "  View logs:           docker-compose logs -f" -ForegroundColor White
Write-Host "  Stop application:    docker-compose down" -ForegroundColor White
Write-Host "  Restart:             docker-compose restart" -ForegroundColor White
Write-Host "  Create admin user:   docker-compose exec backend python manage.py createsuperuser" -ForegroundColor White
Write-Host ""

Write-Host "📊 Container status:" -ForegroundColor Cyan
docker-compose ps
Write-Host ""

# Ask to view logs
Write-Host "Would you like to view the logs? (y/n): " -ForegroundColor Yellow -NoNewline
$viewLogs = Read-Host

if ($viewLogs -eq "y" -or $viewLogs -eq "Y") {
    Write-Host ""
    Write-Host "Showing logs... (Press Ctrl+C to exit)" -ForegroundColor Cyan
    Write-Host ""
    Start-Sleep -Seconds 2
    docker-compose logs -f
} else {
    pause
}
