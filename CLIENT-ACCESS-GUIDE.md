# 🎮 DiabloGrudge - Player Access Guide

**Welcome to DiabloGrudge!** This guide will help you connect to our Diablo 2 multiplayer community.

---

## 📱 Step 1: Access the Web Lobby

### What You Need:
- A modern web browser (Chrome, Firefox, Edge, Safari)
- Internet connection
- The DiabloGrudge lobby URL (provided by admin)

### How to Connect:
1. Open your web browser
2. Navigate to: **[YOUR_LOBBY_URL_HERE]**
3. Bookmark this page for easy access!

---

## 🧙 Step 2: Create Your Hero

### Hero Creation:
1. On the main page, you'll see "Create New Hero"
2. Click "Create Hero" button
3. Choose your class:
   - ⚔️ **Warrior** - Melee combat specialist
   - 🔮 **Wizard** - Master of magic
   - 🏹 **Rogue** - Ranged and stealth
   - ⚡ **Paladin** - Holy warrior
   - 💀 **Necromancer** - Summoner of undead
   - 🪓 **Barbarian** - Brutal fighter
   - 🎯 **Amazon** - Bow and javelin expert
4. Enter a hero name
5. Click "Create"

**Your hero is saved in your browser!** You can create multiple heroes and switch between them.

### Selecting Your Hero:
1. Click on any hero card to select it
2. Your selected hero will be highlighted
3. This is the hero you'll use in the lobby and games

---

## 🎮 Step 3: Join the Lobby

### Entering the Lobby:
1. After selecting a hero, click "Enter Lobby"
2. You'll see:
   - **Online Players**: All connected players
   - **Available Games**: Games you can join
   - **Chat**: Communicate with others

### Lobby Features:
- **Create Game**: Start a new game room
- **Join Game**: Join an existing game
- **Chat**: Send messages to all lobby members
- **Player List**: See who's online

---

## 🏰 Step 4: Create or Join a Game

### Creating a Game:
1. Click "Create Game" button
2. Enter game name (e.g., "Baal Run", "Hell Cows")
3. (Optional) Set a password for private games
4. Click "Create"
5. Wait for other players to join!

### Joining a Game:
1. Browse the "Available Games" list
2. Click "Join" on any game
3. Enter password if required
4. You're in! Chat with your party in the game room

### Game Room Info:
- **Max 8 players** per game
- Game host shown with crown icon
- Game is deleted when last player leaves
- Use game room chat to coordinate

---

## 🌐 Step 5: Install ZeroTier (For D2 Connection)

### What is ZeroTier?
ZeroTier creates a virtual LAN so you can play D2 online without port forwarding. It's like everyone is on the same Wi-Fi!

