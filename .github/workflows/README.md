- name: Validate = This is simply the name GitHub Actions will display.

- on:
    pull_request: = this runs when somone opens or updated pull request 

    You change code
        ↓
    Push branch
        ↓
    Open Pull Request
        ↓
    GitHub Actions
        ↓
    validate.yaml
        ↓
    Checks everything

- jobs: each workflow contains jobs e.g validate , deploy

- runs-on: ubuntu-latest = comes after a job: and it means give this job ubuntu machine to run commands

- steps come under jobs = you define under it, the different things you want to acheive with in this job

- Checkout code = copies your repo into the runner 

- permissions:
  id-token: write this allows the workflow to request a temp token to present to aws 
  contents: read allows the workflow to read your repo  "actions/checkout@v4"

- TFLINT catched out bad practice 

- Verify AWS identity = The command asks AWS who the authenticated caller is
    . Account — confirms which AWS account the workflow is accessing.
    . Arn — confirms the assumed IAM role.
    . UserId — identifies the temporary session associated with that role.
    this step is useful because:
         Catches authentication or account-selection mistakes early.
        Makes troubleshooting easier.
    P   rovides a visible confirmation in the GitHub Actions logs.


-out=tfplan = saves the proposed changes/plan to a file named tfplann

echo "IMAGE_TAG=${GITHUB_SHA}" >> "$GITHUB_ENV" 

GITHUB_SHA = GitHub automatically provides this variable. It contains the commit SHA associated with the workflow run

$GITHUB_ENV a file provided by github any variable assignment writen to it can be reused in the same jobs, almost like storage

you can run 

on:
   workflow_run:
    workflows:
        - docker build and push
    types:
        - completed
    branches:
        - main
and the below together

if: ${{ github.event.workflow_run.conclusion == 'success' }}

the on: controls what triggers this workfl and the  if statement controls whether it goes a head or not.
it may be triggerts by on: by skipped by the if statement.
github = box containing information about what is happening in github actions
.event = something that happened , e.g what triggered the work flow, it could be a finishing of another workflow
workflow_run = information about a workflow that just finished
.conclusion = how the previous workflow finished
possible conclusions:
Conclusion	Meaning
success	    Everything succeeded
failure	    Something failed
cancelled	The workflow was cancelled
skipped	    A job or workflow was skipped

IMAGE_TAG= — Creates a variable called IMAGE_TAG.
>> "$GITHUB_ENV" — Saves that variable so subsequent steps in the same job can use it.

Coordinate means to organise things so they work together without clashing.

concurrency:
  group: url-shortener-terraform-state
  cancel-in-progress: false

1. concurrency:
Tells GitHub Actions to coordinate workflow runs that could conflict with each other

2. group: url-shortener-terraform-state
Gives the workflows a shared group name, this is something to use when multiple workflows use the same state

3. cancel-in-progress: false
Means a new run won't cancel the currently running run just because another run in the same group starts.

Terraform Workflow A
        │
        ▼
  Applying changes
        │
        │  Workflow B starts
        ▼
  A continues running
  B waits as pending
        │
        ▼
  B can run afterwards


If the image has already been pushed, what stops you pushing it again?
ECR's tag immutability setting stops you.

Whenever you make a commit in Git, Git creates a unique identifier for that commit. This is called a commit SHA.

A tag is a label that identifies a particular version of that image.










