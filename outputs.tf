output "commit_before_sha" {
  description = "Git commit short SHA used in the last deployment"
  value       = var.enable_green_deployment ? var.commit_before_sha : null
}

output "commit_short_sha" {
  value = var.commit_short_sha
}
