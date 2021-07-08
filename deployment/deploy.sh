#!/bin/bash

function print_usage {
    echo "$1 -a [plan|apply|destroy|output] -r <region> -s <sources>"
}

# Change directory to the terraform directory
export BASE_DIR=`dirname "$0"`
cd $BASE_DIR/terraform

if [[ $# -lt 4 ]] ;  then
    print_usage $0
    exit 1
fi

while getopts ":a:r:f:s:h" opt ; do 
    case $opt in
        a )
            ACTION=$OPTARG
        ;;
        r ) 
            REGION=$OPTARG
            export AWS_DEFAULT_REGION=$REGION
        ;;
        f ) 
            FORMAT=$OPTARG
        ;;
        s ) 
            export TF_VAR_sources_zip="../$OPTARG"
        ;;
        h ) 
            print_usage $0
            exit 0
        ;;
        \? )
            print_usage $0
            exit 1
        ;; 
    esac 
done
shift $((OPTIND -1))

# initialize terraform 
terraform init -backend-config=backend.tfvars -reconfigure
# select the correct region
terraform workspace select $REGION


case $ACTION in
    "plan")
        terraform plan -out=plan.tfplan -var-file=regions-values/$REGION/variables.tfvars
    ;;
    "apply")
        terraform apply plan.tfplan 
    ;;
    "destroy")
        echo "this is disabled, enable this manually if you really want to destroy the deployment"
        #terraform destroy -var-file=regions-values/$REGION/variables.tfvars 
    ;;
    "output")
        terraform output -json       
    ;;
    *)
        print_usage
    ;;
esac
