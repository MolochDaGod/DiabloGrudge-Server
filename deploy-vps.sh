#!/bin/bash

# DiabloGrudge VPS Deployment Script
# Run this on your Ubuntu/Debian VPS

set -e

echo "🎮 DiabloGrudge Server VPS Setup"
echo "=================================="

# Update system
echo "📦 Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install Node.js 20
echo "📦 Installing Node.js 20..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Install git
echo "📦 Installing git..."
sudo apt install -y git

# Install PM2 (process manager)
echo "📦 Installing PM2..."
sudo npm install -g pm2

# Clone repository
echo "📥 Cloning repository..."
cd /opt
sudo git clone https://github.com/MolochDaGod/DiabloGrudge-Server.git
cd DiabloGrudge-Server

# Install dependencies
echo "📦 Installing dependencies..."
sudo npm install

# Set up environment variables
echo "⚙️ Setting up environment..."
if [ ! -f .env ]; then
    echo "Creating .env file..."
    sudo tee .env > /dev/null <<EOF
PORT=3000
ADMIN_KEY=grudge-admin-2026
NODE_ENV=production
EOF
fi

# Start with PM2
echo "🚀 Starting server with PM2..."
sudo pm2 start server.js --name diablogrudge
sudo pm2 startup
sudo pm2 save

# Install and configure Nginx (reverse proxy)
echo "📦 Installing Nginx..."
sudo apt install -y nginx

# Configure Nginx
echo "⚙️ Configuring Nginx..."
sudo tee /etc/nginx/sites-available/diablogrudge > /dev/null <<'EOF'
map $http_upgrade $connection_upgrade {
    default upgrade;
    '' close;
}

server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # WebSocket support
        proxy_read_timeout 86400;
    }
}
EOF

# Enable Nginx site
sudo ln -sf /etc/nginx/sites-available/diablogrudge /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl restart nginx

# Configure firewall
echo "🔒 Configuring firewall..."
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw --force enable

echo ""
echo "✅ Installation complete!"
echo ""
echo "🎉 Your DiabloGrudge server is now running!"
echo ""
echo "📊 Useful commands:"
echo "  pm2 status                 - Check server status"
echo "  pm2 logs diablogrudge      - View logs"
echo "  pm2 restart diablogrudge   - Restart server"
echo "  pm2 stop diablogrudge      - Stop server"
echo ""
echo "🔄 To update:"
echo "  cd /opt/DiabloGrudge-Server"
echo "  sudo git pull"
echo "  sudo npm install"
echo "  pm2 restart diablogrudge"
echo ""
echo "🌐 Access your server at: http://YOUR_VPS_IP"
echo "🔑 Admin panel: http://YOUR_VPS_IP/admin.html"
echo "🔐 Default admin key: grudge-admin-2026"
echo ""
