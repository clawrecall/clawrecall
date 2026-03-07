# ClawRecall Windows Installer v2.1 (Sync with v1.3.0)
if (-not (Get-Command openclaw -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Error: OpenClaw gateway is not installed." -ForegroundColor Red
    Write-Host "Please install it first: npm install -g @openclaw/gateway" -ForegroundColor Yellow
    exit 1
}

Write-Host "🚀 Installing ClawRecall (Windows)..." -ForegroundColor Green

$skillsPath = "$env:USERPROFILE\.openclaw\skills\clawrecall"

if (Test-Path $skillsPath) {
    Write-Host "⚠️ Folder exists → cleaning and reinstalling..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force $skillsPath
}

git clone https://github.com/clawrecall/clawrecall.git $skillsPath 2>$null
if (-not $?) {
    Write-Host "Cloning failed, trying fallback..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force $skillsPath -ErrorAction SilentlyContinue
    git clone https://github.com/clawrecall/clawrecall.git $skillsPath
}

openclaw config set tools.profile "coding"
openclaw gateway restart

Write-Host "✅ ClawRecall installed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Now paste the big enable block shown in the instructions into your OpenClaw agent." -ForegroundColor Cyan
Write-Host "Test: 'Remember this forever: Test from Windows install'" -ForegroundColor Cyan