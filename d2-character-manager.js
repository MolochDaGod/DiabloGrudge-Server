import { promises as fs } from 'fs';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// D2 Character Classes
const CLASSES = {
    Amazon: 0,
    Sorceress: 1,
    Necromancer: 2,
    Paladin: 3,
    Barbarian: 4,
    Druid: 5,
    Assassin: 6
};

const CLASS_ICONS = {
    Amazon: '🏹',
    Sorceress: '🔮',
    Necromancer: '💀',
    Paladin: '🛡️',
    Barbarian: '⚔️',
    Druid: '🌿',
    Assassin: '🗡️'
};

class D2CharacterManager {
    constructor(baseSavePath = join(__dirname, 'Saves')) {
        this.baseSavePath = baseSavePath;
        this.cactusPath = 'C:\\Users\\nugye\\Documents\\Cactus\\Saves\\thoc_b8_1';
    }

    // Get user's save directory
    getUserSavePath(puterUserId) {
        return join(this.baseSavePath, `puter_${puterUserId}`);
    }

    // Initialize user directory if it doesn't exist
    async initializeUser(puterUserId) {
        const userPath = this.getUserSavePath(puterUserId);
        await fs.mkdir(userPath, { recursive: true });
        
        const metadataPath = join(userPath, 'characters.json');
        try {
            await fs.access(metadataPath);
        } catch {
            await fs.writeFile(metadataPath, JSON.stringify({}, null, 2));
        }
        
        return userPath;
    }

    // List user's characters
    async listCharacters(puterUserId) {
        const userPath = this.getUserSavePath(puterUserId);
        const metadataPath = join(userPath, 'characters.json');
        
        try {
            const data = await fs.readFile(metadataPath, 'utf8');
            return JSON.parse(data);
        } catch {
            return {};
        }
    }

    // Create a new D2 character
    async createCharacter(puterUserId, characterName, className, isHardcore = false) {
        // Sanitize character name
        const safeName = characterName.replace(/[^a-zA-Z0-9_-]/g, '').substring(0, 15);
        if (!safeName) {
            throw new Error('Invalid character name');
        }

        if (!CLASSES.hasOwnProperty(className)) {
            throw new Error('Invalid character class');
        }

        await this.initializeUser(puterUserId);
        const userPath = this.getUserSavePath(puterUserId);
        const savePath = join(userPath, `${safeName}.d2s`);
        
        // Check if character already exists
        try {
            await fs.access(savePath);
            throw new Error('Character already exists');
        } catch (err) {
            if (err.message === 'Character already exists') throw err;
        }

        // Create basic D2 save file
        const saveData = this.generateD2SaveFile(safeName, className, isHardcore);
        await fs.writeFile(savePath, saveData);

        // Update metadata
        const metadata = await this.listCharacters(puterUserId);
        metadata[safeName] = {
            class: className,
            level: 1,
            hardcore: isHardcore,
            created: new Date().toISOString(),
            lastPlayed: new Date().toISOString(),
            icon: CLASS_ICONS[className]
        };

        const metadataPath = join(userPath, 'characters.json');
        await fs.writeFile(metadataPath, JSON.stringify(metadata, null, 2));

        return { name: safeName, ...metadata[safeName] };
    }

    // Generate a basic D2 save file
    generateD2SaveFile(name, className, isHardcore) {
        // D2 save file header (simplified for THOC/1.10)
        const buffer = Buffer.alloc(765); // Basic save file size
        
        // Signature: 0xAA55AA55
        buffer.writeUInt32LE(0xAA55AA55, 0);
        
        // Version (1.10 = 71)
        buffer.writeUInt32LE(71, 4);
        
        // File size
        buffer.writeUInt32LE(765, 8);
        
        // Checksum (simplified - would need proper calculation)
        buffer.writeUInt32LE(0, 12);
        
        // Active weapon set
        buffer.writeUInt32LE(0, 16);
        
        // Character name (max 16 bytes, null-terminated)
        const nameBytes = Buffer.from(name, 'ascii');
        nameBytes.copy(buffer, 20, 0, Math.min(15, nameBytes.length));
        
        // Character status flags (offset 36)
        let status = 0x00;
        if (isHardcore) status |= 0x04; // Hardcore flag
        buffer.writeUInt8(status, 36);
        
        // Character progression (offset 37)
        buffer.writeUInt8(0, 37); // Not started
        
        // Character class (offset 40)
        buffer.writeUInt8(CLASSES[className], 40);
        
        // Level (offset 43)
        buffer.writeUInt8(1, 43);
        
        // Difficulty flags (offset 168)
        buffer.writeUInt8(0, 168);
        
        // Stats header at offset 765 (simplified)
        // In real implementation, this would need proper stats structure
        
        return buffer;
    }

    // Delete a character
    async deleteCharacter(puterUserId, characterName) {
        const userPath = this.getUserSavePath(puterUserId);
        const savePath = join(userPath, `${characterName}.d2s`);
        
        await fs.unlink(savePath);
        
        // Update metadata
        const metadata = await this.listCharacters(puterUserId);
        delete metadata[characterName];
        
        const metadataPath = join(userPath, 'characters.json');
        await fs.writeFile(metadataPath, JSON.stringify(metadata, null, 2));
        
        return { success: true };
    }

    // Copy character to Cactus active saves
    async activateCharacter(puterUserId, characterName) {
        const userPath = this.getUserSavePath(puterUserId);
        const sourcePath = join(userPath, `${characterName}.d2s`);
        
        // Ensure Cactus directory exists
        await fs.mkdir(this.cactusPath, { recursive: true });
        
        const destPath = join(this.cactusPath, `${characterName}.d2s`);
        
        // Copy file
        await fs.copyFile(sourcePath, destPath);
        
        // Update last played time
        const metadata = await this.listCharacters(puterUserId);
        if (metadata[characterName]) {
            metadata[characterName].lastPlayed = new Date().toISOString();
            const metadataPath = join(userPath, 'characters.json');
            await fs.writeFile(metadataPath, JSON.stringify(metadata, null, 2));
        }
        
        return { success: true, path: destPath };
    }

    // Sync character back from Cactus (after playing)
    async syncCharacterBack(puterUserId, characterName) {
        const userPath = this.getUserSavePath(puterUserId);
        const sourcePath = join(this.cactusPath, `${characterName}.d2s`);
        const destPath = join(userPath, `${characterName}.d2s`);
        
        try {
            // Copy updated save back
            await fs.copyFile(sourcePath, destPath);
            
            // Update metadata
            const metadata = await this.listCharacters(puterUserId);
            if (metadata[characterName]) {
                metadata[characterName].lastPlayed = new Date().toISOString();
                // Would parse level from save file here
                const metadataPath = join(userPath, 'characters.json');
                await fs.writeFile(metadataPath, JSON.stringify(metadata, null, 2));
            }
            
            return { success: true };
        } catch (err) {
            console.error('Failed to sync character:', err);
            return { success: false, error: err.message };
        }
    }

    // Get character count for user
    async getCharacterCount(puterUserId) {
        const chars = await this.listCharacters(puterUserId);
        return Object.keys(chars).length;
    }
}

export default D2CharacterManager;
