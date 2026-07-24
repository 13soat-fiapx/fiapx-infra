resource "kubernetes_namespace_v1" "observability" {
  count = local.datadog_enabled

  metadata {
    name = "observability"
  }
}

resource "kubernetes_secret_v1" "datadog_api_key" {
  count = local.datadog_enabled

  metadata {
    name      = "datadog-api-key"
    namespace = kubernetes_namespace_v1.observability[0].metadata[0].name

    annotations = {
      "reflector.v1.k8s.emberstack.com/reflection-allowed" = "true"
    }
  }

  data = {
    "api-key" = var.datadog_api_key
  }
}
