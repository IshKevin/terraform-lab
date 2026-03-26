#!/bin/bash

set -e

CONFIG_FILE="config/env.tfvars"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "Config file not found. Nothing to clean."
  exit 1
fi

# Extract values from tfvars
BUCKET_NAME=$(grep bucket_name $CONFIG_FILE | cut -d '"' -f2)
REGION=$(grep region $CONFIG_FILE | cut -d '"' -f2)
DYNAMODB_TABLE=$(grep dynamodb_table $CONFIG_FILE | cut -d '"' -f2)

echo "Starting cleanup..."

# 1. Destroy Terraform resources
echo "Destroying Terraform infrastructure..."
terraform destroy -var-file="$CONFIG_FILE" -auto-approve

# 2. Empty and delete S3 bucket
echo "Deleting S3 bucket: $BUCKET_NAME"

aws s3 rm s3://$BUCKET_NAME --recursive || true
aws s3api delete-bucket --bucket $BUCKET_NAME --region $REGION

# 3. Delete DynamoDB table
echo "Deleting DynamoDB table: $DYNAMODB_TABLE"

aws dynamodb delete-table \
  --table-name $DYNAMODB_TABLE \
  --region $REGION

# 4. Remove generated config
echo "Removing generated config file..."
rm -f $CONFIG_FILE

echo "Cleanup complete ✅"