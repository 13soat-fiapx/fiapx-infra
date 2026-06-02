output "environment" {
  value = data.terraform_remote_state.shared.outputs.environment
}

output "queues_arns" {
  value = { for k, q in aws_sqs_queue.main : k => q.arn }
}

output "queues_urls" {
  value = { for k, q in aws_sqs_queue.main : k => q.url }
}

output "dlq_queues_arns" {
  value = { for k, q in aws_sqs_queue.dlq : k => q.arn }
}

output "dlq_queues_urls" {
  value = { for k, q in aws_sqs_queue.dlq : k => q.url }
}
