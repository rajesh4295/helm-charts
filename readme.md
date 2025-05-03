##### This repository has helm chart to deploy PostgresDB and MongoDB in kubernetes cluster

# Postgres DB
**Install helm release**

1. `./deployPostgres.sh <env> <namespace>`

**Connection**
1. Connect with PGAdmin
    1. Port forward the postgres pod
    `kubectl port-forward -n app pod/postgress 5432:5432`
    2. Open PGAdmin and connect
    ```
    host: localhost
    port: 5432
    user: admin
    password: adminpassword
    ```



**Uninstall helm release**

1. `helm uninstall postgres-<env> -n <namespace>`

# Mongo DB with ReplicaSet
**Install helm release**

1. `./deployMongo.sh <env> <namespace>`

**Initialize replicas and Connection**

1. `./initMongoReplica.sh <env> <namespace>`
2. Connect with MongoCompass
    1. Find primary DB 
    `kubectl exec -it mongo-dev-0 -n app -- mongosh --eval "rs.isMaster()"`
    2. Port forward the mongo service
    `kubectl port-forward -n app svc/mongo-dev 27018:27017`
    3. **[Without Credential]** Open MongoDB Compass and connect with
    `mongodb://localhost:27018?directConnection=true`
    4. To Initialize DB and Admin User which is part of values.yaml
    `./initMongoDB.sh mongo-dev-0 app`
    5. **[With Credential]** Open MongoDB Compass and connect with
    `mongodb://admin:adminpassword@localhost:27018/?directConnection=true&authSource=dev`

**Uninstall helm release**

1. `helm uninstall mongo-<env> -n <namespace>`

# Mongo DB with Deployment
**Install helm release**

1. `./deployMongoDeployment.sh <env> <namespace>`

1. `./initMongoDeploymentReplica.sh <env> <namespace> <podname>`
2. Connect with MongoCompass
    3. **[Without Credential]** Open MongoDB Compass and connect with
    `mongodb://localhost:27017,localhost:27018,localhost:27019`

**Uninstall helm release**

1. `helm uninstall mongo-<env> -n <namespace>`

#### Helper cmds

1. Find process on port
`netstat -aon | findstr :5432`
2. Kill process PID
`taskkill /PID 7128 /F`
3. Run busybox
`kubectl run debug-pod -n app --rm -it --image=busybox --restart=Never -- sh`

