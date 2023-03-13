# aws-proton-poc

# Deploying POC

## Cloudformation validation

Before deploying any Proton templates we would need to validate that the infrastructure syntax to be deployed is valid.
That makes things easy to debug before adding a new template version on Proton.

It's important to notice that we are choosing a different region for deploying and validating the stacks.

Environment template cloudformation definition being deployed:
```
aws cloudformation create-stack --stack-name shared-vpc-test --region eu-west-2 --template-body file://pocs/AwsProton/environment-templates/shared-vpc-env/v1/infrastructure/cloudformation.yaml
```

## Environment template

A new environment template needs to be created and updated on the next steps.
```
aws proton create-environment-template --name shared-vpc-env
```
For being able to update the environment template for linking some definitions a new repository needs to be linked.
```
aws proton create-repository --connection-arn "arn:aws:codestar-connections:eu-west-1:487354732760:connection/a42a60bc-48e8-4246-96ac-78ab55541f30" --name "bounteous17/chapter-devops" --provider "GITHUB"
```
After the following step the template would be available for creating the cloudformation stack.
```
aws proton create-template-sync-config --branch "chore/aws-proton-poc" --repository-name "bounteous17/chapter-devops" --repository-provider "GITHUB" --subdirectory "pocs/AwsProton/environment-templates" --template-name "shared-vpc-env" --template-type "ENVIRONMENT"
```