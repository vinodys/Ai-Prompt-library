# AI Prompt Library - Railway Deployment Guide

Railway is a modern, developer-friendly deployment platform that makes it easy to deploy applications. This guide covers deploying the AI Prompt Library to Railway.

## Prerequisites

1. **GitHub Account** - Repo must be on GitHub
2. **Railway Account** - Sign up at https://railway.app
3. **Railway CLI** (Optional but recommended)
4. **Docker** (Already configured in this project)

## Quick Start: Deploy from Web Dashboard

### Step 1: Push to GitHub
```bash
git remote add origin https://github.com/your-username/ai-prompt-library.git
git branch -M main
git push -u origin main
```

### Step 2: Connect Railway to GitHub
1. Go to https://railway.app
2. Click "Login" → Login with GitHub
3. Click "New Project"
4. Select "Deploy from GitHub repo"
5. Authorize Railway to access your GitHub repositories
6. Select `ai-prompt-library` repository

### Step 3: Configure Services
Railway will auto-detect Docker Compose. You'll see:
- **postgres** (Database)
- **redis** (Cache)
- **backend** (API Server)
- **frontend** (Web UI)

### Step 4: Set Environment Variables
For each service, click it and set variables:

**For Backend Service:**
```
DEBUG=False
SECRET_KEY=<generate-strong-key>
ALLOWED_HOSTS=your-domain.railway.app,yourdomain.com
DB_NAME=prompts
DB_USER=postgres
DB_PASSWORD=<generated-by-railway>
DB_HOST=postgres
REDIS_HOST=redis
```

**For Frontend Service:**
```
BACKEND_URL=https://backend-your-project.railway.app
```

### Step 5: Deploy
Click "Deploy" button. Railway will:
1. Build Docker images
2. Start containers
3. Run migrations automatically
4. Deploy services

### Step 6: Access Your App
After deployment completes:
- Frontend: `https://frontend-your-project.railway.app`
- Backend API: `https://backend-your-project.railway.app/api/prompts/`
- Admin Panel: `https://backend-your-project.railway.app/admin/`

---

## Advanced: Deploy with Railway CLI

### Step 1: Install Railway CLI
```bash
# macOS/Linux
curl -fsSL https://railway.app/install.sh | sh

# Windows (PowerShell)
iwr https://railway.app/install.ps1 -useb | iex
```

### Step 2: Login
```bash
railway login
```

### Step 3: Initialize Project
```bash
cd ai-prompt-library
railway init
```

Follow prompts to create a new project.

### Step 4: Set Environment Variables
```bash
railway variables set DEBUG=False
railway variables set SECRET_KEY=$(python -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())')
railway variables set ALLOWED_HOSTS=your-domain.railway.app
railway variables set DB_PASSWORD=your-secure-password
```

### Step 5: Deploy
```bash
railway up
```

The CLI will upload your code and deploy everything.

### Step 6: View Logs
```bash
railway logs
```

### Step 7: Access Services
```bash
railway open
```

---

## Environment Variables Reference

### Backend Variables
| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `DEBUG` | Yes | `False` | Disable in production |
| `SECRET_KEY` | Yes | None | Generate with Django utils |
| `ALLOWED_HOSTS` | Yes | localhost | Your domain(s) |
| `DB_NAME` | Yes | prompts | Database name |
| `DB_USER` | Yes | postgres | DB user |
| `DB_PASSWORD` | Yes | None | DB password |
| `DB_HOST` | Yes | db | Database host |
| `REDIS_HOST` | No | redis | Redis host |

### Generate Secret Key
```bash
python -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())'
```

---

## Database Migration

After first deployment, run:

```bash
# Using Railway CLI
railway exec backend python manage.py migrate
railway exec backend python manage.py createsuperuser

# Or via web dashboard:
# 1. Go to Backend service
# 2. Click "Connect" → Terminal
# 3. Run commands above
```

---

## Custom Domain Setup

### Step 1: In Railway Dashboard
1. Go to Frontend service
2. Click "Settings" → "Domain"
3. Add custom domain (e.g., prompt-library.com)

### Step 2: Update DNS Records
In your domain provider (GoDaddy, Namecheap, etc.):

