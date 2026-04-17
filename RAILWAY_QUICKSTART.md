# Quick Start to Railway Deployment

## 🚀 Fastest Way (5 minutes)

### Step 1: Push to GitHub
```bash
git add .
git commit -m "Add Railway deployment config"
git push origin main
```

### Step 2: Go to Railway.app
1. Visit https://railway.app
2. Click "New Project" → "Deploy from GitHub repo"
3. Select `ai-prompt-library`
4. Railway auto-detects services

### Step 3: Set Secrets
Go to your project → Add these variables:

```
SECRET_KEY=<generate-strong-key-below>
ALLOWED_HOSTS=your-domain.railway.app,yourdomain.com
DEBUG=False
```

**Generate SECRET_KEY:**
```bash
python -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())'
```

### Step 4: Deploy
Click "Deploy" button - Done! 🎉

Your app will be at: `https://your-project.railway.app`

---

## 📖 Full Guide

See **RAILWAY_DEPLOYMENT.md** for comprehensive instructions including:
- CLI setup
- Database migrations  
- Custom domains
- Backups
- Monitoring
- Troubleshooting

---

## ⚡ Using Deployment Scripts

### On Mac/Linux:
```bash
chmod +x deploy-railway.sh
./deploy-railway.sh
```

### On Windows:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
.\deploy-railway.ps1
```

---

## 🆘 Troubleshooting

| Problem | Solution |
|---------|----------|
| Service won't start | Check logs in Railway dashboard |
| Can't connect to DB | Verify DB_HOST, DB_USER, DB_PASSWORD |
| Frontend can't reach backend | Check BACKEND_URL matches backend service URL |
| Build fails | Check Dockerfile, ensure port mappings are correct |

---

## 📚 Resources

- **Railway Docs**: https://docs.railway.app
- **GitHub Integration**: https://docs.railway.app/deploy/github
- **Environment Variables**: https://docs.railway.app/develop/variables
- **Custom Domains**: https://docs.railway.app/deploy/exposing-your-app
