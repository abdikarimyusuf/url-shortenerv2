resource "aws_cloudwatch_metric_alarm" "api_cpu_alarm" {
  alarm_name = "${var.name}-api-cpu-alarm"

  namespace   = "AWS/ECS"
  metric_name = "CPUUtilization"

  dimensions = {
    ClusterName = var.cluster_name
    serviceName = var.api_service_name
  }

  statistic           = "Average"
  period              = 60
  evaluation_periods  = 5
  datapoints_to_alarm = 3

  threshold           = 80
  comparison_operator = "GreaterThanThreshold"

  treat_missing_data = "notBreaching"

}

resource "aws_cloudwatch_metric_alarm" "api_memory_alarm" {
  alarm_name = "${var.name}-api-memory-alarm"

  namespace   = "AWS/ECS"
  metric_name = "MemoryUtilization"

  dimensions = {
    ClusterName = var.cluster_name
    serviceName = var.api_service_name
  }

  statistic           = "Average"
  period              = 60
  evaluation_periods  = 5
  datapoints_to_alarm = 3

  threshold           = 80
  comparison_operator = "GreaterThanThreshold"

  treat_missing_data = "notBreaching"

}

resource "aws_cloudwatch_metric_alarm" "worker_cpu_alarm" {
  alarm_name = "${var.name}-worker-cpu-alarm"

  namespace   = "AWS/ECS"
  metric_name = "CPUUtilization"

  dimensions = {
    ClusterName = var.cluster_name
    serviceName = var.worker_service_name
  }

  statistic           = "Average"
  period              = 60
  evaluation_periods  = 5
  datapoints_to_alarm = 3

  threshold           = 80
  comparison_operator = "GreaterThanThreshold"

  treat_missing_data = "notBreaching"

}


resource "aws_cloudwatch_metric_alarm" "worker_memory_alarm" {
  alarm_name = "${var.name}-worker-memory-alarm"

  namespace   = "AWS/ECS"
  metric_name = "MemoryUtilization"

  dimensions = {
    ClusterName = var.cluster_name
    serviceName = var.worker_service_name
  }

  statistic           = "Average"
  period              = 60
  evaluation_periods  = 5
  datapoints_to_alarm = 3

  threshold           = 80
  comparison_operator = "GreaterThanThreshold"

  treat_missing_data = "notBreaching"

}


resource "aws_cloudwatch_metric_alarm" "dashboard_cpu_alarm" {
  alarm_name = "${var.name}-dashboard-cpu-alarm"

  namespace   = "AWS/ECS"
  metric_name = "CPUUtilization"

  dimensions = {
    ClusterName = var.cluster_name
    serviceName = var.dashboard_service_name
  }

  statistic           = "Average"
  period              = 60
  evaluation_periods  = 5
  datapoints_to_alarm = 3

  threshold           = 80
  comparison_operator = "GreaterThanThreshold"

  treat_missing_data = "notBreaching"

}


resource "aws_cloudwatch_metric_alarm" "dashboard_memory_alarm" {
  alarm_name = "${var.name}-dashboard-memory-alarm"

  namespace   = "AWS/ECS"
  metric_name = "MemoryUtilization"

  dimensions = {
    ClusterName = var.cluster_name
    serviceName = var.dashboard_service_name
  }

  statistic           = "Average"
  period              = 60
  evaluation_periods  = 5
  datapoints_to_alarm = 3

  threshold           = 80
  comparison_operator = "GreaterThanThreshold"

  treat_missing_data = "notBreaching"

}

resource "aws_cloudwatch_metric_alarm" "rds_cpu_alarm" {
  alarm_name = "${var.name}-rds-cpu-alarm"

  namespace   = "AWS/RDS"
  metric_name = "CPUUtilization"

  dimensions = {
    DBInstanceIdentifier = var.rds_instance_identifier
  }

  statistic           = "Average"
  period              = 300
  evaluation_periods  = 5
  datapoints_to_alarm = 3

  threshold           = 80
  comparison_operator = "GreaterThanThreshold"

  treat_missing_data = "notBreaching"

}

resource "aws_cloudwatch_metric_alarm" "redis_cpu_alarm" {
  alarm_name = "${var.name}-redis-cpu-alarm"

  namespace   = "AWS/ElastiCache"
  metric_name = "EngineCPUUtilization"

  dimensions = {
    ReplicationGroupId = var.redis_replication_group_id
  }

  statistic          = "Average"
  period             = 300
  evaluation_periods = 3

  threshold           = 80
  comparison_operator = "GreaterThanThreshold"

  treat_missing_data = "notBreaching"

}

resource "aws_cloudwatch_metric_alarm" "rds_lowstorage_alarm" {
  alarm_name = "${var.name}-rds-lowstorage-alarm"

  namespace   = "AWS/RDS"
  metric_name = "FreeStorageSpace"

  dimensions = {
    DBInstanceIdentifier = var.rds_instance_identifier
  }

  statistic          = "Minimum"
  period             = 300
  evaluation_periods = 3

  threshold           = 5368709120 #5 GB in bytes
  comparison_operator = "LessThanThreshold"

  treat_missing_data = "notBreaching"

}


resource "aws_cloudwatch_metric_alarm" "alb_5xx" {
  alarm_name = "${var.name}-alb-5xx"

  namespace   = "AWS/ApplicationELB"
  metric_name = "HTTPCode_ELB_5XX_Count"

  dimensions = {
    LoadBalancer = var.alb_arn_suffix # ARN_SUFFIX → Format CloudWatch expects for ALB metrics
  }

  statistic          = "Sum"
  period             = 60
  evaluation_periods = 5

  threshold           = 10
  comparison_operator = "GreaterThanThreshold"

  treat_missing_data = "notBreaching"

}

resource "aws_cloudwatch_metric_alarm" "api_5xx" {
  alarm_name = "${var.name}-api-5xx"

  namespace   = "AWS/ApplicationELB"
  metric_name = "HTTPCode_Target_5XX_Count"

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
    TargetGroup  = var.api_tg_arn_suffix
  }

  statistic          = "Sum"
  period             = 60
  evaluation_periods = 5

  threshold           = 10
  comparison_operator = "GreaterThanThreshold"

  treat_missing_data = "notBreaching"

}

resource "aws_cloudwatch_metric_alarm" "dashboard_5xx" {
  alarm_name = "${var.name}-dahboard-5xx"

  namespace   = "AWS/ApplicationELB"
  metric_name = "HTTPCode_Target_5XX_Count"

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
    TargetGroup  = var.dashboard_tg_arn_suffix
  }

  statistic          = "Sum"
  period             = 60
  evaluation_periods = 5

  threshold           = 10
  comparison_operator = "GreaterThanThreshold"

  treat_missing_data = "notBreaching"

}
