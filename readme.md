1)Install the terraform and setup the path.
2)Install the aws-cli and run aws configure command to configure the keys. 
profiles for the aws-cli:your user home directory .aws
config / credentials


commands:
-----------------
1. terraform init
2. terraform plan
3. terraform plan --var-file dev.tfvars
4. terraform apply --var-file dev.tfvars

what is tfstate?
It is a terraform file which contains about all the resource information.

we are going to create the vpc using terraform.
provider : AWS
region: ap-south-1
resource: vpc
cidr: 10.1.0.0/16
subnets
pubsubnet - ["10.1.0.0/24","10.1.1.0/24","10.1.2.0/24"]
prisubnet - ["10.1.3.0/24","10.1.4.0/24","10.1.5.0/24"]
datasubnet - ["10.1.6.0/24","10.1.7.0/24","10.1.8.0/24"]

igw
attach

eip
nat-gw=pubsubnet[0]

route table
pub route
privateroute

associate the pubsubnets with the igw in pubroute
associate the privatesubnets with the nat-gw in private route



=======================
terraform init
terraform plan 
terraform apply