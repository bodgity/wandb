#!/bin/bash
set -euo pipefail

# Read Terraform outputs
ACM_ARN=$(terraform output -raw acm_certificate_arn)
DB_HOST=$(terraform output -raw db_host)
WAND_B_HOST=$(terraform output -raw wandb_host)
S3_BUCKET=$(terraform output -raw artifacts_bucket)
S3_REGION=$(terraform output -raw artifacts_bucket_region)
LICENSE=$(terraform output -raw wandb_license)

# Template and output file
TEMPLATE_FILE="wandb.yaml.tpl"
OUTPUT_FILE="../charts/manifest/wandb.yaml"

# Substitute variables using sed
sed -e "s|\${ACM_ARN}|$ACM_ARN|g" \
    -e "s|\${DB_HOST}|$DB_HOST|g" \
    -e "s|\${WAND_B_HOST}|$WAND_B_HOST|g" \
    -e "s|\${S3_BUCKET}|$S3_BUCKET|g" \
    -e "s|\${S3_REGION}|$S3_REGION|g" \
    -e "s|\${LICENSE}|$LICENSE|g" \
    "$TEMPLATE_FILE" > "$OUTPUT_FILE"

echo "Generated $OUTPUT_FILE successfully!"
