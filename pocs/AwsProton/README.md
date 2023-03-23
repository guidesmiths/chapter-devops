# aws-proton-poc

# Conclusions

## What is `Proton`?

`Proton` is an `AWS` service for allowing `infrastructure teams only` to create **_environment templates_**. That ones contains platform resources to be created on some choosen **_environment_** that has been created previously.

Besides the `developers teams` would be able to create **_service templates_** that needs to be **compatible** with one or multiple **_environment templates_** infrastructure resources already deployed. That compatibility is going to be always indicated through the file `.compatible-envs` available on the template root folder.

On this POC the **_environment template_** called `shared-vpc-env` would deploy a __*public*__ and __*private*__ `VPC` _subnets_ with an `App Runner VPC connector`.

On the other hand the **_service template_** called `apprunner-svc` is going to deploy an `App Runner` instance that has **access to both subnets** since it's using an already created connector explained above. That means in case there are some resources deployed on the _private subnet_ the `App Runner` instance would be able to access them. The type of resources that would be deployed on a _private_ subnet are those that does not make sense to be publicly accessible, for example: databases, queuing systems, etc...

Both _**environment**_ and _**service**_ templates types needs to be deployed on some `Proton` _environment_. The created _environments_ can also be **linked outside** the current AWS `Proton` account currently being used.

## Who is `Proton` intended for?

Probably the **most appropriate** use of this service is in large, **already consolidated teams** that seek to improve their deployment procedures.
This is so because it would prevent them from having blocks when deploying new resources in AWS. Since there is an **infrastructure** team that has already published templates on demand so that the **developer does not have to worry about asking the infrastructure team for a new deployment**. This is possible thanks to the fact that the Proton service uses an admin `IAM` _role_ capable of performing all actions on the resources. In this way it is not necessary to assign extra permissions in the infrastructure to the developers.

As you are probably thinking this is **not designed for small teams** that does not worry about splitting roles between infrastructure and development. The most smart solutions for that use cases would be to keep using `CDK` or `Terraform`. That's because this allows all developers to create resources in the infrastructure without any type of limitation, which Proton does not allow.

## What's the relation between `Proton` and `Cloudformation`?

The `Proton` templates can only be written using `AWS Cloudformation` syntax, so this will make things a bit **less agile**, especially if you don't have previous experience with it. A good starting point to **begin with Proton** would be to **write our templates without parameterization** so that they can be deployed in `Cloudformation` and verify that a functional `stack` is generated.

This POC includes the folder `./cloudformation` containing the _templates_ before being parameterized for making them compatible with `Proton`.
```bash
aws cloudformation create-stack --stack-name "hello-world" --region "eu-west-1" --template-body "file://cloudformation/shared-vpc/service-template-cloudformation.yaml" --capabilities "CAPABILITY_IAM"
```
The command seen above would create an `stack` on `Cloudformation` that includes an `App runner` resource instance.

When I got this to work I began to investigate how to parameterize with `jinja` the values of the template to make them compatible with `Proton`.
Both template types includes the file `manifest.yaml` for allowing `Cloudformation` templates to **receive some input** params through `schema/schema.yaml` config file.

## How to speed up the start-up process with `Proton`?

After having written the `Cloudformation` template to **deploy an image** from a **public ECR** in the `App Runner` I was getting permission errors when pulling the image. So I decided to use <a href="https://former2.com/">Former2</a> to generate a `Cloudformation` template from an `App Runner` instance that I manually created from the `AWS dashboard` and it was working fine. In this way I obtained a template for `Cloudformation` ready to be parameterized by using `jinja`.

# Deploying this POC

