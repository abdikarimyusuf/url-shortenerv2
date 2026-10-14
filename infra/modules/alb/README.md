# ALB Module

Creates an internet-facing Application Load Balancer.

Resources created:

- Application Load Balancer
- API target group
- Dashboard target group
- HTTP listener
- API path-based listener rule
- Dashboard path-based listener rule

Target groups use IP targets because ECS Fargate uses awsvpc networking.




"traffic-port" in a Target Group : It means:

Use the same port that the target group is already sending traffic to.

matcher = "200-399"

Means:

Treat any response with a status code from 200 through 399 as successful
deregistration_delay = 30 
means:

Old task running
      ↓
ECS wants to stop it
      ↓
ALB stops sending new traffic
      ↓
Wait 30 seconds
      ↓
Old task is removed



listener rule vs listener 

Listener = "I receive visitors at the front door."

Listener rule = "If visitor asks for API, send them to API.
                 If visitor asks for dashboard, send them to dashboard."


type = "fixed-response" :
User requests /unknown
        ↓
ALB Listener
        ↓
No listener rule matches
        ↓
Default action
        ↓
ALB returns:
404 Not Found



ALB Listener Rule Priority — Summary
priority = 100

Means:

The order in which the ALB checks this listener rule.

Key points
Lower number = checked first.
Higher number = checked later.
Rules are checked in priority order.
Once a rule matches, its action is used.
Each rule on the same listener needs a unique priority.


Common collection-style names
security_group_ids
subnet_ids
route_table_ids
availability_zones
availability_zone_ids
target_group_arns
listener_arns
instance_ids
vpc_ids
public_subnet_cidrs
private_subnet_cidrs
container_ports
environment_variables
secrets
Memory
Singular:
security_group_id = "sg-123"

Plural:
security_group_ids = ["sg-123", "sg-456"]

Singular = one value
Plural = usually a collection of values