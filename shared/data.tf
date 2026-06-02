data "aws_caller_identity" "current" {}

data "aws_s3_bucket" "tfstate" {
  bucket = "${var.project_name}-tf-${data.aws_caller_identity.current.account_id}"
}