## Project structure
```bash
.
├── cloudformation # environment and service template with static parameter values
│   └── shared-vpc # cloudformation definitions
│       ├── environment-template-cloudformation.yaml
│       └── service-template-cloudformation.yaml
├── environment-templates # infrastructure team available templates
│   └── shared-vpc-env
│       ├── README.md
│       ├── spec
│       │   └── spec.yaml
│       └── v1
│           ├── infrastructure # cloudformation definitions with jinja
│           │   ├── cloudformation.yaml
│           │   └── manifest.yaml
│           └── schema
│               └── schema.yaml # input parameters with default VPC values
├── LICENSE
├── README.md
└── service-templates # developers team created templates
    └── apprunner-svc
        ├── README.md
        ├── spec
        │   └── spec.yaml
        └── v1
            ├── .compatible-envs # list of compatible environment templates
            ├── instance_infrastructure # cloudformation definitions with jinja
            │   ├── cloudformation.yaml
            │   └── manifest.yaml
            └── schema
                └── schema.yaml # input parameters with default App Runner values
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
First of all we need to list our repositories connections already configured from **Codestar** service.

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

Now that the repository has been created on **Proton** we are able sync _major_ and _minor_ _template_ versions for the choosen _environment template_ on every new _commit_ that affects the `infrstructure/` folder generating changes.

```bash
aws proton create-template-sync-config --branch "chore/aws-proton-poc" --repository-name "bounteous17/chapter-devops" --repository-provider "GITHUB" --subdirectory "environment-templates/shared-vpc-env" --template-name "shared-vpc-env" --template-type "ENVIRONMENT"
```

Sometimes the *commits trigger* is being executed inmediately and we should run that manually:
```bash
aws proton update-template-sync-config --branch "chore/aws-proton-poc" --repository-name "bounteous17/chapter-devops" --repository-provider "GITHUB" --subdirectory "environment-templates/shared-vpc-env" --template-name "shared-vpc-env" --template-type "ENVIRONMENT"
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
    --spec "file://environment-templates/shared-vpc-env/spec/spec.yaml"
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
    --spec "file://environment-templates/shared-vpc-env/spec/spec.yaml" \
    --deployment-type "MINOR_VERSION"
```

## Service template

Next steps would be to create a compatible **_service template_** without any _version_ associated yet. For simplifying this POC we would **avoid configuring** any **_pipeline_** since it's too complex to use the AWS solution for our purpose on it.

```bash
aws proton create-service-template --name "apprunner-svc" --pipeline-provisioning "CUSTOMER_MANAGED"
```

Creating a simple **_sync config_** would be needed but not for creating _service template_ versions. Instead the objective this time is to **connect** the repository to automatically execute the **optional _pipeline_** in case of new commits. That process is the one responsible to **create service releases**. 

In other words the difference between synchronizing a repo for the **_environment templates_** is that since these **do not contain _pipelines_** we will **create template versions** on every commit added latter. But in the case of the **_service templates_** we are going to **create releases of a service** that depends on the _pipeline_ linked to this template.

In a moment we would see how to create **_service releases_** versions manually since there is no _pipeline_ associated.

```bash
aws proton create-template-sync-config \
    --template-name "home" \
    --template-type "SERVICE" \
    --repository-provider "GITHUB" \
    --repository-name "bounteous17/chapter-devops" \
    --branch "chore/aws-proton-poc" \
    --subdirectory "service-templates/apprunner-svc"
```

The only way to create _template versions_ is to upload them to an `s3` bucket. First step would be to compress the template _major versions_ folder and upload the `.tar.gz` file.

```bash
tar czvf /tmp/apprunner-service-template.tar.gz --directory service-templates/apprunner-svc .
```

List your `s3` buckets and choose one of them for uploading the compressed file.

```bash
aws s3 ls
```

After choosing the bucket uploading files is really simple.

```bash
aws s3 cp /tmp/apprunner-service-template.tar.gz s3://proton-poc-39b4f9ea-ec15-4f1d-b304-275d4bb3728f
```

Let's create out first _major_ and _minor_ template versions linked to the bucket storage.

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

On our case the template would contain all the steps for easily create an `App Runner` instance by indicating some basic input param:
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

Since the `App Runner` instance is publically accessible we are able to establish the connection with the domain.
But non of the resources on the other subnet, the _private_ one are exposed publically.

![image](https://user-images.githubusercontent.com/16175933/226876213-72f070c1-d050-46c9-942b-acfa97a57c91.png)

Having verified that our _service template_ resources has been **successfully deployed** we can **publish the version** so that other developers can make use of an stable version by default. That means that the template would no longer appear as a `Draft` then the current status would be `Recommended` **after publishing it**.

```bash
aws proton update-service-template-version --template-name "apprunner-svc" --major-version "1" --minor-version "0" --status "PUBLISHED"
```