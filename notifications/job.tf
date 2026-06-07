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
                    name = "EmailSenderOptions__UserName"
                    valueFrom = {
                      secretKeyRef = {
                        name = kubernetes_secret_v1.email.metadata[0].name
                        key  = "username"
                      }
                    }
                  },
                  {
                    name = "EmailSenderOptions__Password"
                    valueFrom = {
                      secretKeyRef = {
                        name = kubernetes_secret_v1.email.metadata[0].name
                        key  = "password"
                      }
                    }
                  },
                  {
                    name = "AwsCredentials__AccessKey"
                    valueFrom = {
                      secretKeyRef = {
                        name = kubernetes_secret_v1.aws_credentials.metadata[0].name
                        key  = "access-key-id"
                      }
                    }
                  },
                  {
                    name = "AwsCredentials__SecretAccessKey"
                    valueFrom = {
                      secretKeyRef = {
                        name = kubernetes_secret_v1.aws_credentials.metadata[0].name
                        key  = "secret-access-key"
                      }
                    }
                  },
                  {
                    name = "AwsCredentials__SessionToken"
                    valueFrom = {
                      secretKeyRef = {
                        name = kubernetes_secret_v1.aws_credentials.metadata[0].name
                        key  = "session-token"
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
            name = "keda-authentication"
          }
        }
      ]
    }
  }
}

resource "kubernetes_manifest" "keda_trigger_auth" {
  manifest = {
    apiVersion = "keda.sh/v1alpha1"
    kind       = "TriggerAuthentication"

    metadata = {
      name      = "keda-authentication"
      namespace = kubernetes_namespace_v1.notifications.metadata[0].name
    }

    spec = {
      secretTargetRef = [
        {
          parameter = "awsAccessKeyID"
          name      = kubernetes_secret_v1.aws_credentials.metadata[0].name
          key       = "access-key-id"
        },
        {
          parameter = "awsSecretAccessKey"
          name      = kubernetes_secret_v1.aws_credentials.metadata[0].name
          key       = "secret-access-key"
        },
        {
          parameter = "awsSessionToken"
          name      = kubernetes_secret_v1.aws_credentials.metadata[0].name
          key       = "session-token"
        }
      ]
    }
  }
}
