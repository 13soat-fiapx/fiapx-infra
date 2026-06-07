resource "kubernetes_secret_v1" "email" {
  metadata {
    name      = "email"
    namespace = kubernetes_namespace_v1.notifications.metadata[0].name
  }

  data = {
    username = "${random_string.email_smtp_user.result}@${var.email_domain}"
    password = random_password.email_smtp_password.result
  }
}

resource "kubernetes_secret_v1" "aws_credentials" {
  metadata {
    name      = "aws-credentials"
    namespace = kubernetes_namespace_v1.notifications.metadata[0].name

    annotations = {
      "reflector.v1.k8s.emberstack.com/reflects" = "external-secrets/aws-credentials"
    }
  }
}

