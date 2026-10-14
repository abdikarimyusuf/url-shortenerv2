SQS = Simple Queue Service. 
1. The Queue: The queue is the central component
2. The producer is whoever puts messages into SQS
3. The consumer is the application that takes messages out of SQS
4. A message is the actual piece of information inside the queue
5. Visibility Timeout = sqs temp hiding a messasage after worker consumes it , if worker exceeds they delete the message, if not not it reappears
6. long polling = receive_wait_time_seconds = 20 it stops the worker from constantly asking for a message
7. DEAD LETTER QUEUE DLQ, The place where messages go when they keep failing, you can configure something like this , maxReceiveCount = 5
8. Redrive Policy = Controls when failed messages go to the DLQ"If this message fails too many times..."
9. Redrive Allow Policy = it basically says I allow the main queue to use me as its DLQ. sourceQueueArns = [aws_sqs_queue.main_queue.arn]
10. Message Retention = This determines how long SQS keeps a message before it expires
11. Encryption = This enables server-side encryption