```
CNAME  www    -> your-railway-url.railway.app
CNAME  @      -> your-railway-url.railway.app (or A record)
```

### Step 3: Wait for DNS Propagation
Usually 5-30 minutes. Check with:
```bash
nslookup yourdomain.com
```

### Step 4: Enable SSL
Railway automatically provisions SSL certificates via Let's Encrypt. It's enabled by default on all Railway apps.

---

## Database Backups

### Automatic Backups
Railway includes automatic backups for Postgres. Access from dashboard:
1. Go to Postgres service
2. Click "Settings" → "Data"
3. View backup snapshots

### Manual Backup
```bash
# Using Railway CLI
railway exec db pg_dump -U postgres prompts > backup.sql

# Download via dashboard
# 1. Connect to Postgres service terminal
# 2. Run pg_dump command
# 3. Download file
```

### Restore Backup
```bash
railway exec db psql -U postgres prompts < backup.sql
```

---

## Monitoring

### View Logs
```bash
# All services
railway logs

# Specific service
railway logs -s backend
railway logs -s frontend
railway logs -s db
```

### Metrics
In Railway dashboard:
1. Select service
2. Click "Metrics"
3. View CPU, Memory, Network usage

### Alerts
1. Go to project settings
2. Click "Alerts"
3. Set up notifications for:
   - High CPU usage
   - Memory errors
   - Deployment failures

---

## Scaling

### Increase Resources
In Railway dashboard:
1. Select service
2. Click "Settings" → "Resources"
3. Increase CPU and Memory

### Horizontal Scaling (Multiple Instances)
```bash
railway add --name backend2
```

---

## Troubleshooting

### Build Fails
```bash
# Check logs
railway logs

# Rebuild
railway build
```

### Service Not Starting
1. Check environment variables are set correctly
2. Verify Dockerfile is valid
3. Check port mappings (should match your app)

### Database Connection Error
1. Verify `DB_HOST`, `DB_USER`, `DB_PASSWORD`
2. Make sure Postgres service is running
3. Check service logs: `railway logs -s db`

### Frontend Can't Connect to Backend
1. Verify `BACKEND_URL` points to correct backend URL
2. Check CORS settings in Django
3. Ensure both services are deployed

### Out of Disk Space
1. Go to Postgres settings
2. Request more storage
3. Railway will resize automatically

---

## Cost Optimization

1. **Use smaller resource tiers** for low-traffic apps
2. **Enable auto-scaling** (if available)
3. **Use Railway's PostgreSQL** instead of external DB
4. **Consolidate services** where possible
5. **Monitor usage** regularly

---

## GitHub Integration

### Auto-Deploy on Push
1. Connect GitHub repo (already done in setup)
2. Every push to `main` branch deploys automatically
3. View deployment status in Railway dashboard

### Preview Deployments
Create a `railway.toml` file for advanced config:

```toml
[build]
builder = "dockerfile"

[deploy]
numReplicas = 1
healthchecks = {cmd = "curl -f http://localhost:8000/api/prompts/", interval = 30}
```

---

## Security Best Practices

1. ✅ Never commit `.env` file
2. ✅ Use Railway's secret management for sensitive data
3. ✅ Enable SSL/TLS (automatic)
4. ✅ Keep dependencies updated
5. ✅ Use strong database passwords
6. ✅ Implement rate limiting
7. ✅ Set up monitoring and alerts

---

## Performance Tips

1. Enable Redis caching
2. Optimize database queries
3. Use CDN for static files
4. Enable gzip compression
5. Use appropriate logging levels
6. Monitor slow queries

---

## Need Help?

- **Railway Docs**: https://docs.railway.app
- **Railway Discord**: https://discord.gg/railway
- **GitHub Issues**: Create issue in your repo
- **Email Support**: support@railway.app

---

## Useful Commands

```bash
# Login
railway login

# Initialize project
railway init

# Deploy
railway up

# View logs
railway logs

# Run command in service
railway exec backend python manage.py migrate

# View environment variables
railway variables

# Set variable
railway variables set KEY=value

# Open dashboard
railway open

# Check status
railway status

# Restart service
railway restart backend

# Stop project
railway stop

# Start project
railway start
```
