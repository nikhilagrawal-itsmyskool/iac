resource "aws_sqs_queue" "simple_queue" {
    for_each = { for o in var.queue_details : o.queue_name => o }

    name                          = "${each.value.queue_name}"
    visibility_timeout_seconds    = each.value.visibility_timeout_seconds
    message_retention_seconds     = each.value.message_retention_seconds
    delay_seconds                 = each.value.delay_seconds
    max_message_size              = each.value.max_message_size_bytes
    receive_wait_time_seconds     = each.value.receive_wait_time_seconds
    sqs_managed_sse_enabled       = each.value.sqs_managed_sse_enabled

#   redrive_policy = jsonencode({
#     deadLetterTargetArn = aws_sqs_queue.terraform_queue_deadletter.arn
#     maxReceiveCount     = 4
#   })

  tags = var.tags
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "simple_queue_policy_document" {

    for_each = { for o in var.queue_details : o.queue_name => o }

    statement {
        sid    = "1"
        effect = "Allow"

        principals {
        type        = "AWS"
        identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
        }

        actions   = ["SQS:*"]
        resources = [aws_sqs_queue.simple_queue[each.key].arn]

    }
}

resource "aws_sqs_queue_policy" "simple_queue_policy" {

    for_each = { for o in var.queue_details : o.queue_name => o }

    queue_url = aws_sqs_queue.simple_queue[each.key].id
    policy    = data.aws_iam_policy_document.simple_queue_policy_document[each.key].json
}