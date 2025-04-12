# helm repo add bitnami https://charts.bitnami.com/bitnami
# helm repo update

# helm upgrade --install mongo bitnami/mongodb \
#   --set architecture=replicaset \
#   --set replicaCount=2 \
#   --set auth.enabled=true \
#   --set auth.rootUser=admin \
#   --set auth.rootPassword=adminpassword \
#   --set auth.replicaSetKey=replicaSetKey123 \
#   -n app --create-namespace

#!/bin/bash

# Exit on error
set -e

# Check if environment argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <environment>"
  echo "Example: $0 dev"
  exit 1
fi

if [ -z "$2" ]; then
  echo "Usage: $0 $1 <namespace>"
  echo "Example: $0 $1 app"
  exit 1
fi

# Set environment variable
ENV=$1
NAMESPACE=$2

# Define values file based on environment
VALUES_FILE="./mongo/values.${ENV}.yaml"

# Check if the values file exists
if [ ! -f "$VALUES_FILE" ]; then
  echo "Error: $VALUES_FILE not found!"
  exit 1
fi

# Define release name
RELEASE_NAME="mongo-$ENV"

# Deploy the Helm chart
helm upgrade --install $RELEASE_NAME -f $VALUES_FILE ./mongo -n $NAMESPACE --create-namespace

# Undeploy release
# helm uninstall mongo-dev -n app

echo "✅ Helm chart deployed successfully for environment: $ENV"
