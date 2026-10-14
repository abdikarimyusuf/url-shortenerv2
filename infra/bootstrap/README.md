
 OIDC


               AWS
                     │
          ┌──────────┴──────────┐
          │                     │
          ▼                     ▼
   ① OIDC PROVIDER          ② IAM ROLE
          │                     │
          │                     ├── Trust Policy
          │                     │
          │                     └── Permissions Policy
          │
          └──────────┬──────────┘
                     │
                     │
                     ▼
              GitHub Actions
                     │
                     ▼
               OIDC Token
                     │
                     ▼
                  AWS STS
                     │
                     ▼
             Temporary Credentials
                     │
                     ▼
              AWS API requests
                     │
                     ▼
              IAM Permission Check
                     │
              ┌──────┴──────┐
              ▼             ▼
            ALLOW          DENY

step 1 oidc provider:
-provider url - who issued the token 
-audience - who is it for

step 2 iam role:
-trust policy - who can assume/ specific repo/specifi branch 
-permissions policy = what can they do with the role 

step 3 gitwork flow runs and request token

step 4 token issue and aws sts checken token/trust policy and grants short lived credentials

step 5 github issume role and make api request 

step 6 each api request gets checked against permissions




# GitHub Actions OIDC → AWS
# ==========================================

## STEP 1 — GitHub OIDC Endpoint

GitHub provides an OIDC endpoint:

    https://token.actions.githubusercontent.com

URL
    ↓
Tells AWS where GitHub's OIDC provider is.

GitHub Actions
    ↓
GitHub OIDC Provider
    ↓
Creates an OIDC token


## STEP 2 — TLS Certificate

Because the OIDC endpoint uses HTTPS, GitHub's server
presents a TLS certificate when AWS connects to it.

AWS
    ↓
Connects to GitHub OIDC endpoint
    ↓
GitHub presents TLS certificate
    ↓
Certificate helps establish HTTPS trust


## STEP 3 — Certificate Thumbprint

The TLS certificate is a large piece of data.

SHA-1
    ↓
Creates a fingerprint/thumbprint from the certificate.

Certificate
    ↓
SHA-1
    ↓
Thumbprint

Same certificate
    ↓
Same thumbprint

Different certificate
    ↓
Different thumbprint

The thumbprint is basically a compact identifier
derived from the certificate.


## STEP 4 — Store Thumbprint in AWS

Terraform retrieves GitHub's certificate:

    data "tls_certificate" "github" {
      url = "https://token.actions.githubusercontent.com"
    }

Terraform gets the certificate fingerprint:

    data.tls_certificate.github.certificates[0].sha1_fingerprint

Then Terraform creates the AWS IAM OIDC Provider:

    resource "aws_iam_openid_connect_provider" "github"

The thumbprint becomes part of the OIDC Provider
configuration stored in AWS IAM.

IMPORTANT:

    Thumbprint
        ↓
    Stored in AWS IAM OIDC Provider

NOT:

    Thumbprint
        ↓
    AWS STS


## STEP 5 — What Happens When GitHub Uses OIDC

GitHub Actions starts
    ↓
GitHub creates an OIDC token
    ↓
Token is sent to AWS STS
    ↓
AWS validates the OIDC provider/token
    ↓
IAM Trust Policy is checked
    ↓
"Is this GitHub workload allowed to assume this role?"
    ↓
YES
    ↓
AWS STS gives temporary AWS credentials
    ↓
GitHub uses temporary credentials to call AWS APIs
    ↓
IAM checks the role's permissions
    ↓
"Is this role allowed to perform this action?"
    ↓
YES → AWS performs the action
NO  → AccessDenied


# THE 4 IMPORTANT CONCEPTS
# ==========================================

OIDC Provider
    ↓
"I recognize GitHub as an identity provider."

Thumbprint
    ↓
"Certificate trust/verification information
for the OIDC provider."

OIDC Token
    ↓
"Which GitHub workload is making this request?"

Trust Policy
    ↓
"Is this GitHub workload allowed to assume
this IAM role?"

