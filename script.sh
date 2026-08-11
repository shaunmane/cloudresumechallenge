#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root or with sudo." 
   exit 1
fi

apt-get update -y
apt-get install -y unzip apt-transport-https curl gnupg software-properties-common

AWS_CLI_V2_ZIP="awscliv2.zip"

ARCH=$(uname -m)
if [ "$ARCH" == "aarch64" ] || [ "$ARCH" == "arm64" ]; then
    curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
elif [ "$ARCH" == "x86_64" ] || [ "$ARCH" == "amd64" ]; then
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
else
    echo "Error: Unsupported or unknown architecture '$ARCH' for AWS CLI."
    exit 1
fi

unzip awscliv2.zip
./aws/install

# Clean up
rm awscliv2.zip
rm -rf aws

echo " ------------- AWS CLI ------------ "
aws --version
echo " ---------------------------------- "

curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list

apt-get update -y
apt-get install terraform -y

echo " ------- Terraform ------- "
terraform version

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "ERROR: Missing Access Key ID (\$1) or Secret Access Key (\$2)."
    echo "Usage: sudo ./install_tools.sh <AWS_AKID> <AWS_SAK>"
    exit 1
fi

aws configure set aws_access_key_id "$1"
aws configure set aws_secret_access_key "$2"
aws configure set default.region "us-east-1"

echo " ---------------------------------- "
aws sts get-caller-identity