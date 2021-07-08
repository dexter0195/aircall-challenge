# aircall-challenge

These CD scripts are used to deploy on AWS Lambda the aircall challenge.

## General Architecture

The deployment is done through Jenkins on Kubernetes and the pipeline is composed as following: 

0. The pipeline takes as arguments:
	- the AWS region in which you want to deploy
	- the COMMIT_SHA of that repository that you want to checkout
1. The Build step clones the repository and installs the node dependencies. Then generates a file src.zip
2. The Deploy step takes as input the parameters + the src.zip and deploys that on AWS.
	> The src.zip is uploaded to s3 through the terraform
3. Ad the end of the pipeline jenkins sends a message on Slack informing us of the state of the Deployment
