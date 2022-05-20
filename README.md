# terraformhw3

Let's improve what we have:
- Generate dynamic CIDR for the subnets using Terraform functions
- Iterate to create a number of public and private subnets equal to the number of availability zones the Region has
- Use a `data` to get the AMI for the AutoScaling Group
- Tag all the resources with the DateTime when they got created (Use Terraform locals)

# project description
Most of the changes is in /modules/vpc/main.tf
