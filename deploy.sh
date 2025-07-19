#!/bin/bash

# Railway API Token
RAILWAY_TOKEN="52c7ac2c-8a55-465c-abdf-19599b4b5796"

# Create a new project
echo "Creating Railway project..."
PROJECT_RESPONSE=$(curl -s -X POST \
  https://api.railway.app/graphql/v2 \
  -H "Authorization: Bearer $RAILWAY_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "mutation { projectCreate(input: {name: \"anythingllm\"}) { id name } }"
  }')

echo "Response: $PROJECT_RESPONSE"

# Extract project ID
PROJECT_ID=$(echo $PROJECT_RESPONSE | grep -o '"id":"[^"]*' | grep -o '[^"]*$' | head -1)
echo "Project ID: $PROJECT_ID"

if [ -z "$PROJECT_ID" ]; then
  echo "Failed to create project. Response: $PROJECT_RESPONSE"
  exit 1
fi

echo "Project created successfully!"
echo "Please deploy manually through Railway UI using project ID: $PROJECT_ID"