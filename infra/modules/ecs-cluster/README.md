
Task definition = the instructions for running a container.
ECS service = keeps the required number of containers running.



ECS Container Insights Options
Value	Meaning
disabled	No Container Insights monitoring
enabled	Basic CloudWatch monitoring
enhanced	Detailed monitoring of CPU, memory, tasks, containers, and network


ID vs Name vs ARN vs URL
Attribute	When you use it
ID	To identify/reference the resource internally
Name	When a service or Terraform setting asks for the resource’s name
ARN	IAM permissions and policies — specifies exactly which AWS resource is allowed
URL	When connecting to or sending requests to the resource endpoint

ECS Deployment Circuit Breaker

A deployment circuit breaker automatically detects when a new ECS deployment is failing and can stop it and roll back to the last working version.
enable = true → monitor deployment failures
rollback = true → automatically return to the previous working deployment

