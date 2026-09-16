Concept	Meaning
IAM Policy	What actions are allowed
IAM Role	Identity that can be assumed
Trust Policy	Who can assume the role
Permissions Policy	What the role can do
AssumeRole	Temporarily become the role
STS	Issues temporary credentials
Execution Role	Helps ECS launch the container
Task Role	Gives the application permissions
Terraform Role	Gives Terraform permission to manage AWS


sid       → Label
effect    → Allow/Deny
actions   → What
resources → Which 

Inline Policy
Step 1: Create the IAM Role
Step 2: Create the Policy Document
Step 3: Create an Inline Policy and attach the Policy Document directly to the IAM Role
Step 4: The IAM Role now has the required permissions


Managed Policy
Step 1: Create the IAM Role
Step 2: Create the Policy Document
Step 3: Create a Managed IAM Policy using the Policy Document
Step 4: Create a Policy Attachment to attach the Managed Policy to the IAM Role


When to Use Inline Policy
One IAM Role
     │
     ▼
Inline Policy
     │
     ▼
Permissions used only by that role

Use when: The permissions belong to one specific role.

When to Use Managed Policy
Managed Policy
     │
     ├──► IAM Role 1
     ├──► IAM Role 2
     └──► IAM Role 3

Use when: The same permissions need to be reused across multiple roles.


RDS Secret → ECS Execution Role Flow "  manage_master_user_password = true"
1. RDS Creates the Database
        │
        ▼
2. AWS Generates and Stores the Master Password
   in AWS Secrets Manager
        │
        ▼
3. RDS Exposes the Secret's ARN
   (the secret's unique address)
        │
        ▼
4. Terraform Passes That ARN
   from the RDS Module → ECS Module
        │
        ▼
5. ECS Execution Role Gets Permission
   to read that specific secret
        │
        ▼
6. ECS Uses the Secret During Container Startup
   to retrieve the database credentials
        │
        ▼
7. The Application Uses Those Credentials
   to Connect to RDS

