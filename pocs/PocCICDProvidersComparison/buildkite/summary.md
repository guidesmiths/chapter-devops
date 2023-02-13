# Buildkite

### Basics
Buildkite is a CI/CD tool that sits between your code repository, and machines you dedicate to testing and deploying your code.

It is basically Bash-as-a-service.

As opposed to other CI/CD tools, buildkite agents are self-hosted, meaning that you are in charge of the infrastructure to host those pipeline agents. This allows for a very cost-effective, scalable CI/CD integration, which can start from hosting the agents on a raspberry pi or even your local development machine, all the way to powerful cloud solutions such as EC2. The configuration of the agents is totally up to the user, so it can be one powerful machine running tons of agents, o multiple small machines running one or a few instances.

Apart from all that manual configuration, Buildkite also offers some pre-built stacks, that allow you to set up the infrastructure needed with just a click. For example with the AWS Launch Stack, Buildkite will spin up a pre-built cluster including Docker, S3 and CloudWatch, all configured ready to be used.

Buildkite has out-of-the-box integration with all the main Source Control providers, GitHub and GitHub Enterprise pull requests, GitLab, BitBucket, Phabricator, and more. It provides CI out of the box with all of these.

### Pipelines
The pipelines make a copy of your code from the repository and execute the actions you define, either in the Buildkite platform or in a YAML file. They are as flexible as you can imagine from a pipeline, from running scripts, to making use of Docker and Docker-compose or uploading artifacts. There's a plugin system that allows to add steps to the pipeline with just a click.

### Tips
- Each bash script that runs a step should include `set -euo pipefail` at the top so that any error will fail the build.
- You don’t have to use bash, you can script things in whatever you want. Python could be a good choice.
- A Docker environment makes things more flexible and maintainable. The isolation and deterministic nature makes things easy to think about and extra dependencies easy to install (once you learn the docker dance).
- Use the out of the box Elastic CI Stack for AWS (if you’re on AWS) and don’t fiddle with much until you have a real need.
- Use Artifacts to store assets that other steps might need.

### Conclusions from POC
I've done a pretty basic POC using Buildkite and a React project with testing and license-checking. The configuration of the pipeline can't be easier, just grant access to gitlab (in this case) and to the project, set up some pipeline steps, either manually or in a YAML and the pipeline is set. As for the agent, I decided to try it out both locally and in an EC2 instance. There's a quick start guide for each operating system you can run the agent on, with some simple commands and tokens to set everything up. In a matter of 3 minutes for each case, the agent can be set up in the wanted machine, and then either manually or by changing the code, you can trigger the pipeline and it will run on the decided agent.

PROS:
- Super easy set up.
- Cost-effective and scalable (up to a certain point).
- Ideal for small/medium projects.
- Great user experience.

CONS:
- For bigger projects, it can get hard to maintain a lot of self-hosted agents, other CI/CD tools that abstract you from this are better in those cases.

