# Terraform_Infra_Setup_on_AWS
Terraform code to create infra on AWS.

### Requirements

- Install terraform 
- Attach role with necessary permission to create Infra on AWS to the terraform server.[Add Access key and Seret Key of the user if the terraform server is not an aws instance]

### Archetecture to build
![Capture](https://user-images.githubusercontent.com/106676454/185428055-694cdd50-1ff8-4e46-82a9-261059682be6.JPG)


### Requirements

- Install terraform 
- Attach role with necessary permission to create Infra on AWS to the terraform server.[Add Access key and Seret Key of the user if the terraform server is not an aws instance]

### Infra creation using terraform

- Planning the resource creation

```sh
# terraform plan 
Plan: 25 to add, 0 to change, 0 to destroy.
```
- Applying the terraform code to deploy the resources
```sh
# terraform apply
Apply complete! Resources: 25 added, 0 changed, 0 destroyed.
```
- Showing the resources in the infra.
```sh
# terraform state list

data.aws_availability_zones.AZs
aws_eip.ngw
aws_instance.Bastion
aws_instance.dbserver
aws_instance.webserver
aws_internet_gateway.igw
aws_key_pair.myKey
aws_nat_gateway.ngw
aws_route_table.Private-RTB
aws_route_table.Public-RTB
aws_route_table_association.private-1
aws_route_table_association.private-2
aws_route_table_association.private-3
aws_route_table_association.public-1
aws_route_table_association.public-2
aws_route_table_association.public-3
aws_security_group.Bastion
aws_security_group.DB_Access
aws_security_group.WebAccess
aws_subnet.private-1
aws_subnet.private-2
aws_subnet.private-3
aws_subnet.public-1
aws_subnet.public-2
aws_subnet.public-3
aws_vpc.vpc
```
- Displaying output
```sh
# terraform output

Backend-Private_ip = "172.19.122.218"
Bastion_Private_IP = "172.19.8.114"
Bastion_Pubic_IP = "65.0.103.218"
Frontend_Private_ip = "172.19.41.247"
Frontend_Public_ip = "3.109.123.107"
```
