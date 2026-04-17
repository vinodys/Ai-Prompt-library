# 🚀 Railway Deployment - The Right Way (Individual Services)

## ❌ Why Docker Compose Doesn't Work on Railway

Railway is a cloud platform (PaaS) that deploys **individual services**, not docker-compose orchestration.
- Docker Compose is for local development
- Railway needs each service deployed separately

---

## ✅ THE CORRECT APPROACH: Deploy as Separate Services

### **Step 1: Create a New Railway Project**

1. Go https://railway.app
2. Click "New Project"
3. Select "Provision PostgreSQL" (Railway managed DB)
4. Click "Add Service" → Select "GitHub Repo"
5. Deploy backend from your repo

---

### **Step 2: Add Services to Your Railway Project**

In your Railway project dashboard:

#### **Option A: Add Managed Services (Recommended)**

1. **PostgreSQL Database**
   - Click "Add Service" → "Provision PostgreSQL"
   - Railway creates it automatically
   - Copy connection variables

2. **Redis Cache**
   - Click "Add Service" → "Provision Redis"
   - Railway creates it automatically

3. **Deploy Backend**
   - Click "Add Service" → "GitHub Repo"
   - Select: `ai-prompt-library`
   - Config: Set root directory to `./backend`
   - Railway auto-detects Dockerfile

4. **Deploy Frontend**
   - Click "Add Service" → "GitHub Repo"
   - Select: `ai-prompt-library`
   - Config: Set root directory to `./frontend/frontend-app`
   - Railway auto-detects Dockerfile

---

### **Step 3: Configure Environment Variables**

**For Backend Service:**
```
PORT=8000
DEBUG=False
SECRET_KEY=<generate-key>
ALLOWED_HOSTS=${{ Railway.domain }}
DB_ENGINE=django.db.backends.postgresql
DB_HOST=${{ Postgres.PGHOST }}
DB_PORT=${{ Postgres.PGPORT }}
DB_NAME=${{ Postgres.PGDATABASE }}
DB_USER=${{ Postgres.PGUSER }}
DB_PASSWORD=${{ Postgres.PGPASSWORD }}
REDIS_HOST=${{ Redis.REDIS_HOST }}
REDIS_PORT=${{ Redis.REDIS_PORT }}
```

**For Frontend Service:**
```
BACKEND_URL=${{ Backend.RAILWAY_DOMAIN }}
```

---

### **Step 4: Deploy Each Service**

1. Backend service deploys from `backend/` directory with `backend/Dockerfile`
2. Frontend service deploys from `frontend/frontend-app/` with its Dockerfile
3. Railway manages Postgres and Redis automatically

---

## 📋 STEP-BY-STEP VISUAL GUIDE

```
┌─────────────────────────────────────┐
│      Railway.app Dashboard           │
└─────────────────────────────────────┘
           │
     ┌─────┴─────┬─────────┬──────────┬──────────┐
     │           │         │          │          │
     ▼           ▼         ▼          ▼          ▼
  PostgreSQL   Redis    Backend    Frontend   Volumes
  (Managed)   (Managed)  (Docker)   (Docker)  (Data)
     │           │         │          │
     └─────┬─────┴────┬────┴──────────┘
           │          │
      Automatic   Connected
      Setup       Services
```

---

## 🔧 DEPLOY BACKEND AS SEPARATE SERVICE

1. In Railway: Click "Add Service" → "GitHub"
2. Select repo: `ai-prompt-library`
3. Configure:
   - **Build Settings:**
     - Root Directory: `./backend`
     - Dockerfile: `./backend/Dockerfile` (auto-detected)
   - **Environment Variables:** (see Step 3 above)

---

## 🎨 DEPLOY FRONTEND AS SEPARATE SERVICE

1. In Railway: Click "Add Service" → "GitHub"
2. Select repo: `ai-prompt-library`
3. Configure:
   - **Build Settings:**
     - Root Directory: `./frontend/frontend-app`
     - Dockerfile: `./frontend/frontend-app/Dockerfile`
   - **Environment Variables:**
     - `BACKEND_URL=${{ Backend.RAILWAY_DOMAIN }}`

---

## 📍 YOUR LIVE URLS

After deploying all services:

| Service | URL | Notes |
|---------|-----|-------|
| **Frontend** | `https://frontend-XXXXX.railway.app` | Your Angular UI |
| **Backend** | `https://backend-XXXXX.railway.app` | Django API |
| **Admin** | `https://backend-XXXXX.railway.app/admin` | Django Admin |
| **API** | `https://backend-XXXXX.railway.app/api/prompts/` | Prompts API |

---

## ✨ FEATURES OF THIS APPROACH

✅ **Railway Managed Services:** No maintenance needed for DB/Redis
✅ **Independent Scaling:** Scale each service separately
✅ **Automatic SSL:** All services get HTTPS automatically
✅ **Git Integration:** Push = Auto-Deploy
✅ **Environment Isolation:** Services are independent
✅ **Easy Logs:** View logs per service

---

## 🆘 COMMON ISSUES & FIXES

| Issue | Solution |
|-------|----------|
| Build fails for backend | Check `./backend/Dockerfile` exists and is valid |
| Can't find frontend | Set root directory to `./frontend/frontend-app` |
| Can't connect to DB | Use `${{ Postgres.PGHOST }}` env variable |
| Frontend can't reach backend | Set `BACKEND_URL=${{ Backend.RAILWAY_DOMAIN }}` |
| Build takes too long | Check `.dockerignore` file is optimized |

---

## 🎯 NEXT STEPS

1. ✅ Go to https://railway.app
2. ✅ Create new project
3. ✅ Add PostgreSQL (managed)
4. ✅ Add Redis (managed)
5. ✅ Add Backend Service (GitHub repo, `./backend` directory)
6. ✅ Add Frontend Service (GitHub repo, `./frontend/frontend-app` directory)
7. ✅ Set environment variables
8. ✅ Deploy!

---

## 📚 HELPFUL RAILWAY DOCS

- [Multiple Services](https://docs.railway.app/deploy/services)
- [Environment Variables](https://docs.railway.app/develop/variables)
- [Build Settings](https://docs.railway.app/deploy/builds)
- [Custom Domain](https://docs.railway.app/deploy/exposing-your-app)

---

## ⚡ QUICK TIPS

- Use `${{ ServiceName.VARIABLE }}` to reference other services
- Railway auto-provisions SSL/HTTPS
- Logs are available in real-time
- Environment variables update instantly
- Each service can be redeployed independently

---

**Railway with separate services is the proper way to deploy! 🚀**
