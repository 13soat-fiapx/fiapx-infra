resource "helm_release" "datadog" {
  count = local.datadog_enabled

  name      = "datadog"
  namespace = kubernetes_namespace_v1.observability[0].metadata[0].name

  repository = "https://helm.datadoghq.com"
  chart      = "datadog"

  set = [
    {
      name  = "datadog.site"
      value = var.datadog_site
    },
    {
      name  = "datadog.clusterName"
      value = data.terraform_remote_state.k8s.outputs.cluster_name
    },
    {
      name  = "datadog.apiKeyExistingSecret"
      value = kubernetes_secret_v1.datadog_api_key[0].metadata[0].name
    },
    {
      name  = "datadog.kubeStateMetricsCore.enabled"
      value = "true"
    },
    {
      name  = "datadog.logs.enabled"
      value = "false"
    },
    {
      name  = "datadog.apm.portEnabled"
      value = "false"
    },
    {
      name  = "datadog.processAgent.processCollection"
      value = "false"
    }
  ]
}
