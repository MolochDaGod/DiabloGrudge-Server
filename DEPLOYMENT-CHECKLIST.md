# 🎮 DiabloGrudge Server - Deployment Checklist

**Deployment Manager: DiGrudge**  
**Last Updated:** 2026-01-12

## ✅ Pre-Deployment Requirements

### 1. Node.js Installation
- [ ] Download Node.js 20 LTS from https://nodejs.org/
- [ ] Run installer and restart terminal
- [ ] Verify installation:
  ```powershell
  node --version  # Should show v20.x.x or higher
  npm --version   # Should show v10.x.x or higher
  ```

### 2. Repository Preparation
- [ ] Navigate to project directory
  ```powershell
  cd C:\Users\nugye\Documents\DiabloGrudge-Server
  ```
- [ ] Create `.gitignore` file for large folders
- [ ] Commit all necessary files
- [ ] Push to GitHub (https://github.com/MolochDaGod/DiabloGrudge-Server)

### 3. Local Testing
- [ ] Install dependencies:
  ```powershell
  npm install
  ```
- [ ] Start server locally:
  ```powershell
  npm start
  ```
- [ ] Test player lobby: http://localhost:3000
- [ ] Test admin panel: http://localhost:3000/admin.html
- [ ] Create test hero and verify localStorage saves
- [ ] Test game room creation and chat
- [ ] Stop local server (Ctrl+C)

## 🚀 Vercel Deployment

### Option A: GitHub Integration (RECOMMENDED)

1. **Prepare Vercel Account**
   - [ ] Create account at https://vercel.com
   - [ ] Connect GitHub account to Vercel
   - [ ] Grant Vercel access to repositories

2. **Import Project**
   - [ ] Click "Add New..." → "Project" in Vercel dashboard
   - [ ] Select "DiabloGrudge-Server" repository
   - [ ] Verify framework preset: "Other"
   - [ ] Verify build settings:
     - Build Command: (leave empty)
     - Output Directory: (leave empty)
     - Install Command: `npm install`

3. **Configure Environment Variables**
   - [ ] Add environment variable:
     - **Key:** `ADMIN_KEY`
     - **Value:** `[Generate secure key - use password generator]`
   - [ ] Save environment variables

4. **Deploy**
   - [ ] Click "Deploy"
   - [ ] Wait for deployment to complete (2-3 minutes)
   - [ ] Note deployment URL (e.g., `diablogrudge-server.vercel.app`)

### Option B: Vercel CLI

```powershell
# Install Vercel CLI globally
npm install -g vercel

# Login to Vercel
vercel login

# Deploy to preview
vercel

# Deploy to production
vercel --prod

# Add environment variable
vercel env add ADMIN_KEY production
```

## 🔐 Security Configuration

### Post-Deployment Security Steps
- [ ] Change default admin key from `grudge-admin-2026`
- [ ] Store admin key securely (password manager)
- [ ] Test admin panel with new key
- [ ] Document admin key location for team
- [ ] Set up IP banning for troublemakers
- [ ] Enable Vercel domain protection if needed

## 🌐 Client Access Setup

### 1. Web Portal Access
- [ ] Share deployment URL with clients
- [ ] Test URL from different devices/networks
- [ ] Verify WebSocket connections work on public URL
- [ ] Create bookmarkable link for easy access

### 2. Client Onboarding Documentation
Create and share:
- [ ] Quick Start Guide for clients
- [ ] Hero creation tutorial
- [ ] Game room instructions
- [ ] ZeroTier setup guide
- [ ] D2 connection instructions

## 🔗 ZeroTier Network Setup

### 1. Create Network
- [ ] Go to https://my.zerotier.com/
- [ ] Create account (free tier supports 25 devices)
- [ ] Click "Create A Network"
- [ ] Copy Network ID (16-digit code)
- [ ] Set network name: "DiabloGrudge D2 Network"

### 2. Configure Network Settings
- [ ] Enable "Private" access (require authorization)
- [ ] Set managed IP range (default: 10.147.x.x)
- [ ] Enable IPv4 Auto-Assign
- [ ] Save network settings

### 3. Server Setup (Host Machine)
- [ ] Install ZeroTier on host machine
- [ ] Join network using Network ID
- [ ] Authorize server in ZeroTier Central
- [ ] Note server ZeroTier IP (e.g., 10.147.17.1)
- [ ] Test connectivity: `ping [ZeroTier IP]`

### 4. Client Instructions
Create document with:
- [ ] ZeroTier download link
- [ ] Network ID to join
- [ ] Authorization process
- [ ] How to find their ZeroTier IP
- [ ] Server ZeroTier IP for D2 connection

## 📋 Verification Testing

### Web Portal Tests
- [ ] **Hero Creation**
  - Create warrior, wizard, rogue, paladin, necromancer, barbarian, amazon
  - Verify heroes save to localStorage
  - Test hero deletion
  
- [ ] **Lobby Functions**
  - Join lobby with hero
  - See other connected players
  - Verify player list updates in real-time
  
- [ ] **Game Rooms**
  - Create game without password
  - Create game with password
  - Join game as second player
  - Verify 8-player limit
  - Test password protection
  - Leave game and verify cleanup
  
- [ ] **Chat System**
  - Send messages in lobby
  - Send messages in game room
  - Verify real-time message delivery
  
- [ ] **Admin Panel**
  - Access `/admin.html`
  - Login with admin key
  - View server statistics
  - Test kick player function
  - Test ban player function
  - Verify banned IP cannot reconnect

### D2 Connectivity Tests
- [ ] Launch D2 via Cactus
- [ ] Host TCP/IP game
- [ ] Second player joins via ZeroTier IP
- [ ] Verify game connection successful
- [ ] Test actual gameplay
- [ ] Verify multiple players can connect

### Performance Tests
- [ ] Test with 5+ concurrent users
- [ ] Monitor WebSocket connections
- [ ] Check Vercel function logs
- [ ] Verify no disconnection issues
- [ ] Test across different browsers (Chrome, Firefox, Edge)

## 📊 Monitoring & Maintenance

### Daily Checks
- [ ] Check Vercel deployment status
- [ ] Review function logs for errors
- [ ] Monitor active player count
- [ ] Check for banned IPs needing review

### Weekly Checks
- [ ] Update dependencies if needed:
  ```powershell
  npm update
  git commit -am "Update dependencies"
  git push
  ```
- [ ] Review player feedback
- [ ] Test new features in dev environment

### Monthly Checks
- [ ] Review Vercel usage/bandwidth
- [ ] Backup player data if needed
- [ ] Update documentation
- [ ] Security audit

## 🆘 Troubleshooting

### WebSocket Connection Issues
**Problem:** Players can't connect to lobby

**Solutions:**
1. Check Vercel deployment logs
2. Verify WebSocket support in `vercel.json`
3. Test with different browser
4. Check client firewall settings
5. Verify URL uses `https://` not `http://`

### Admin Panel Access Issues
**Problem:** Admin key not working

**Solutions:**
1. Verify `ADMIN_KEY` in Vercel environment variables
2. Check for typos in key
3. Redeploy after changing env variables
4. Clear browser cache and retry

### D2 Connection Issues
**Problem:** Players can't connect via TCP/IP

**Solutions:**
1. Verify both players on same ZeroTier network
2. Check ZeroTier IPs: `ipconfig | Select-String "ZeroTier"`
3. Verify port 4000 not blocked
4. Test direct connection without ZeroTier first
5. Check Windows Firewall settings

### Performance Issues
**Problem:** Lag or disconnections

**Solutions:**
1. Check Vercel function logs for errors
2. Monitor concurrent connections
3. Verify not hitting Vercel free tier limits
4. Consider upgrading to Vercel Pro if needed
5. Optimize WebSocket message frequency

## 📝 Important URLs & Credentials

### Production URLs
- **Main Lobby:** [To be filled after deployment]
- **Admin Panel:** [To be filled after deployment]/admin.html
- **Health Check:** [To be filled after deployment]/health
- **API Endpoint:** [To be filled after deployment]/api/games

### GitHub Repository
- **URL:** https://github.com/MolochDaGod/DiabloGrudge-Server
- **Branch:** main

### Vercel Project
- **Dashboard:** https://vercel.com/dashboard
- **Project:** DiabloGrudge-Server

### ZeroTier Network
- **Network ID:** [To be filled after creation]
- **Dashboard:** https://my.zerotier.com/
- **Server IP:** [To be filled after joining]

### Admin Credentials
- **Admin Key:** [SECURE - Store in password manager]
- **Default Key:** `grudge-admin-2026` (CHANGE IMMEDIATELY)

## ✅ Final Deployment Sign-Off

**Deployment Completed By:** _________________  
**Date:** _________________  
**Production URL:** _________________  
**ZeroTier Network ID:** _________________  
**Admin Key Set:** ☐ Yes ☐ No  
**All Tests Passed:** ☐ Yes ☐ No  

**Signature:** _________________

---

## 🎉 Next Steps After Deployment

1. **Announce to Community**
   - Share lobby URL
   - Post ZeroTier instructions
   - Schedule first game night

2. **Gather Feedback**
   - Monitor player experience
   - Track bug reports
   - Collect feature requests

3. **Iterate & Improve**
   - Fix reported issues
   - Add requested features
   - Optimize performance

---

**For Support:** Contact DiGrudge (Deployment Manager)  
**Documentation:** See README.md and QUICKSTART.md  
**Emergency:** Check Vercel dashboard for real-time logs
