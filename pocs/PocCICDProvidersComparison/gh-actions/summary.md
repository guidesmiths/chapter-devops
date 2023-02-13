
# Github Actions

### Basics
Github Actions is a CI/CD tool that, as many other similar tools out there, allow you to automate your build, test, and deployment pipeline. You can create workflows that build and test every pull request to your repository or deploy merged pull requests to production.

It allows for many different events (commits, pull requests, merges, issues, etc) to trigger different workflows, or actions, as they are called in Github. This actions can help you automate many different tasks, like testing, building and deploying of your code.

It obviously comes with out-of-the-box integration with their own source control, though you could also set up actions with your code residing elsewhere. 

### Workflows
A workflow is a configurable automated process that will run one or more jobs. Workflows are defined by a YAML file checked in to your repository and will run when triggered by an event in your repository, or they can be triggered manually, or at a defined schedule.

Workflows are defined in the .github/workflows directory in a repository, and a repository can have multiple workflows, each of which can perform a different set of tasks.

### Events
An event is a specific activity in a repository that triggers a workflow run. [Here](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows)'s a list of all the events that can trigger a workflow.

### Actions
Actions are written in a .yml format, which allow you to create your own actions following [Github's Workflow Syntax](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions). It's quite similar to other yaml conventions from providers like CircleCI. Github also provides a huge variery of prebuilt actions to avoid having to write them manually, which most likely cover your needs. 

### Jobs
A job is a set of steps in a workflow that execute on the same runner (or server). They are executed in order and dependant on each other.

### Conclusions from POC
I've done a simple POC  in which I used the action to build a docker image and push it to a remote registry. In the POC, I stored the environment variables in the repo's settings, which is way provided by Github. It makes the secrets available in the actions in a secrets object, which you can then access like ```${{secrets.MYSQL_HOST}}``` and then replace in your code or dockerfile. The process is quite easy and it's well documented. Prebuilt workflows are really useful.

PROS:
- Free tier is pretty extensive and should be enough for small projects and POCs.
- Maintainability. Runners are owned and maintained by Github.
- Easy to set up.

CONS:
- It ties you to use Github for version control, there are alternatives but it's quite hermetic.
- It's quite new so it's not yet as established as CircleCI or Jenkins for example.
