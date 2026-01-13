# ✅ DiabloGrudge Server Installation Complete!

## 📍 Installation Location
**Server Path:** `D:\D2Server`

## ✅ What's Been Set Up

### 1. Cactus Version Switcher ✅
- Installed at: `D:\D2Server\Cactus.exe`
- Desktop shortcut created: "DiabloGrudge Server (G Drive)"
- Configuration file: `D:\D2Server\Entries.json`

### 2. Diablo II Core Files ✅
All required MPQ files copied:
- ✅ d2char.mpq
- ✅ d2data.mpq
- ✅ d2exp.mpq
- ✅ d2music.mpq
- ✅ d2sfx.mpq
- ✅ d2speech.mpq
- ✅ d2xmusic.mpq
- ✅ d2xtalk.mpq
- ✅ d2xvideo.mpq
- ✅ D2.LNG
- Plus additional mod files

### 3. Disotheb Mod ✅
- Installed at: `D:\D2Server\Platforms\Disotheb\`
- Configured in Cactus as "Disotheb - Multiplayer"

### 4. Windows Firewall ✅
- TCP/IP port 4000 opened (TCP & UDP)
- Ready for multiplayer connections

## 📋 Next Steps to Complete Setup

### Step 1: Install Node.js (Required for Web Lobby)
1. Download Node.js 20+ from: https://nodejs.org/
2. Run installer (choose LTS version)
3. Restart PowerShell after installation

### Step 2: Install Web Lobby Dependencies
```powershell
cd C:\Users\nugye\Documents\DiabloGrudge-Server
npm install
```

### Step 3: Start Web Lobby Server
```powershell
npm start
```

Then visit: http://localhost:3000

## 🎮 How to Launch & Test

### Option A: Launch from Desktop
1. Double-click "DiabloGrudge Server (G Drive)" on desktop
2. Select "Disotheb - Multiplayer" platform
3. Click "Launch"
4. Game should start!

### Option B: Launch from Command Line
```powershell
cd D:\D2Server
.\Cactus.exe
```

## 🌐 Multiplayer Setup

### Local Network (LAN)
Your local IP: `169.254.112.117`

Players on same network can connect using this IP.

### Online Play (Internet)
Choose one of these options:

1. **ZeroTier (Recommended)**
   - Download: https://www.zerotier.com/
   - Creates virtual LAN over internet
   - No port forwarding needed

2. **Hamachi**
   - Download: https://vpn.net/
   - Easy to set up
   - Free for up to 5 players

3. **Port Forwarding**
   - Forward port 4000 (TCP & UDP) on your router
   - Players connect using your public IP
   - Find public IP: https://api.ipify.org

## 📂 Directory Structure

```
D:\D2Server\
├── Cactus.exe              # Main launcher
├── Game.exe                # D2 executable
├── *.mpq                   # Game data files
├── D2.LNG                  # Language file
├── Platforms\
│   └── Disotheb\          # Your mod
├── Saves\
│   └── Disotheb\          # Character saves
│       └── Multiplayer\   # Labeled save folder
└── Backups\               # Automatic backups
```

## 🧪 Testing Checklist

### Test D2 Launch:
- [ ] Launch Cactus.exe
- [ ] Select Disotheb platform
- [ ] Click Launch
- [ ] D2 starts successfully
- [ ] Can create character

### Test Multiplayer:
- [ ] In D2: Click "Multiplayer"
- [ ] Click "TCP/IP Game"
- [ ] Click "Host Game"
- [ ] Create game with name/password
- [ ] Game lobby appears

### Test Web Lobby (after Node.js installed):
- [ ] Run `npm start` in DiabloGrudge-Server folder
- [ ] Visit http://localhost:3000
- [ ] Create a hero
- [ ] Enter lobby
- [ ] Create game room
- [ ] Chat works

## 🔧 Troubleshooting

### "Can't find MPQ files"
All MPQ files are in `D:\D2Server\` - Cactus should auto-detect them.

### "Version mismatch" in multiplayer
All players must use the same D2 version/mod. Have them use Cactus with Disotheb platform.

### "Can't connect to host"
1. Check firewall allows port 4000
2. Both players on same network OR using VPN
3. Host gives correct IP address

### "Cactus won't launch game"
1. Right-click Cactus.exe → "Run as Administrator"
2. Check `D:\D2Server\Game.exe` exists

## 📊 Installation Summary

- ✅ Installation Drive: D:\ (322 GB free)
- ✅ Cactus installed and configured
- ✅ Disotheb mod ready
- ✅ All D2 MPQ files present
- ✅ Firewall configured
- ✅ Desktop shortcut created
- ⏳ Node.js needed for web lobby
- ⏳ npm dependencies not installed yet

## 🚀 Quick Start Commands

```powershell
# Start D2 Server
cd D:\D2Server
.\Cactus.exe

# Start Web Lobby (after Node.js installed)
cd C:\Users\nugye\Documents\DiabloGrudge-Server
npm install  # First time only
npm start

# Find your IP
ipconfig | Select-String "IPv4"
```

## 📞 Support Resources

- Cactus Documentation: `D:\D2Server\README.md`
- Web Lobby Setup: `C:\Users\nugye\Documents\DiabloGrudge-Server\QUICKSTART.md`
- D2 Server Guide: `C:\Users\nugye\Documents\DiabloGrudge-Server\D2-SERVER-SETUP.md`

---

**Installation completed:** 2026-01-12
**Ready to play!** Just need Node.js for the web lobby.
