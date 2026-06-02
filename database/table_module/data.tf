# remote states

data "aws_caller_identity" "current" {}

data "terraform_remote_state" "shared" {
  backend = "s3"

  config = {
    bucket = "fiapx-tf-${data.aws_caller_identity.current.account_id}"
    key    = "shared-${var.environment}.tfstate"
    region = "us-east-1"
  }
}
