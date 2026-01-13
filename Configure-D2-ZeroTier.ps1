# DiabloGrudge D2 Server - ZeroTier Configuration & Firewall Setup
# Network ID: cf719fd5401e3d2c

Write-Host "🎮 DiabloGrudge D2 Server - ZeroTier Configuration" -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host ""

# Check if running as admin
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "⚠️  This script needs Administrator privileges" -ForegroundColor Yellow
    Write-Host "   Right-click PowerShell and select 'Run as Administrator'" -ForegroundColor Gray
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit
}

# Step 1: Check ZeroTier Status
Write-Host "📡 Checking ZeroTier status..." -ForegroundColor Yellow

$ztService = Get-Service -Name "ZeroTierOneService" -ErrorAction SilentlyContinue

if ($ztService -and $ztService.Status -eq "Running") {
    Write-Host "✅ ZeroTier service is running" -ForegroundColor Green
} else {
    Write-Host "❌ ZeroTier service not found or not running" -ForegroundColor Red
    Write-Host "   Install ZeroTier from: https://www.zerotier.com/download/" -ForegroundColor Yellow
    exit 1
}

# Step 2: Get ZeroTier CLI path
Write-Host ""
Write-Host "🔍 Locating ZeroTier CLI..." -ForegroundColor Yellow

$ztPaths = @(
    "C:\ProgramData\ZeroTier\One\zerotier-one_x64.exe",
    "C:\Program Files (x86)\ZeroTier\One\zerotier-one_x64.exe",
    "C:\Program Files\ZeroTier\One\zerotier-one_x64.exe"
)

$ztCli = $null
foreach ($path in $ztPaths) {
    if (Test-Path $path) {
        $ztCli = $path
        break
    }
}

if (-not $ztCli) {
    Write-Host "⚠️  ZeroTier CLI not found" -ForegroundColor Yellow
    Write-Host "   Continuing with manual configuration..." -ForegroundColor Gray
} else {
    Write-Host "✅ ZeroTier CLI found: $ztCli" -ForegroundColor Green
    
    # Get network info
    Write-Host ""
    Write-Host "📊 Network Information:" -ForegroundColor Yellow
    & $ztCli -q listnetworks
}

# Step 3: Get ZeroTier IP
Write-Host ""
Write-Host "🌐 Your Network Addresses:" -ForegroundColor Yellow

$ztAdapter = Get-NetAdapter | Where-Object { $_.InterfaceDescription -like "*ZeroTier*" }

if ($ztAdapter) {
    $ipConfig = Get-NetIPAddress -InterfaceIndex $ztAdapter.ifIndex -AddressFamily IPv4 -ErrorAction SilentlyContinue
    
    if ($ipConfig) {
        $ztIP = $ipConfig.IPAddress
        Write-Host "   ZeroTier IP: $ztIP" -ForegroundColor Green
        
        if ($ztIP -like "169.254.*") {
            Write-Host ""
            Write-Host "⚠️  WARNING: You have an auto-configuration IP (169.254.x.x)" -ForegroundColor Yellow
            Write-Host "   This means you're not fully connected to the ZeroTier network yet." -ForegroundColor Gray
            Write-Host ""
            Write-Host "📋 TO FIX THIS:" -ForegroundColor Cyan
            Write-Host "   1. Open https://my.zerotier.com/" -ForegroundColor White
            Write-Host "   2. Click on network: cf719fd5401e3d2c" -ForegroundColor White
            Write-Host "   3. Scroll to 'Members' section" -ForegroundColor White
            Write-Host "   4. Find your device and CHECK the 'Auth' box" -ForegroundColor White
            Write-Host "   5. Wait 30 seconds, then run this script again" -ForegroundColor White
            Write-Host ""
        }
    } else {
        Write-Host "   ⚠️  No IPv4 address assigned yet" -ForegroundColor Yellow
    }
    
    # Show all IPs for reference
    Write-Host ""
    Write-Host "   All Network Adapters:" -ForegroundColor Gray
    Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -notlike "127.*" } | ForEach-Object {
        Write-Host "   - $($_.IPAddress) ($($_.InterfaceAlias))" -ForegroundColor Gray
    }
} else {
    Write-Host "   ❌ ZeroTier adapter not found" -ForegroundColor Red
}

# Step 4: Open Firewall Ports for Diablo II
Write-Host ""
Write-Host "🔥 Configuring Windows Firewall for Diablo II..." -ForegroundColor Yellow

$d2Rules = @(
    @{
        Name = "Diablo II - TCP/IP (TCP In)"
        Direction = "Inbound"
        Protocol = "TCP"
        LocalPort = 4000
        Action = "Allow"
    },
    @{
        Name = "Diablo II - TCP/IP (UDP In)"
        Direction = "Inbound"
        Protocol = "UDP"
        LocalPort = 4000
        Action = "Allow"
    },
    @{
        Name = "Diablo II - Battle.net (TCP Out)"
        Direction = "Outbound"
        Protocol = "TCP"
        RemotePort = 6112
        Action = "Allow"
    },
    @{
        Name = "Diablo II - Battle.net (UDP Out)"
        Direction = "Outbound"
        Protocol = "UDP"
        RemotePort = 6112
        Action = "Allow"
    }
)

