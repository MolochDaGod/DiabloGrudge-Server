# ZeroTier Setup for DiabloGrudge D2 Server
# Automatically sets up ZeroTier VPN for D2 multiplayer

Write-Host "🌐 ZeroTier Setup for DiabloGrudge" -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Download ZeroTier
Write-Host "📥 Downloading ZeroTier..." -ForegroundColor Yellow
$ZeroTierUrl = "https://download.zerotier.com/dist/ZeroTier%20One.msi"
$InstallerPath = "$env:TEMP\ZeroTierOne.msi"

try {
    Invoke-WebRequest -Uri $ZeroTierUrl -OutFile $InstallerPath -UseBasicParsing
    Write-Host "✅ Downloaded ZeroTier installer" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to download ZeroTier" -ForegroundColor Red
    Write-Host "   Please download manually from: https://www.zerotier.com/download/" -ForegroundColor Yellow
    exit 1
}

# Step 2: Install ZeroTier
Write-Host ""
Write-Host "📦 Installing ZeroTier..." -ForegroundColor Yellow
Write-Host "   (This will open an installer window)" -ForegroundColor Gray

try {
    Start-Process msiexec.exe -ArgumentList "/i `"$InstallerPath`" /quiet /norestart" -Wait -NoNewWindow
    Write-Host "✅ ZeroTier installed" -ForegroundColor Green
} catch {
    Write-Host "❌ Installation failed" -ForegroundColor Red
    exit 1
}

# Wait for service to start
Write-Host ""
Write-Host "⏳ Waiting for ZeroTier service to start..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

# Step 3: Get ZeroTier CLI path
$ZtCliPath = "C:\Program Files (x86)\ZeroTier\One\zerotier-one_x64.exe"
if (!(Test-Path $ZtCliPath)) {
    $ZtCliPath = "C:\ProgramData\ZeroTier\One\zerotier-one_x64.exe"
}

if (!(Test-Path $ZtCliPath)) {
    Write-Host "⚠️  ZeroTier CLI not found at expected location" -ForegroundColor Yellow
    Write-Host "   Please continue setup manually" -ForegroundColor Yellow
} else {
    Write-Host "✅ ZeroTier CLI found" -ForegroundColor Green
}

# Step 4: Instructions
Write-Host ""
Write-Host "===================================" -ForegroundColor Cyan
Write-Host "✅ ZeroTier Installed!" -ForegroundColor Green
Write-Host "===================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📋 NEXT STEPS:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1️⃣  CREATE A ZEROTIER NETWORK:" -ForegroundColor White
Write-Host "   • Go to: https://my.zerotier.com/" -ForegroundColor Cyan
Write-Host "   • Click 'Sign Up' (free account)" -ForegroundColor Gray
Write-Host "   • After login, click 'Create A Network'" -ForegroundColor Gray
Write-Host "   • Copy your Network ID (16-digit code)" -ForegroundColor Gray
Write-Host ""

Write-Host "2️⃣  JOIN YOUR NETWORK (On This PC):" -ForegroundColor White
Write-Host "   • Right-click ZeroTier icon in system tray" -ForegroundColor Gray
Write-Host "   • Click 'Join Network...'" -ForegroundColor Gray
Write-Host "   • Paste your Network ID" -ForegroundColor Gray
Write-Host "   • Click 'Join'" -ForegroundColor Gray
Write-Host ""

Write-Host "3️⃣  AUTHORIZE THIS COMPUTER:" -ForegroundColor White
Write-Host "   • Go back to: https://my.zerotier.com/" -ForegroundColor Cyan
Write-Host "   • Click on your network" -ForegroundColor Gray
Write-Host "   • Scroll to 'Members' section" -ForegroundColor Gray
Write-Host "   • Check the box next to your PC to authorize it" -ForegroundColor Gray
Write-Host "   • Note your ZeroTier IP (looks like: 10.147.x.x)" -ForegroundColor Gray
Write-Host ""

Write-Host "4️⃣  INVITE YOUR FRIENDS:" -ForegroundColor White
Write-Host "   • Send them your Network ID" -ForegroundColor Gray
Write-Host "   • They install ZeroTier: https://www.zerotier.com/download/" -ForegroundColor Cyan
Write-Host "   • They join using your Network ID" -ForegroundColor Gray
Write-Host "   • You authorize them on my.zerotier.com" -ForegroundColor Gray
Write-Host ""

Write-Host "5️⃣  START YOUR D2 SERVER:" -ForegroundColor White
Write-Host "   • Launch 'DiabloGrudge Server' from desktop" -ForegroundColor Gray
Write-Host "   • Start Disotheb - Multiplayer" -ForegroundColor Gray
Write-Host "   • In D2: Multiplayer → TCP/IP → Host Game" -ForegroundColor Gray
Write-Host ""

Write-Host "6️⃣  FRIENDS CONNECT:" -ForegroundColor White
Write-Host "   • Friends launch D2" -ForegroundColor Gray
Write-Host "   • Multiplayer → TCP/IP → Join Game" -ForegroundColor Gray
Write-Host "   • Enter YOUR ZeroTier IP (10.147.x.x)" -ForegroundColor Gray
Write-Host ""

Write-Host "===================================" -ForegroundColor Cyan
Write-Host "💡 PRO TIPS:" -ForegroundColor Yellow
Write-Host ""
Write-Host "• ZeroTier creates a virtual LAN - no port forwarding needed!" -ForegroundColor Gray
Write-Host "• Everyone must be on the same ZeroTier network" -ForegroundColor Gray
Write-Host "• Free tier supports up to 25 devices" -ForegroundColor Gray
Write-Host "• Your ZeroTier IP is different from your regular IP" -ForegroundColor Gray
Write-Host ""

Write-Host "🔧 To find your ZeroTier IP:" -ForegroundColor Yellow
Write-Host "   ipconfig | Select-String 'ZeroTier'" -ForegroundColor Cyan
Write-Host ""

Write-Host "📖 Full guide: https://docs.zerotier.com/getting-started" -ForegroundColor Gray
Write-Host ""

# Create quick reference file
$RefPath = "C:\D2Server\ZEROTIER-QUICKREF.txt"
$QuickRef = @"
===========================================
DIABLOGRUDGE D2 SERVER - ZEROTIER GUIDE
===========================================

YOUR NETWORK DASHBOARD:
https://my.zerotier.com/

FINDING YOUR ZEROTIER IP:
1. Open Command Prompt
2. Type: ipconfig
3. Look for "ZeroTier" adapter
4. Note the IPv4 Address (10.147.x.x)

HOSTING A GAME:
1. Launch D2 via "DiabloGrudge Server"
2. Multiplayer → TCP/IP → Host Game
3. Share your ZeroTier IP with friends

FRIENDS JOINING:
1. Install ZeroTier
2. Join your Network ID
3. Get authorized by you
4. Launch D2 → Multiplayer → TCP/IP → Join
5. Enter your ZeroTier IP

NETWORK ID: [Write yours here after creating]
YOUR ZEROTIER IP: [Check with ipconfig]

===========================================
"@

$QuickRef | Out-File -FilePath $RefPath -Encoding UTF8
Write-Host "📄 Quick reference saved to: $RefPath" -ForegroundColor Green
Write-Host ""

# Open ZeroTier website
Write-Host "🌐 Opening ZeroTier Central..." -ForegroundColor Yellow
Start-Process "https://my.zerotier.com/"

Write-Host ""
Write-Host "✅ Setup complete! Follow the steps above." -ForegroundColor Green
Write-Host ""
