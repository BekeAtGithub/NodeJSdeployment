# install Terraform and Docker on local machine
i used Chocolatey to install on my windows PC with powershell
choco install terraform
choco install docker-desktop 
with VScode, I install extensions as it recommends as I progress along the way

# setup AWS
once I create my new account, i create an IAM user, create a Group, add Administration access to it, and assign my admin user to it. I save the keys in password manager: KeePass
i install aws CLI with:
msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi
i run a few commands 
aws configure to sync up the cli with my user in IAM
i create a new user for terraform development:
aws iam create-user --user-name tf-developer
aws iam add-user-to-group --user-name tf-developer --group-name "admingroup"
aws iam create-access-key --user-name tf-developer
aws configure --profile tf-developer

# build terraform config
SRECHALLENGE/
│
├── modules/
│   ├── ecr/
│   │   ├── ecr.tf
│   │   ├── outputs.tf
│   │   ├── variables.tf
│   ├── ecs/
│   │   ├── ecs.tf
│   │   ├── data.tf
│   │   ├── variables.tf
│   └── tf-state/
│       ├── tf-state.tf
│       ├── variables.tf
│
├── locals.tf
├── main.tf
└── providers.tf

providers.tf lists the provider block
main.tf lists the version, s3, providers, module location, references module variables
locals.tf has names for the variable definitions, and the container port number, values store locally
modules/ecr/ecr.tf points to repo URL of resource with a variable
modules/ecr/variables.tf defines ecr variable
modules/ecr/outputs.tf outputs the repo url - that is sent to the ecs module as a variable
modules/ecs/ecs.tf resource blocks - to deploy cluster in a vpc, into a set of subnets based on availability zone, and passing in task definition, with a task family, to define the container name, image, port mappings and resource utilization. also setting IAM roles, load balancer and security group
modules/ecs/data.tf has the policy document to allow the role assignments for the ecs role principles 
modules/ecs/variables.tf declarations for ecs module

# add application to /App 
build an app, or pull an existing app from a repo which has a docker file
navigate to aws.amazon.com - to ecr repo, click "view push commands" to follow along the 4 commands it lists
once the dockerfile is built and the image is added to the registry, move to next step

# deploy 
terraform fmt -recursive
terraform init
terraform plan
terraform apply