foreach ($rule in $d2Rules) {
    # Remove existing rule if it exists
    $existing = Get-NetFirewallRule -DisplayName $rule.Name -ErrorAction SilentlyContinue
    if ($existing) {
        Remove-NetFirewallRule -DisplayName $rule.Name
        Write-Host "   • Removed old rule: $($rule.Name)" -ForegroundColor Gray
    }
    
    # Create new rule
    $params = @{
        DisplayName = $rule.Name
        Direction = $rule.Direction
        Protocol = $rule.Protocol
        Action = $rule.Action
        Enabled = "True"
    }
    
    if ($rule.LocalPort) { $params.LocalPort = $rule.LocalPort }
    if ($rule.RemotePort) { $params.RemotePort = $rule.RemotePort }
    
    New-NetFirewallRule @params | Out-Null
    Write-Host "   ✅ Created: $($rule.Name)" -ForegroundColor Green
}

# Step 5: Open ZeroTier ports
Write-Host ""
Write-Host "🔥 Configuring Firewall for ZeroTier..." -ForegroundColor Yellow

$ztFirewallRule = Get-NetFirewallRule -DisplayName "ZeroTier DiabloGrudge" -ErrorAction SilentlyContinue
if ($ztFirewallRule) {
    Remove-NetFirewallRule -DisplayName "ZeroTier DiabloGrudge"
}

New-NetFirewallRule -DisplayName "ZeroTier DiabloGrudge" `
    -Direction Inbound `
    -Protocol UDP `
    -LocalPort 9993 `
    -Action Allow `
    -Enabled True | Out-Null

Write-Host "   ✅ ZeroTier port 9993 opened" -ForegroundColor Green

# Step 6: Summary & Next Steps
Write-Host ""
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host "✅ Firewall Configuration Complete!" -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "📋 FIREWALL RULES CREATED:" -ForegroundColor Yellow
Write-Host "   • Diablo II TCP port 4000 (Inbound)" -ForegroundColor White
Write-Host "   • Diablo II UDP port 4000 (Inbound)" -ForegroundColor White
Write-Host "   • Battle.net TCP port 6112 (Outbound)" -ForegroundColor White
Write-Host "   • Battle.net UDP port 6112 (Outbound)" -ForegroundColor White
Write-Host "   • ZeroTier UDP port 9993 (Inbound)" -ForegroundColor White
Write-Host ""

Write-Host "🌐 ZEROTIER NETWORK:" -ForegroundColor Yellow
Write-Host "   Network ID: cf719fd5401e3d2c" -ForegroundColor Cyan
Write-Host "   Dashboard: https://my.zerotier.com/" -ForegroundColor Cyan
Write-Host ""

if ($ztIP -and $ztIP -notlike "169.254.*") {
    Write-Host "✅ YOU'RE READY TO HOST!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📋 TO HOST A GAME:" -ForegroundColor Yellow
    Write-Host "   1. Launch Diablo II via Cactus (thoc_b8_1)" -ForegroundColor White
    Write-Host "   2. Click: Multiplayer → TCP/IP → Host Game" -ForegroundColor White
    Write-Host "   3. Share this IP with friends: $ztIP" -ForegroundColor Green
    Write-Host ""
    Write-Host "📋 FRIENDS JOIN:" -ForegroundColor Yellow
    Write-Host "   1. Install ZeroTier and join network: cf719fd5401e3d2c" -ForegroundColor White
    Write-Host "   2. Launch D2 → Multiplayer → TCP/IP → Join Game" -ForegroundColor White
    Write-Host "   3. Enter your IP: $ztIP" -ForegroundColor Green
} else {
    Write-Host "⚠️  AUTHORIZATION NEEDED" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "🔧 COMPLETE SETUP:" -ForegroundColor Yellow
    Write-Host "   1. Open: https://my.zerotier.com/" -ForegroundColor Cyan
    Write-Host "   2. Sign in and click network: cf719fd5401e3d2c" -ForegroundColor White
    Write-Host "   3. Scroll to 'Members' section" -ForegroundColor White
    Write-Host "   4. Find this computer and CHECK the 'Auth' box" -ForegroundColor White
    Write-Host "   5. Wait 30 seconds for IP assignment" -ForegroundColor White
    Write-Host "   6. Run this script again to verify" -ForegroundColor White
}

Write-Host ""
Write-Host "💾 Configuration saved!" -ForegroundColor Green
Write-Host ""

# Save configuration info
$configInfo = @"
DiabloGrudge D2 Server - ZeroTier Configuration
================================================
Date: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

ZeroTier Network ID: cf719fd5401e3d2c
Network Dashboard: https://my.zerotier.com/

Your ZeroTier IP: $ztIP
$(if ($ztIP -like "169.254.*") { "(Needs authorization - see dashboard)" } else { "(Share this with friends to join)" })

Firewall Rules Created:
- Diablo II TCP/UDP port 4000 (Inbound)
- Battle.net TCP/UDP port 6112 (Outbound)
- ZeroTier UDP port 9993 (Inbound)

How to Host:
1. Launch D2 via Cactus → thoc_b8_1
2. Multiplayer → TCP/IP → Host Game
3. Friends join using your ZeroTier IP

How Friends Connect:
1. Install ZeroTier: https://www.zerotier.com/download/
2. Join network: cf719fd5401e3d2c
3. Get authorized by you on my.zerotier.com
4. Launch D2 → TCP/IP → Join Game
5. Enter: $ztIP
================================================
"@

$configPath = "C:\Users\nugye\Documents\DiabloGrudge-Server\ZEROTIER-CONFIG.txt"
$configInfo | Out-File -FilePath $configPath -Encoding UTF8
Write-Host "📄 Config saved to: $configPath" -ForegroundColor Gray
Write-Host ""
