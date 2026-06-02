resource "kubernetes_manifest" "notifier_scaledjob" {
  manifest = {
    apiVersion = "keda.sh/v1alpha1"
    kind       = "ScaledJob"

    metadata = {
      name      = "notifier"
      namespace = kubernetes_namespace_v1.notifications.metadata[0].name
    }

    spec = {
      jobTargetRef = {
        template = {
          spec = {
            containers = [
              {
                name            = "notifier"
                image           = "${data.terraform_remote_state.cr.outputs.container_registry_uris["notifier"]}:latest"
                imagePullPolicy = "Always"

                envFrom = [
                  {
                    secretRef = {
                      name = kubernetes_secret_v1.email.metadata[0].name
                    }
                  }
                ]
              }
            ]
            restartPolicy = "Never"
          }
        }
      }

      triggers = [
        {
          type = "aws-sqs-queue"
          metadata = {
            queueURL    = data.terraform_remote_state.messaging.outputs.queues_urls["video-status-changed"]
            queueLength = "1"
            awsRegion   = "us-east-1"
          }
          authenticationRef = {
            name = "${local.prefix}-keda-auth"
          }
        }
      ]
    }
  }
}
