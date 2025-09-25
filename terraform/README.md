# CSIRT Repository Management

This directory contains Terraform configurations to manage CSIRT team repositories, including rulesets, branch protection, and access controls.

## Overview

- **main.tf**: Core Terraform configuration with repository rulesets
- **variables.tf**: Input variables for customization
- **outputs.tf**: Output values for reference
- **terraform.tfvars.example**: Example configuration file

## Features

### Repository Rulesets
- **Branch Protection**: Require PR reviews before merging
- **Status Checks**: Enforce CI/CD pipeline success
- **Push Restrictions**: Prevent direct pushes to protected branches
- **Commit Signing**: Require signed commits for security

### Managed Repositories
Currently managing:
- `csirt-infra`: Infrastructure and automation tools

## Usage

### Prerequisites
1. GitHub Personal Access Token with appropriate permissions:
   - `repo` (full repository access)
   - `admin:org` (organization administration)

### Setup
1. Copy the example configuration:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Edit `terraform.tfvars` with your values:
   - Add your GitHub token
   - Configure team members
   - Customize repository settings

3. Initialize and apply:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Configuration

### Adding New Repositories
To manage additional repositories, add them to the `managed_repositories` variable in `terraform.tfvars`:

```hcl
managed_repositories = {
  "csirt-infra" = {
    description           = "CSIRT infrastructure and automation tools"
    require_reviews      = 2
    require_status_checks = ["ci/terraform-validate", "ci/security-scan"]
    restrict_pushes      = true
    require_signed_commits = true
  }
  "new-repo" = {
    description           = "New repository description"
    require_reviews      = 1
    require_status_checks = ["ci/test"]
    restrict_pushes      = true
    require_signed_commits = false
  }
}
```

### Customizing Rules
Modify the ruleset configurations in `main.tf` to adjust:
- Required number of reviews
- Status check requirements
- Push restrictions
- Commit signing requirements

## Security Considerations

- Never commit `terraform.tfvars` files containing tokens
- Use environment variables or secure secret management
- Regularly rotate GitHub tokens
- Review and audit ruleset changes

## Troubleshooting

### Common Issues
1. **403 Forbidden**: Check GitHub token permissions
2. **404 Not Found**: Verify repository exists and token has access
3. **Ruleset conflicts**: Ensure no conflicting branch protection rules exist

### Getting Help
Contact the CSIRT team for support with repository management configurations.
