# Script unifie de reparation claude-code-webui
# Par Ava pour Cap'taine Fab - VERSION WSL COMPATIBLE

$appPath = "E:\WSurfWSpaceGlobal\Applications\claude-code-webui"
$wslPath = "/mnt/e/WSurfWSpaceGlobal/Applications/claude-code-webui"

# Verifier que nous sommes au bon endroit
if (-not (Test-Path "$appPath\package.json")) {
    Write-Host "ERREUR: Le repertoire claude-code-webui n'existe pas a l'emplacement prevu !" -ForegroundColor Red
    Write-Host "Chemin attendu : $appPath" -ForegroundColor Yellow
    exit 1
}

Clear-Host
Write-Host "=== REPARATION CLAUDE-CODE-WEBUI ===" -ForegroundColor Blue
Write-Host "Probleme : Page blanche / Erreur crypto.hash" -ForegroundColor Yellow
Write-Host "Solution : Utilisation de WSL + serveur statique" -ForegroundColor Green
Write-Host ""

# Menu principal
Write-Host "Que veux-tu faire ?" -ForegroundColor White
Write-Host ""
Write-Host "1) " -NoNewline -ForegroundColor Green
Write-Host "Demarrage rapide (serveur statique) - RECOMMANDE"
Write-Host "2) " -NoNewline -ForegroundColor Green  
Write-Host "Demarrage avec options de compatibilite"
Write-Host "3) " -NoNewline -ForegroundColor Green
Write-Host "Reparation complete (nettoie et reinstalle)"
Write-Host "4) " -NoNewline -ForegroundColor Green
Write-Host "Mode developpement"
Write-Host "5) " -NoNewline -ForegroundColor Green
Write-Host "Diagnostic du probleme"
Write-Host "6) " -NoNewline -ForegroundColor Green
Write-Host "Creer serveur statique permanent"
Write-Host "0) " -NoNewline -ForegroundColor Green
Write-Host "Quitter"
Write-Host ""
$choice = Read-Host "Ton choix [0-6]"

