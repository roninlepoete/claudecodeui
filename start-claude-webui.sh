#!/bin/bash
cd /mnt/e/WSurfWSpaceGlobal/Applications
source claude-venv/bin/activate
source claude-nodeenv/bin/activate
cd claude-code-webui
PORT=3002 npm start
