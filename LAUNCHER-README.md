# 🎮 DiabloGrudge ZeroTier Launcher

A complete game deployment system with ZeroTier network integration for hosting and joining Diablo II games.

## 📦 What's Included

### 🌐 Web Interface
- **launcher.html** - Main ZeroTier game launcher interface
- **index.html** - Original web lobby for hero management and chat
- **admin.html** - Admin dashboard for server management

### 🔧 Backend
- **server.js** - Node.js server with:
  - WebSocket for real-time lobby
  - ZeroTier status API (`/api/zerotier/status`)
  - Game launcher API (`/api/launch-game`)
  
### 📋 Configuration
- **puter.json** - Puter app manifest for deployment
- **Configure-D2-ZeroTier.ps1** - Firewall configuration script

---

## 🚀 Quick Start

### 1. Install Dependencies
```powershell
npm install
```

### 2. Configure Firewall (One-Time)
Run as Administrator:
```powershell
.\Configure-D2-ZeroTier.ps1
```

This opens:
- Diablo II ports (4000 TCP/UDP)
- Battle.net ports (6112 TCP/UDP)
- ZeroTier port (9993 UDP)

### 3. Start Server
```powershell
npm start
```

### 4. Access Launcher
- **Game Launcher**: http://localhost:3000/launcher.html
- **Web Lobby**: http://localhost:3000/
- **Admin Panel**: http://localhost:3000/admin.html

---

## 🌐 Deploy to Vercel

### Option 1: Vercel CLI
```powershell
# Install Vercel
npm install -g vercel

# Login
vercel login

# Deploy
vercel --prod
```

### Option 2: GitHub Integration
1. Push to GitHub
2. Import on vercel.com
3. Set `ADMIN_KEY` environment variable
4. Auto-deploy on every push

**Live URL Example**: `https://diablogrudge-launcher.vercel.app/launcher.html`

---

## 🖥️ Deploy as Puter App

### Requirements
- Puter account at https://puter.com/
- This repository hosted somewhere accessible

### Deployment Steps

1. **Upload to Puter Storage**
   - Zip your project
   - Upload via Puter file manager

2. **Create App from Manifest**
   - Use `puter.json` configuration
   - Entry point: `public/launcher.html`

3. **Access Your App**
   - Run from Puter desktop
   - Share with friends via Puter link

---

## 🎮 Features

### ZeroTier Network Status
- ✅ Real-time connection monitoring
- 🌐 Auto-detect your ZeroTier IP
- ⚠️ Authorization warnings
- 📋 One-click IP copy

### Game Launcher
- 🔥 Launch THOC Beta 8.1
- 🌐 Open web lobby
- 💡 Auto-instructions for hosting
- 📡 Network-aware UI

### Multiplayer Coordination
- 👥 Player list with heroes
- 💬 Global chat
- 🎲 Game rooms (up to 8 players)
- 🔒 Password-protected games

---

## 📡 ZeroTier Network

### Your Network Info
- **Network ID**: `cf719fd5401e3d2c`
- **Your Primary IP**: `192.168.194.1`
- **Dashboard**: https://my.zerotier.com/

### How It Works
1. **Virtual LAN**: ZeroTier creates a private network
2. **No Port Forwarding**: Works through NAT automatically
3. **Direct Connections**: Peer-to-peer when possible
4. **Encrypted**: All traffic is encrypted

### Adding Friends
1. They install ZeroTier
2. Join network: `cf719fd5401e3d2c`
3. You authorize them on dashboard
4. They get an IP: `192.168.194.x`

---

## 🔥 How to Host Games

### Step 1: Launch Launcher
```
http://localhost:3000/launcher.html
```

### Step 2: Check ZeroTier
- Verify you have a green status indicator
- Note your IP (e.g., `192.168.194.1`)
- If red/yellow, authorize on my.zerotier.com

### Step 3: Launch THOC
- Click "Launch THOC" button
- Cactus directory opens
- Launch game via Cactus interface

### Step 4: Host in D2
- Multiplayer → TCP/IP → Host Game
- Create game name/password
- Game is live!

### Step 5: Share IP
- Give friends your ZeroTier IP: `192.168.194.1`
- They join via TCP/IP using your IP

---

## 👥 How Friends Join

### One-Time Setup
1. **Install ZeroTier**
   - Download: https://www.zerotier.com/download/
   - Install and launch

2. **Join Network**
   - System tray → ZeroTier icon → Join Network
   - Enter: `cf719fd5401e3d2c`

3. **Get Authorized**
   - Host goes to https://my.zerotier.com/
   - Finds friend's device in "Members"
   - Checks the "Auth" box
   - Friend waits 30 seconds for IP

