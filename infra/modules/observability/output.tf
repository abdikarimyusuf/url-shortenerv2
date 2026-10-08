output "alarm_arn" {
  description = "cloud watch alarm arn"
  value = {
    api_cpu_alarm          = aws_cloudwatch_metric_alarm.api_cpu_alarm.arn
    api_memory_alarm       = aws_cloudwatch_metric_alarm.api_memory_alarm.arn
    worker_cpu_alarm       = aws_cloudwatch_metric_alarm.worker_cpu_alarm.arn
    worker_memory_alarm    = aws_cloudwatch_metric_alarm.worker_memory_alarm.arn
    dashboard_cpu_alarm    = aws_cloudwatch_metric_alarm.dashboard_cpu_alarm.arn
    dashboard_memory_alarm = aws_cloudwatch_metric_alarm.dashboard_memory_alarm.arn
    rds_cpu_alarm          = aws_cloudwatch_metric_alarm.rds_cpu_alarm.arn
    redis_cpu_alarm        = aws_cloudwatch_metric_alarm.redis_cpu_alarm.arn
    rds_lowstorage_alarm   = aws_cloudwatch_metric_alarm.rds_lowstorage_alarm.arn
    alb_5xx_alarm          = aws_cloudwatch_metric_alarm.alb_5xx.arn
    api_target_alarm       = aws_cloudwatch_metric_alarm.api_5xx.arn
    dashboard_alarm        = aws_cloudwatch_metric_alarm.dashboard_5xx.arn


  }
}