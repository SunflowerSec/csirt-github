# Variables for CSIRT repository management

variable "github_token" {
  type        = string
  description = "GitHub Personal Access Token with repo and admin:org permissions"
  sensitive   = true
}

variable "github_owner" {
  type        = string
  description = "GitHub organization or username"
  default     = "SunflowerSec"
}

variable "managed_repositories" {
  type = map(object({
    description           = string
    require_reviews      = optional(number, 1)
    require_status_checks = optional(list(string), ["ci/terraform-validate"])
    restrict_pushes      = optional(bool, true)
    require_signed_commits = optional(bool, true)
  }))
  description = "Map of repositories to manage with their ruleset configurations"
  default = {
    "csirt-infra" = {
      description           = "CSIRT infrastructure repository"
      require_reviews      = 1
      require_status_checks = ["ci/terraform-validate", "ci/security-scan"]
      restrict_pushes      = true
      require_signed_commits = true
    }
  }
}

variable "team_members" {
  type        = list(string)
  description = "List of CSIRT team members with admin access"
  default     = ["einargaustad"]
}
