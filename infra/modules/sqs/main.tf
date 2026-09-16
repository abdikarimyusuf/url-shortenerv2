resource "aws_sqs_queue" "dead_letter_queue" {
  name                      = "${var.project_name}-${var.environment}-dlq"
  message_retention_seconds = 120000 # 4 days
  sqs_managed_sse_enabled   = true
}

resource "aws_sqs_queue" "main_queue" {
  name                       = "${var.project_name}-${var.environment}-main-queue"
  message_retention_seconds  = var.main_queue_message_retention_seconds
  visibility_timeout_seconds = var.main_queue_visibility_timeout_seconds
  receive_wait_time_seconds  = 20 # Long Polling
  sqs_managed_sse_enabled    = true

}

resource "aws_sqs_queue_redrive_policy" "main_queue_redrive_policy" {
  queue_url = aws_sqs_queue.main_queue.id
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dead_letter_queue.arn
    maxReceiveCount     = var.max_receive_count
  })
}


resource "aws_sqs_queue_redrive_allow_policy" "main_queue_redrive_allow_policy" {
  queue_url = aws_sqs_queue.main_queue.id
  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue"
    sourceQueueArn    = [aws_sqs_queue.main_queue.arn]

  })

}















#Redrive Policy defines what happens when a message repeatedly fails processing