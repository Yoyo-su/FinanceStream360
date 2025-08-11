# zip lambda function
zip lambda.zip src/finnhub_conn.py

# make s3 bucket

aws s3 mb s3://fin360-bucket-XX25

# package the SAM application
aws cloudformation package --s3-bucket fin360-bucket-XX25 --template-file finstream_deploy.yaml --output-template-file pack_finstream_deploy.yaml

# deploy the application
aws cloudformation deploy --template-file pack_finstream_deploy.yaml --stack-name finstream360 --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM

# delete the application
# aws cloudformation delete-stack --stack-name finstream360