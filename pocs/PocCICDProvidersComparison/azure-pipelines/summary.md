# Azure Pipelines PoC

## Azure Pipelines

Azure Pipelines automatically builds and tests code projects to make them available to others. It works with just about any language or project type. Azure Pipelines combines continuous integration (CI) and continuous delivery (CD) to test and build your code and ship it to any target.

Azure DevOps supports two forms of version control - Git (GitHub, GitLab, etc) and Azure Repos

## PoC Description

This PoC is very simple, a base React project has been used which is deployed in an Azure Static Web App. The code repository is in Azure Devops.

```yaml
trigger:
  - main

pool:
  vmImage: ubuntu-latest

steps:
  - task: NodeTool@0
    inputs:
      versionSpec: '14.0'
    displayName: 'Install Node.js'
  
  - script: npm ci
    displayName: 'Installing dependencies'
  
  - script: npm run build
    env:
      REACT_APP_API_URL: $(api_url)
    displayName: 'Bundling project'

  - task: AzureStaticWebApp@0
    inputs:
      output_location: "build"
    env:
      azure_static_web_apps_api_token: $(deployment_token)
```

- First, code dependencies are installed and is built using the Azure Pipelines `NodeTools` task, which contains all the necessary pre-installed tools to work with NodeJS projects (npm, yarn, etc).
- Then, the `AzureStaticWebApp` task is used to deploy the compiled code to the 'Azure Static Web App' Azure service.

Azure Pipelines contains built-in tasks to work with the most popular programming languages, as well as to easily integrate with Azure services.

## Conclusions

Azure Pipelines is surely the best choice for managing project CI/CD pipelines within the Azure ecosystem.

The integration of Azure Pipelines with a project whose code repository is in Azure DevOps is completely automatic. In addition, both the code and the pipelines are unified in a single place, along with the rest of the functionalities that Azure Pipelines provides.

Integration with the rest of the Azure portal services is also very simple thanks to the built-in tasks it provides. So it is very easy to deploy our projects on its cloud platform.

Lastly, Azure Pipelines provides a set of pipeline templates with some of the most common use cases (and languages), which can allow you to create simple pipelines for your applications or be used as a basis for setting up more complex pipelines.



## Pros / Cons

- Pros :white_check_mark:
    - Automatic integration with Azure Devops projects
    - Also integrates with other git repositories (GitHub, GitLab)
    - Easy integration with other Azure services
    - Multiple basic pipeline templates
    - Cloud and self-hosted version
    - Reasonable free-tier version (specially for open source projects)
- Cons :x:
    - Not the best option if code repository is not in Azure Devops
