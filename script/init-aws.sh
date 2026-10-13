#!/bin/bash

echo "Creating SQS queue..."

awslocal sqs create-queue \
  --queue-name url-shortener-click-events

echo "Queue URL:"

awslocal sqs get-queue-url \
  --queue-name url-shortener-click-events