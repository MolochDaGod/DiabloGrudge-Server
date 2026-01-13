# 🛡️ DiabloGrudge Server - Admin Operations Guide

**Deployment Manager: DiGrudge**  
**Date:** 2026-01-12

---

## 🎯 Your Role as Deployment Manager

You are in charge of:
1. **GitHub Repository Management** - Code updates, version control
2. **Server Deployment** - Vercel deployment and monitoring
3. **Documentation** - Keeping guides up-to-date
4. **Client Access** - Ensuring players can connect
5. **Network Management** - ZeroTier setup and authorization
6. **Troubleshooting** - Fixing issues as they arise

---

## 📋 Quick Start Deployment

### FIRST TIME DEPLOYMENT

#### Step 1: Install Node.js
```powershell
# Check if Node.js is installed
node --version
npm --version

# If not installed, download from:
# https://nodejs.org/ (v20 LTS)
```

#### Step 2: Test Locally
```powershell
cd C:\Users\nugye\Documents\DiabloGrudge-Server

# Install dependencies
npm install

# Start server
npm start

# Test in browser:
# http://localhost:3000 - Main lobby
# http://localhost:3000/admin.html - Admin panel
# Default admin key: grudge-admin-2026

# Stop server: Ctrl+C
```

#### Step 3: Deploy to Vercel
```powershell
# Option A: Vercel Website (Easiest)
# 1. Go to https://vercel.com
# 2. Sign up / Login
# 3. Click "Add New..." → "Project"
# 4. Import from GitHub
# 5. Select "DiabloGrudge-Server"
# 6. Add environment variable: ADMIN_KEY
# 7. Deploy!

# Option B: Vercel CLI
npm install -g vercel
vercel login
vercel --prod
```

---

## 🔑 Admin Panel Access

### Accessing Admin Panel
1. Navigate to: `https://[your-url].vercel.app/admin.html`
2. Enter admin key (set in Vercel environment variables)
3. You'll see:
   - Total players online
   - Total active games
   - Banned IPs count
   - Server uptime

### Admin Functions

#### Kick Player
- Temporarily removes player from server
- Player can reconnect immediately
- Use for minor issues or testing

#### Ban Player
- Permanently bans player's IP address
- Player cannot reconnect
- Use for serious rule violations
- **Note:** Bans persist until server restart

#### View Statistics
- Real-time player count
- Active games count
- Server uptime
- Banned IP count

---

## 📂 Repository Management

### Current Repository
- **URL:** https://github.com/MolochDaGod/DiabloGrudge-Server
- **Branch:** main
- **Owner:** MolochDaGod

### Making Changes

#### Update Code
```powershell
cd C:\Users\nugye\Documents\DiabloGrudge-Server

# Make your changes to files

# Check status
git status

# Stage changes
git add .

# Commit changes
git commit -m "Description of changes"

# Push to GitHub
git push origin main

# Vercel will auto-deploy!
```

#### Important Files
- `server.js` - Main server logic, WebSocket handling
- `public/index.html` - Player lobby interface
- `public/admin.html` - Admin dashboard
- `package.json` - Dependencies and scripts
- `vercel.json` - Vercel deployment config

### DO NOT COMMIT
Large files already excluded in `.gitignore`:
- `Disotheb/` folders
- `*.mpq` files
- `node_modules/`
- `.env` files

---

## 🌐 Vercel Dashboard

### Accessing Dashboard
1. Go to https://vercel.com/dashboard
2. Click on "DiabloGrudge-Server" project

### Dashboard Features

#### Deployments
- View all deployments (production & preview)
- See deployment status and logs
- Roll back to previous versions if needed

#### Logs
- Real-time function logs
- Error tracking
- WebSocket connection monitoring
- Filter by level (info, error, warning)

#### Settings
- **Environment Variables**
  - Add/edit `ADMIN_KEY`
  - Changes require redeployment
  
- **Domains**
  - Add custom domain if desired
  - Default: `[project].vercel.app`
  
- **General**
  - Project name
  - Git integration
  - Auto-deploy settings

#### Analytics (Pro Plan)
- Visitor statistics
- Function invocations
- Bandwidth usage

---

## 🔗 ZeroTier Network Management

### Creating Network (First Time)

1. **Go to ZeroTier Central**
   - URL: https://my.zerotier.com/
   - Create account (free)
   
2. **Create Network**
   - Click "Create A Network"
   - Copy Network ID (16-digit code)
   - Example: `1234567890abcdef`
   
3. **Configure Network**
   - **Name:** DiabloGrudge D2 Network
   - **Access Control:** Private
   - **IPv4 Auto-Assign:** Enable
   - **Managed Routes:** 10.147.0.0/16
   - **IPv6:** Optional

4. **Document Network ID**
   - Add to `CLIENT-ACCESS-GUIDE.md`
   - Add to `DEPLOYMENT-CHECKLIST.md`
   - Share with clients

### Authorizing Players

When a player joins your network:

