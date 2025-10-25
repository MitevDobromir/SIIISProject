# Setup Dependencies for Windows
# Run as Administrator in PowerShell

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "📦 Installing Dependencies - Windows" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Check if running as administrator
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "✗ Please run this script as Administrator!" -ForegroundColor Red
    Write-Host "Right-click PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
    pause
    exit
}

################################################################################
# CHECK/INSTALL WINGET
################################################################################

Write-Host "Checking for winget..." -ForegroundColor Yellow

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "✗ winget not found" -ForegroundColor Red
    Write-Host "Installing App Installer (winget)..." -ForegroundColor Yellow
    Write-Host "Please install App Installer from Microsoft Store" -ForegroundColor Yellow
    Start-Process "ms-windows-store://pdp/?ProductId=9NBLGGH4NNS1"
    Write-Host "After installing, run this script again" -ForegroundColor Yellow
    pause
    exit
}

Write-Host "✓ winget found" -ForegroundColor Green
Write-Host ""

################################################################################
# INSTALL DOCKER DESKTOP
################################################################################

Write-Host "Installing Docker Desktop..." -ForegroundColor Yellow

try {
    winget install --id Docker.DockerDesktop -e --silent --accept-package-agreements --accept-source-agreements
    Write-Host "✓ Docker Desktop installed" -ForegroundColor Green
    Write-Host ""
    Write-Host "⚠️  IMPORTANT: Please start Docker Desktop from Start Menu" -ForegroundColor Yellow
    Write-Host "Wait for it to fully start before continuing" -ForegroundColor Yellow
    Write-Host ""
} catch {
    Write-Host "⚠️  Docker may already be installed" -ForegroundColor Yellow
}

Write-Host ""

################################################################################
# INSTALL PYTHON
################################################################################

Write-Host "Installing Python..." -ForegroundColor Yellow

try {
    winget install --id Python.Python.3.11 -e --silent --accept-package-agreements --accept-source-agreements
    Write-Host "✓ Python installed" -ForegroundColor Green
    
    # Refresh PATH
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
} catch {
    Write-Host "⚠️  Python may already be installed" -ForegroundColor Yellow
}

Write-Host ""

################################################################################
# INSTALL GIT
################################################################################

Write-Host "Installing Git..." -ForegroundColor Yellow

try {
    winget install --id Git.Git -e --silent --accept-package-agreements --accept-source-agreements
    Write-Host "✓ Git installed" -ForegroundColor Green
    
    # Refresh PATH
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
} catch {
    Write-Host "⚠️  Git may already be installed" -ForegroundColor Yellow
}

Write-Host ""

################################################################################
# INSTALL POSTGRESQL (OPTIONAL)
################################################################################

Write-Host "Do you want to install PostgreSQL? (y/n)" -ForegroundColor Yellow
Write-Host "Not required for Docker setup" -ForegroundColor Cyan
$installPg = Read-Host

if ($installPg -eq "y" -or $installPg -eq "Y") {
    Write-Host "Installing PostgreSQL..." -ForegroundColor Yellow
    try {
        winget install --id PostgreSQL.PostgreSQL -e --silent --accept-package-agreements --accept-source-agreements
        Write-Host "✓ PostgreSQL installed" -ForegroundColor Green
    } catch {
        Write-Host "⚠️  PostgreSQL installation failed" -ForegroundColor Yellow
    }
}

Write-Host ""

################################################################################
# VERIFY INSTALLATION
################################################################################

Write-Host "Verifying installation..." -ForegroundColor Yellow
Write-Host ""

# Check Docker
try {
    $dockerVersion = docker --version
    Write-Host "✓ Docker: $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ Docker not found or not started" -ForegroundColor Red
}

# Check Docker Compose
try {
    $composeVersion = docker-compose --version
    Write-Host "✓ Docker Compose: $composeVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ Docker Compose not found" -ForegroundColor Red
}

# Check Python
try {
    $pythonVersion = python --version
    Write-Host "✓ Python: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ Python not found" -ForegroundColor Red
}

# Check Git
try {
    $gitVersion = git --version
    Write-Host "✓ Git: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ Git not found" -ForegroundColor Red
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "✓ Dependencies Installation Complete!" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""

Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Make sure Docker Desktop is running" -ForegroundColor White
Write-Host "  2. Run: .\setup_docker.ps1" -ForegroundColor White
Write-Host "  3. Run: .\run_docker.ps1" -ForegroundColor White
Write-Host ""

pause
