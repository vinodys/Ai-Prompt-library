#!/bin/bash

# AI Prompt Library - Railway Deployment Script
# This script helps deploy the application to Railway

set -e

echo "🚀 AI Prompt Library - Railway Deployment"
echo "=========================================="
echo ""

# Check if logged in to Railway
if ! command -v railway &> /dev/null; then
    echo "❌ Railway CLI not found!"
    echo "Install from: https://railway.app/install.sh"
    exit 1
fi

echo "1️⃣  Checking Railway Login..."
if ! railway whoami &> /dev/null; then
    echo "🔐 Please login to Railway..."
    railway login
fi

echo "✅ Logged in to Railway"
echo ""

# Get project selection
echo "2️⃣  Selecting Project..."
echo "Available projects:"
railway projects list
echo ""
read -p "Enter project name or ID: " PROJECT_ID

echo ""
echo "3️⃣  Connecting to project..."
railway link $PROJECT_ID

echo ""
echo "4️⃣  Setting Environment Variables..."
echo ""
echo "Generate a SECRET_KEY with:"
echo "  python -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())'"
echo ""

read -p "Enter SECRET_KEY: " SECRET_KEY
read -p "Enter ALLOWED_HOSTS (e.g., example.railway.app,example.com): " ALLOWED_HOSTS
read -p "Enter DB_PASSWORD (leave empty for auto-generated): " DB_PASSWORD

railway variables set SECRET_KEY="$SECRET_KEY"
railway variables set ALLOWED_HOSTS="$ALLOWED_HOSTS"
railway variables set DEBUG="False"

if [ -n "$DB_PASSWORD" ]; then
    railway variables set DB_PASSWORD="$DB_PASSWORD"
fi

echo "✅ Environment variables set"
echo ""

echo "5️⃣  Deploying to Railway..."
railway up

echo ""
echo "6️⃣  Running migrations..."
railway exec backend python manage.py migrate
railway exec backend python manage.py collectstatic --noinput

echo ""
echo "✅ Deployment Complete!"
echo ""
echo "Next steps:"
echo "1. View your app: railway open"
echo "2. Check logs: railway logs"
echo "3. Set up custom domain in Railway dashboard"
echo ""
