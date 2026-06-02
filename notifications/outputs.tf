output "environment" {
  value = data.terraform_remote_state.shared.outputs.environment
}

output "email_smtp_user" {
  value = "${random_string.email_smtp_user.result}@${var.email_domain}"
}

output "email_smtp_password" {
  value = random_password.email_smtp_password.result

  sensitive = true
}
