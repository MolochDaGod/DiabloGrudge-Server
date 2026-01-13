import express from 'express';
import { WebSocketServer } from 'ws';
import cors from 'cors';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';
import { exec } from 'child_process';
import { promisify } from 'util';
import os from 'os';
import D2CharacterManager from './d2-character-manager.js';

const execAsync = promisify(exec);
const charManager = new D2CharacterManager();

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const app = express();
const PORT = process.env.PORT || 3000;

// Security headers with proper CSP
app.use((req, res, next) => {
  res.setHeader(
    'Content-Security-Policy',
    "default-src 'self'; " +
    "script-src 'self' 'unsafe-inline' 'unsafe-eval'; " +
    "style-src 'self' 'unsafe-inline'; " +
    "img-src 'self' data: https:; " +
    "media-src 'self' data: blob:; " +
    "font-src 'self' data:; " +
    "connect-src 'self' ws: wss: http: https:; " +
    "frame-ancestors 'none'"
  );
  next();
});

app.use(cors());
app.use(express.json());
app.use(express.static('public'));

// Favicon route
app.get('/favicon.ico', (req, res) => {
  res.redirect('/favicon.svg');
});

// API Routes

// ZeroTier status check
app.get('/api/zerotier/status', async (req, res) => {
  try {
    if (os.platform() !== 'win32') {
      return res.json({ connected: false, error: 'Only Windows supported' });
    }

    // Get ZeroTier IP from ipconfig
    const { stdout } = await execAsync('ipconfig');
    
    // Find ZeroTier adapter
    const lines = stdout.split('\n');
    let inZeroTier = false;
    let ztIP = null;
    
    for (const line of lines) {
      if (line.includes('ZeroTier')) {
        inZeroTier = true;
      }
      if (inZeroTier && line.includes('IPv4 Address')) {
        const match = line.match(/([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})/);
        if (match) {
          ztIP = match[1];
          break;
        }
      }
    }

    if (ztIP) {
      res.json({
        connected: true,
        ip: ztIP,
        uptime: 'Active'
      });
    } else {
      res.json({
        connected: false,
        error: 'ZeroTier adapter not found or not connected'
      });
    }
  } catch (error) {
    res.json({
      connected: false,
      error: error.message
    });
  }
});

// Launch game endpoint
app.post('/api/launch-game', async (req, res) => {
  try {
    const { game, path, puterUserId, characterName } = req.body;
    
    if (os.platform() !== 'win32') {
      return res.json({ 
        success: false, 
        error: 'Game launching only supported on Windows' 
      });
    }

    if (game === 'thoc') {
      // If character specified, activate it first
      if (puterUserId && characterName) {
        await charManager.activateCharacter(puterUserId, characterName);
      }
      
      // Launch THOC via Cactus
      const cactusPath = path || 'C:\\Users\\nugye\\Documents\\Cactus\\Cactus\\thoc_b8_1';
      
      // Open the directory in explorer
      await execAsync(`explorer "${cactusPath}"`);
      
      res.json({
        success: true,
        message: 'Opening THOC directory. Please launch via Cactus.',
        character: characterName
      });
    } else {
      res.json({
        success: false,
        error: 'Unknown game'
      });
    }
  } catch (error) {
    res.json({
      success: false,
      error: error.message
    });
  }
});

