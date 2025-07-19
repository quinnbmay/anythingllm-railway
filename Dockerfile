FROM mintplexlabs/anythingllm:latest

# Set required environment variables
ENV STORAGE_DIR=/app/server/storage
ENV SERVER_PORT=3001
ENV PORT=3001

# Expose port
EXPOSE 3001