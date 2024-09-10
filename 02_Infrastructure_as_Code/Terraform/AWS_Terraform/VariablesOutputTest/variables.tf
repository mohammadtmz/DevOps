# AWS provider region
variable "aws_region" {
  description = "The AWS region to create resources in"
  default     = "us-east-2"
}

# VPC configuration
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "Name tag for the VPC"
  default     = "terraform-test-vpc"
}

# Subnet configuration
variable "public_subnet_cidr_block" {
  description = "CIDR block for the public subnet"
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "Availability zone for the public subnet"
  default     = "us-east-2a"
}

variable "public_subnet_name" {
  description = "Name tag for the public subnet"
  default     = "terraform-public-subnet"
}

# Internet Gateway configuration
variable "igw_name" {
  description = "Name tag for the Internet Gateway"
  default     = "terraform-igw"
}

# Route Table configuration
variable "route_table_name" {
  description = "Name tag for the public route table"
  default     = "terraform-public-rt"
}

# Security group configuration
variable "ssh_ingress_cidr_blocks" {
  description = "CIDR blocks for allowing SSH access"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # Allow SSH from anywhere (use caution in production)
}

variable "security_group_name" {
  description = "Name tag for the security group"
  default     = "terraform-allow-ssh"
}

# EC2 instance configuration
variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  default     = "ami-09efc42336106d2f2"
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  default     = "t2.micro"
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  default     = "terraform-test-instance"
}
