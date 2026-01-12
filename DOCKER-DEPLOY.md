# 🐳 Docker Deployment Guide

## Option 1: Deploy Locally (Your PC)

### Quick Start
```powershell
# Build and run
docker-compose up -d

# View logs
docker-compose logs -f

# Stop
docker-compose down
```

**Access:**
- Main lobby: http://localhost:3000
- Admin panel: http://localhost:3000/admin.html

---

## Option 2: Deploy to Any VPS

### 1. Get a VPS (Choose One):

**FREE Options:**
- **Oracle Cloud** - Free forever (2 VMs)
- **Google Cloud** - $300 credits (12 months)
- **AWS** - 12 months free tier

**Paid ($4-6/month):**
- **DigitalOcean** - Easiest
- **Linode/Akamai**
- **Vultr**
- **Hetzner** - Cheapest

### 2. Connect to VPS

```powershell
ssh root@YOUR_VPS_IP
```

### 3. Install Docker on VPS

```bash
# Update system
apt update && apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Install Docker Compose
apt install docker-compose -y
```

### 4. Deploy Your Server

```bash
# Clone repo
git clone https://github.com/MolochDaGod/DiabloGrudge-Server.git
cd DiabloGrudge-Server

# Set admin key (optional)
echo "ADMIN_KEY=your-secret-key" > .env

# Build and run
docker-compose up -d

# Check logs
docker-compose logs -f
```

**Access:**
- `http://YOUR_VPS_IP:3000`

---

## Option 3: Deploy to Cloud (Azure/AWS/GCP)

### Azure Container Instances (You have Azure!)

```powershell
# Login to Azure
az login

# Create resource group
az group create --name diablogrudge-rg --location eastus

# Build and push to Azure Container Registry
az acr create --resource-group diablogrudge-rg --name diablogrudgeacr --sku Basic
az acr build --registry diablogrudgeacr --image diablogrudge:latest .

# Deploy container
az container create `
  --resource-group diablogrudge-rg `
  --name diablogrudge-server `
  --image diablogrudgeacr.azurecr.io/diablogrudge:latest `
  --dns-name-label diablogrudge `
  --ports 3000 `
  --environment-variables ADMIN_KEY=grudge-admin-2026
```

### AWS (Elastic Container Service)

```bash
# Install AWS CLI first
# Then:
aws ecr create-repository --repository-name diablogrudge
docker build -t diablogrudge .
docker tag diablogrudge:latest YOUR_AWS_ACCOUNT.dkr.ecr.us-east-1.amazonaws.com/diablogrudge:latest
docker push YOUR_AWS_ACCOUNT.dkr.ecr.us-east-1.amazonaws.com/diablogrudge:latest
```

---

## Option 4: Deploy to Render.com (Easiest Cloud)

1. Go to https://render.com
2. Click "New +" → "Web Service"
3. Connect your GitHub repo
4. Select "Docker" as environment
5. Add environment variable: `ADMIN_KEY=your-secret-key`
6. Click "Create Web Service"

**Done!** You'll get a URL like: `https://diablogrudge-server.onrender.com`

---

## Option 5: Deploy to Railway.app

1. Go to https://railway.app
2. Click "Start a New Project"
3. Select "Deploy from GitHub repo"
4. Choose DiabloGrudge-Server
5. Add environment variable: `ADMIN_KEY=your-secret-key`
6. Click Deploy

**Done!** Railway auto-detects Dockerfile.

---

## 🔧 Management Commands

### Local Docker:
```powershell
docker-compose up -d          # Start
docker-compose down           # Stop
docker-compose logs -f        # View logs
docker-compose restart        # Restart
docker-compose pull           # Update image
docker-compose build --no-cache  # Rebuild
```

### VPS Docker:
```bash
docker ps                     # List containers
docker logs diablogrudge-server  # View logs
docker restart diablogrudge-server  # Restart
docker stop diablogrudge-server  # Stop
docker-compose pull && docker-compose up -d  # Update
```

---

## 🔄 Update Deployment

### Local or VPS:
```bash
cd DiabloGrudge-Server
git pull
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

---

## 🌐 Add Domain Name (Optional)

### Using Cloudflare (Free):

1. Buy domain or use free subdomain
2. Add A record: `@` → `YOUR_VPS_IP`
3. Add CNAME: `www` → `@`
4. On VPS, install Nginx:

```bash
apt install nginx certbot python3-certbot-nginx -y

# Configure Nginx
cat > /etc/nginx/sites-available/diablogrudge <<EOF
server {
    listen 80;
    server_name yourdomain.com www.yourdomain.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$host;
    }
}
EOF

ln -s /etc/nginx/sites-available/diablogrudge /etc/nginx/sites-enabled/
nginx -t
systemctl restart nginx

# Get free SSL
certbot --nginx -d yourdomain.com -d www.yourdomain.com
```

Now access: `https://yourdomain.com`

---

## 💰 Cost Comparison

| Provider | Cost | Setup Time | Best For |
|----------|------|------------|----------|
| **Your PC (Docker)** | Free | 2 minutes | Testing locally |
| **Oracle Cloud** | Free forever | 15 minutes | Best free option |
| **Railway.app** | Free tier | 2 minutes | Easiest cloud |
| **Render.com** | Free tier | 2 minutes | Simple cloud |
| **DigitalOcean** | $6/month | 10 minutes | Best paid option |
| **Azure/AWS/GCP** | ~$10/month | 20 minutes | Enterprise |

---

## 🚀 Recommended Path:

1. **Test locally first:** `docker-compose up -d`
2. **If it works, deploy to Railway/Render** (2 clicks, free)
3. **Or get Oracle Cloud VPS** (free forever)

Which would you like to try?
