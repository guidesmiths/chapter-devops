# Recovery plan guidelines
This document is meant to works as a strategy guidelines for **disaster recovery** and **backup plans**. We will identify the key features when facing a backup and disaster recovery plan.
## What to consider?
These are what needs to be consider when we elaborate a recovery plan:
- Identify the key features for the application integrity
- Backup plan for key environments (normally `production`)
- Disaster recovery plan and its estimated times
- Identify scenarios and its response

## Identify key features
![diagram_sample](/assets/diagram_sample.png)
Taking this diagram as a sample of the application we are working for. We need to identify those key services for the stability and application's performance. In this sample we can identify:

- Application database
- Hosting cluster
- Identities database
- Extra resoruces needed for the application's functionality
 
We identify these features based on what it needs the application to fully work without any other third-party service. We might identify not just the key features but all the services we can control; those who are not under a third party control like an external hosting (e.g. VMs, DNS records, etc...)

## Backup plan for selected environments
We need to plan ahead which environments we need to keep on track. Some client's might have environments dedicated for different clients. In this case, we won't only consider applying the plan to just `production`, but applying a backup template for the different environments. 
### How we estimate the frequency, retention policies, etc... based on its importance?
It's completely necessary make an estimation of the sensibility of the data, how dynamic is the data, CI/CD applied over the application. This is generally calculated based on:
- App hosting SLAs: What SLAs are guaranteed by the hosting provider (e.g. AWS compute)
We will take an AWS EC2 as an example, here you can find the SLAs provided by AWS https://aws.amazon.com/compute/sla/. In this scenario, we can see that AWS has a 99% uptime guarantee but, this might be not enough. How can we rise the uptime values? 
The uptime formula will be: `100% - SLA% = possible_donwtime_considered`
The most resources we have, will vary this formula. For example:
Being 'x' the number of resources' failure percentages
`100% - sum(x)% = estimation`
Let's think EC2 failure percentage is about a 5%, being `x` the number of services, to reduce the downtime the formula will be like:
`100% - (5/2)% = estimation` 
As we set a backup machine, this will reduce the failure percentage by two. The most machines we have, will decrease the more from the original SLA. This should apply for every service we scale out in order to reduce the downtime percentage.
### The importance of each service
We will consider the frequency the data is backed up, also its rentetion. Some cases/sectors, client's will require to have a yearly backup for over 5 years in case of auditories. This is a step to be discussed with the customer. Retentions and frequency will incur in the final price of the deployed infrastructure
At the end, a backup plan must be a balance between the desired ETA to recover the application and the monthly pricing. A disaster recovery is not as usual as a recurrent bill. 
## Disaster recovery
The DR plan must contains a realistic recovery ETA based on the worst scenarios we could face. We should make a calculation (always over the expected "time"). We might consider any problems during the process like a pipeline error, corrupted service, etc...
The calculation of the different ETAs might be separated by key feature, this will be the estimation for this scenario:
- Application database (creation of the service plus restoration of the LTS snapshot)
- Hosting server/service (Creation of the cluster from the scratch). If the creation of it takes less than a new one, this is only a relief. In the other hand, if the server is completely inoperative, might be a good practice to make a estimation based on its fully creation
- Identities database (either if is a identity DB, which requieres the restoration of a DB, or a user directory, we need to estimate the time based on its full recreation too)
- Extra resoruces needed for the application's functionality (this will be based on the Gi/provider_sla. If we are talking of the recovery of 1Ti, it could take even days)

## Identify scenarios and its response
After we have designed a plan, we will consider the different scenarios to trace a plan/estimation for the full service recovery. Is not possible to calculate a 100% effective DR plan, therefore we will focus in the most common scenarios we think the application might face (based on business logic and known errors from the past). 
Also, the official channel of communication about the procedure, the ETAs and its responsiveness/interventions from possible third parties.

## Creating the final proposal
After we plan our strategy, we go through the final steps; creating our **recovery plan** proposal. We will based our document in the following bullet points:

- Version control index
- Document brief summary
- Identify the involved stakeholders
- The different sections described in the guidelines above
- Budget estimation
- Extra annotations 

**here** we can have a look on AWS paper when analyzing a recovery plan as an example: https://docs.aws.amazon.com/whitepapers/latest/disaster-recovery-workloads-on-aws/disaster-recovery-options-in-the-cloud.html
