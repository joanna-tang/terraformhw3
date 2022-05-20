# terraformhw3

Let's improve what we have:
- Generate dynamic CIDR for the subnets using Terraform functions
- Iterate to create a number of public and private subnets equal to the number of availability zones the Region has
- Use a `data` to get the AMI for the AutoScaling Group
- Tag all the resources with the DateTime when they got created (Use Terraform locals)

# project description
Most of the changes are in /modules/vpc/main.tf. I already used `data` for ami in hw2 so there's no change here.

To run this project, please make sure you have S3 / dynamoDB access. It might be necessary to change the backend section in resources.tf.

>terraform init
>
>terraform apply

To remove all the changes, use this command:
>terraform destroy