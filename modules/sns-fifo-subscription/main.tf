data "aws_sns_topic" "sns_topic" {
  for_each = { for o in var.subscription_details : o.topic_name => o }

  name = each.key
}

data "aws_sqs_queue" "sqs_queue" {
  for_each = { for o in var.subscription_details : o.topic_name => o }

  name = each.value.queue_name
}

resource "aws_sns_topic_subscription" "sns_topic_subscription" {
  for_each = { for o in var.subscription_details : o.topic_name => o }

  topic_arn = data.aws_sns_topic.sns_topic[each.key].arn
  protocol  = "sqs"
  endpoint  = data.aws_sqs_queue.sqs_queue[each.key].arn
}