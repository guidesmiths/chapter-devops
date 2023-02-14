# POC FISSION + KAFKA

## Installation overview
1. Set up local kubernetes cluster (the one provided by Docker Desktop is enough)
2. Ensure you have installed kubectl & helm
3. Install fission on cluster (follow guide from [website](https://fission.io/docs/installation/))
5. Install kafka and mongodb on the cluster
4. Install fission client on your device
5. Install our functions into cluster with fission cli

### Install kafka on kubernetes
1. (optional, only first time) Get kafka helm charts
`helm repo add bitnami https://charts.bitnami.com/bitnami`
2. Install kafka helm chart
`helm install --namespace $FISSION_NAMESPACE fission-kafka bitnami/kafka`

### Set up fission
1. Create namespace
`export FISSION_NAMESPACE=fission`
`kubectl create namespace $FISSION_NAMESPACE`
2. Install fission stuff into cluster
`kubectl create -k "github.com/fission/fission/crds/v1?ref=v1.17.0"`
3. (optional, only first time) Get fission helm charts
`helm repo add fission-charts https://fission.github.io/fission-charts/`
`helm repo update`
4. Install fission helm chart
`helm install --version v1.17.0 --namespace $FISSION_NAMESPACE fission fission-charts/fission-all --set kafka.enabled=true --set kafka.brokers=fission-kafka-0.fission-kafka-headless.fission.svc.cluster.local:9092`

### Install mongo on kubernetes
1. (optional, only first time) Get mongodb helm charts
`helm repo add bitnami https://charts.bitnami.com/bitnami`
2. Install kafka helm chart
`helm install --namespace $FISSION_NAMESPACE fission-mongodb bitnami/mongodb`

### Install fission functions
1. (optional, only first time) Install fission cli
`curl -Lo fission https://github.com/fission/fission/releases/download/v1.17.0/fission-v1.17.0-darwin-amd64 \
&& chmod +x fission && sudo mv fission /usr/local/bin/`
2. Create the fission environment to run functions
`fission environment create --name nodejs --image fission/node-env --builder fission/node-builder`
3. Package all code
`zip -r -X fission-functions.zip ./src/* -x ./src/node_modules/\*`
`fission package create --src fission-functions.zip --env nodejs --name fission-functions-pkg`
4. Install http-producer function
`fission function create --name http-producer --pkg fission-functions-pkg --env nodejs --entrypoint "src/http-producer"`
`fission route create --function http-producer --url /http-producer --name http-producer`
5. Install kafka-consumer function
`fission function create --name kafka-consumer --pkg fission-functions-pkg --env nodejs --entrypoint "src/kafka-consumer"`
`fission mqt create --name kafka-consumer --function kafka-consumer --mqtype kafka --mqtkind fission --topic test-topic`
6. Install http-query function
`fission function create --name http-query --pkg fission-functions-pkg --env nodejs --entrypoint "src/http-query"`
`fission route create --function http-query --url /http-query --name http-query`