# Script simple pour lancer claude-code-webui correctement
# Par Ava pour Fabrice

Clear-Host
Write-Host "=== LANCEMENT CLAUDE-CODE-WEBUI ===" -ForegroundColor Blue
Write-Host ""

# Verification WSL
$wslCheck = wsl --list --quiet 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERREUR: WSL n'est pas installe !" -ForegroundColor Red
    Write-Host "Claude-code-webui necessite WSL pour fonctionner." -ForegroundColor Yellow
    exit 1
}

# Tuer les processus existants sur les ports
Write-Host "Nettoyage des ports..." -ForegroundColor Yellow
$ports = @(3008, 3002)
foreach ($port in $ports) {
    $tcpConnection = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue
    if ($tcpConnection) {
        Write-Host "  Liberation du port $port..." -ForegroundColor Yellow
        Stop-Process -Id $tcpConnection.OwningProcess -Force -ErrorAction SilentlyContinue
    }
}

Write-Host ""
Write-Host "Lancement du serveur backend (qui sert aussi le frontend)..." -ForegroundColor Green
Write-Host "L'application sera disponible sur http://localhost:3008" -ForegroundColor Cyan
Write-Host ""
Write-Host "Appuie sur Ctrl+C pour arreter" -ForegroundColor Yellow
Write-Host ""

# Lancer le backend qui sert tout
wsl bash -c "cd /mnt/e/WSurfWSpaceGlobal/Applications/claude-code-webui && export NODE_OPTIONS='--openssl-legacy-provider' && PORT=3008 npm run server"
