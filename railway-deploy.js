const https = require('https');

const RAILWAY_TOKEN = '52c7ac2c-8a55-465c-abdf-19599b4b5796';
const PROJECT_ID = 'ef790873-cffa-4a47-9fad-1e38b317d0c2';

function graphqlRequest(query, variables = {}) {
  return new Promise((resolve, reject) => {
    const data = JSON.stringify({ query, variables });
    
    const options = {
      hostname: 'api.railway.app',
      path: '/graphql/v2',
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${RAILWAY_TOKEN}`,
        'Content-Type': 'application/json',
        'Content-Length': data.length
      }
    };

    const req = https.request(options, (res) => {
      let body = '';
      res.on('data', (chunk) => body += chunk);
      res.on('end', () => {
        try {
          resolve(JSON.parse(body));
        } catch (e) {
          reject(e);
        }
      });
    });

    req.on('error', reject);
    req.write(data);
    req.end();
  });
}

async function deployToRailway() {
  try {
    // Create environment
    console.log('Creating environment...');
    const envResponse = await graphqlRequest(`
      mutation($projectId: String!) {
        environmentCreate(input: {projectId: $projectId, name: "production"}) {
          id
          name
        }
      }
    `, { projectId: PROJECT_ID });
    
    const environmentId = envResponse.data?.environmentCreate?.id || envResponse.data?.project?.environments?.edges?.[0]?.node?.id;
    console.log('Environment ID:', environmentId);

    // Create service
    console.log('Creating service...');
    const serviceResponse = await graphqlRequest(`
      mutation($projectId: String!) {
        serviceCreate(input: {
          projectId: $projectId,
          name: "anythingllm",
          source: {
            repo: {
              fullRepoName: "quinnbmay/anythingllm-railway",
              branch: "main"
            }
          }
        }) {
          id
          name
        }
      }
    `, { projectId: PROJECT_ID });
    
    const serviceId = serviceResponse.data?.serviceCreate?.id;
    console.log('Service created:', serviceId);

    // Set environment variables
    console.log('Setting environment variables...');
    const envVars = {
      STORAGE_DIR: '/app/server/storage',
      SERVER_PORT: '3001',
      JWT_SECRET: require('crypto').randomBytes(32).toString('hex'),
      AUTH_TOKEN: require('crypto').randomBytes(32).toString('hex')
    };

    for (const [key, value] of Object.entries(envVars)) {
      await graphqlRequest(`
        mutation($projectId: String!, $environmentId: String!, $serviceId: String!, $name: String!, $value: String!) {
          variableSet(input: {
            projectId: $projectId,
            environmentId: $environmentId,
            serviceId: $serviceId,
            name: $name,
            value: $value
          })
        }
      `, {
        projectId: PROJECT_ID,
        environmentId: environmentId,
        serviceId: serviceId,
        name: key,
        value: value
      });
    }

    console.log('Environment variables set successfully!');
    console.log('Deployment initiated! Check your Railway dashboard for progress.');
    console.log(`Project URL: https://railway.app/project/${PROJECT_ID}`);

  } catch (error) {
    console.error('Error:', error);
  }
}

deployToRailway();