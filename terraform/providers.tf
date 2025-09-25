terraform {
  required_version = ">= 1.0"
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

# GitHub Provider with App Authentication
provider "github" {
  # Use GitHub App authentication when available
  dynamic "app_auth" {
    for_each = var.use_github_app ? [1] : []
    content {
      id              = var.github_app_id
      installation_id = var.github_app_installation_id  
      pem_file        = var.github_app_private_key
    }
  }
  
  # Fallback to token authentication if GitHub App not configured
  token = var.use_github_app ? null : var.github_token
  owner = var.github_owner
}
