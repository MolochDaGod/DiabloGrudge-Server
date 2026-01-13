# Quick Installation Test Script
# Tests if DiabloGrudge Server is ready to use

Write-Host "`n🧪 DiabloGrudge Server Installation Test" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

$allGood = $true

# Test 1: Check D2Server exists
Write-Host "📁 Checking D2Server directory..." -NoNewline
if (Test-Path "D:\D2Server") {
    Write-Host " ✅" -ForegroundColor Green
} else {
    Write-Host " ❌ NOT FOUND" -ForegroundColor Red
    $allGood = $false
}

# Test 2: Check Cactus.exe exists
Write-Host "🎮 Checking Cactus.exe..." -NoNewline
if (Test-Path "D:\D2Server\Cactus.exe") {
    Write-Host " ✅" -ForegroundColor Green
} else {
    Write-Host " ❌ NOT FOUND" -ForegroundColor Red
    $allGood = $false
}

# Test 3: Check MPQ files
Write-Host "📦 Checking MPQ files..." -NoNewline
$mpqFiles = Get-ChildItem "D:\D2Server" -Filter "*.mpq" -ErrorAction SilentlyContinue
if ($mpqFiles.Count -ge 10) {
    Write-Host " ✅ ($($mpqFiles.Count) files)" -ForegroundColor Green
} else {
    Write-Host " ⚠️  Only $($mpqFiles.Count) files found" -ForegroundColor Yellow
    $allGood = $false
}

# Test 4: Check Disotheb platform
Write-Host "🔧 Checking Disotheb platform..." -NoNewline
if (Test-Path "D:\D2Server\Platforms\Disotheb") {
    Write-Host " ✅" -ForegroundColor Green
} else {
    Write-Host " ❌ NOT FOUND" -ForegroundColor Red
    $allGood = $false
}

# Test 5: Check firewall rules
Write-Host "🔒 Checking firewall rules..." -NoNewline
$fwRule = Get-NetFirewallRule -DisplayName "D2 TCP/IP Server" -ErrorAction SilentlyContinue
if ($fwRule) {
    Write-Host " ✅" -ForegroundColor Green
} else {
    Write-Host " ⚠️  Not configured" -ForegroundColor Yellow
}

# Test 6: Check Node.js
Write-Host "📦 Checking Node.js..." -NoNewline
try {
    $nodeVersion = node --version 2>$null
    Write-Host " ✅ $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host " ⚠️  Not installed (needed for web lobby)" -ForegroundColor Yellow
}

# Test 7: Check desktop shortcut
Write-Host "🔗 Checking desktop shortcut..." -NoNewline
if (Test-Path "$env:USERPROFILE\Desktop\DiabloGrudge Server (G Drive).lnk") {
    Write-Host " ✅" -ForegroundColor Green
} else {
    Write-Host " ⚠️  Not found" -ForegroundColor Yellow
}

# Summary
Write-Host "`n========================================" -ForegroundColor Cyan
if ($allGood) {
    Write-Host "✅ Installation looks good!" -ForegroundColor Green
    Write-Host "`nYou can now:" -ForegroundColor White
    Write-Host "1. Launch Cactus from: D:\D2Server\Cactus.exe" -ForegroundColor Cyan
    Write-Host "2. Or use desktop shortcut: 'DiabloGrudge Server (G Drive)'" -ForegroundColor Cyan
} else {
    Write-Host "⚠️  Some issues detected" -ForegroundColor Yellow
    Write-Host "Review the checks above and fix any ❌ items" -ForegroundColor White
}

Write-Host "`n📋 Next Steps:" -ForegroundColor Yellow
Write-Host "1. Launch Cactus and test D2" -ForegroundColor White
Write-Host "2. Install Node.js for web lobby: https://nodejs.org/" -ForegroundColor White
Write-Host "3. Run 'npm install' in DiabloGrudge-Server folder" -ForegroundColor White
Write-Host "4. Run 'npm start' to start web lobby" -ForegroundColor White

Write-Host "`n📖 Full details: INSTALLATION-COMPLETE.md`n" -ForegroundColor Cyan
