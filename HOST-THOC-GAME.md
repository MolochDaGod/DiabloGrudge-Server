# 🎮 DiabloGrudge - Host THOC Games Quick Guide

## ✅ Your Network is Ready!

### 🌐 Your ZeroTier Network Info
- **Network ID:** `cf719fd5401e3d2c`
- **Device Name:** grudgeyonko (dev unit)
- **Your Primary IP:** `192.168.194.1` ⭐
- **Backup IPs:** 192.168.194.2, 192.168.194.3, 192.168.194.14, 192.168.194.15
- **Dashboard:** https://my.zerotier.com/

> **Note:** Use `192.168.194.1` as your primary hosting IP. If friends can't connect, try the backup IPs.

---

## 🎮 How to Host a THOC Game

### Step 1: Launch THOC via Cactus
1. Open **Cactus** from `C:\Users\nugye\Documents\Cactus\Cactus\`
2. Select platform: **thoc_b8_1**
3. Click **Launch** or **Run**
4. Diablo II should start with The Hordes of Chaos mod loaded

### Step 2: Host TCP/IP Game
1. In D2 main menu: **Multiplayer**
2. Select: **TCP/IP Game**
3. Click: **Host Game**
4. Create game name and password (optional)
5. Game is now live!

### Step 3: Share Your IP
Tell friends to connect to:
```
192.168.194.1
```

---

## 👥 How Friends Join Your Game

### Prerequisites (Friends Must Do Once)
1. **Install ZeroTier**
   - Download: https://www.zerotier.com/download/
   - Install and restart

2. **Join Your Network**
   - Right-click ZeroTier icon in system tray
   - Click "Join Network..."
   - Enter network ID: `cf719fd5401e3d2c`
   - Click Join

3. **Get Authorized by You**
   - You go to: https://my.zerotier.com/
   - Click network: cf719fd5401e3d2c
   - Scroll to "Members" section
   - Find their device and CHECK the "Auth" box
   - They wait 30 seconds for IP assignment

### Connecting to Your Game
1. Launch Diablo II (they can use any version/mod)
2. **Multiplayer** → **TCP/IP Game** → **Join Game**
3. Enter your IP: `192.168.194.1`
4. Press Enter
5. Select your game from the list

---

## 🔥 Firewall Ports (Already Configured)
✅ Port 4000 (TCP/UDP) - D2 TCP/IP
✅ Port 6112 (TCP/UDP) - Battle.net
✅ Port 9993 (UDP) - ZeroTier

---

## 🛠️ Troubleshooting

### "Can't find games" or "Connection failed"
1. **Verify both players are on ZeroTier:**
   ```powershell
   ipconfig | Select-String "192.168.194"
   ```
   Should show your ZeroTier IP

2. **Test connectivity:**
   ```powershell
   ping 192.168.194.1
   ```
   Friend runs this - should get replies

3. **Try backup IPs:**
   - 192.168.194.2
   - 192.168.194.3
   - 192.168.194.15

4. **Check ZeroTier is connected:**
   - Right-click ZeroTier tray icon
   - Should show "cf719fd5401e3d2c" with green checkmark

### Windows Firewall Blocking
If you didn't run the `Configure-D2-ZeroTier.ps1` script as admin:
```powershell
# Run as Administrator
.\Configure-D2-ZeroTier.ps1
```

### THOC Won't Launch via Cactus
1. Click **Reset** in Cactus
2. Launch thoc_b8_1 again
3. If still fails, check Diablo II path is correct

---

## 📝 Quick Commands

### Check Your ZeroTier IP
```powershell
ipconfig | Select-String "ZeroTier" -Context 0,5
```

### Test Friend's Connection
```powershell
# Friend runs this to test if they can reach you
ping 192.168.194.1
```

### Verify Firewall Rules
```powershell
Get-NetFirewallRule -DisplayName "Diablo II*" | Select-Object DisplayName, Enabled
```

---

## 🌐 Web Lobby Integration (Optional)

Your DiabloGrudge web server at http://localhost:3000 can coordinate games:
- Players create heroes and chat
- You announce: "Hosting THOC at 192.168.194.1"
- Friends join via TCP/IP using that IP

The web lobby doesn't launch D2 automatically - players still use Cactus/D2 directly.

---

## 💡 Pro Tips

1. **Keep ZeroTier running** - Don't close it while playing
2. **Authorize friends promptly** - They can't connect until you check the Auth box
3. **Same mod version** - Friends need THOC b8.1 if you're hosting THOC
4. **Character levels** - TCP/IP allows any level to play together
5. **Save backups** - THOC characters are in `Cactus/Saves/thoc_b8_1/`

---

## 📊 Network Topology

```
┌─────────────────────────────────────────┐
│   ZeroTier Network: cf719fd5401e3d2c    │
│   (Virtual LAN - 192.168.194.0/24)     │
└─────────────────────────────────────────┘
                    │
        ┌───────────┼───────────┐
        │           │           │
   You (Host)    Friend 1   Friend 2
   192.168.194.1  .x         .y
   
   Hosting THOC → D2 TCP/IP Port 4000
```

Everyone on the ZeroTier network can see each other as if on same LAN!

---

**Ready to play! 🎮⚔️**

Share this guide with friends or visit: https://my.zerotier.com/
