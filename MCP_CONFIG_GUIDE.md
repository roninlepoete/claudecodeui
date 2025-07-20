# Configuration MCP pour Claude WebUI

## Serveurs MCP qui fonctionnent bien dans WSL

### 1. Filesystem (RECOMMANDE)
```
Server Name: filesystem
Transport Type: stdio  
Command: node
Arguments (un par ligne):
/mnt/c/Users/Fabrice/AppData/Roaming/Claude/Claude Extensions/ant.dir.ant.anthropic.filesystem/server/index.js

Environment Variables:
ALLOWED_DIRECTORIES=/mnt/e/WSurfWSpaceGlobal,/mnt/c/Users/Fabrice/.claude,/mnt/c/Users/Fabrice/AppData/Roaming/Claude
```

### 2. Memory
```
Server Name: memory
Transport Type: stdio
Command: npx
Arguments:
-y
@mcp-servers/memory
```

### 3. SQLite
```
Server Name: sqlite
Transport Type: stdio
Command: npx
Arguments:
-y
@mcp-servers/sqlite
```

## Serveurs problematiques dans WSL

- **desktop-commander** : Necessite acces GUI Windows
- **puppeteer** : Problemes de navigateur headless
- **Docker MCP** : Conflits WSL/Docker

## Solution alternative

Utiliser Claude WebUI uniquement pour l'interface chat et garder les serveurs MCP dans Claude Desktop.