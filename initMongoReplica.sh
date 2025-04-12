#!/bin/bash

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <env> <namespace>"
  echo "Example: $0 dev app"
  exit 1
fi

ENV=$1
NAMESPACE=$2
STATEFULSET_NAME="mongo-${ENV}"
REPLICA_SET_NAME="rs0"

MEMBERS="[
  { _id: 0, host: \"${STATEFULSET_NAME}-0.${STATEFULSET_NAME}.${NAMESPACE}.svc.cluster.local:27017\" },
  { _id: 1, host: \"${STATEFULSET_NAME}-1.${STATEFULSET_NAME}.${NAMESPACE}.svc.cluster.local:27017\" }
]"


echo "🔁 Initiating MongoDB replica set for env=$ENV in namespace=$NAMESPACE..."

kubectl exec -it ${STATEFULSET_NAME}-0 -n ${NAMESPACE} -- mongosh --eval "
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
echo "👉 Open a **new terminal** and run the following command to forward mongo-dev-0:"
echo "kubectl port-forward -n ${NAMESPACE} svc/${STATEFULSET_NAME} 27018:27017"

echo ""
echo "🔗 Then connect with this Compass URI:"
echo "mongodb://localhost:27018/?directConnection=true"
