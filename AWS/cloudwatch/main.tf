resource "aws_cloudwatch_metric_alarm" "CPU_Utilization" {
  alarm_name                = "cpu_metrics"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "70"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
}

resource "aws_cloudwatch_metric_alarm" "StatusCheckFailed_Instance" {
  alarm_name                = "cpu_metrics"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "StatusCheckFailed_Instance"
  namespace                 = "AWS/EC2"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "1"
  alarm_description         = "This metric monitors ec2 Instance Checks"
  insufficient_data_actions = []
}

esource "aws_cloudwatch_event_rule" "API_Access" {
  name        = "api_access"
  description = "Evet Rule based on Access Keys being created"
  
  event_pattern = <<PATTERN
{
  "detail-type": [
    ""
  ]
}
PATTERN
}

resource "aws_cloudwatch_event_target" "sns" {
  rule      = "${aws_cloudwatch_event_rule.API_Access.name}"
  target_id = "${var.Target_ID}"
  arn       = "${aws_sns_topic.aws_logins.arn}"
}

resource "aws_sns_topic" "aws_api_access" {
  name = "aws-api_access_keys"
}

resource "aws_sns_topic_policy" "default" {
  arn    = "${aws_sns_topic.aws_api_access.arn}"
  policy = "${data.aws_iam_policy_document.sns_topic_policy.json}"
}

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = ["${aws_sns_topic.aws_api_access.arn}"]
  }
}
