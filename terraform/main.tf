# CSIRT Repository Management
# This Terraform configuration manages rulesets and policies for CSIRT repositories

terraform {
  required_version = ">= 1.0"
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

# Configure GitHub provider
provider "github" {
  token = var.github_token
  owner = var.github_owner
}

# Import existing repositories as data sources
data "github_repository" "csirt_infra" {
  full_name = "${var.github_owner}/csirt-infra"
}

# Repository ruleset for csirt-infra
resource "github_repository_ruleset" "csirt_infra_protection" {
  name        = "csirt-infra-protection"
  repository  = data.github_repository.csirt_infra.name
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  # Require pull request reviews
  rules {
    pull_request {
      required_approving_review_count = 1
      dismiss_stale_reviews_on_push   = true
      require_code_owner_review       = false
      require_last_push_approval      = false
    }
  }

  # Require status checks
  rules {
    required_status_checks {
      required_check {
        context = "ci/terraform-validate"
      }
      strict_required_status_checks_policy = true
    }
  }

  # Restrict pushes to protected branches
  rules {
    push {
      restrict_pushes_to_matching_refs = true
    }
  }

  # Require signed commits
  rules {
    commit_author_email_pattern {
      name     = "require-company-email"
      pattern  = ".*@sunflowersec\\.com$"
      operator = "regex"
    }
  }
}
