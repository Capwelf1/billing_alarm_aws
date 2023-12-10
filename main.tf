
resource "aws_cloudwatch_metric_alarm" "billing_alarm" {
  alarm_name          = var.alarm_name
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  period              = var.period # 6 hours
  statistic           = "Maximum"
  threshold           = var.amount  
   alarm_actions = [aws_sns_topic.billing_alarm.arn]
  alarm_description = <<EOF
  EOF
}

resource "aws_sns_topic" "billing_alarm" {
}
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.billing_alarm.arn
  protocol  = "email"
  endpoint  = var.email

  filter_policy = jsonencode({
    state = ["ALARM"]
  })
}

