output "environment" {
  value = data.terraform_remote_state.shared.outputs.environment
}

output "artifacts_bucket_name" {
  value = aws_s3_bucket.artifacts.bucket
}
