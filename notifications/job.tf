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
                    configMapRef = {
                      name = kubernetes_config_map_v1.notifier.metadata[0].name
                    }
                  }
                ]

                env = [
                  {
                    name = "EmailSenderOptions__SmtpServer"
                    valueFrom = {
                      secretKeyRef = {
                        name = kubernetes_secret_v1.email.metadata[0].name
                        key  = "host"
                      }
                    }
                  },
                  {
                    name = "EmailSenderOptions__SmtpPort"
                    valueFrom = {
                      secretKeyRef = {
                        name = kubernetes_secret_v1.email.metadata[0].name
                        key  = "port"
                      }
                    }
                  },
                  {
                    name = "EmailSenderOptions__SmtpUsername"
                    valueFrom = {
                      secretKeyRef = {
                        name = kubernetes_secret_v1.email.metadata[0].name
                        key  = "username"
                      }
                    }
                  },
                  {
                    name = "EmailSenderOptions__SmtpPassword"
                    valueFrom = {
                      secretKeyRef = {
                        name = kubernetes_secret_v1.email.metadata[0].name
                        key  = "password"
                      }
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
            queueURL    = data.terraform_remote_state.messaging.outputs.queues_urls["video-processing-completed"]
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
