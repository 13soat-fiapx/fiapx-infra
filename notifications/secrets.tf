resource "aws_secretsmanager_secret" "email_credentials" {
  name = "${local.prefix}-email"
}

resource "aws_secretsmanager_secret_version" "email_credentials_value" {
  secret_id = aws_secretsmanager_secret.email_credentials.id
  secret_string = jsonencode({
    userName = "${random_string.email_smtp_user.result}@${var.email_domain}"
    password = random_password.email_smtp_password.result
  })
}