### Every Time
1. **Launch D2** (any version/mod)
2. **Multiplayer → TCP/IP → Join Game**
3. **Enter host IP**: `192.168.194.1`
4. **Select game from list**

---

## 🛠️ API Endpoints

### GET `/api/zerotier/status`
Returns ZeroTier connection status and IP.

**Response:**
```json
{
  "connected": true,
  "ip": "192.168.194.1",
  "uptime": "Active"
}
```

### POST `/api/launch-game`
Launches a game via Cactus.

**Request:**
```json
{
  "game": "thoc",
  "path": "C:\\Users\\nugye\\Documents\\Cactus\\Cactus\\thoc_b8_1"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Opening THOC directory. Please launch via Cactus."
}
```

### WebSocket Events
Same as original lobby:
- `register`, `chat`, `create_game`, `join_game`, etc.

---

## 🎨 Customization

### Add More Games
Edit `launcher.html`:
```javascript
<div class="game-card" onclick="launchGame('newgame')">
    <div class="game-icon">🌟</div>
    <div class="game-name">My New Mod</div>
    <div class="game-version">v1.0</div>
    <button class="btn">Launch Game</button>
</div>
```

Then in `server.js`:
```javascript
if (game === 'newgame') {
    const gamePath = 'C:\\Path\\To\\Game';
    await execAsync(`explorer "${gamePath}"`);
    // Or launch Game.exe directly
}
```

### Change Network ID
Update in both:
- `launcher.html` (line 372)
- `Configure-D2-ZeroTier.ps1` (line 2)

### Modify Colors/Theme
Edit CSS variables in `launcher.html`:
- `#d4af37` - Gold
- `#8b0000` - Dark red
- `#0a0a0a` - Background

---

## 📁 File Structure

```
DiabloGrudge-Server/
├── public/
│   ├── launcher.html       ← ZeroTier launcher (NEW)
│   ├── index.html          ← Original web lobby
│   └── admin.html          ← Admin dashboard
├── server.js               ← Backend (updated with APIs)
├── package.json            ← Dependencies
├── puter.json              ← Puter app config (NEW)
├── Configure-D2-ZeroTier.ps1  ← Firewall setup (NEW)
├── HOST-THOC-GAME.md       ← Hosting guide (NEW)
└── LAUNCHER-README.md      ← This file (NEW)
```

---

## 🔒 Security Notes

1. **Admin Key**: Change `ADMIN_KEY` in production
2. **HTTPS**: Use HTTPS in production (automatic on Vercel)
3. **IP Banning**: Admin can ban abusive IPs
4. **Private Network**: ZeroTier is encrypted and private

---

## 🐛 Troubleshooting

### "ZeroTier Not Connected"
- Check ZeroTier is running (system tray icon)
- Verify joined network: `cf719fd5401e3d2c`
- Check authorization on my.zerotier.com

### "169.254.x.x" IP (Link-Local)
- Not authorized yet
- Go to my.zerotier.com and check "Auth"
- Wait 30 seconds

### Game Won't Launch
- Check Cactus path in `launcher.html` (line 373)
- Manually launch via Cactus directory
- Ensure D2 is installed

### Friends Can't Connect
- Both on same ZeroTier network?
- Both authorized?
- Test with `ping 192.168.194.1`
- Check Windows Firewall rules

### API Errors
- Check console (F12) for errors
- Ensure server is running: `npm start`
- Verify Node.js 20+ installed

---

## 💡 Pro Tips

1. **Auto-Start Server**: Use PM2 or Windows Task Scheduler
2. **Multiple IPs**: If you have multiple ZeroTier IPs, use the first non-.0 one
3. **Character Backups**: Save at `Cactus/Saves/thoc_b8_1/`
4. **Mod Compatibility**: All players need same mod version
5. **Latency**: ZeroTier adds ~10-30ms, usually fine for D2

---

## 📊 System Requirements

### Server (Host)
- Windows 10/11
- Node.js 20+
- ZeroTier installed
- Diablo II + Cactus

### Client (Friend)
- Any OS that runs D2
- ZeroTier installed
- Diablo II (any version)

---

## 🤝 Contributing

Want to improve the launcher?
1. Fork the repo
2. Create feature branch
3. Make changes
4. Submit pull request

**Ideas Welcome:**
- Auto-launch D2 from launcher
- In-game overlay for IP display
- Discord integration
- More game/mod support

---

## 📝 License

MIT License - Free to use and modify

---

## 🎉 Credits

- **Cactus** - Version switcher by the community
- **THOC** - Mod by Diabolic Studios
- **ZeroTier** - VPN technology
- **DiabloGrudge** - Community project

---

**Ready to play! Share `cf719fd5401e3d2c` with friends! ⚔️**

Questions? Open an issue on GitHub!
