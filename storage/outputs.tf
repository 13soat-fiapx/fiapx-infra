output "environment" {
  value = data.terraform_remote_state.shared.outputs.environment
}

output "artifacts_bucket_name" {
  value = aws_s3_bucket.artifacts.bucket
}

output "web_url" {
  value = "http://${aws_s3_bucket_website_configuration.web.website_endpoint}"
}
