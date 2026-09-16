runtime_platform {
  operating_system_family = "LINUX"
  cpu_architecture        = "X86_64"
}
What Each Means
Operating system → The environment the container runs on.
LINUX = Linux
CPU architecture → The processor type.
X86_64 = Intel/AMD
ARM64 = ARM/AWS Graviton
Docker Buildx


Task definition

This tells ECS:

Use Fargate
Use Linux
Use this Docker image
Give it this CPU
Give it this memory
Use this execution role
Use this application role
Send logs to CloudWatch

ECS service

This tells ECS:

Keep one or more copies running.
Run inside these private subnets.
Use this security group.
Restart failed tasks.
Rollback if deployment fails.


var.container_port == null ? [] : [port_mapping] Memory: ? means "then", : means "otherwise."


User
  ↓
Load Balancer :80 or :443
  ↓
Target Group :8080
  ↓
ECS Task IP :8080
  ↓
Container :8080
  ↓
Application

different between env port and container port 

container_port = 8081
        ↓
ECS knows where to send traffic

ENV PORT = "8081"
        ↓
Application knows where to listen

Target group = routing instructions/group of targets for mainly alb
Port = communication endpoint
Container port = tells ecs where the application is listening
Host port = port receiving traffic on the ECS task/network interface
Load balancer = receives incoming traffic
Listener = listens for traffic on a port, such as 80 or 443
Target = actual ECS task/container receiving traffic
Port mapping = connects the incoming task port to the application’s container port


Environment variable = runtime application setting
Map = { KEY = VALUE }
ECS format = [{ name = KEY, value = VALUE }]


awslogs = send logs to CloudWatch
Log group = main container for logs
Region = where logs are stored
Stream prefix = organizes individual log streams

enable_execute_command = true

Allows you to open a shell inside a running ECS container using ECS Exec


deployment_circuit_breaker :
Controls what happens when a new deployment keeps failing


[A dynamic] block creates a Terraform block only when needed


content Block defines how the ECS service connects to the load balancer.