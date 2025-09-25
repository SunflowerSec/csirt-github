# GitHub App Authentication Variables
# Use these instead of the token-based variables in variables.tf

variable "github_app_id" {
  type        = string
  description = "GitHub App ID for authentication"
  sensitive   = true
}

variable "github_app_installation_id" {
  type        = string  
  description = "GitHub App Installation ID for the organization"
  sensitive   = true
}

variable "github_app_private_key" {
  type        = string
  description = "GitHub App private key (PEM format)"
  sensitive   = true
}

variable "github_owner" {
  type        = string
  description = "GitHub organization or username"
  default     = "SunflowerSec"
}

variable "use_github_app" {
  type        = bool
  description = "Whether to use GitHub App authentication instead of token"
  default     = true
}
