# 🎮 DiabloGrudge D2 Server Setup Guide

## Current Status
You have:
- ✅ Cactus version switcher at: `C:\Users\nugye\Documents\Cactus\Cactus`
- ✅ Disotheb mod at: `C:\Users\nugye\Documents\Disotheb_Patch_1\Disotheb (Patch 1)`
- ✅ DiabloGrudge web lobby (this repo)

## Required: Get Core D2 Files

You need the core Diablo 2 MPQ files. These should be in your Disotheb folder or original D2 install:

**Required files:**
```
D2Char.mpq
D2Data.mpq
D2Exp.mpq
D2Music.mpq
D2Sfx.mpq
D2Speech.mpq
D2Video.mpq
D2XMusic.mpq
D2XTalk.mpq
D2XVideo.mpq
D2.LNG
```

## Step 1: Set Up D2 Server Directory

```powershell
# Create server directory
mkdir C:\D2Server
cd C:\D2Server

# Copy Cactus files
Copy-Item "C:\Users\nugye\Documents\Cactus\Cactus\1. Files\*" -Destination "C:\D2Server\" -Recurse -Force

# Copy Disotheb mod (your custom mod)
mkdir "C:\D2Server\Platforms\Disotheb"
Copy-Item "C:\Users\nugye\Documents\Disotheb_Patch_1\Disotheb (Patch 1)\*" -Destination "C:\D2Server\Platforms\Disotheb\" -Recurse -Force
```

## Step 2: Find Your Core D2 MPQs

Check these locations:
```powershell
# Option 1: Original D2 install
Get-ChildItem "C:\Program Files (x86)\Diablo II" -Filter "*.mpq"

# Option 2: Battle.net install
Get-ChildItem "$env:USERPROFILE\Saved Games\Diablo II" -Filter "*.mpq"

# Option 3: Your Disotheb folder (should have them)
Get-ChildItem "C:\Users\nugye\Documents\Disotheb_Patch_1" -Recurse -Filter "D2*.mpq"
```

Once found, copy them to: `C:\D2Server\`

## Step 3: Configure Cactus for Multiplayer

1. Open `C:\D2Server\Cactus.exe`
2. Click "Add"
3. Fill in:
   - **Platform**: `Disotheb`
   - **Label**: `Multiplayer` (optional)
   - **Launcher**: `Game.exe`
   - **Flags**: `-skiptobnet` (optional, skips to multiplayer)
4. Click "Add"

## Step 4: Set Up TCP/IP Server

### Option A: Local LAN (Easy)
1. Launch from Cactus
2. Click "Multiplayer" → "TCP/IP Game"
3. Click "Host Game"
4. Friends connect using your local IP: `192.168.x.x`

To find your IP:
```powershell
ipconfig | Select-String "IPv4"
```

### Option B: Online (Port Forwarding)
1. Forward port **4000** (TCP & UDP) on your router
2. Friends connect using your public IP

Find public IP:
```powershell
(Invoke-WebRequest -Uri "https://api.ipify.org").Content
```

### Option C: VPN (Easiest for Online)
Use one of these free VPN services:
- **ZeroTier** (Recommended) - https://www.zerotier.com/
- **Hamachi** - https://vpn.net/
- **Radmin VPN** - https://www.radmin-vpn.com/

These create a virtual LAN so friends can connect as if on same network.

## Step 5: Web Launcher Integration

Update the web launcher to point to your Cactus setup:

1. Players visit: http://localhost:3000
2. Create/select hero
3. Create/join game room
4. Click "PLAY" gets instructions
5. Launch D2 via Cactus manually
6. Use TCP/IP to connect

## Alternative: PvPGN Server (Advanced)

If you want Battle.net-style server with realms:

### Install PvPGN:
```powershell
# Download PvPGN
# https://github.com/pvpgn/pvpgn-server/releases

# Extract to C:\PvPGN\
# Run: bnetd.exe
```

### Configure D2 to connect:
1. Edit `C:\D2Server\registry_fix.reg`:
```reg
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Blizzard Entertainment\Diablo II]
"Gateway"="localhost"
```

2. Double-click to apply
3. Launch D2, click Battle.net
4. Server runs on localhost

## Folder Structure
```
C:\D2Server\
├── Cactus.exe              # Launcher
├── D2*.mpq                 # Core game files
├── Platforms\
│   ├── 1.09b\             # Vanilla versions
│   ├── 1.14d\
│   └── Disotheb\          # Your custom mod
├── Saves\
│   └── Disotheb\          # Character saves
└── Backups\               # Auto backups
```

## Testing Steps

1. **Test locally first:**
   ```powershell
   cd C:\D2Server
   .\Cactus.exe
   ```

2. **Launch Disotheb platform**

3. **Create test character**

4. **Try TCP/IP:**
   - Host a game
   - Open 2nd D2 instance (Cactus allows multi-instance)
   - Join your own game

5. **Verify web lobby:**
   - Open http://localhost:3000
   - Create hero
   - Create game room
   - Check chat works

## Port Reference

- **TCP/IP Game**: Port 4000 (TCP & UDP)
- **PvPGN Server**: Port 6112 (TCP)
- **Web Lobby**: Port 3000 (TCP)

## Troubleshooting

**"Can't find MPQs"**
- Make sure all D2*.mpq files are in C:\D2Server\

**"Can't join TCP/IP"**
- Disable Windows Firewall temporarily
- Check port 4000 is open
- Use VPN software instead

**"Version mismatch"**
- All players must use same D2 version
- Use same Cactus platform

**"Characters not saved"**
- Check C:\D2Server\Saves\Disotheb\
- Cactus automatically manages save paths

## Next Steps

Want me to:
1. ✅ Create automated setup scripts?
2. ✅ Set up PvPGN server?
3. ✅ Deploy web lobby to VPS?
4. ✅ Create server monitoring dashboard?

Let me know what you need!
