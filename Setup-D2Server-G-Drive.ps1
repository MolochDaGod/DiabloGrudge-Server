# DiabloGrudge D2 Server Setup Script - G Drive Installation
# Run as Administrator

param(
    [string]$ServerPath = "G:\D2Server"
)

Write-Host "🎮 DiabloGrudge D2 Server Setup (G: Drive)" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Create server directory
Write-Host "📁 Creating server directory on G: drive..." -ForegroundColor Yellow
if (!(Test-Path $ServerPath)) {
    New-Item -ItemType Directory -Path $ServerPath | Out-Null
    Write-Host "✅ Created: $ServerPath" -ForegroundColor Green
} else {
    Write-Host "⚠️  Directory already exists: $ServerPath" -ForegroundColor Yellow
}

# Step 2: Copy Cactus files
Write-Host ""
Write-Host "📦 Copying Cactus files..." -ForegroundColor Yellow
$CactusSource = "C:\Users\nugye\Documents\Cactus\Cactus\1. Files"
if (Test-Path $CactusSource) {
    Copy-Item "$CactusSource\*" -Destination $ServerPath -Recurse -Force
    Write-Host "✅ Cactus files copied" -ForegroundColor Green
} else {
    Write-Host "❌ Cactus not found at: $CactusSource" -ForegroundColor Red
    Write-Host "   Please extract Cactus first!" -ForegroundColor Yellow
    exit 1
}

# Step 3: Set up Disotheb platform
Write-Host ""
Write-Host "📦 Setting up Disotheb mod..." -ForegroundColor Yellow
$DisothebSource = "C:\Users\nugye\Documents\Disotheb_Patch_1\Disotheb (Patch 1)"
$DisothebDest = "$ServerPath\Platforms\Disotheb"

if (Test-Path $DisothebSource) {
    if (!(Test-Path $DisothebDest)) {
        New-Item -ItemType Directory -Path $DisothebDest | Out-Null
    }
    Copy-Item "$DisothebSource\*" -Destination $DisothebDest -Recurse -Force
    Write-Host "✅ Disotheb mod copied" -ForegroundColor Green
} else {
    Write-Host "⚠️  Disotheb not found, skipping..." -ForegroundColor Yellow
}

# Step 4: Copy Disotheb from DiabloGrudge-Server repo
Write-Host ""
Write-Host "📦 Copying Disotheb from repo..." -ForegroundColor Yellow
$DisothebRepoSource = "C:\Users\nugye\Documents\DiabloGrudge-Server\Disotheb"
if (Test-Path $DisothebRepoSource) {
    if (!(Test-Path $DisothebDest)) {
        New-Item -ItemType Directory -Path $DisothebDest | Out-Null
    }
    Copy-Item "$DisothebRepoSource\*" -Destination $DisothebDest -Recurse -Force
    Write-Host "✅ Disotheb from repo copied" -ForegroundColor Green
}

# Step 5: Search for core D2 MPQs
Write-Host ""
Write-Host "🔍 Searching for core D2 MPQ files..." -ForegroundColor Yellow

$MPQLocations = @(
    "C:\Program Files (x86)\Diablo II",
    "C:\Program Files\Diablo II",
    "$env:USERPROFILE\Saved Games\Diablo II",
    "C:\Users\nugye\Documents\Disotheb_Patch_1",
    "C:\Users\nugye\Documents\Disotheb_Patch_1\Disotheb (Patch 1)",
    "C:\Users\nugye\Documents\DiabloGrudge-Server\Disotheb",
    "C:\Users\nugye\Documents\Cactus\Cactus"
)

$RequiredMPQs = @(
    "D2Char.mpq",
    "D2Data.mpq",
    "D2Exp.mpq",
    "D2Music.mpq",
    "D2Sfx.mpq",
    "D2Speech.mpq",
    "D2Video.mpq",
    "D2XMusic.mpq",
    "D2XTalk.mpq",
    "D2XVideo.mpq",
    "D2.LNG"
)

$CopiedMPQs = @{}

