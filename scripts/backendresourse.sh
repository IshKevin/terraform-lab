#!/bin/bash

set -e

export AWS_PAGER=""
REGION="us-east-1"
BUCKET_NAME="tf-state-$(date +%Y%m%d%H%M%S)"
DYNAMODB_TABLE="terraform-lock"

echo "Creating backend resources..."

aws s3api create-bucket \
  --bucket $BUCKET_NAME \
  --region $REGION

aws dynamodb create-table \
  --table-name $DYNAMODB_TABLE \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region $REGION

MY_IP=$(curl -s ifconfig.me)

mkdir -p config

cat <<EOF > config/env.tfvars
region         = "$REGION"
bucket_name    = "$BUCKET_NAME"
dynamodb_table = "$DYNAMODB_TABLE"
my_ip          = "${MY_IP}/32"
EOF

echo "Backend resources create  succesfully. Config saved to config/env.tfvars"