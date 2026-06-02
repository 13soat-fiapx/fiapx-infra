resource "aws_sqs_queue" "dlq" {
  for_each = toset(var.queue_names)

  name = "${local.prefix}-${each.key}-dlq"

  message_retention_seconds = 1209600 # 14 days
}

resource "aws_sqs_queue" "main" {
  for_each = toset(var.queue_names)

  name = "${local.prefix}-${each.key}"

  visibility_timeout_seconds = 30
  message_retention_seconds  = 345600 # 4 days
  delay_seconds              = 0

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq[each.key].arn
    maxReceiveCount     = 3
  })
}
