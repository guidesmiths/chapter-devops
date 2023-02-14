# Goals
## terraform
* Setup a kubernetes cluster using minikube
* Setup terraform and store state file using `local` backend, state should be stored at `state/terraform.tfstate`
* Create namespaces using terraform
    * blog
    * secured
    * traefik

## terraform + rbac
* Create service accounts for `blog` and `secured` namespace using terraform
* Assign RBAC roles using terraform
    * `blog` namespace can be accessed/managed by `secured` namespace scope
    * `secured` can only be accessed by its own scope

## deployments
* Deploy a ghost blog using helm at `blog` namespace
* Deploy this repository **pending** with the name `challenge_deployment` at `secured` namespace
* Setup a mongodb server at `secured` namespace

## kubernetes administration
* Setup traefik as load balancer
    * Route blog using rules accessible from outside
    * Add basic authentication middleware to `challenge_deployment`
        * user: `codechallenge`
        * pass: `P455w0rd!`

# Bonus points
* Expose minikube and point a domain to it (you can use any kind of free domain, like .tk )
    * Secure all the endpoints using `cert-manager` with `letsencrypt`
* Deploy `prometheus` + `grafana` and read metrics sended by `challenge_deployment` service
* Get a low score using `kubescape`, we need to define what range we want to check