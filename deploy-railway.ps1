# AI Prompt Library - Railway Deployment Script (Windows)
# This script helps deploy the application to Railway

Write-Host "🚀 AI Prompt Library - Railway Deployment" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Railway CLI is installed
if (-not (Get-Command railway -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Railway CLI not found!" -ForegroundColor Red
    Write-Host "Install from: https://railway.app/install.ps1" -ForegroundColor Yellow
    Write-Host "Run: iwr https://railway.app/install.ps1 -useb | iex" -ForegroundColor Yellow
    exit 1
}

Write-Host "1️⃣  Checking Railway Login..." -ForegroundColor Yellow
try {
    railway whoami | Out-Null
    Write-Host "✅ Already logged in to Railway" -ForegroundColor Green
} catch {
    Write-Host "🔐 Please login to Railway..." -ForegroundColor Yellow
    railway login
}

Write-Host ""
Write-Host "2️⃣  Creating New Railway Project..." -ForegroundColor Yellow
Write-Host ""

$createNew = Read-Host "Create a new project? (y/n)"
if ($createNew -eq 'y') {
    railway init
} else {
    Write-Host "Available projects:" -ForegroundColor Cyan
    railway projects list
    Write-Host ""
    $projectId = Read-Host "Enter project name or ID"
    railway link $projectId
}

Write-Host ""
Write-Host "3️⃣  Setting Environment Variables..." -ForegroundColor Yellow
Write-Host ""
Write-Host "Generate a SECRET_KEY by running in PowerShell:" -ForegroundColor Cyan
Write-Host "python -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())'" -ForegroundColor Gray
Write-Host ""

$secretKey = Read-Host "Enter SECRET_KEY"
$allowedHosts = Read-Host "Enter ALLOWED_HOSTS (e.g., example.railway.app,example.com)"
$dbPassword = Read-Host "Enter DB_PASSWORD (leave empty for auto-generated)"

Write-Host "Setting variables..." -ForegroundColor Yellow
railway variables set SECRET_KEY="$secretKey"
railway variables set ALLOWED_HOSTS="$allowedHosts"
railway variables set DEBUG="False"

if ($dbPassword) {
    railway variables set DB_PASSWORD="$dbPassword"
}

Write-Host "✅ Environment variables set" -ForegroundColor Green
Write-Host ""

Write-Host "4️⃣  Deploying to Railway..." -ForegroundColor Yellow
railway up

Write-Host ""
Write-Host "5️⃣  Running migrations..." -ForegroundColor Yellow
railway exec backend python manage.py migrate
railway exec backend python manage.py collectstatic --noinput

Write-Host ""
Write-Host "✅ Deployment Complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. View your app: railway open" -ForegroundColor Gray
Write-Host "2. Check logs: railway logs" -ForegroundColor Gray
Write-Host "3. Set up custom domain in Railway dashboard" -ForegroundColor Gray
Write-Host ""