// Puter Authentication
app.post('/api/auth/puter', async (req, res) => {
  try {
    const { puterUserId, username } = req.body;
    
    if (!puterUserId) {
      return res.status(400).json({ error: 'Puter user ID required' });
    }
    
    // Initialize user if new
    await charManager.initializeUser(puterUserId);
    
    res.json({
      success: true,
      userId: puterUserId,
      username: username || 'Player'
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// List user's characters
app.get('/api/characters/:puterUserId', async (req, res) => {
  try {
    const { puterUserId } = req.params;
    const characters = await charManager.listCharacters(puterUserId);
    
    res.json({ characters });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Create new character
app.post('/api/characters/create', async (req, res) => {
  try {
    const { puterUserId, characterName, className, isHardcore } = req.body;
    
    if (!puterUserId || !characterName || !className) {
      return res.status(400).json({ error: 'Missing required fields' });
    }
    
    // Check character limit (max 10 per user)
    const count = await charManager.getCharacterCount(puterUserId);
    if (count >= 10) {
      return res.status(400).json({ error: 'Maximum 10 characters per user' });
    }
    
    const character = await charManager.createCharacter(
      puterUserId,
      characterName,
      className,
      isHardcore || false
    );
    
    res.json({ success: true, character });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// Delete character
app.delete('/api/characters/:puterUserId/:characterName', async (req, res) => {
  try {
    const { puterUserId, characterName } = req.params;
    
    await charManager.deleteCharacter(puterUserId, characterName);
    
    res.json({ success: true });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Activate character for play
app.post('/api/characters/activate', async (req, res) => {
  try {
    const { puterUserId, characterName } = req.body;
    
    const result = await charManager.activateCharacter(puterUserId, characterName);
    
    res.json(result);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Sync character back after playing
app.post('/api/characters/sync', async (req, res) => {
  try {
    const { puterUserId, characterName } = req.body;
    
    const result = await charManager.syncCharacterBack(puterUserId, characterName);
    
    res.json(result);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Game state
const gameState = {
  players: new Map(),
  games: new Map(),
  adminKey: process.env.ADMIN_KEY || 'grudge-admin-2026',
  bannedIPs: new Set(),
};

// Start HTTP server
const server = app.listen(PORT, () => {
  console.log(`🎮 DiabloGrudge Server running on port ${PORT}`);
  console.log(`🔑 Admin key: ${gameState.adminKey}`);
});

// WebSocket server
const wss = new WebSocketServer({ server });

wss.on('connection', (ws, req) => {
    const clientIP = req.socket.remoteAddress;
    
    if (gameState.bannedIPs.has(clientIP)) {
      ws.close(1008, 'Banned');
      return;
    }

    const playerId = generateId();
    
    ws.on('message', (data) => {
      try {
        const msg = JSON.parse(data.toString());
        handleMessage(ws, playerId, msg, clientIP);
      } catch (err) {
        console.error('Message error:', err);
      }
    });

    ws.on('close', () => {
      handleDisconnect(playerId);
    });

    ws.send(JSON.stringify({ 
      type: 'connected', 
      playerId,
      serverTime: Date.now()
    }));
  });

function handleMessage(ws, playerId, msg, clientIP) {
  switch (msg.type) {
    case 'register':
      registerPlayer(ws, playerId, msg.hero, clientIP);
      break;
    case 'chat':
      broadcastChat(playerId, msg.message);
      break;
    case 'create_game':
      createGame(playerId, msg.gameName, msg.password);
      break;
    case 'join_game':
      joinGame(playerId, msg.gameId, msg.password);
      break;
    case 'leave_game':
      leaveGame(playerId);
      break;
    case 'get_games':
      sendGamesList(ws);
      break;
    case 'admin_kick':
      if (msg.adminKey === gameState.adminKey) {
        kickPlayer(msg.targetId);
      }
      break;
    case 'admin_ban':
      if (msg.adminKey === gameState.adminKey) {
        banPlayer(msg.targetId);
      }
      break;
    case 'admin_stats':
      if (msg.adminKey === gameState.adminKey) {
        sendAdminStats(ws);
      }
      break;
  }
}

function registerPlayer(ws, playerId, hero, ip) {
  gameState.players.set(playerId, {
    id: playerId,
    ws,
    hero,
    ip,
    gameId: null,
    connectedAt: Date.now()
  });
  
  broadcastPlayerList();
  console.log(`✅ Player ${hero.name} (${playerId}) connected`);
}

function handleDisconnect(playerId) {
  const player = gameState.players.get(playerId);
  if (player) {
    if (player.gameId) {
      leaveGame(playerId);
    }
    gameState.players.delete(playerId);
    broadcastPlayerList();
    console.log(`❌ Player ${player.hero?.name} disconnected`);
  }
}

function createGame(playerId, gameName, password) {
  const gameId = generateId();
  const player = gameState.players.get(playerId);
  
  if (!player) return;

  gameState.games.set(gameId, {
    id: gameId,
    name: gameName,
    host: playerId,
    players: [playerId],
    password: password || null,
    createdAt: Date.now(),
    status: 'waiting'
  });

  player.gameId = gameId;
  
  broadcast({
    type: 'game_created',
    game: getPublicGameInfo(gameId)
  });

  player.ws.send(JSON.stringify({
    type: 'joined_game',
    gameId,
    isHost: true
  }));

  console.log(`🎲 Game "${gameName}" created by ${player.hero.name}`);
}

function joinGame(playerId, gameId, password) {
  const game = gameState.games.get(gameId);
  const player = gameState.players.get(playerId);
  
  if (!game || !player) return;

  if (game.password && game.password !== password) {
    player.ws.send(JSON.stringify({
      type: 'error',
      message: 'Wrong password'
    }));
    return;
  }

  if (game.players.length >= 8) {
    player.ws.send(JSON.stringify({
      type: 'error',
      message: 'Game full'
    }));
    return;
  }

  game.players.push(playerId);
  player.gameId = gameId;

  player.ws.send(JSON.stringify({
    type: 'joined_game',
    gameId,
    isHost: false
  }));

  notifyGamePlayers(gameId, {
    type: 'player_joined',
    player: {
      id: playerId,
      hero: player.hero
    }
  });

  console.log(`🎮 ${player.hero.name} joined game "${game.name}"`);
}

function leaveGame(playerId) {
  const player = gameState.players.get(playerId);
  if (!player || !player.gameId) return;

  const game = gameState.games.get(player.gameId);
  if (!game) return;

  game.players = game.players.filter(id => id !== playerId);
  player.gameId = null;

  if (game.players.length === 0) {
    gameState.games.delete(game.id);
    broadcast({ type: 'game_closed', gameId: game.id });
  } else if (game.host === playerId) {
    game.host = game.players[0];
    notifyGamePlayers(game.id, {
      type: 'new_host',
      hostId: game.host
    });
  } else {
    notifyGamePlayers(game.id, {
      type: 'player_left',
      playerId
    });
  }
}

function broadcastChat(playerId, message) {
  const player = gameState.players.get(playerId);
  if (!player) return;

  const chatMsg = {
    type: 'chat',
    from: player.hero.name,
    message,
    timestamp: Date.now()
  };

  if (player.gameId) {
    notifyGamePlayers(player.gameId, chatMsg);
  } else {
    broadcast(chatMsg);
  }
}

function kickPlayer(targetId) {
  const player = gameState.players.get(targetId);
  if (player) {
    player.ws.close(1008, 'Kicked by admin');
    handleDisconnect(targetId);
  }
}

function banPlayer(targetId) {
  const player = gameState.players.get(targetId);
  if (player) {
    gameState.bannedIPs.add(player.ip);
    player.ws.close(1008, 'Banned by admin');
    handleDisconnect(targetId);
    console.log(`🚫 Banned IP: ${player.ip}`);
  }
}

function sendGamesList(ws) {
  const games = Array.from(gameState.games.values()).map(g => getPublicGameInfo(g.id));
  ws.send(JSON.stringify({ type: 'games_list', games }));
}

function sendAdminStats(ws) {
  ws.send(JSON.stringify({
    type: 'admin_stats',
    stats: {
      players: gameState.players.size,
      games: gameState.games.size,
      bannedIPs: gameState.bannedIPs.size,
      uptime: process.uptime()
    }
  }));
}

function getPublicGameInfo(gameId) {
  const game = gameState.games.get(gameId);
  if (!game) return null;

  return {
    id: game.id,
    name: game.name,
    players: game.players.length,
    maxPlayers: 8,
    hasPassword: !!game.password,
    status: game.status
  };
}

function notifyGamePlayers(gameId, message) {
  const game = gameState.games.get(gameId);
  if (!game) return;

  game.players.forEach(playerId => {
    const player = gameState.players.get(playerId);
    if (player && player.ws.readyState === 1) {
      player.ws.send(JSON.stringify(message));
    }
  });
}

function broadcastPlayerList() {
  const players = Array.from(gameState.players.values()).map(p => ({
    id: p.id,
    hero: p.hero,
    inGame: !!p.gameId
  }));

  broadcast({ type: 'player_list', players });
}

function broadcast(message) {
  const data = JSON.stringify(message);
  gameState.players.forEach(player => {
    if (player.ws.readyState === 1) {
      player.ws.send(data);
    }
  });
}

function generateId() {
  return Math.random().toString(36).substr(2, 9);
}

// Root route - serve index.html
app.get('/', (req, res) => {
  res.sendFile(join(__dirname, 'public', 'index.html'));
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ 
    status: 'ok', 
    players: gameState.players.size,
    games: gameState.games.size
  });
});

// API endpoint for game list
app.get('/api/games', (req, res) => {
  const games = Array.from(gameState.games.values()).map(g => getPublicGameInfo(g.id));
  res.json({ games });
});
