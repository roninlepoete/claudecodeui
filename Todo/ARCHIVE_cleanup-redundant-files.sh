#!/bin/bash
# Script de nettoyage des fichiers redondants
# Créé suite à la violation de D41 et D48

cd /mnt/e/WSurfWSpaceGlobal/Applications/claude-code-webui

echo "=== NETTOYAGE DES FICHIERS REDONDANTS ==="
echo ""
echo "Fichiers à supprimer (créés par Ava en trop) :"
echo ""

# Liste des fichiers redondants
FILES_TO_DELETE=(
    "RESOLUTION_PAGE_BLANCHE.md"
    "SOLUTION_CRYPTO_ERROR.md" 
    "SOLUTION_RAPIDE_AVA.md"
    "DEMARRAGE_RAPIDE.md"
    "INDEX_SOLUTIONS_AVA.md"
    "fix-crypto-error.sh"
    "fix-crypto-error.ps1"
    "fix-claude-webui.sh"
    "diagnose-claude-webui.ps1"
    "start-alternative.sh"
    "start-windows.bat"
    "start-windows.ps1"
    "start-fixed.sh"
    "start-dev.sh"
)

# Afficher la liste
for file in "${FILES_TO_DELETE[@]}"; do
    if [ -f "$file" ]; then
        echo "  - $file"
    fi
done

echo ""
echo "Fichiers à GARDER :"
echo "  ✓ fix-claude-webui-unified.sh (script unique avec menu)"
echo "  ✓ GUIDE_COMPLET_REPARATION_CLAUDE_WEBUI.md (guide simplifié)"
echo "  ✓ serve-static.js (serveur statique)"
echo ""

read -p "Confirmer la suppression ? (o/n) " confirm

if [[ $confirm =~ ^[Oo]$ ]]; then
    for file in "${FILES_TO_DELETE[@]}"; do
        if [ -f "$file" ]; then
            rm "$file"
            echo "Supprimé : $file"
        fi
    done
    echo ""
    echo "✓ Nettoyage terminé !"
    echo ""
    echo "Il ne reste que :"
    echo "  - fix-claude-webui-unified.sh"
    echo "  - GUIDE_COMPLET_REPARATION_CLAUDE_WEBUI.md"
    echo "  - serve-static.js"
else
    echo "Annulé."
fi
