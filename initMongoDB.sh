#!/bin/bash

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <pod-name> <namespace>"
  echo "Example: $0 mongo-dev-0 app"
  exit 1
fi

POD_NAME=$1
NAMESPACE=$2

echo "🔐 Creating user from env vars inside pod '$POD_NAME' in namespace '$NAMESPACE'..."

kubectl exec -n "$NAMESPACE" "$POD_NAME" -- bash -c '
  echo "👉 Using DB: $MONGO_DB"
  echo "👉 Creating user: $MONGO_USER"

 mongosh <<EOF
use $MONGO_DB

try {
  db.createUser({
    user: "$MONGO_USER",
    pwd: "$MONGO_PASSWORD",
    roles: [{ role: "readWrite", db: "$MONGO_DB" }]
  });
} catch (e) {
  if (e.codeName === "DuplicateKey") {
    print("User already exists, skipping creation.");
  } else {
    throw e;
  }
}

// Now insert a dummy doc to persist the DB
db.getCollection("__init").updateOne(
  { initialized: true },
  { \$set: { initialized: true, timestamp: new Date() } },
  { upsert: true }
);
EOF
'

echo "✅ Mongo user created inside pod $POD_NAME for database $MONGO_DB"
