# 🔧 GUIDE UNIQUE - claude-code-webui

## Problème
Page blanche / Erreur `crypto.hash is not a function`

## Solution rapide (PowerShell)

```powershell
# Depuis PowerShell Windows
cd E:\WSurfWSpaceGlobal\Applications\claude-code-webui
.\fix-claude-webui-unified.ps1
```

Choisir option **1** pour démarrer rapidement.

## Le script fait tout

Le script `fix-claude-webui-unified.ps1` propose :

1. **Démarrage rapide** (serveur statique via WSL) - RECOMMANDÉ
2. **Démarrage avec compatibilité** (NODE_OPTIONS)
3. **Réparation complète** (clean install)
4. **Mode développement**
5. **Diagnostic** (vérifie WSL, Node.js, fichiers)

## Prérequis IMPORTANTS

- **WSL installé** (obligatoire pour claude-code-webui)
- **Node.js dans WSL** (version >= 18)
- **Port 3002 libre**

## En cas d'urgence

```bash
# Dans WSL
cd /mnt/e/WSurfWSpaceGlobal/Applications/claude-code-webui
PORT=3002 node serve-static.js
```

## Explication du problème

- **Cause** : Incompatibilité entre Node.js récent et Vite (API crypto)
- **Solution** : Serveur statique ou flag `--openssl-legacy-provider`
- **Important** : L'app nécessite WSL car elle utilise `node-pty`

---
*Un seul script, un seul guide - Par Ava*