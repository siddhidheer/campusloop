# ==============================================================================
# CampusLoop — Serverpod Cloud Deployment Script (PowerShell)
# Team: HACKTIVATORS | Track: Campus Life, Upgraded
# ==============================================================================

$ProjectName = "campusloop"
$DeployToken = "01a17e55"

Write-Host "=== Deploying CampusLoop to Serverpod Cloud ===" -ForegroundColor Cyan
Write-Host "Project: $ProjectName"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location (Join-Path $ScriptDir "..")

# Check for serverpod CLI
if (-not (Get-Command "serverpod" -ErrorAction SilentlyContinue)) {
    Write-Host "Serverpod CLI not found in PATH. Installing via Dart pub..." -ForegroundColor Yellow
    dart pub global activate serverpod_cli
    $env:PATH += ";$env:LOCALAPPDATA\Pub\Cache\bin"
}

Write-Host "1. Resolving server dependencies..." -ForegroundColor Green
dart pub get

Write-Host "2. Deploying backend to Serverpod Cloud..." -ForegroundColor Green
serverpod cloud deploy --project $ProjectName --token $DeployToken

Write-Host ""
Write-Host "=== Deployment Succeeded! ===" -ForegroundColor Cyan
Write-Host "Live URL: https://api.campusloop.serverpod.cloud/" -ForegroundColor Green
