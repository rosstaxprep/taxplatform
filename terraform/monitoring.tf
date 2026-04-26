# ============================================================================
# CLOUDWATCH MONITORING & ALERTING
# ============================================================================

# SNS Topic for alerts
resource "aws_sns_topic" "primeweb_alerts" {
  name = "primeweb-alerts"

  tags = {
    Name = "primeweb-alerts"
  }
}

# SNS Topic subscription (email)
resource "aws_sns_topic_subscription" "primeweb_alerts_email" {
  topic_arn = aws_sns_topic.primeweb_alerts.arn
  protocol  = "email"
  endpoint  = "condre@rosstaxsoftware.com"
}

# SNS Topic subscription (SMS - optional)
resource "aws_sns_topic_subscription" "primeweb_alerts_sms" {
  topic_arn = aws_sns_topic.primeweb_alerts.arn
  protocol  = "sms"
  endpoint  = "+15124896749"
}

# CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "primeweb" {
  dashboard_name = "primeweb-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/ECS", "CPUUtilization", { stat = "Average" }],
            [".", "MemoryUtilization", { stat = "Average" }],
            ["AWS/ApplicationELB", "TargetResponseTime", { stat = "Average" }],
            [".", "RequestCount", { stat = "Sum" }],
            [".", "HTTPCode_Target_5XX_Count", { stat = "Sum" }],
            ["AWS/RDS", "CPUUtilization", { stat = "Average" }],
            [".", "DatabaseConnections", { stat = "Average" }],
            ["AWS/ElastiCache", "CPUUtilization", { stat = "Average" }],
            [".", "NetworkBytesIn", { stat = "Sum" }]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "PrimeWeb Infrastructure Metrics"
        }
      },
      {
        type = "log"
        properties = {
          query   = "fields @timestamp, @message | stats count() by @logStream"
          region  = var.aws_region
          title   = "ECS Logs"
        }
      }
    ]
  })
}

# ECS CPU Utilization Alarm
resource "aws_cloudwatch_metric_alarm" "ecs_cpu" {
  alarm_name          = "primeweb-ecs-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "Alert when ECS CPU exceeds 80%"
  alarm_actions       = [aws_sns_topic.primeweb_alerts.arn]

  dimensions = {
    ClusterName = aws_ecs_cluster.primeweb.name
    ServiceName = aws_ecs_service.primeweb.name
  }
}

# ECS Memory Utilization Alarm
resource "aws_cloudwatch_metric_alarm" "ecs_memory" {
  alarm_name          = "primeweb-ecs-memory-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = "85"
  alarm_description   = "Alert when ECS memory exceeds 85%"
  alarm_actions       = [aws_sns_topic.primeweb_alerts.arn]

  dimensions = {
    ClusterName = aws_ecs_cluster.primeweb.name
    ServiceName = aws_ecs_service.primeweb.name
  }
}

# ALB Target Unhealthy Alarm
resource "aws_cloudwatch_metric_alarm" "alb_unhealthy_targets" {
  alarm_name          = "primeweb-alb-unhealthy-targets"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Average"
  threshold           = "0"
  alarm_description   = "Alert when ALB has unhealthy targets"
  alarm_actions       = [aws_sns_topic.primeweb_alerts.arn]

  dimensions = {
    LoadBalancer = aws_lb.primeweb.arn_suffix
    TargetGroup  = aws_lb_target_group.primeweb.arn_suffix
  }
}

# ALB 5XX Errors Alarm
resource "aws_cloudwatch_metric_alarm" "alb_5xx_errors" {
  alarm_name          = "primeweb-alb-5xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Sum"
  threshold           = "10"
  alarm_description   = "Alert when ALB 5XX errors exceed 10"
  alarm_actions       = [aws_sns_topic.primeweb_alerts.arn]

  dimensions = {
    LoadBalancer = aws_lb.primeweb.arn_suffix
  }
}

# RDS CPU Utilization Alarm
resource "aws_cloudwatch_metric_alarm" "rds_cpu" {
  alarm_name          = "primeweb-rds-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "Alert when RDS CPU exceeds 80%"
  alarm_actions       = [aws_sns_topic.primeweb_alerts.arn]

  dimensions = {
    DBClusterIdentifier = aws_rds_cluster.primeweb.cluster_identifier
  }
}

# RDS Database Connections Alarm
resource "aws_cloudwatch_metric_alarm" "rds_connections" {
  alarm_name          = "primeweb-rds-connections-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "Alert when RDS connections exceed 80"
  alarm_actions       = [aws_sns_topic.primeweb_alerts.arn]

  dimensions = {
    DBClusterIdentifier = aws_rds_cluster.primeweb.cluster_identifier
  }
}

# Redis CPU Utilization Alarm
resource "aws_cloudwatch_metric_alarm" "redis_cpu" {
  alarm_name          = "primeweb-redis-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = "300"
  statistic           = "Average"
  threshold           = "75"
  alarm_description   = "Alert when Redis CPU exceeds 75%"
  alarm_actions       = [aws_sns_topic.primeweb_alerts.arn]

  dimensions = {
    ReplicationGroupId = aws_elasticache_replication_group.primeweb.id
  }
}

# CloudFront 4XX Errors Alarm
resource "aws_cloudwatch_metric_alarm" "cloudfront_4xx_errors" {
  alarm_name          = "primeweb-cloudfront-4xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "4xxErrorRate"
  namespace           = "AWS/CloudFront"
  period              = "300"
  statistic           = "Average"
  threshold           = "5"
  alarm_description   = "Alert when CloudFront 4XX error rate exceeds 5%"
  alarm_actions       = [aws_sns_topic.primeweb_alerts.arn]

  dimensions = {
    DistributionId = aws_cloudfront_distribution.primeweb.id
  }
}

# CloudFront 5XX Errors Alarm
resource "aws_cloudwatch_metric_alarm" "cloudfront_5xx_errors" {
  alarm_name          = "primeweb-cloudfront-5xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "5xxErrorRate"
  namespace           = "AWS/CloudFront"
  period              = "60"
  statistic           = "Average"
  threshold           = "1"
  alarm_description   = "Alert when CloudFront 5XX error rate exceeds 1%"
  alarm_actions       = [aws_sns_topic.primeweb_alerts.arn]

  dimensions = {
    DistributionId = aws_cloudfront_distribution.primeweb.id
  }
}

# Log Group Retention
resource "aws_cloudwatch_log_group" "primeweb_application" {
  name              = "/primeweb/application"
  retention_in_days = 30

  tags = {
    Name = "primeweb-application-logs"
  }
}

# Metric Filter - Application Errors
resource "aws_cloudwatch_log_metric_filter" "primeweb_errors" {
  name           = "primeweb-application-errors"
  log_group_name = aws_cloudwatch_log_group.ecs.name
  filter_pattern = "[ERROR]"

  metric_transformation {
    name      = "ApplicationErrorCount"
    namespace = "PrimeWeb"
    value     = "1"
  }
}

# Application Error Alarm
resource "aws_cloudwatch_metric_alarm" "application_errors" {
  alarm_name          = "primeweb-application-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "ApplicationErrorCount"
  namespace           = "PrimeWeb"
  period              = "300"
  statistic           = "Sum"
  threshold           = "10"
  alarm_description   = "Alert when application errors exceed 10 in 5 minutes"
  alarm_actions       = [aws_sns_topic.primeweb_alerts.arn]
}
