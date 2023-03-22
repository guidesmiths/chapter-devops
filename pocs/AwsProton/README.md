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

```bash
aws cloudformation create-stack --stack-name "shared-vpc-test" --region "eu-west-2" --template-body "file://pocs/AwsProton/environment-templates/shared-vpc-env/v1/infrastructure/cloudformation.yaml"
```

## Environment template

Before performing any new step just make sure that your default region makes sense for you. If that's not the case make sure to <a href="https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html#cli-configure-quickstart-region">change your account profile default region</a>.

```bash
aws configure get region
```

A new **Proton** _environment template_ needs to be created and updated on the next steps.

```bash
aws proton create-environment-template --name "shared-vpc-env"
```

For being able to update the _environment template_ for linking some definitions a new repository needs to be configured.
After the following step the template would be available for creating the **Cloudformation** _stack_.
First of all we would need to list our repositories connections already configured from **Codestar** service.

```bash
aws codestar-connections list-connections --provider-type "GitHub"
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

```bash
aws proton create-repository \
    --name bounteous17/chapter-devops \
    --connection-arn "arn:aws:codestar-connections:eu-west-1:487354732760:connection/69013ae6-a462-4617-ac68-e1c41a9b5937" \
    --provider "GITHUB" \
    --encryption-key "arn:aws:kms:region-id:123456789012:key/bPxRfiCYEXAMPLEKEY"
```

Now that the repository has been created on **Proton** we are able sync _major_ and _minor_ \*template versions for the choosen _environment template_ on every new _commit_ that affects the `infrstructure/` folder generating changes.

```bash
aws proton create-template-sync-config --branch "chore/aws-proton-poc" --repository-name "bounteous17/chapter-devops" --repository-provider "GITHUB" --subdirectory "pocs/AwsProton/environment-templates/shared-vpc-env" --template-name "shared-vpc-env" --template-type "ENVIRONMENT"
```

Sometimes the *commits trigger* is being executed inmediately and we should run that manually:
```bash
aws proton update-template-sync-config --branch "chore/aws-proton-poc" --repository-name "bounteous17/chapter-devops" --repository-provider "GITHUB" --subdirectory "pocs/AwsProton/environment-templates/shared-vpc-env" --template-name "shared-vpc-env" --template-type "ENVIRONMENT"
```

The next steps that I have made to the _environment template_ has been adding _tags_ to the resources for making them easier to get filtered from the console dashboard. As mentioned before modifying any file from `infrastructure/` folder would create a new `minor` version.

From the previous _commit_ described before a _minor_ version `1.2` has been created as a `Draft` for being able to **test** it and _publish_ them in case the updated **Cloudformation** _stack_ looks fine.

![image](https://user-images.githubusercontent.com/16175933/224987370-ace7b2ab-d8f3-4040-b1fb-fe7c561fb97c.png)

Let's configure our new _environment_ for testing the `Draft` template version `1.2`.

```bash
aws iam list-roles
```

Without an _environment_ we would not be able to _deploy_ the _template_ on any place. That's why we decided to create the `development` environment for
testing purposes.

```bash
aws proton create-environment \
    --name "development" \
    --template-name "shared-vpc-env" \
    --proton-service-role-arn "arn:aws:iam::487354732760:role/service-role/aws-proton-poc" \
    --template-major-version "1" \
    --template-minor-version "2" \
    --spec "file://pocs/AwsProton/environment-templates/shared-vpc-env/spec/spec.yaml"
