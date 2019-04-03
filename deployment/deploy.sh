# This script create the S3 bucket, builds templates and the Node website, and deploys the Media Analysis Solution stack.

export DIST_OUTPUT_BUCKET=mas1
export VERSION=1.0.0
export REGION=us-east-1
aws s3 mb s3://$DIST_OUTPUT_BUCKET-$REGION --region $REGION
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
source $NVM_DIR/nvm.sh
nvm use 9
./build-s3-dist.sh $DIST_OUTPUT_BUCKET $VERSION
aws s3 cp ./dist/ s3://$DIST_OUTPUT_BUCKET-$REGION/media-analysis-solution/$VERSION/ --recursive --acl bucket-owner-full-control
aws cloudformation create-stack --stack-name $DIST_OUTPUT_BUCKET --template-url  https://s3.amazonaws.com/$DIST_OUTPUT_BUCKET-$REGION/media-analysis-solution/$VERSION/media-analysis-deploy.template --region $REGION --parameters ParameterKey=Email,ParameterValue=ianwow@amazon.com --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND
#aws cloudformation create-stack --stack-name $DIST_OUTPUT_BUCKET --template-url  https://s3.amazonaws.com/$DIST_OUTPUT_BUCKET-$REGION/media-analysis-solution/$VERSION/media-analysis-deploy.template --region $REGION --parameters ParameterKey=Email,ParameterValue=ianwow@amazon.com --role-arn arn:aws:iam::773074507832:role/admin_for_mas1.0  --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND --disable-rollback
