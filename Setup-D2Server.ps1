# DiabloGrudge D2 Server Setup Script
# Run as Administrator

param(
    [string]$ServerPath = "C:\D2Server"
)

Write-Host "🎮 DiabloGrudge D2 Server Setup" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Create server directory
Write-Host "📁 Creating server directory..." -ForegroundColor Yellow
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

# Step 4: Search for core D2 MPQs
Write-Host ""
Write-Host "🔍 Searching for core D2 MPQ files..." -ForegroundColor Yellow

$MPQLocations = @(
    "C:\Program Files (x86)\Diablo II",
    "C:\Program Files\Diablo II",
    "$env:USERPROFILE\Saved Games\Diablo II",
    "C:\Users\nugye\Documents\Disotheb_Patch_1"
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

$FoundMPQs = @()

foreach ($location in $MPQLocations) {
    if (Test-Path $location) {
        Write-Host "  Checking: $location" -ForegroundColor Gray
        $mpqs = Get-ChildItem $location -Recurse -Filter "D2*.mpq" -ErrorAction SilentlyContinue
        if ($mpqs) {
            $FoundMPQs += $mpqs
            Write-Host "  ✅ Found MPQs in: $location" -ForegroundColor Green
        }
    }
}

# Copy found MPQs
if ($FoundMPQs.Count -gt 0) {
    Write-Host ""
    Write-Host "📋 Copying MPQ files to server..." -ForegroundColor Yellow
    foreach ($mpq in $FoundMPQs) {
        $destPath = Join-Path $ServerPath $mpq.Name
        if (!(Test-Path $destPath)) {
            Copy-Item $mpq.FullName -Destination $destPath -Force
            Write-Host "  ✅ Copied: $($mpq.Name)" -ForegroundColor Green
        }
    }
} else {
    Write-Host "⚠️  No MPQ files found automatically" -ForegroundColor Yellow
    Write-Host "   Please manually copy D2*.mpq files to: $ServerPath" -ForegroundColor Yellow
}

# Step 5: Create firewall rules
Write-Host ""
Write-Host "🔒 Configuring Windows Firewall..." -ForegroundColor Yellow
try {
    New-NetFirewallRule -DisplayName "D2 TCP/IP Server" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 4000 -ErrorAction SilentlyContinue | Out-Null
    New-NetFirewallRule -DisplayName "D2 TCP/IP Server UDP" -Direction Inbound -Action Allow -Protocol UDP -LocalPort 4000 -ErrorAction SilentlyContinue | Out-Null
    Write-Host "✅ Firewall rules added for port 4000" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Could not add firewall rules (need admin)" -ForegroundColor Yellow
}

# Step 6: Create launch configuration
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

# Step 7: Create shortcuts
Write-Host ""
Write-Host "🔗 Creating shortcuts..." -ForegroundColor Yellow

$WScriptShell = New-Object -ComObject WScript.Shell

# Cactus shortcut
$CactusShortcut = $WScriptShell.CreateShortcut("$env:USERPROFILE\Desktop\DiabloGrudge Server.lnk")
$CactusShortcut.TargetPath = "$ServerPath\Cactus.exe"
$CactusShortcut.WorkingDirectory = $ServerPath
$CactusShortcut.Description = "Launch DiabloGrudge D2 Server"
$CactusShortcut.Save()
Write-Host "✅ Created desktop shortcut: DiabloGrudge Server" -ForegroundColor Green

# Summary
Write-Host ""
Write-Host "=================================" -ForegroundColor Cyan
Write-Host "✅ Setup Complete!" -ForegroundColor Green
Write-Host "=================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📍 Server location: $ServerPath" -ForegroundColor White
Write-Host "🎮 Launch: Double-click 'DiabloGrudge Server' on desktop" -ForegroundColor White
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
