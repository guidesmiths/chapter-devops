# aws-proton-poc

# Deploying POC

## Cloudformation validation

At the beginning of this POC Before adding more complexity this templates was compatible with **Cloudformation**. 
That templates stopped being compatible with it at the moment in which we added `environment` variables that can only me accessed by **Proton**.
So this section only applies to the templates that does not contains yet any parametrization.

Before deploying any Proton templates we would need to validate that the infrastructure syntax to be deployed is valid.
That makes things easy to debug before adding a new template version on Proton.

It's important to notice that we are choosing a different region for deploying and validating the stacks.

Environment template **Cloudformation** definition being deployed:
```
aws cloudformation create-stack --stack-name shared-vpc-test --region eu-west-2 --template-body file://pocs/AwsProton/environment-templates/shared-vpc-env/v1/infrastructure/cloudformation.yaml
```

## Environment template

Before performing any new step just make sure that your default region makes sense for you. If that's not the case make sure to <a href="https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html#cli-configure-quickstart-region">change your account profile default region</a>.
```
aws configure get region
```

A new **Proton** _environment template_ needs to be created and updated on the next steps.
```
aws proton create-environment-template --name shared-vpc-env
```

For being able to update the _environment template_ for linking some definitions a new repository needs to be configured.
After the following step the template would be available for creating the **Cloudformation** _stack_.
First of all we would need to list our repositories connections already configured from **Codestar** service.
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
Since I'm only able to link my personal account because of access restrictions on the organization one make sure to have the **right permissions**.
Choose a repository from the list with the `ConnectionStatus` marked as `AVAILABLE` and sync it by running:
```
aws proton create-repository \
    --name bounteous17/chapter-devops \
    --connection-arn "arn:aws:codestar-connections:eu-west-1:487354732760:connection/69013ae6-a462-4617-ac68-e1c41a9b5937" \
    --provider "GITHUB" \
    --encryption-key "arn:aws:kms:region-id:123456789012:key/bPxRfiCYEXAMPLEKEY"
```
Now that the repository has been created on **Proton** we are able sync _major_ and _minor_ *template versions for the choosen _environment template_ on every new _commit_ that affects the `infrstructure/` folder generating changes.
```
aws proton create-template-sync-config --branch "chore/aws-proton-poc" --repository-name "bounteous17/chapter-devops" --repository-provider "GITHUB" --subdirectory "pocs/AwsProton/environment-templates/shared-vpc-env" --template-name "shared-vpc-env" --template-type "ENVIRONMENT"
```
The next steps that I have made to the _environment template_ has been adding _tags_ to the resources for making them easier to get filtered from the console dashboard. As mentioned before modifying any file from `infrastructure/` folder would create a new `minor` version.

From the previous _commit_ described before a _minor_ version `1.1` has been created as a `Draft` for being able to **test** it and _publish_ them in case the updated **Cloudformation** _stack_ looks fine.

![Screenshot_20230314_111038-1](https://user-images.githubusercontent.com/16175933/224968455-222e1035-f21f-429b-8419-d4a83c592339.png)