### Install ZeroTier:
1. Download from: https://www.zerotier.com/download/
2. Install ZeroTier One (it's free!)
3. Restart your computer after installation

### Join DiabloGrudge Network:
1. Right-click ZeroTier icon in system tray (near clock)
2. Click "Join Network..."
3. Enter Network ID: **[ADMIN_WILL_PROVIDE]**
4. Click "Join"

### Get Authorized:
1. Contact admin after joining
2. Admin will authorize you in ZeroTier Central
3. Wait 30 seconds for connection
4. You're connected!

### Find Your ZeroTier IP:
**Windows:**
```powershell
ipconfig | Select-String "ZeroTier"
```

**Or manually:**
1. Open Command Prompt or PowerShell
2. Type: `ipconfig`
3. Look for "ZeroTier One" adapter
4. Note your IPv4 Address (looks like 10.147.x.x)

---

## 🎲 Step 6: Launch Diablo 2

### Requirements:
- Diablo 2 installed on your PC
- (Optional) Cactus launcher for mods
- Your ZeroTier IP from Step 5

### Launching D2:

#### Option A: Standard D2
1. Launch Diablo 2
2. Click "Multiplayer"
3. Click "TCP/IP Game"

#### Option B: With Cactus (for mods)
1. Launch Cactus.exe
2. Select your mod (e.g., Disotheb)
3. Click "Launch"
4. In D2: Multiplayer → TCP/IP Game

---

## 🔗 Step 7: Connect to Game

### Hosting a Game:
1. In D2, click "Host Game"
2. Create your game name
3. Set difficulty and other options
4. Click "Create"
5. **Share your ZeroTier IP** with other players!

### Joining a Game:
1. In D2, click "Join Game"
2. Enter the host's **ZeroTier IP address** (not their regular IP!)
   - Example: `10.147.17.1`
3. Click "Join"
4. You're in! Start playing!

---

## 💬 Communication

### Web Lobby Chat:
- Chat in lobby to find players
- Chat in game rooms to coordinate
- Be respectful and friendly!

### Voice Chat (Optional):
Consider using:
- Discord
- TeamSpeak
- In-game chat if available

---

## ❓ Troubleshooting

### Can't Access Web Lobby
**Problem:** Lobby URL won't load

**Solutions:**
- Check your internet connection
- Try different browser
- Clear browser cache
- Contact admin for correct URL

---

### Heroes Not Saving
**Problem:** Heroes disappear after refresh

**Solutions:**
- Enable browser localStorage (check browser settings)
- Don't use incognito/private browsing mode
- Try different browser
- Make sure you're not clearing browser data

---

### Can't Connect to ZeroTier
**Problem:** Network won't join or shows "Access Denied"

**Solutions:**
- Verify you entered correct Network ID
- Contact admin to authorize your device
- Wait 30-60 seconds after joining
- Restart ZeroTier service
- Check firewall isn't blocking ZeroTier

---

### Can't Join D2 Game
**Problem:** Connection fails in D2 TCP/IP

**Solutions:**
- **Verify both players are on ZeroTier network**
- Use **ZeroTier IP**, not regular IP
- Check Windows Firewall allows D2
- Verify port 4000 is open
- Try hosting instead of joining
- Make sure you're using same D2 version

---

### Connection Lag
**Problem:** Game is laggy or disconnects

**Solutions:**
- Check your internet speed
- Close bandwidth-heavy apps
- Choose host with best connection
- Consider wired connection instead of Wi-Fi
- Check ZeroTier ping to host

---

## 🎯 Quick Reference

### Important Links:
- **Web Lobby:** [YOUR_LOBBY_URL]
- **Admin Panel:** [YOUR_LOBBY_URL]/admin.html (admins only)
- **ZeroTier Download:** https://www.zerotier.com/download/
- **ZeroTier Central:** https://my.zerotier.com/

### Network Info:
- **ZeroTier Network ID:** [ADMIN_PROVIDES]
- **Server ZeroTier IP:** [ADMIN_PROVIDES]
- **D2 Port:** 4000 (TCP & UDP)

### Hero Classes:
- ⚔️ Warrior | 🔮 Wizard | 🏹 Rogue | ⚡ Paladin
- 💀 Necromancer | 🪓 Barbarian | 🎯 Amazon

---

## 🎉 Tips for Best Experience

1. **Create Multiple Heroes**
   - Try different classes
   - Level up different builds
   - Switch based on party needs

2. **Use Descriptive Game Names**
   - "Baal Run - Hell"
   - "Cow Level Farm"
   - "Act 1 Questing"

3. **Communicate in Lobby**
   - Announce what you're playing
   - Ask for party members
   - Coordinate game times

4. **Be a Good Player**
   - Don't ninja loot
   - Help new players
   - Be patient with connections
   - Have fun!

5. **Stay Connected**
   - Keep ZeroTier running
   - Don't close lobby tab
   - Check for community announcements

---

## 📞 Support

**Need Help?**
- Ask in lobby chat
- Contact server admin
- Check troubleshooting section above
- Report bugs to admin

**Server Admin Contact:** [ADMIN_CONTACT_INFO]

---

## 🏆 Community Rules

1. **Be Respectful** - No harassment, toxicity, or hate speech
2. **No Cheating** - Play fair, no hacks or exploits
3. **Help Others** - Newbie friendly community
4. **Have Fun!** - This is about enjoying D2 together

**Admin reserves the right to kick or ban players violating rules.**

---

## 🚀 Ready to Play!

You're all set! Here's your checklist:
- ✅ Access web lobby
- ✅ Create hero
- ✅ Install ZeroTier
- ✅ Join DiabloGrudge network
- ✅ Get authorized
- ✅ Launch D2
- ✅ Connect and PLAY!

**Welcome to DiabloGrudge! Good hunting in Sanctuary!** ⚔️🔥

---

*Last Updated: 2026-01-12*  
*Questions? Contact your server administrator*