```

```json
{
  "environment": {
    "arn": "arn:aws:proton:eu-west-1:487354732760:environment/development",
    "createdAt": "2023-03-14T12:25:06.824000+01:00",
    "deploymentStatus": "IN_PROGRESS",
    "lastDeploymentAttemptedAt": "2023-03-14T12:25:06.824000+01:00",
    "name": "development",
    "protonServiceRoleArn": "arn:aws:iam::487354732760:role/service-role/aws-proton-poc",
    "templateName": "shared-vpc-env"
  }
}
```

Once the `deploymentStatus` becomes `SUCCEEDED` for the _template version_ associated to the _environment_ that means we can publish it after testing the new **Cloudformation** _stack_.

It's also possible to list the _environment template_ versions by using the following command:

```bash
aws proton list-environment-template-versions --template-name "shared-vpc-env"
```

```json
{
  "templateVersions": [
    {
      "arn": "arn:aws:proton:eu-west-1:487354732760:environment-template/shared-vpc-env:1.0",
      "createdAt": "2023-03-13T17:19:09.939000+01:00",
      "description": "[985aeb4] fix: tags definition",
      "lastModifiedAt": "2023-03-13T17:19:11.843000+01:00",
      "majorVersion": "1",
      "minorVersion": "0",
      "recommendedMinorVersion": "1",
      "status": "DRAFT",
      "statusMessage": "",
      "templateName": "shared-vpc-env"
    },
    {
      "arn": "arn:aws:proton:eu-west-1:487354732760:environment-template/shared-vpc-env:1.1",
      "createdAt": "2023-03-14T10:16:13.044000+01:00",
      "description": "[761b382] fix: tags keys",
      "lastModifiedAt": "2023-03-14T11:51:33.907000+01:00",
      "majorVersion": "1",
      "minorVersion": "1",
      "recommendedMinorVersion": "1",
      "status": "PUBLISHED",
      "statusMessage": "",
      "templateName": "shared-vpc-env"
    },
    {
      "arn": "arn:aws:proton:eu-west-1:487354732760:environment-template/shared-vpc-env:1.2",
      "createdAt": "2023-03-14T12:24:11.029000+01:00",
      "description": "[db9dda7] fix: aws prefix not allowed on tags",
      "lastModifiedAt": "2023-03-14T12:24:12.714000+01:00",
      "majorVersion": "1",
      "minorVersion": "2",
      "recommendedMinorVersion": "1",
      "status": "DRAFT",
      "statusMessage": "",
      "templateName": "shared-vpc-env"
    }
  ]
}
```

Let's now choose the latest version for _publishing_ them an making it available for the developers by using any compatible _service template_.

```bash
aws proton update-environment-template-version \
    --template-name "shared-vpc-env" \
    --major-version "1" \
    --minor-version "2" \
    --status "PUBLISHED"
```

```json
{
  "environmentTemplateVersion": {
    "arn": "arn:aws:proton:eu-west-1:487354732760:environment-template/shared-vpc-env:1.2",
    "createdAt": "2023-03-14T12:24:11.029000+01:00",
    "description": "[db9dda7] fix: aws prefix not allowed on tags",
    "lastModifiedAt": "2023-03-14T12:32:32.913000+01:00",
    "majorVersion": "1",
    "minorVersion": "2",
    "recommendedMinorVersion": "2",
    "schema": "schema:\n  format:\n    openapi: \"3.0.0\"\n  environment_input_type: \"VPCEnvironmentInput\"\n  types:\n    VPCEnvironmentInput:\n      type: object\n      description: \"Input properties for my environment\"\n      properties:\n        vpc_cidr:\n          type: string\n          description: \"The CIDR range for your VPC\"\n          default: 10.0.0.0/16\n          pattern: ([0-9]{1,3}\\.){3}[0-9]{1,3}($|/(16|18|24))\n        public_subnet_one_cidr:\n          type: string\n          description: \"The CIDR range for public subnet one\"\n          default: 10.0.0.0/18\n          pattern: ([0-9]{1,3}\\.){3}[0-9]{1,3}($|/(16|18|24))\n        private_subnet_one_cidr:\n          type: string\n          description: \"The CIDR range for private subnet one\"\n          default: 10.0.128.0/18\n          pattern: ([0-9]{1,3}\\.){3}[0-9]{1,3}($|/(16|18|24))",
    "status": "PUBLISHED",
    "statusMessage": "",
    "templateName": "shared-vpc-env"
  }
}
```

Congratulations you deployed your first _environment_ **Cloudformation** _stack_ associated to an _environment template_ exact _version_.

![image](https://user-images.githubusercontent.com/16175933/224989099-ed22ff28-36b3-49a1-9be5-e279a21a08a8.png)

For updating the __environment template__ _minor version_ being used we should run:

```bash
aws proton update-environment \
    --name "development" \
    --proton-service-role-arn "arn:aws:iam::487354732760:role/service-role/aws-proton-poc" \
    --template-major-version "1" \
    --template-minor-version "4" \
    --spec "file://pocs/AwsProton/environment-templates/shared-vpc-env/spec/spec.yaml" \
    --deployment-type "MINOR_VERSION"
