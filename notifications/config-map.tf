resource "kubernetes_config_map_v1" "notifier" {
  metadata {
    name      = "notifier-configs"
    namespace = kubernetes_namespace_v1.notifications.metadata[0].name
  }

  data = {
    ASPNETCORE_ENVIRONMENT = data.terraform_remote_state.shared.outputs.environment

    AppInfo__Name    = "fiapx-notifier"
    AppInfo__Version = "1.0.0"

    EmailSenderOptions__SmtpServer                 = "mailpit-smtp"
    EmailSenderOptions__SmtpPort                   = "25"
    EmailSenderOptions__SslRequired                = "false"
    EmailSenderOptions__SenderInformation__Name    = "FIAP X"
    EmailSenderOptions__SenderInformation__Address = "postmaster@${var.email_domain}"

    EmailContent__LogoUrl         = "${var.web_base_url}/logo_video.svg"
    EmailContent__DownloadBaseUrl = "${var.web_base_url}/videos"

    AwsCredentials__UseLocalstack = "false"

    MessagingOptions__QueueNames__VideoProcessingCompleted = "${local.prefix}-video-processing-completed"
  }
}
