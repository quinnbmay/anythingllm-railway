FROM mintplexlabs/anythingllm:latest

# Set required environment variables
ENV STORAGE_DIR=/app/server/storage
ENV SERVER_PORT=3001

# Create storage directories
RUN mkdir -p /app/server/storage/plugins

# Create a temporary directory for our config
RUN mkdir -p /tmp/mcp-config

# Copy MCP configuration to temp location
COPY anythingllm_mcp_servers.json /tmp/mcp-config/

# Create startup script to copy config on container start
RUN echo '#!/bin/bash\n\
mkdir -p /app/server/storage/plugins\n\
cp /tmp/mcp-config/anythingllm_mcp_servers.json /app/server/storage/plugins/\n\
exec /usr/local/bin/docker-entrypoint.sh' > /startup.sh && \
chmod +x /startup.sh

# Expose port
EXPOSE 3001

# Use our startup script
ENTRYPOINT ["/startup.sh"]