#!/bin/bash
# Script unifié de réparation claude-code-webui
# Par Ava pour Cap'taine Fab - VERSION SIMPLIFIÉE

cd /mnt/e/WSurfWSpaceGlobal/Applications/claude-code-webui

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

clear
echo -e "${BLUE}=== RÉPARATION CLAUDE-CODE-WEBUI ===${NC}"
echo -e "${YELLOW}Problème : Page blanche / Erreur crypto.hash${NC}"
echo ""

# Menu principal
echo "Que veux-tu faire ?"
echo ""
echo -e "${GREEN}1)${NC} Démarrage rapide (serveur statique) - RECOMMANDÉ"
echo -e "${GREEN}2)${NC} Démarrage avec options de compatibilité"
echo -e "${GREEN}3)${NC} Réparation complète (nettoie et réinstalle)"
echo -e "${GREEN}4)${NC} Mode développement"
echo -e "${GREEN}5)${NC} Diagnostic du problème"
echo -e "${GREEN}6)${NC} Créer serveur statique permanent"
echo -e "${GREEN}0)${NC} Quitter"
echo ""
read -p "Ton choix [1-6] : " choice

case $choice in
    1)
        echo -e "\n${YELLOW}Démarrage du serveur statique...${NC}"
        
        # Créer le serveur si nécessaire
        if [ ! -f "serve-static.js" ]; then
            cat > serve-static.js << 'EOF'
const express = require('express');
const path = require('path');
const app = express();
const PORT = process.env.PORT || 3002;

app.use(express.static(path.join(__dirname, 'dist')));
app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, 'dist', 'index.html'));
});

app.listen(PORT, () => {
    console.log(`Serveur sur http://localhost:${PORT}`);
});
EOF
        fi
        
        echo -e "${GREEN}Serveur démarré sur http://localhost:3002${NC}"
        PORT=3002 node serve-static.js
        ;;
        
    2)
        echo -e "\n${YELLOW}Démarrage avec options de compatibilité...${NC}"
        export NODE_OPTIONS="--openssl-legacy-provider"
        export PORT=3002
        echo -e "${GREEN}Variables définies. Démarrage...${NC}"
        npm start
        ;;
        
    3)
        echo -e "\n${YELLOW}Réparation complète...${NC}"
        
        # Vérifier Node.js
        NODE_VERSION=$(node -v)
        NODE_MAJOR=$(echo $NODE_VERSION | cut -d. -f1 | sed 's/v//')
        if [ "$NODE_MAJOR" -lt 18 ]; then
            echo -e "${RED}ERREUR: Node.js $NODE_VERSION trop ancien (besoin >= 18)${NC}"
            exit 1
        fi
        
        echo "1. Nettoyage..."
        rm -rf node_modules package-lock.json
        npm cache clean --force
        
        echo "2. Installation des dépendances..."
        npm install --legacy-peer-deps
        
        echo "3. Reconstruction..."
        npm run build
        
        echo -e "${GREEN}Réparation terminée !${NC}"
        read -p "Démarrer maintenant ? (o/n) " start_now
        if [[ $start_now =~ ^[Oo]$ ]]; then
            PORT=3002 node serve-static.js
        fi
        ;;
        
    4)
        echo -e "\n${YELLOW}Mode développement...${NC}"
        export NODE_OPTIONS="--openssl-legacy-provider"
        export PORT=3002
        npm run dev
        ;;
        
    5)
        echo -e "\n${YELLOW}Diagnostic...${NC}"
        
        # Port
        echo -n "Port 3002 : "
        if lsof -i :3002 > /dev/null 2>&1; then
            echo -e "${RED}OCCUPÉ${NC}"
            PID=$(lsof -ti :3002)
            echo "  PID: $PID - Tuer le processus ? (o/n)"
            read kill_proc
            if [[ $kill_proc =~ ^[Oo]$ ]]; then
                kill -9 $PID
            fi
        else
            echo -e "${GREEN}LIBRE${NC}"
        fi
        
        # Node
        echo -n "Node.js : "
        node -v
        
        # Fichiers
        echo -n "Build : "
        [ -d "dist" ] && echo -e "${GREEN}PRÉSENT${NC}" || echo -e "${RED}MANQUANT${NC}"
        
        echo -n "Dependencies : "
        [ -d "node_modules" ] && echo -e "${GREEN}PRÉSENT${NC}" || echo -e "${RED}MANQUANT${NC}"
        
        echo -n ".env : "
        [ -f ".env" ] && echo -e "${GREEN}PRÉSENT${NC}" || echo -e "${YELLOW}MANQUANT (copie depuis .env.example)${NC}"
        
        echo ""
        read -p "Appuie sur Entrée pour continuer..."
        exec $0
        ;;
        
    6)
        echo -e "\n${YELLOW}Création du serveur statique permanent...${NC}"
        cat > serve-static.js << 'EOF'
const express = require('express');
const path = require('path');
const app = express();
const PORT = process.env.PORT || 3002;

app.use(express.static(path.join(__dirname, 'dist')));
app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, 'dist', 'index.html'));
});

app.listen(PORT, () => {
    console.log(`Serveur sur http://localhost:${PORT}`);
});
EOF
        echo -e "${GREEN}serve-static.js créé !${NC}"
        echo "Usage : PORT=3002 node serve-static.js"
        ;;
        
    0)
        echo "Au revoir !"
        exit 0
        ;;
        
    *)
        echo -e "${RED}Choix invalide${NC}"
        sleep 2
        exec $0
        ;;
esac
