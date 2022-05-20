########################################################################
#  new for hw3
########################################################################
data "aws_availability_zones" "available" {}
locals {
  current_timestamp = timestamp()
}

########################################################################
#  VPC
########################################################################
resource "aws_vpc" "main" {
  cidr_block = var.ipblock #"${var.ipblock}.0.0/16"
  tags = {
    Name = "${var.prefix}-vpc"
    timestamp  = local.current_timestamp
  }
}

########################################################################
#  Internet Gateway
########################################################################
resource "aws_internet_gateway" "igw" {
   vpc_id = aws_vpc.main.id
   tags = {
    Name = "${var.prefix}-internet-gateway"
    timestamp  = local.current_timestamp
   }
}

########################################################################
# Public Subnets based on AZ in region
########################################################################
resource "aws_subnet" "publicsubnet" {
    #new in hw3
  count = "${length(data.aws_availability_zones.available.names)}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(var.ipblock, 4, count.index+1) #"${var.ipblock}.1.0/24"

  tags = {
    Name = "${var.prefix}-publicsubnet${count.index}"
    timestamp  = local.current_timestamp
  }
}
########################################################################
#  Private Subnets based on AZ in region
########################################################################
resource "aws_subnet" "privatesubnet" {
    #new in hw3
  count = "${length(data.aws_availability_zones.available.names)}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(var.ipblock, 4, count.index+8)

  tags = {
    Name = "${var.prefix}-privatesubnet${count.index}"
    timestamp  = local.current_timestamp
  }
}


########################################################################
# NAT Gateway
########################################################################
resource "aws_eip" "eip" {
  vpc = true
  tags = {
    Name = "${var.prefix}-eip"
    timestamp  = local.current_timestamp
  }
}
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.publicsubnet[1].id

  tags = {
    Name = "${var.prefix}-nat-gateway"
    timestamp  = local.current_timestamp
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

########################################################################
# 2 RouteTables (1 Public, 1 Private)
########################################################################
resource "aws_route_table" "publicrt" {
  vpc_id = aws_vpc.main.id

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.prefix}-public-routetable"
    timestamp  = local.current_timestamp
  }
}
resource "aws_route_table_association" "rtpublic" {
  count = "${length(data.aws_availability_zones.available.names)}"
  subnet_id      = aws_subnet.publicsubnet[count.index].id
  route_table_id = aws_route_table.publicrt.id
}


resource "aws_route_table" "privatert" {
  vpc_id = aws_vpc.main.id

  route {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.prefix}-private-routetable"
    timestamp  = local.current_timestamp
  }
}
resource "aws_route_table_association" "rtprivate" {
  count = "${length(data.aws_availability_zones.available.names)}"
  subnet_id      = aws_subnet.privatesubnet[count.index].id
  route_table_id = aws_route_table.privatert.id
}
