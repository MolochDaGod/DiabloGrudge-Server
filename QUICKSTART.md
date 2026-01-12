# 🚀 Quick Start Guide

## Step 1: Install Node.js

You need Node.js 20+ to run this server.

### Download & Install:
1. Go to: https://nodejs.org/
2. Download the **LTS version** (v20 or higher)
3. Run the installer
4. Restart your terminal after installation

### Verify Installation:
```powershell
node --version
npm --version
```

## Step 2: Install Dependencies

Open PowerShell in this directory and run:

```powershell
npm install
```

This will install:
- `express` - Web server
- `ws` - WebSocket support
- `cors` - Cross-origin requests

## Step 3: Run Locally

Start the server:

```powershell
npm start
```

You should see:
```
🎮 DiabloGrudge Server running on port 3000
🔑 Admin key: grudge-admin-2026
```

## Step 4: Open in Browser

- **Player Lobby**: http://localhost:3000
- **Admin Panel**: http://localhost:3000/admin.html

## Step 5: Deploy to Vercel (Free!)

### Option A: Using Vercel Website

1. Create account at https://vercel.com
2. Click "Import Project"
3. Connect your GitHub and push this code
4. Vercel will auto-detect settings
5. Add environment variable: `ADMIN_KEY=your-secret-key`
6. Click Deploy!

### Option B: Using Vercel CLI

```powershell
# Install Vercel CLI
npm install -g vercel

# Login
vercel login

# Deploy
vercel

# For production
vercel --prod
```

## 🎮 Test It Out

1. Open lobby in two browser windows
2. Create a hero in each window
3. Create a game in one window
4. Join the game from the other window
5. Use the chat to communicate
6. Click "PLAY DIABLO 2" to launch the game

## 🔑 Admin Panel

Default admin key: `grudge-admin-2026`

**Change this in production!** Set environment variable:

```powershell
# Windows PowerShell
$env:ADMIN_KEY="your-new-secret-key"
```

Or add to Vercel environment variables.

## 📝 Important Notes

- Heroes are saved in **browser localStorage** (not on server)
- Each player must have Diablo 2 installed locally
- The launcher opens DiabloWeb (browser D2) or you can modify it
- For actual multiplayer, players use TCP/IP in Diablo 2
- Server coordinates lobby/chat but doesn't host the actual game

## 🐛 Troubleshooting

**"npm not recognized"**
- Node.js not installed or not in PATH
- Restart terminal after installing Node.js

**Port 3000 already in use**
- Change port in `server.js`: `const PORT = process.env.PORT || 3001;`

**WebSocket connection failed**
- Check firewall settings
- Try different browser
- Check browser console for errors

## 🎉 You're Ready!

Once deployed, share your Vercel URL with friends and start playing!

Example: `https://diablogrudge-server.vercel.app`
