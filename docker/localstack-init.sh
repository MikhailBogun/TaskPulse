#!/bin/bash
set -e
echo "Initializing LocalStack..."
awslocal s3 mb s3://taskpulse-dev
awslocal sqs create-queue --queue-name taskpulse-jobs
echo "LocalStack init complete."
