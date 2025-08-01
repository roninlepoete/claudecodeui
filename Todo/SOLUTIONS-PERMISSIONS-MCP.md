# Solutions aux problèmes de permissions et MCP
*Document créé par Ava pour Fabrice*

## 🚨 Problèmes identifiés

1. **Permissions non synchronisées** entre le système et l'UI claude-code-webui
2. **Serveurs MCP invisibles** dans Claude Desktop (seulement 2/7+ configurés)
3. **Impossibilité d'exécuter des commandes bash** depuis Claude

## ✅ Plan d'action immédiat

### Étape 1 : Corriger les permissions système

```powershell
# En mode administrateur PowerShell
.\AVA-GUARDIAN-SIMPLE.ps1
.\Check-And-Fix-Permissions.ps1
```

### Étape 2 : Mettre à jour la configuration MCP

```powershell
# Ajouter tous les serveurs MCP disponibles
.\Fix-MCP-Configuration.ps1
```

**Serveurs qui seront ajoutés :**
- filesystem (avec permissions E:\WSurfWSpaceGlobal)
- web-search 
- vision-mcp
- docker-commands

### Étape 3 : Diagnostiquer claude-code-webui

```powershell
.\Diagnose-Claude-WebUI.ps1
```

### Étape 4 : Redémarrer proprement

1. **Fermer complètement Claude Desktop**
   ```powershell
   taskkill /F /IM Claude.exe
   ```

2. **Arrêter claude-code-webui**
   ```powershell
   taskkill /F /IM node.exe
   ```

3. **Redémarrer claude-code-webui**
   ```powershell
   cd E:\WSurfWSpaceGlobal\Applications\claude-code-webui
   npm run dev
   ```

4. **Relancer Claude Desktop**
   - Vérifier dans Settings > Model Context Protocol
   - Tous les serveurs MCP devraient être visibles

## 🔧 Solutions spécifiques

### Pour les commandes bash non fonctionnelles

Le problème vient du serveur filesystem MCP. Solutions :

1. **Vérifier que le serveur filesystem est bien configuré** dans claude_desktop_config.json
2. **S'assurer que ALLOWED_DIRECTORIES inclut** : `E:\WSurfWSpaceGlobal,C:\Users\Fabrice`
3. **Alternative temporaire** : Utiliser PowerShell au lieu de bash

### Pour les serveurs MCP Docker

Les serveurs MCP dans Docker nécessitent :
1. Docker Desktop en cours d'exécution
2. Les conteneurs MCP construits (voir `Docker\mcp-servers-fix\build-mcp-servers.ps1`)
3. Configuration spéciale dans claude_desktop_config.json

## 📝 Configuration finale attendue

Après toutes les corrections, ta configuration devrait inclure :

**Claude Desktop (claude_desktop_config.json)** :
- ✅ sequential-thinking
- ✅ memory
- ✅ filesystem (avec permissions correctes)
- ✅ web-search
- ✅ vision-mcp
- ✅ docker-commands (si Docker actif)

**Permissions système** :
- ✅ ExecutionPolicy : RemoteSigned
- ✅ Contrôle total sur E:\WSurfWSpaceGlobal
- ✅ Services Windows actifs (WinRM, EventLog)

## 🚀 Commande rapide tout-en-un

```powershell
# Depuis E:\WSurfWSpaceGlobal en admin
.\PowerShell\AVA-GUARDIAN-SIMPLE.ps1
.\Check-And-Fix-Permissions.ps1
.\Fix-MCP-Configuration.ps1
.\Diagnose-Claude-WebUI.ps1
```

## ⚠️ Si les problèmes persistent

1. **Logs à vérifier** :
   - `%APPDATA%\Claude\logs\`
   - `E:\WSurfWSpaceGlobal\Applications\claude-code-webui\server\logs\`

2. **Mode bypass temporaire** :
   - Utiliser directement les scripts Python/PowerShell
   - Contourner l'UI jusqu'à résolution complète

3. **Support** :
   - Vérifier les issues sur GitHub de claude-code-webui
   - La communauté Anthropic pour les serveurs MCP

---
*Document sauvegardé dans : `E:\WSurfWSpaceGlobal\Applications\claude-code-webui\Todo\SOLUTIONS-PERMISSIONS-MCP.md`*