```

## Service template

Next steps would be to create a compatible **_service template_** without any _version_ associated yet. For simplifying this POC we would **avoid configuring** any **_pipeline_** since it's too complex to use the AWS solution for our purpose on it.

```bash
aws proton create-service-template --name "apprunner-svc" --pipeline-provisioning "CUSTOMER_MANAGED"
```

Creating a simple **_sync config_** would be needed but not for creating _service template_ versions. Instead the objective this time is to **connect** the repository to automatically execute the **optional _pipeline_** in case of new commits. That process is the one responsible to **create service releases**. 

In other words the difference between synchronizing a repo for the **_environment templates_** is that since these **do not contain _pipelines_** we will **create template versions** on every commit added latter. But in the case of the **_service templates_** we are going to **create releases of a service** that depends on the _pipeline_ linked to this template.

In a moment we would see how to create **_service template_** versions manually since there is no _pipeline_ associated.

```bash
aws proton create-template-sync-config \
    --template-name "home" \
    --template-type "SERVICE" \
    --repository-provider "GITHUB" \
    --repository-name "bounteous17/chapter-devops" \
    --branch "chore/aws-proton-poc" \
    --subdirectory "pocs/AwsProton/service-templates/apprunner-svc"
```

The only way to create _template versions_ is to upload them to an `s3` bucket. First step would be to compress the template _major versions_ folder and upload the `tar.gz` file.

```bash
tar czvf /tmp/apprunner-service-template.tar.gz --directory pocs/AwsProton/service-templates/apprunner-svc .
```

List your `s3` buckets and choose one of them for uploading the compressed file.

```bash
aws s3 ls
```

After choosing the bucket uploading files is really simple.

```bash
aws s3 cp /tmp/apprunner-service-template.tar.gz s3://proton-poc-39b4f9ea-ec15-4f1d-b304-275d4bb3728f
```

Let's create out first template _major_ and _minor_ template versions linked to the bucket storage.

```bash
aws proton create-service-template-version --compatible-environment-templates '[{"majorVersion":"1","templateName":"shared-vpc-env"}]' --source '{"s3": {"bucket":"proton-poc-39b4f9ea-ec15-4f1d-b304-275d4bb3728f","key":"apprunner-service-template.tar.gz"}}' --template-name apprunner-svc
```

- [Optional] Deleting the created template:
```bash
aws proton delete-service-template-version --major-version "1" --minor-version "0" --template-name "apprunner-svc"
```

```json
{
  "serviceTemplateVersion": {
    "arn": "arn:aws:proton:eu-west-1:487354732760:service-template/home:1.0",
    "compatibleEnvironmentTemplates": [
      {
        "majorVersion": "1",
        "templateName": "shared-vpc-env"
      }
    ],
    "createdAt": "2023-03-16T09:56:21.032000+01:00",
    "lastModifiedAt": "2023-03-16T09:56:21.032000+01:00",
    "majorVersion": "1",
    "minorVersion": "0",
    "status": "REGISTRATION_IN_PROGRESS",
    "templateName": "home"
  }
}
```

On our case the tenplate would contain all the steps for easily create an `App Runner` instance by indicating some basic input param:
- docker image **public ECR** url
- http **port** for incomming traffic
- instance size (`medium` or `large`)

For creating an instance of the service:
```bash
aws proton create-service --name "hello-world-svc" --spec file://spec/spec.yaml --template-major-version "1" --template-minor-version "0" --template-name "apprunner-svc"
```

- [Optional] Deleting the created service:
```bash
aws proton delete-service --name "hello-world-svc"
```

It's time to update the **_Proton service_** with the **input params** for the resource `App Runner` to be instantiated.

![image](https://user-images.githubusercontent.com/16175933/226874215-021b243e-6bab-4a7f-be8a-3716ad6d199f.png)

Our `App Runner` instance would have been provisioned with some public domain to access it.

![image](https://user-images.githubusercontent.com/16175933/226875225-2477c525-63e1-4f7c-ab37-5046c18dd938.png)

![image](https://user-images.githubusercontent.com/16175933/226876213-72f070c1-d050-46c9-942b-acfa97a57c91.png)

Having verified that our _service template_ resources has been **successfully deployed** we can **publish the version** so that other developers can make use of an stable version by default. That means that the template would no longer appear as a `Draft` then the current status would be `Recommended` **after publishing it**.

```bash
aws proton update-service-template-version --template-name "apprunner-svc" --major-version "1" --minor-version "0" --status "PUBLISHED"
```