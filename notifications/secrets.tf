resource "kubernetes_secret_v1" "email" {
  metadata {
    name      = "email"
    namespace = kubernetes_namespace_v1.notifications.metadata[0].name

  }

  data = {
    host     = "mailpit.notifications.svc.cluster.local"
    port     = "1025"
    username = "${random_string.email_smtp_user.result}@${var.email_domain}"
    password = random_password.email_smtp_password.result
  }
}
