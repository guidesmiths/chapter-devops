# POC - Chaos Engineering - Chaos Toolkit (TBD)

## Introduction

This is a POC from DevOps chapter about [Chaos Engineering](https://principlesofchaos.org/). It consist on:
- A kubernetes cluster where we will run our platform
- An API built with docker and deployed on several pods in our kubernetes cluster
- A k6 setup to run load tests against our platform
- A monitoring setup to monitor the platform during the experiment
- A chaos toolkit experiment

Here's an schema about the setup:
![schema](/docs/schema.png)


## Components

### services - chaos-backend
It's a simple node express service with a mocked delay on the requests and a limited middleware in order to throttle requests

### kubernetes - chaos-backend
It's the helm template to deploy the `chaos-backend` service into the cluster

### k6
It's a pre-defined setup of k6 over docker to run load tests again the cluster

## Manual

### How to update chaos-backend service?
This service docker image is hosted in a public docker repository. Apply the changes you consider in `services/chaos-backend` folder and then run:
- Build a new version of the image: `docker build -t fmac85/chaos-backend .`
- Push the image to the public repository: `docker push fmac85/chaos-backend:latest`

### How to run a kubernetes cluster
Regarding simplicity of the POC, it's recommended to use Docker Desktop to setup a [local kubernetes cluster](https://docs.docker.com/desktop/kubernetes/)
Enable `--extra-config=kubelet.housekeeping-interval=10s` and `metrics-server`to `true` in your minikube config file to enable the HPA test.

### how to deploy my docker image on kubernetes?
Go to `kubernetes` folder and:
- Install the helm template in our kubernetes cluster: `helm install chaos-backend chaos-backend -n <your_namespace>`.
This will output a message with the way to access to the service.
- When finished, uninstall the helm template from kubernetes: `helm uninstall chaos-backend`

** enable `metrics-server` on your minikube config file to export metrics from chaos-backend

## How to run load tests
1. Port forward the service `chaos-backend` using `kubectl port-forward -n chaos-backend services/chaos-backend <my_port>:80`
2. Use `ngrok` (unless you have a public IP) to set external access `ngrok htt <my_port>`
3. With the public address/ngrok URL, just replace it in the file k6/scripts/test.js
3. Browse to k6 folder and run `docker compose run k6 run /k6/scripts/test.js`

## Install Chaos-Mesh using Helm

See oficial documentation here: https://chaos-mesh.org/docs/production-installation-using-helm/

1. Add helm repository using `helm repo add chaos-mesh https://charts.chaos-mesh.org`
2. Update your helm repository `helm repo update`
3. Search the version you prefer `helm search repo chaos-mesh`
4. Create the namespace `kubectl create ns chaos-mesh`
5. Install chaos-mesh `helm upgrade --install chaos-mesh chaos-mesh/chaos-mesh -n=chaos-mesh --version <your_version>`

Chaos-mesh github repo: https://github.com/chaos-mesh/chaos-mesh.git

## Installing Kube Ops View
1. Go to the folder `kube-ops-view` and deploy all the `.yaml` in the folder on the desired namespace. 
2. Port-forward the pod kube-opps-view-ran_number so you can monitor the status when you are using the chaos agent.