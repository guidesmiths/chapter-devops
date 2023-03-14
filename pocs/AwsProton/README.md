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
aws proton create-repository --connection-arn "arn:aws:codestar-connections:eu-west-1:487354732760:connection/69013ae6-a462-4617-ac68-e1c41a9b5937" --name "bounteous17/chapter-devops" --provider "GITHUB"
```
After the following step the template would be available for creating the cloudformation stack.
First of all we would need to list our already configured configured by Codestar service.
```
aws codestar-connections list-connections --provider-type GitHub
```
Anonymized output:
```json
{
    "Connections": [
        {
            "ConnectionName": "bounteous17",
            "ConnectionArn": "arn:aws:codestar-connections:eu-west-1:487354732760:connection/69013ae6-a462-4617-ac68-e1c41a9b5937",
            "ProviderType": "GitHub",
            "OwnerAccountId": "487354732760",
            "ConnectionStatus": "AVAILABLE"
        },
        {
            "ConnectionName": "guidesmiths",
            "ConnectionArn": "arn:aws:codestar-connections:eu-west-1:487354732760:connection/bbdaa14b-2ad1-4ecf-b41f-775b435b07cf",
            "ProviderType": "GitHub",
            "OwnerAccountId": "487354732760",
            "ConnectionStatus": "PENDING"
        }
    ]
}
```
Since I'm only able to link my personal account because of access restrictions on the organization one make sure to have the right permissions.
Choose a repository from the list with the `ConnectionStatus` marked as `AVAILABLE`.
```
aws proton create-repository \
    --name bounteous17/chapter-devops \
    --connection-arn "arn:aws:codestar-connections:eu-west-1:487354732760:connection/69013ae6-a462-4617-ac68-e1c41a9b5937" \
    --provider "GITHUB" \
    --encryption-key "arn:aws:kms:region-id:123456789012:key/bPxRfiCYEXAMPLEKEY"
```
Now that the repository has been created on Proton we are able sync major and minor versions for the choosen environment template on every new commit that affects the `infrstructure/` folder generating changes.
```
aws proton create-template-sync-config --branch "chore/aws-proton-poc" --repository-name "bounteous17/chapter-devops" --repository-provider "GITHUB" --subdirectory "pocs/AwsProton/environment-templates/shared-vpc-env" --template-name "shared-vpc-env" --template-type "ENVIRONMENT"
```