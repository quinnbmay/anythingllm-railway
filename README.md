# AnythingLLM on Railway

This repository deploys AnythingLLM with MCP servers to Railway.

## Deployment Steps

1. Push this repository to GitHub
2. Go to [Railway](https://railway.app)
3. Create a new project
4. Select "Deploy from GitHub repo"
5. Choose this repository
6. Add the following environment variables in Railway:
   - `STORAGE_DIR=/app/server/storage`
   - `SERVER_PORT=3001`
   - `JWT_SECRET=your-secure-jwt-secret`
   - `AUTH_TOKEN=your-secure-auth-token`

## After Deployment

1. Railway will provide a public URL (e.g., https://your-app.railway.app)
2. Access AnythingLLM from anywhere using this URL
3. Complete the initial setup
4. Configure MCP servers with your API keys

## MCP Servers Included

- filesystem - File system access
- github - GitHub integration (add token in UI)
- web-search - Brave search (add API key in UI)
- memory - Memory management
- sqlite - Database access

## Persistent Storage

Railway provides persistent storage by default. Your data will be preserved across deployments.