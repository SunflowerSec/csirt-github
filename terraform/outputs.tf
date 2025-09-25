# Outputs for CSIRT repository management

output "managed_repositories" {
  description = "List of repositories under CSIRT management"
  value = {
    for repo_name, config in var.managed_repositories : repo_name => {
      name        = repo_name
      description = config.description
      url         = "https://github.com/${var.github_owner}/${repo_name}"
    }
  }
}

output "ruleset_ids" {
  description = "Repository ruleset IDs for managed repositories"
  value = {
    csirt_infra = github_repository_ruleset.csirt_infra_protection.id
  }
}

output "protection_summary" {
  description = "Summary of protection rules applied"
  value = {
    csirt_infra = {
      required_reviews = github_repository_ruleset.csirt_infra_protection.rules[0].pull_request[0].required_approving_review_count
      status_checks   = [for check in github_repository_ruleset.csirt_infra_protection.rules[1].required_status_checks[0].required_check : check.context]
      push_restrictions = github_repository_ruleset.csirt_infra_protection.rules[2].push[0].restrict_pushes_to_matching_refs
    }
  }
}
