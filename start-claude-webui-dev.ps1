# SOLUTION SIMPLE QUI MARCHE - Claude-Code-WebUI
# Par Ava

Clear-Host
Write-Host "=== SOLUTION DEFINITIVE CLAUDE-CODE-WEBUI ===" -ForegroundColor Green
Write-Host ""

# Tuer les anciens processus
Write-Host "Nettoyage..." -ForegroundColor Yellow
Get-Process | Where-Object {$_.ProcessName -like "*node*"} | Stop-Process -Force -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "Cette fois on va utiliser le mode developpement qui MARCHE !" -ForegroundColor Cyan
Write-Host "Ca va lancer frontend + backend ensemble" -ForegroundColor Cyan
Write-Host ""
Write-Host "L'app sera sur http://localhost:5173 (Vite dev server)" -ForegroundColor Green
Write-Host ""

# Lancer en mode dev qui evite tous les problemes ESM
wsl bash -c "cd /mnt/e/WSurfWSpaceGlobal/Applications/claude-code-webui && export NODE_OPTIONS='--openssl-legacy-provider' && npm run dev"