Permissions Policy
    ↓
"What can this IAM role actually do?"


# COMPLETE FLOW
# ==========================================

GitHub Actions
    ↓
GitHub OIDC Endpoint
    ↓
OIDC Token
    ↓
AWS STS
    ↓
IAM Trust Policy
    ↓
Temporary AWS Credentials
    ↓
AWS API Request
    ↓
IAM Permissions Policy
    ↓
AWS Resource


# SHARP MEMORY
# ==========================================

Thumbprint
    → Certificate trust information

OIDC Token
    → Identifies the GitHub workload

Trust Policy
    → Decides WHO can assume the role

Permissions Policy
    → Decides WHAT the role can do

AWS STS
    → Gives trusted workloads temporary credentials




# IAM Policy Document — Key Headings

Statement
    → The rule being defined

Effect
    → Allow or Deny

Action
    → What AWS action is allowed/denied

Principal
    → WHO is allowed/denied

Resource
    → WHICH AWS resource the rule applies to

Condition
    → Extra requirements that must be met

Version
    → IAM policy language version

Sid
    → Optional name/identifier for the statement

Common principal types
AWS
    → An AWS account, IAM user, or IAM role

Service
    → An AWS service

Federated
    → An external identity provider


IDENTIFIER                         ACTION
──────────                         ──────

WHO?                               DO WHAT?

GitHub OIDC Provider               AssumeRoleWithWebIdentity
       │                                  │
       ▼                                  ▼
"This specific identity"           "Assume this role"




Think of the GitHub OIDC token as a form with different boxes.
              GITHUB OIDC TOKEN
        ┌─────────────────────────────┐
        │                             │
        │ aud = sts.amazonaws.com     │ ← Audience box
        │                             │
        │ sub = repo:ak/app:...:main  │ ← Subject box
        │                             │
        │ other claims...             │
        └─────────────────────────────┘

Your Terraform condition tells AWS which box to look at, how to check it, and what value to expect.
🧠 The 3 pieces
TEST
 ↓
HOW do I check?
 ↓
StringEquals
 ↓
"Must exactly match"


VARIABLE
 ↓
WHAT should I look at?
 ↓
aud / sub
 ↓
"Which box in the token?"


VALUES
 ↓
WHAT should it contain?
 ↓
Expected value

🎯 Example 1 — Audience

condition {
  test     = "StringEquals"

  variable = "token.actions.githubusercontent.com:aud" the aud makes the varaible to look for that in the token 

  values   = ["sts.amazonaws.com"]
}
Visual:
                 GITHUB TOKEN
                      │
                      ▼
              ┌───────────────┐
              │ aud = ???     │
              │ sub = ???     │
              └───────────────┘
                      │
                      │
 VARIABLE ────────────┘
     │
     ▼
 "Look at AUD"
     │
     ▼
    TEST
     │
     ▼
StringEquals
     │
     ▼
   VALUES
     │
     ▼
"sts.amazonaws.com"


variable = "token.actions.githubusercontent.com:sub" -- the sub identifies which GitHub repository and execution context the OIDC token belongs to.

Immutables ID

     GitHub Actions
                │
                ▼
         GitHub OIDC Token
                │
                ▼
          Subject (sub)
                │
        ┌───────┴────────┐
        ▼                ▼
  Traditional ID    Immutable ID
        │                │
        ▼                ▼
  Repository name   Owner + Repository
  + branch          numeric IDs + branch
        │                │
        └───────┬────────┘
                ▼
       AWS IAM Trust Policy
                │
       Does the sub match?
           ┌────┴────┐
           ▼         ▼
          YES        NO
           │         │
           ▼         ▼
     Assume IAM    Access denied
        role

        to retreive the githubowner id you:  curl -s https://api.github.com/users/accountname
        to retreive the github repo id you:  curl -s https://api.github.com/repos/accountname/reponame

        format for the value = repo:OWNERNAME@OWNER_ID/REPOSITORYNAME@REPOSITORY_ID:ref:refs/heads/BRANCH
