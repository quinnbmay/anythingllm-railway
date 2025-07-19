FROM mintplexlabs/anythingllm:latest

# Ensure storage directory exists
RUN mkdir -p /app/server/storage/plugins

# Copy MCP configuration
COPY anythingllm_mcp_servers.json /app/server/storage/plugins/

# Expose port
EXPOSE 3001

# Environment variables will be set in Railway