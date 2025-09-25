# GitHub App Setup for CSIRT Repository Management

## Overview
To manage repository rulesets and advanced settings, this project uses a GitHub App with elevated permissions instead of personal access tokens.

## GitHub App Creation

### 1. Create the GitHub App
1. Go to your organization settings: `https://github.com/organizations/SunflowerSec/settings/apps`
2. Click "New GitHub App"
3. Fill in the required information:

#### Basic Information
- **GitHub App name**: `CSIRT Repository Manager`
- **Description**: `Automated management of CSIRT team repositories including rulesets, branch protection, and access controls`
- **Homepage URL**: `https://github.com/SunflowerSec/csirt-github`

#### Permissions
The app needs the following **Repository permissions**:
- **Administration**: Read & Write (manage repository settings)
- **Contents**: Read & Write (access repository files)
- **Metadata**: Read (basic repository information)
- **Pull requests**: Read & Write (manage PR settings)
- **Repository security and analysis**: Write (manage security features)

The app needs the following **Organization permissions**:
- **Members**: Read (access organization member information)
- **Team discussions**: Read (if using team-based permissions)

#### Webhook Settings
- **Webhook URL**: Leave empty (not needed for this use case)
- **Webhook secret**: Leave empty
- **SSL verification**: Enable SSL verification

#### Subscribe to events
- Uncheck all events (we don't need webhooks)

#### Where can this GitHub App be installed?
- Select "Only on this account" (SunflowerSec)

### 2. Generate Private Key
1. After creating the app, scroll down to "Private keys"
2. Click "Generate a private key"
3. Download the `.pem` file securely

### 3. Install the App
1. Go to the app's page and click "Install App"
2. Select "SunflowerSec" organization
3. Choose "Selected repositories" and select:
   - `csirt-github` (this repository)
   - `csirt-infra` (target repository to manage)
   - Any other CSIRT repositories you want to manage

### 4. Get App Credentials
Note down these values (you'll need them later):
- **App ID**: Found in the app's general settings
- **Installation ID**: Found in the URL after installing (or via API)
- **Private Key**: The `.pem` file you downloaded

## Environment Setup

### GitHub Repository Environments
1. Go to `Settings > Environments` in the csirt-github repository
2. Create a new environment called `prod`
3. Add protection rules:
   - **Required reviewers**: Add CSIRT team members
   - **Wait timer**: 0 minutes (or as desired)
   - **Deployment branches**: Only main branch

### Environment Secrets
Add these secrets to the `prod` environment:

1. **`GITHUB_APP_ID`**
   - Value: Your app's ID (numeric)

2. **`GITHUB_APP_INSTALLATION_ID`** 
   - Value: Installation ID for SunflowerSec org

3. **`GITHUB_APP_PRIVATE_KEY`**
   - Value: Contents of the `.pem` file
   - Include the full content including `-----BEGIN RSA PRIVATE KEY-----` and `-----END RSA PRIVATE KEY-----`

## Terraform Provider Configuration

The Terraform configuration will use the GitHub App for authentication:

```hcl
provider "github" {
  app_auth {
    id              = var.github_app_id
    installation_id = var.github_app_installation_id  
    pem_file        = var.github_app_private_key
  }
  owner = var.github_owner
}
```

## Security Considerations

### Private Key Security
- **Never commit** the private key to the repository
- Store the key securely in GitHub environment secrets
- Rotate the key periodically (generate new keys, update secrets)
- Use environment protection rules to control access

### App Permissions
- Follow principle of least privilege
- Regularly audit app installations and permissions
- Remove unused permissions
- Monitor app activity through GitHub's audit logs

### Access Control
- Use environment protection rules
- Require reviews for production deployments
- Limit who can access environment secrets
- Enable audit logging for secret access

## Troubleshooting

### Common Issues
1. **Authentication failed**: Check app ID, installation ID, and private key format
2. **Insufficient permissions**: Verify app has required repository permissions
3. **App not installed**: Ensure app is installed on target repositories
4. **Wrong installation ID**: Each organization has a different installation ID

### Getting Installation ID
You can get the installation ID via API:
```bash
curl -H "Authorization: Bearer \$JWT_TOKEN" \
     -H "Accept: application/vnd.github.v3+json" \
     https://api.github.com/app/installations
```

Or check the URL after installing the app - it will be in the format:
`https://github.com/organizations/SunflowerSec/settings/installations/INSTALLATION_ID`
