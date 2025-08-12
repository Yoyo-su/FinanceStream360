#!/bin/sh
set -a
source .env
set +a

# # make s3 bucket
# aws s3 mb s3://$S3_BUCKET

# # create dependency layer
# pip install -r lambda_requirements.txt -t python/

# # zip dependency layer
zip -r layer.zip python/

# # package dependency layer
aws s3 cp layer.zip s3://$S3_BUCKET/websocket_layer.zip

# # zip lambda function
zip -j lambda.zip src/finnhub_conn.py

# # package lambda layer
aws s3 cp lambda.zip s3://$S3_BUCKET/finnhub_lambda.zip

# package the SAM application
aws cloudformation package --s3-bucket $S3_BUCKET --template-file finstream_deploy.yaml --output-template-file pack_finstream_deploy.yaml

# deploy the application
aws cloudformation deploy --template-file pack_finstream_deploy.yaml --stack-name finstream360 --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM --parameter-overrides S3Bucket=$S3_BUCKET FinnhubKey=$FINNHUB_KEY

# delete the application
# aws cloudformation delete-stack --stack-name finstream360