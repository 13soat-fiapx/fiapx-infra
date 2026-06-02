resource "random_string" "email_smtp_user" {
  length  = 10
  upper   = false
  numeric = false
  special = false
}

resource "random_password" "email_smtp_password" {
  length  = 16
  special = false
}
