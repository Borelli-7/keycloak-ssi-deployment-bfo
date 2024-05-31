## keycloak-aws-ecs

A Terraform setup for creating a Keycloak ECS instance behind an ALB. This project uses ECS and not RDS and is inspired by this [keycloak-aws-rds](https://github.com/devopsutils/keycloak-aws-rds) project.

# What

This project demonstrates how to launch an instance of [KeyCloak](https://keycloak.org) with a Postgres DB within your AWS [VPC](https://aws.amazon.com/vpc/) using [Terraform](https://terraform.io).  
These modules will deploy both KeyCloak and postgres in Docker containers deployed on [ECS](https://aws.amazon.com/ecs/). 
Keycloak is accessible behind an [ALB](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html).  
A DNS record for the instance will also be created using [Route 53](https://aws.amazon.com/route53/) and a corresponding certificate for the ALB will be created and applied using [ACM](https://aws.amazon.com/certificate-manager/).

# Getting Started

This code has been tested using Terraform v1.0.2. After cloning this repo, within the source directory run:

```
terraform init
```

This will register all modules and download any required providers. 
With the build environment initialized, you must define the values for the variables needed by the Terraform modules.  
You may either do this as `terraform apply` is run, or you may use a var file. To use a var file (in this case, called `private.tfvars`) simple run:

```
terraform plan -var-file=private.tfvars
```

If everything in the plan looks appropriate, you may apply the Terraform module and begin building out your infrastructure by running:

```
terraform apply -var-file=private.tfvars
```

# Testing it out

Once your Terraform build completes, you will see outputs showing the ALB's DNS name, as well as the DNS name created using Route 53. 
Wait a couple seconds for the ALB to register the backend target, and then open up a browser to either of those values. 
You should see the KeyCloak login page appear. 
Login with the administrator username and password you provided as part of your Terraform variables.

# Caveats

A few caveats, particularly related to security...

#### Route 53 and DNS

This deployment assumes that you have an existing Route 53 zone setup for your domain. 
The DNS record for KeyCloak will be created in this zone during ```apply```, but the zone itself must exist beforehand.


