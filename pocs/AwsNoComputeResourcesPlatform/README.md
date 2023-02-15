# AWS - No-Compute-Resources platform

## Getting started

This project is a Proof of Concept about how to set up a complete and functional project on AWS using only managed services and 
writing it using only terraform code

## Current functionality implemented

### Resources
* API Gateway
* DynamoDB

### Features
* GET HTTP endpoint to retrieve animals stored in DynamoDB
* POST HTTP endpoint to create new animals and persist into DynamoDB

## Test and Deploy

You will need to have `terraform` installed and a `default` aws profile already configured in your machine. Then you will be able to just run:
- `terraform plan` to check changes before creating resources
- `terraform apply` to create resources on the aws account provided
