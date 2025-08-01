# DIAGNOSTIC ET REPARATION CLAUDE-WEBUI
# Par Ava - On va regler ca une bonne fois pour toutes !

Clear-Host
Write-Host "=== DIAGNOSTIC COMPLET CLAUDE-WEBUI ===" -ForegroundColor Blue
Write-Host ""

$appPath = "E:\WSurfWSpaceGlobal\Applications\claude-code-webui"
$wslPath = "/mnt/e/WSurfWSpaceGlobal/Applications/claude-code-webui"

# 1. Verifier les dependances
Write-Host "1. Verification des dependances..." -ForegroundColor Yellow
if (-not (Test-Path "$appPath\node_modules\concurrently")) {
    Write-Host "   ERREUR: Dependances manquantes !" -ForegroundColor Red
    Write-Host "   Installation en cours..." -ForegroundColor Yellow
    wsl bash -c "cd $wslPath && npm install --legacy-peer-deps"
} else {
    Write-Host "   OK: Dependances presentes" -ForegroundColor Green
}

# 2. Verifier le build
Write-Host ""
Write-Host "2. Verification du build..." -ForegroundColor Yellow
if (-not (Test-Path "$appPath\dist\index.html")) {
    Write-Host "   Build manquant ! Construction..." -ForegroundColor Yellow
    wsl bash -c "cd $wslPath && export NODE_OPTIONS='--openssl-legacy-provider' && npm run build"
} else {
    Write-Host "   OK: Build present" -ForegroundColor Green
}

# 3. Test direct du serveur
Write-Host ""
Write-Host "3. Test du serveur backend seul..." -ForegroundColor Yellow
Write-Host "   Le serveur va demarrer sur http://localhost:3008" -ForegroundColor Cyan
Write-Host "   (Le backend sert aussi le frontend)" -ForegroundColor Gray
Write-Host ""
Write-Host "Appuie sur une touche pour lancer..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Lancer directement le serveur
wsl bash -c "cd $wslPath && export NODE_OPTIONS='--openssl-legacy-provider' && node server/index.js"
