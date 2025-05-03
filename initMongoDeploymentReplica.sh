#!/bin/bash

if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <env> <namespace> <podname>"
  echo "Example: $0 dev app mongo-dev-mongo-deploy-54cdc57d65-j8m9t"
  exit 1
fi

ENV=$1
NAMESPACE=$2
POD_NAME=$3
STATEFULSET_NAME="mongo-${ENV}"
REPLICA_SET_NAME="rs0"

MEMBERS="[
  { _id: 0, host: \"localhost:27017\" },
  { _id: 1, host: \"localhost:27018\" },
  { _id: 2, host: \"localhost:27019\" },
]"


echo "🔁 Initiating MongoDB replica set for env=$ENV in namespace=$NAMESPACE..."

kubectl exec -it ${POD_NAME} -n ${NAMESPACE} -- mongosh --eval "
try {
  rs.status();
  print('Replica set already exists');
} catch (e) {
  print('Initiating replica set...');
  rs.initiate({
    _id: \"$REPLICA_SET_NAME\",
    members: $MEMBERS
  });
}
"

echo ""
# echo "👉 Open a **new terminal** and run the following command to forward mongo-dev-0:"
# echo "kubectl port-forward -n ${NAMESPACE} svc/${STATEFULSET_NAME} 27018:27017"

echo ""
echo "🔗 Then connect with this Compass URI:"
echo "mongodb://localhost:27017,localhost:27018,localhost:27019/?directConnection=true"
