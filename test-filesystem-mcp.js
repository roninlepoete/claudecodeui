// Test simple pour filesystem MCP
const path = require('path');

console.log('Testing filesystem MCP paths:');
console.log('Claude Extensions:', path.join('C:', 'Users', 'Fabrice', 'AppData', 'Roaming', 'Claude', 'Claude Extensions'));
console.log('WSL equivalent:', '/mnt/c/Users/Fabrice/AppData/Roaming/Claude/Claude Extensions');
console.log('');
console.log('For Claude WebUI, try:');
console.log('Command: node');
console.log('Arguments:');
console.log('/mnt/c/Users/Fabrice/AppData/Roaming/Claude/Claude Extensions/ant.dir.ant.anthropic.filesystem/server/index.js');
console.log('');
console.log('Environment:');
console.log('ALLOWED_DIRECTORIES=/mnt/e/WSurfWSpaceGlobal,/mnt/c/Users/Fabrice/.claude');