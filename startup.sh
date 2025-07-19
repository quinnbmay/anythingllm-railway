#!/bin/bash

# Ensure MCP config directory exists
mkdir -p /app/server/storage/plugins

# Start AnythingLLM
exec /usr/local/bin/docker-entrypoint.sh