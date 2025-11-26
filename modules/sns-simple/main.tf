resource "aws_sns_topic" "simple_topic" {
    for_each = { for o in var.topic_details : o.topic_name => o }

    name = "${each.value.topic_name}"
    fifo_topic = false

  tags = var.tags
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "simple_topic_policy_document" {

    for_each = { for o in var.topic_details : o.topic_name => o }

    statement {
        sid    = "1"
        effect = "Allow"

        principals {
        type        = "AWS"
        identifiers = ["*"]
        }

        actions   = [
          "SNS:GetTopicAttributes",
          "SNS:SetTopicAttributes",
          "SNS:AddPermission",
          "SNS:RemovePermission",
          "SNS:DeleteTopic",
          "SNS:Subscribe",
          "SNS:ListSubscriptionsByTopic",
          "SNS:Publish"          
        ]
        resources = [aws_sns_topic.simple_topic[each.key].arn]

        condition {
          test     = "StringEquals"
          variable = "AWS:SourceOwner"
          values   = [data.aws_caller_identity.current.account_id]
        }
    }
}

resource "aws_sns_topic_policy" "simple_topic_policy" {

    for_each = { for o in var.topic_details : o.topic_name => o }

    arn = aws_sns_topic.simple_topic[each.key].arn
    policy    = data.aws_iam_policy_document.simple_topic_policy_document[each.key].json
}