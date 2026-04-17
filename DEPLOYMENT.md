# AI Prompt Library - Deployment Guide

## Prerequisites
- Docker & Docker Compose installed
- Git installed
- A server with public IP (AWS EC2, DigitalOcean, etc.)

## Quick Deployment Steps

### 1. Clone the Repository
```bash
git clone <your-repo-url> ai-prompt-library
cd ai-prompt-library
```

### 2. Setup Environment Variables
```bash
cp .env.example .env
# Edit .env with your production values
nano .env
```

**Important variables to update:**
- `DEBUG=False` (disable debug mode)
- `SECRET_KEY` - Generate a strong secret key
- `ALLOWED_HOSTS` - Add your domain
- `DB_PASSWORD` - Use a strong database password

### 3. Generate Secret Key
```bash
python -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())'
```

### 4. Deploy with Docker Compose
```bash
docker-compose -f docker-compose.yml up -d --build
```

### 5. Run Migrations (if not auto-running)
```bash
docker-compose exec backend python manage.py migrate
```

### 6. Create Superuser (Optional)
```bash
docker-compose exec backend python manage.py createsuperuser
```

## Access the Application
- Frontend: http://yourdomain.com:4200
- Backend API: http://yourdomain.com:8000/api/
- Admin Panel: http://yourdomain.com:8000/admin/

## Production Deployment Options

### Option 1: AWS EC2
1. Launch Ubuntu 22.04 LTS instance
2. Install Docker & Docker Compose
3. Clone repo and follow steps above
4. Use Route53/ALB for domain routing
5. Set up SSL/TLS with Let's Encrypt

### Option 2: DigitalOcean App Platform
1. Connect your GitHub repo
2. Set environment variables
3. Deploy automatically on push

### Option 3: Heroku
1. Add Procfile
2. Push to Heroku remote
3. Set config vars

### Option 4: Self-Hosted (VPS)
1. SSH into your VPS
2. Install Docker & Compose
3. Clone repository
4. Use Nginx as reverse proxy with SSL

## SSL/TLS Setup (Recommended)
```bash
# Using Let's Encrypt with Certbot
sudo apt-get install certbot python3-certbot-nginx
sudo certbot certonly --standalone -d yourdomain.com
```

## Monitoring & Logs
```bash
# View logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f backend

# Check container health
docker ps
```

## Backup Database
```bash
# Create backup
docker-compose exec db pg_dump -U postgres prompts > backup.sql

# Restore backup
docker-compose exec -T db psql -U postgres prompts < backup.sql
```

## Scaling Tips
- Use managed database (AWS RDS, DigitalOcean Managed DB)
- Use CDN for static files (CloudFront, CloudFlare)
- Implement caching strategy with Redis
- Load balance with Nginx/HAProxy

## Security Checklist
- [ ] Change SECRET_KEY in .env
- [ ] Set DEBUG=False
- [ ] Update ALLOWED_HOSTS
- [ ] Use strong database password
- [ ] Enable HTTPS/SSL
- [ ] Set secure CORS policies
- [ ] Regular backups
- [ ] Monitor logs

## Troubleshooting

### Port Already in Use
```bash
# Find what's using port 8000
lsof -i :8000

# Kill process
kill -9 <PID>
```

### Database Connection Error
```bash
# Check if db container is running
docker-compose ps

# Restart services
docker-compose restart db backend
```

### Frontend not loading
```bash
# Rebuild frontend
docker-compose build frontend
docker-compose up -d frontend
```

## Support
For issues, check logs: `docker-compose logs`
