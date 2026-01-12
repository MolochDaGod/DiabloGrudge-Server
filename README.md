# 🎮 DiabloGrudge Multiplayer Server

A web-based multiplayer lobby and launcher for Diablo 2 with hero selection, game rooms, chat, and admin controls.

## 🚀 Features

- **Hero Selection**: Create and manage multiple heroes with different classes
- **Multiplayer Lobby**: Real-time player list and game browser
- **Game Rooms**: Create/join games with optional passwords (up to 8 players)
- **Global Chat**: Communicate with other players in the lobby
- **Admin Panel**: Kick/ban players, view stats, send announcements
- **Live Connection**: WebSocket-based real-time updates
- **Persistent Storage**: Heroes saved to browser localStorage

## 📋 Requirements

- Node.js 20+
- Modern web browser
- Diablo 2 installed (for actual gameplay)

## 🔧 Local Setup

1. **Install dependencies**:
```bash
npm install
```

2. **Set admin key** (optional):
```bash
# Windows PowerShell
$env:ADMIN_KEY="your-secret-key"

# Linux/Mac
export ADMIN_KEY="your-secret-key"
```

3. **Start server**:
```bash
npm start
```

4. **Access the lobby**:
- Main lobby: http://localhost:3000
- Admin panel: http://localhost:3000/admin.html

## ☁️ Deploy to Vercel

### Option 1: Vercel CLI (Recommended)

1. **Install Vercel CLI**:
```bash
npm install -g vercel
```

2. **Login to Vercel**:
```bash
vercel login
```

3. **Deploy**:
```bash
vercel
```

4. **Set environment variables**:
```bash
vercel env add ADMIN_KEY
```

5. **Deploy to production**:
```bash
vercel --prod
```

### Option 2: GitHub Integration

1. Push this code to GitHub
2. Import project on [vercel.com](https://vercel.com)
3. Add environment variable `ADMIN_KEY` in project settings
4. Deploy automatically on every push

## 🎮 Usage

### For Players:

1. Open the lobby URL
2. Create a hero (Warrior, Wizard, Rogue, Paladin, Necromancer, Barbarian, Amazon)
3. Select your hero to enter the lobby
4. Create a new game or join an existing one
5. Click "PLAY DIABLO 2" to launch the game
6. Use TCP/IP in D2 to connect with other players

### For Admins:

1. Navigate to `/admin.html`
2. Enter your admin key (default: `grudge-admin-2026`)
3. View server stats, manage players, kick/ban users
4. Send global announcements

## 🔐 Security

- Change the default `ADMIN_KEY` in production
- The server tracks IPs for banning
- Banned players cannot reconnect
- Admin actions are logged

## 🌐 Server API

### WebSocket Messages

**Client → Server:**
- `register` - Register player with hero
- `chat` - Send chat message
- `create_game` - Create new game room
- `join_game` - Join existing game
- `leave_game` - Leave current game
- `get_games` - Request game list
- `admin_kick` - Kick player (admin only)
- `admin_ban` - Ban player IP (admin only)
- `admin_stats` - Request server stats (admin only)

**Server → Client:**
- `connected` - Connection successful
- `player_list` - Updated player list
- `chat` - Chat message
- `games_list` - Available games
- `game_created` - New game created
- `game_closed` - Game closed
- `joined_game` - Successfully joined game
- `error` - Error message
- `admin_stats` - Server statistics

### REST Endpoints

- `GET /health` - Server health check
- `GET /api/games` - Get game list (JSON)

## 📁 Project Structure

```
DiabloGrudge-Server/
├── server.js           # Node.js WebSocket server
├── package.json        # Dependencies and scripts
├── vercel.json        # Vercel deployment config
├── public/
│   ├── index.html     # Main lobby interface
│   └── admin.html     # Admin dashboard
└── README.md          # This file
```

## 🎨 Customization

### Add More Hero Classes

Edit `index.html` and `admin.html`:
```javascript
const CLASS_ICONS = {
    warrior: '⚔️',
    wizard: '🔮',
    druid: '🌿',  // Add new class
    // ...
};
```

### Change Theme Colors

Modify CSS variables in the `<style>` section:
- `#d4af37` - Gold color
- `#8b0000` - Dark red
- `#0a0a0a` - Background

### Adjust Game Limits

In `server.js`:
```javascript
if (game.players.length >= 8) {  // Change max players
```

## 🐛 Troubleshooting

**WebSocket won't connect:**
- Check firewall settings
- Ensure port 3000 is available
- Verify Vercel WebSocket support

**Heroes not saving:**
- Check browser localStorage is enabled
- Clear browser cache and try again

**Admin panel not working:**
- Verify `ADMIN_KEY` environment variable
- Check browser console for errors

## 📝 License

MIT License - Free to use and modify

## 🤝 Contributing

Feel free to fork, improve, and submit pull requests!

---

**Made for DiabloGrudge Community** ⚔️
