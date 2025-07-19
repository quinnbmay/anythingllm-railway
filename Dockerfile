FROM mintplexlabs/anythingllm:latest

# Set required environment variables
ENV STORAGE_DIR=/app/server/storage
ENV SERVER_PORT=3001
ENV PORT=3001

# Switch to root to create directories
USER root

# Create directory and copy MCP config
RUN mkdir -p /app/server/storage/plugins
COPY anythingllm_mcp_servers.json /app/server/storage/plugins/anythingllm_mcp_servers.json

# Set proper permissions
RUN chown -R anythingllm:anythingllm /app/server/storage

# Switch back to anythingllm user
USER anythingllm

# Expose port
EXPOSE 3001