switch ($choice) {
    "1" {
        Write-Host "`nDemarrage du serveur statique via WSL..." -ForegroundColor Yellow
        Write-Host "Serveur demarre sur http://localhost:3002" -ForegroundColor Green
        
        # Lancer via WSL avec le serveur statique existant
        wsl bash -c "cd $wslPath && PORT=3002 node serve-static.js"
    }
    
    "2" {
        Write-Host "`nDemarrage avec options de compatibilite via WSL..." -ForegroundColor Yellow
        Write-Host "Utilisation de NODE_OPTIONS=--openssl-legacy-provider" -ForegroundColor Green
        Write-Host "Serveur demarre sur http://localhost:3002" -ForegroundColor Green
        
        # Lancer via WSL avec les options de compatibilite
        wsl bash -c "cd $wslPath && export NODE_OPTIONS='--openssl-legacy-provider' && PORT=3002 npm start"
    }
    
    "3" {
        Write-Host "`nReparation complete via WSL..." -ForegroundColor Yellow
        Write-Host "Cette operation peut prendre quelques minutes..." -ForegroundColor Yellow
        
        # Script de reparation complet dans WSL
        $repairScript = @"
cd /mnt/e/WSurfWSpaceGlobal/Applications/claude-code-webui
echo "Verification de Node.js..."
node_version=`$(node -v | sed 's/v\([0-9]*\).*/\1/')
if [ `$node_version -lt 18 ]; then
    echo "ERREUR: Node.js trop ancien (besoin >= 18)"
    exit 1
fi

echo "1. Nettoyage..."
rm -rf node_modules package-lock.json
npm cache clean --force

echo "2. Installation des dependances..."
export NODE_OPTIONS="--openssl-legacy-provider"
npm install --legacy-peer-deps

echo "3. Reconstruction..."
npm run build

echo "Reparation terminee !"
"@
        
        # Executer le script de reparation
        wsl bash -c $repairScript
        
        Write-Host "Reparation terminee !" -ForegroundColor Green
        $start = Read-Host "Demarrer maintenant ? (o/n)"
        if ($start -eq "o") {
            wsl bash -c "cd $wslPath && PORT=3002 node serve-static.js"
        }
    }
    
    "4" {
        Write-Host "`nMode developpement via WSL..." -ForegroundColor Yellow
        Write-Host "Lancement du serveur et du client en mode dev" -ForegroundColor Green
        
        # Lancer en mode dev via WSL
        wsl bash -c "cd $wslPath && export NODE_OPTIONS='--openssl-legacy-provider' && PORT=3002 npm run dev"
    }
    
    "5" {
        Write-Host "`nDiagnostic..." -ForegroundColor Yellow
        
        # Port Windows
        Write-Host "`n--- Cote Windows ---" -ForegroundColor Cyan
        Write-Host -NoNewline "Port 3002 : "
        $tcpConnection = Get-NetTCPConnection -LocalPort 3002 -ErrorAction SilentlyContinue
        if ($tcpConnection) {
            Write-Host "OCCUPE" -ForegroundColor Red
            Write-Host "  PID: $($tcpConnection.OwningProcess)"
            $kill = Read-Host "  Tuer le processus ? (o/n)"
            if ($kill -eq "o") {
                Stop-Process -Id $tcpConnection.OwningProcess -Force
            }
        } else {
            Write-Host "LIBRE" -ForegroundColor Green
        }
        
        # WSL
        Write-Host "`n--- Cote WSL ---" -ForegroundColor Cyan
        Write-Host -NoNewline "WSL installe : "
        $wslCheck = wsl --list --quiet 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "OUI" -ForegroundColor Green
            
            # Node dans WSL
            Write-Host -NoNewline "Node.js dans WSL : "
            $nodeVersion = wsl bash -c "node -v 2>/dev/null"
            if ($nodeVersion) {
                Write-Host $nodeVersion -ForegroundColor Green
            } else {
                Write-Host "NON INSTALLE" -ForegroundColor Red
            }
        } else {
            Write-Host "NON" -ForegroundColor Red
            Write-Host "WSL est REQUIS pour claude-code-webui !" -ForegroundColor Yellow
        }
        
        # Fichiers
        Write-Host "`n--- Fichiers ---" -ForegroundColor Cyan
        Write-Host -NoNewline "Build (dist/) : "
        if (Test-Path "$appPath\dist") {
            Write-Host "PRESENT" -ForegroundColor Green
        } else {
            Write-Host "MANQUANT" -ForegroundColor Red
        }
        
        Write-Host -NoNewline "Dependencies : "
        if (Test-Path "$appPath\node_modules") {
            Write-Host "PRESENT" -ForegroundColor Green
        } else {
            Write-Host "MANQUANT" -ForegroundColor Red
        }
        
        Write-Host -NoNewline ".env : "
        if (Test-Path "$appPath\.env") {
            Write-Host "PRESENT" -ForegroundColor Green
        } else {
            Write-Host "MANQUANT" -ForegroundColor Yellow
        }
        
        Write-Host -NoNewline "serve-static.js : "
        if (Test-Path "$appPath\serve-static.js") {
            Write-Host "PRESENT" -ForegroundColor Green
        } else {
            Write-Host "MANQUANT" -ForegroundColor Red
        }
        
        Write-Host ""
        Read-Host "Appuie sur Entree pour continuer"
        & $PSCommandPath
    }
    
    "6" {
        Write-Host "`nOption inutile - serve-static.js existe deja !" -ForegroundColor Yellow
        Write-Host "Utilise plutot l'option 1 pour demarrer rapidement." -ForegroundColor Green
        Start-Sleep -Seconds 2
        & $PSCommandPath
    }
    
    "0" {
        Write-Host "Au revoir !"
        exit 0
    }
    
    default {
        Write-Host "Choix invalide" -ForegroundColor Red
        Start-Sleep -Seconds 2
        & $PSCommandPath
    }
}