1. **Player Actions**
   - Installs ZeroTier
   - Joins network with Network ID
   - Contacts you for authorization

2. **Your Actions**
   - Go to https://my.zerotier.com/
   - Click on your network
   - Scroll to "Members" section
   - Find new member (unauth enticated)
   - Check authorization box
   - Player is connected in 30 seconds!

3. **Member Info**
   - Name/description (edit to identify player)
   - ZeroTier IP (what they use in D2)
   - Physical IP
   - Last seen
   - Authorization status

### Managing Members

#### Good Practices
- Name each member (e.g., "PlayerName-PC")
- Document their ZeroTier IP
- Note which player owns which device
- Remove inactive members periodically

#### Removing Problem Players
1. Go to ZeroTier Central
2. Find member in list
3. Uncheck authorization
4. Click delete (optional)
5. Player is immediately disconnected

---

## 👥 Client Onboarding Process

### When a New Player Joins

1. **Send Them:**
   - Web lobby URL
   - `CLIENT-ACCESS-GUIDE.md` document
   - ZeroTier Network ID
   - Your contact info

2. **Guide Them Through:**
   - Creating hero on web lobby
   - Installing ZeroTier
   - Joining network

3. **Authorize Their Connection:**
   - Check ZeroTier Central
   - Authorize their device
   - Confirm they can see ZeroTier IP

4. **Test Connection:**
   - Have them connect to web lobby
   - Verify they appear in player list
   - Test chat functionality

5. **D2 Connection Test:**
   - You host D2 game via TCP/IP
   - Share your ZeroTier IP
   - Player connects to test
   - Verify successful connection

### Creating Quick-Start Email

```
Subject: Welcome to DiabloGrudge!

Hi [Player Name],

Welcome to the DiabloGrudge D2 community!

🌐 WEB LOBBY:
https://[your-url].vercel.app

📖 PLAYER GUIDE:
[Attach or link to CLIENT-ACCESS-GUIDE.md]

🔗 ZEROTIER NETWORK:
Network ID: [Your Network ID]
Download: https://www.zerotier.com/download/

STEPS TO JOIN:
1. Visit web lobby and create a hero
2. Install ZeroTier and join network (ID above)
3. Contact me to authorize your connection
4. Launch D2 and connect via TCP/IP using ZeroTier IPs

Questions? Just ask in lobby chat or reply to this email!

See you in Sanctuary!
- DiGrudge (Admin)
```

---

## 🛠️ Common Maintenance Tasks

### Daily Tasks (5 minutes)

```powershell
# Check Vercel deployment status
# Go to: https://vercel.com/dashboard

# Check ZeroTier network health
# Go to: https://my.zerotier.com/

# Review active players
# Go to: https://[your-url].vercel.app/admin.html

# Check for issues in lobby chat
# Go to: https://[your-url].vercel.app
```

### Weekly Tasks (15 minutes)

```powershell
# Update dependencies
cd C:\Users\nugye\Documents\DiabloGrudge-Server
npm update

# Check for security issues
npm audit

# If issues found:
npm audit fix

# Commit and push if updates made
git add .
git commit -m "Update dependencies"
git push

# Review ZeroTier member list
# Remove inactive members

# Backup important data
# Export ZeroTier network config
```

### Monthly Tasks (30 minutes)

```powershell
# Review Vercel usage
# Check bandwidth and function invocations

# Update documentation
# Fix any outdated instructions

# Test all features
# Hero creation, lobby, games, chat, admin panel

# Gather player feedback
# Ask in lobby: "Any issues or suggestions?"

# Security audit
# Review banned IPs
# Check for suspicious activity
```

---

## 🚨 Troubleshooting Guide

### Server is Down

**Symptoms:** Lobby won't load, "Cannot connect" errors

**Diagnosis:**
```powershell
# Check deployment status
# Go to Vercel dashboard → Deployments

# Check function logs
# Vercel dashboard → Logs

# Test health endpoint
# https://[your-url].vercel.app/health
```

**Solutions:**
1. Check if deployment failed - redeploy
2. Check Vercel status page
3. Verify environment variables set
4. Check recent code changes
5. Roll back to previous deployment if needed

---

### Players Can't Connect to Each Other in D2

**Symptoms:** Web lobby works, but D2 TCP/IP fails

**Diagnosis:**
```powershell
# Player checks ZeroTier connection
ipconfig | Select-String "ZeroTier"

# Player tests ping to host
ping [host-zerotier-ip]

# Check ZeroTier Central
# Verify both players authorized
```

**Solutions:**
1. Verify both players on ZeroTier network
2. Check ZeroTier authorization status
3. Verify Windows Firewall allows D2
4. Check port 4000 not blocked
5. Try reversing host/client roles
6. Restart ZeroTier service

---

### WebSocket Disconnections

**Symptoms:** Players randomly disconnect from lobby

**Diagnosis:**
```powershell
# Check Vercel function logs
# Look for WebSocket close events

# Check client browser console
# F12 → Console tab → Look for errors

# Test connection stability
# Monitor admin panel for player count changes
```

