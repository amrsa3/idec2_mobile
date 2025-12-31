# Flutter Run Script for IDEC Mobile App (PowerShell)
# Run IDEC Mobile App

param(
    [string]$Device = "chrome",
    [int]$Port = 8080,
    [switch]$Web = $false,
    [switch]$Android = $false,
    [switch]$Help = $false
)

# Show help
if ($Help) {
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "IDEC Mobile App - Flutter Run Script" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Usage:" -ForegroundColor Yellow
    Write-Host "  .\run.ps1 [options]" -ForegroundColor White
    Write-Host ""
    Write-Host "Options:" -ForegroundColor Yellow
    Write-Host "  -Web              Run on Chrome (default)" -ForegroundColor White
    Write-Host "  -Android          Run on Android" -ForegroundColor White
    Write-Host "  -Device <name>    Specify device (chrome, edge, etc.)" -ForegroundColor White
    Write-Host "  -Port <number>    Specify port (default: 8080)" -ForegroundColor White
    Write-Host "  -Help             Show this help" -ForegroundColor White
    Write-Host ""
    Write-Host "Examples:" -ForegroundColor Yellow
    Write-Host "  .\run.ps1                    # Run on Chrome" -ForegroundColor White
    Write-Host "  .\run.ps1 -Web               # Run on Chrome" -ForegroundColor White
    Write-Host "  .\run.ps1 -Device edge       # Run on Edge" -ForegroundColor White
    Write-Host "  .\run.ps1 -Android           # Run on Android" -ForegroundColor White
    Write-Host "  .\run.ps1 -Port 3000         # Run on port 3000" -ForegroundColor White
    Write-Host ""
    exit 0
}

# Change to project directory
$ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $ScriptPath

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Starting IDEC Mobile App" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check Flutter installation
Write-Host "Checking Flutter..." -ForegroundColor Yellow
$flutterCheck = flutter --version 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Flutter not found or not properly installed!" -ForegroundColor Red
    Write-Host "Make sure Flutter is installed and added to PATH" -ForegroundColor Yellow
    exit 1
}
Write-Host "Flutter is ready" -ForegroundColor Green
Write-Host ""

# Get dependencies
Write-Host "Getting dependencies..." -ForegroundColor Yellow
flutter pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to get dependencies!" -ForegroundColor Red
    exit 1
}
Write-Host "Dependencies loaded successfully" -ForegroundColor Green
Write-Host ""

# Check available devices
Write-Host "Available devices:" -ForegroundColor Yellow
flutter devices
Write-Host ""

# Determine device and port
if ($Android) {
    $targetDevice = "android"
    Write-Host "Running on Android..." -ForegroundColor Cyan
} else {
    $targetDevice = $Device
    Write-Host "Running on $targetDevice (Port: $Port)..." -ForegroundColor Cyan
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Starting..." -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Tip: Press 'r' to reload, 'R' to restart" -ForegroundColor Yellow
Write-Host "Tip: Press 'q' to quit" -ForegroundColor Yellow
Write-Host ""

# Run the app
if ($Android) {
    flutter run -d android
} else {
    flutter run -d $targetDevice --web-port=$Port
}

# On exit
Write-Host ""
Write-Host "App stopped" -ForegroundColor Green