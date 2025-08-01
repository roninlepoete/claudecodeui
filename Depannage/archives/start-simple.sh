#!/bin/bash
# Script de lancement simplifie sans nodeenv
wsl
cd /mnt/e/WSurfWSpaceGlobal/Applications/claude-code-webui
echo "Lancement Claude WebUI sur port 3002..."
PORT=3002 npm start