**Solutions:**
1. Check Vercel function timeout settings
2. Verify not hitting connection limits
3. Check client internet stability
4. Update WebSocket library if outdated
5. Consider upgrading Vercel plan

---

### Admin Panel Not Working

**Symptoms:** Can't login, "Invalid key" message

**Diagnosis:**
```powershell
# Check environment variable
# Vercel dashboard → Settings → Environment Variables

# Verify ADMIN_KEY is set

# Check admin.html loads
# View page source, check for JS errors
```

**Solutions:**
1. Verify `ADMIN_KEY` in Vercel settings
2. Redeploy after changing env vars
3. Clear browser cache
4. Try different browser
5. Check server.js admin auth logic

---

## 📊 Monitoring Checklist

### Health Checks

#### Web Portal
- [ ] Main lobby loads
- [ ] Hero creation works
- [ ] Lobby connection established
- [ ] Chat sends/receives
- [ ] Game rooms create/join
- [ ] Admin panel accessible

#### ZeroTier Network
- [ ] All players authorized
- [ ] No connection issues reported
- [ ] Network traffic normal
- [ ] Member list up-to-date

#### Vercel Deployment
- [ ] Latest deployment successful
- [ ] No errors in function logs
- [ ] Bandwidth within limits
- [ ] Environment variables set

### Performance Metrics

**Normal Operation:**
- Players online: 0-25
- Active games: 0-5
- WebSocket connections: Stable
- Response time: <500ms
- Uptime: 99.9%

**Alert Thresholds:**
- Players online: >25 (consider scaling)
- WebSocket errors: >5/hour
- Response time: >2000ms
- Uptime: <95%

---

## 📞 Getting Help

### Vercel Support
- **Docs:** https://vercel.com/docs
- **Discord:** https://vercel.com/discord
- **Support:** https://vercel.com/support

### ZeroTier Support
- **Docs:** https://docs.zerotier.com/
- **Forums:** https://discuss.zerotier.com/
- **GitHub:** https://github.com/zerotier/ZeroTierOne

### Community Support
- Ask players in lobby chat
- Check GitHub issues
- Search Discord/Reddit for similar issues

---

## 🎓 Best Practices

### Security
1. **Never share admin key publicly**
2. **Use strong admin key** (32+ characters)
3. **Store credentials in password manager**
4. **Review banned IPs regularly**
5. **Monitor for suspicious activity**

### Performance
1. **Monitor Vercel usage**
2. **Optimize WebSocket messages**
3. **Clean up old games/rooms**
4. **Remove inactive ZeroTier members**
5. **Keep dependencies updated**

### Community Management
1. **Be responsive to player issues**
2. **Communicate downtime in advance**
3. **Gather and act on feedback**
4. **Enforce rules consistently**
5. **Foster positive community culture**

### Documentation
1. **Keep guides updated**
2. **Document all changes**
3. **Maintain changelog**
4. **Update credentials file**
5. **Screenshot important configs**

---

## 📝 Important Commands Reference

### Git Commands
```powershell
git status                          # Check repo status
git add .                           # Stage all changes
git commit -m "message"             # Commit changes
git push origin main                # Push to GitHub
git pull origin main                # Pull latest changes
git log --oneline                   # View commit history
```

### npm Commands
```powershell
npm install                         # Install dependencies
npm start                           # Start local server
npm update                          # Update dependencies
npm audit                           # Check for vulnerabilities
npm audit fix                       # Fix vulnerabilities
```

### Vercel CLI Commands
```powershell
vercel login                        # Login to Vercel
vercel                              # Deploy to preview
vercel --prod                       # Deploy to production
vercel logs                         # View logs
vercel env add KEY                  # Add environment variable
vercel domains                      # Manage domains
```

### Network Commands
```powershell
ipconfig                            # View network info
ipconfig | Select-String "ZeroTier" # Find ZeroTier IP
ping [ip]                           # Test connection
netstat -an | Select-String "3000"  # Check port 3000
Test-NetConnection -Port 4000       # Test D2 port
```

---

## ✅ Deployment Completion Checklist

After deployment is complete, verify:

- [ ] Node.js 20+ installed and working
- [ ] Local server tested successfully
- [ ] GitHub repository up-to-date
- [ ] Vercel deployment successful
- [ ] Production URL accessible
- [ ] Admin key changed from default
- [ ] Admin panel tested
- [ ] ZeroTier network created
- [ ] Network ID documented
- [ ] Server joined ZeroTier network
- [ ] Server authorized on network
- [ ] Client guide updated with URLs
- [ ] Test player onboarded successfully
- [ ] D2 connection tested and working
- [ ] All documentation updated
- [ ] Monitoring setup complete

---

**You're Ready to Manage DiabloGrudge! Good luck, Admin!** 🛡️⚔️

---

*Last Updated: 2026-01-12*  
*DiGrudge - Deployment Manager*
