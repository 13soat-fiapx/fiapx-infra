resource "kubernetes_namespace_v1" "notifications" {
  metadata {
    name = "notifications"
  }
}

resource "helm_release" "mailpit" {
  name      = "mailpit"
  namespace = kubernetes_namespace_v1.notifications.metadata[0].name

  repository = "https://jouve.github.io/charts"
  chart      = "mailpit"

  set = [{
    name  = "mailpit.smtp.authFile.enabled"
    value = true
  }]

  set_sensitive = [{
    name  = "mailpit.smtp.authFile.htpasswd"
    value = "${random_string.email_smtp_user.result}@${var.email_domain}:${random_password.email_smtp_password.result}"
  }]
}
