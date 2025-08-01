#!/bin/bash
# Script de lancement propre pour claude-code-webui
# Par Ava - Solution qui marche vraiment !

echo "=== LANCEMENT CLAUDE-CODE-WEBUI ==="
echo ""

cd /mnt/e/WSurfWSpaceGlobal/Applications/claude-code-webui

# Verifier si le build existe
if [ ! -d "dist" ]; then
    echo "Build manquant ! Construction en cours..."
    export NODE_OPTIONS="--openssl-legacy-provider"
    npm run build
fi

# Option 1: Lancer directement avec node (plus stable)
echo "Demarrage du serveur backend..."
echo "Application disponible sur http://localhost:3008"
echo ""

# Forcer le mode CommonJS pour eviter les erreurs ESM
export NODE_OPTIONS="--openssl-legacy-provider"
node --no-warnings --experimental-modules server/index.js