foreach ($location in $MPQLocations) {
    if (Test-Path $location) {
        Write-Host "  Checking: $location" -ForegroundColor Gray
        
        foreach ($mpqName in $RequiredMPQs) {
            if (!$CopiedMPQs.ContainsKey($mpqName)) {
                $mpqPath = Get-ChildItem $location -Filter $mpqName -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
                
                if ($mpqPath) {
                    $destPath = Join-Path $ServerPath $mpqName
                    Copy-Item $mpqPath.FullName -Destination $destPath -Force
                    $CopiedMPQs[$mpqName] = $true
                    Write-Host "  ✅ Found `& copied: $mpqName" -ForegroundColor Green
                }
            }
        }
    }
}

# Check what's missing
$MissingMPQs = $RequiredMPQs | Where-Object { !$CopiedMPQs.ContainsKey($_) }
if ($MissingMPQs.Count -gt 0) {
    Write-Host ""
    Write-Host "⚠️  Missing MPQ files:" -ForegroundColor Yellow
    $MissingMPQs | ForEach-Object { Write-Host "   - $_" -ForegroundColor Red }
    Write-Host "   Please copy these manually to: $ServerPath" -ForegroundColor Yellow
}

# Step 6: Create firewall rules
Write-Host ""
Write-Host "🔒 Configuring Windows Firewall..." -ForegroundColor Yellow
try {
    New-NetFirewallRule -DisplayName "D2 TCP/IP Server" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 4000 -ErrorAction SilentlyContinue | Out-Null
    New-NetFirewallRule -DisplayName "D2 TCP/IP Server UDP" -Direction Inbound -Action Allow -Protocol UDP -LocalPort 4000 -ErrorAction SilentlyContinue | Out-Null
    Write-Host "✅ Firewall rules added for port 4000" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Could not add firewall rules (need admin)" -ForegroundColor Yellow
}

# Step 7: Create launch configuration
Write-Host ""
Write-Host "⚙️  Creating Cactus configuration..." -ForegroundColor Yellow

$EntriesPath = "$ServerPath\Entries.json"
if (!(Test-Path $EntriesPath)) {
    $entries = @{
        entries = @(
            @{
                name = "Disotheb"
                label = "Multiplayer"
                launcher = "Game.exe"
                flags = ""
                note = "DiabloGrudge multiplayer server"
                id = (New-Guid).ToString()
            }
        )
    } | ConvertTo-Json -Depth 10
    
    $entries | Out-File -FilePath $EntriesPath -Encoding UTF8
    Write-Host "✅ Cactus configuration created" -ForegroundColor Green
}

# Step 8: Create shortcuts
Write-Host ""
Write-Host "🔗 Creating shortcuts..." -ForegroundColor Yellow

$WScriptShell = New-Object -ComObject WScript.Shell

# Cactus shortcut
$CactusShortcut = $WScriptShell.CreateShortcut("$env:USERPROFILE\Desktop\DiabloGrudge Server (G Drive).lnk")
$CactusShortcut.TargetPath = "$ServerPath\Cactus.exe"
$CactusShortcut.WorkingDirectory = $ServerPath
$CactusShortcut.Description = "Launch DiabloGrudge D2 Server (G: Drive)"
$CactusShortcut.Save()
Write-Host "✅ Created desktop shortcut: DiabloGrudge Server (G Drive)" -ForegroundColor Green

# Summary
Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "✅ Setup Complete!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📍 Server location: $ServerPath" -ForegroundColor White
Write-Host "🎮 Launch: Double-click 'DiabloGrudge Server (G Drive)' on desktop" -ForegroundColor White
Write-Host "🌐 Web lobby: http://localhost:3000" -ForegroundColor White
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Launch Cactus from desktop shortcut" -ForegroundColor White
Write-Host "2. Select 'Disotheb - Multiplayer' platform" -ForegroundColor White
Write-Host "3. Click 'Launch' to start D2" -ForegroundColor White
Write-Host "4. In D2: Multiplayer → TCP/IP Game → Host Game" -ForegroundColor White
Write-Host "5. Friends join using your IP address" -ForegroundColor White
Write-Host ""
Write-Host "To find your IP:" -ForegroundColor Yellow
$ip = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -notlike "*Loopback*"} | Select-Object -First 1).IPAddress
Write-Host "Local IP: $ip" -ForegroundColor Green
Write-Host ""
Write-Host "For online play, consider using ZeroTier or Hamachi VPN" -ForegroundColor Cyan
Write-Host ""
Write-Host "📊 Copied MPQs: $($CopiedMPQs.Count) / $($RequiredMPQs.Count)" -ForegroundColor White
Write-Host ""
